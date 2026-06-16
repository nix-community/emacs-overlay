{ lib ? pkgs.lib
, pkgs ? import <nixpkgs> { }
, commentMaxLength ? 300
, stringMaxLength ? 3000
, characterMaxLength ? 50
, integerMaxLength ? 50
, floatMaxLength ? 50
, boolVectorMaxLength ? 50
, symbolMaxLength ? 50
, orgModeBabelCodeBlockHeaderMaxLength ? 200
, orgModeBabelCodeBlockArgMaxLength ? 30
}:

let
  inherit (lib)
    substring length replaceStrings genList head const max elem seq
    stringLength stringToCharacters tail elemAt isList
    isString toLower
    ;
  inherit (builtins) match foldl' filter fromJSON concatLists;

  # Modulo
  mod = i: d: i - ((i / d) * d);

  # Bounded-chunk list accumulator to avoid quadratic list buildups.
  accChunkSize = 64;
  accEmpty = { chunk = []; chunks = []; };
  accPush = acc: x:
    if length acc.chunk >= accChunkSize then
      let chunks' = acc.chunks ++ [ acc.chunk ];
      in seq chunks' { chunk = [ x ]; chunks = chunks'; }
    else
      { chunk = acc.chunk ++ [ x ]; inherit (acc) chunks; };
  accFinish = acc: if acc.chunks == [] then acc.chunk else concatLists (acc.chunks ++ [ acc.chunk ]);
  accPushAll = acc: xs: foldl' accPush acc xs;

  isWhitespace = lib.flip elem [ " " "\t" "\r" ];

  # Create a matcher from a regex string and maximum length. A
  # matcher takes a string and returns the first match produced by
  # running its regex on it, or null if the match is unsuccessful,
  # but only as far in as specified by maxLength.
  mkMatcher = regex: maxLength:
    string:
      let
        substr = substring 0 maxLength string;
        matched = match regex substr;
      in
        if matched != null then head matched else null;

  removeStrings = stringsToRemove: let
    len = length stringsToRemove;
    listOfNullStrings = genList (const "") len;
  in replaceStrings stringsToRemove listOfNullStrings;

  # Split a string of elisp into individual tokens and add useful
  # metadata.
  tokenizeElisp' = let
    # These are the only characters that can not be unescaped in a
    # symbol name. We match the inverse of these to get the actual
    # symbol characters and use them to differentiate between
    # symbols and tokens that could potentially look like symbols,
    # such as numbers. Due to the leading bracket, this has to be
    # placed _first_ inside a bracket expression.
    notInSymbol = '']["'`,#;\\()[:space:][:cntrl:]'';

    matchComment = mkMatcher "(;[^\n]*).*" commentMaxLength;

    matchString = mkMatcher ''("([^"\\]|\\.)*").*'' stringMaxLength;

    matchCharacter = mkMatcher ''([?]((\\[sSHMAC]-)|\\\^)*(([^][\\()]|\\[][\\()])|\\[^^SHMACNuUx0-7]|\\[uU][[:digit:]a-fA-F]+|\\x[[:digit:]a-fA-F]*|\\[0-7]{1,3}|\\N\{[^}]+}))([${notInSymbol}?]|$).*'' characterMaxLength;

    matchNonBase10Integer = mkMatcher ''(#([BbOoXx]|[[:digit:]]{1,2}r)[[:digit:]a-fA-F]+)([${notInSymbol}]|$).*'' integerMaxLength;

    matchInteger = mkMatcher ''([+-]?[[:digit:]]+[.]?)([${notInSymbol}]|$).*'' integerMaxLength;

    matchBoolVector = mkMatcher ''(#&[[:digit:]]+"([^"\\]|\\.)*").*'' boolVectorMaxLength;

    matchFloat = mkMatcher ''([+-]?([[:digit:]]*[.][[:digit:]]+|([[:digit:]]*[.])?[[:digit:]]+e([+-]?[[:digit:]]+|[+](INF|NaN))))([${notInSymbol}]|$).*'' floatMaxLength;

    matchDot = mkMatcher ''([.])([${notInSymbol}]|$).*'' 2;

    # Symbols can contain pretty much any characters - the general
    # rule is that if nothing else matches, it's a symbol, so we
    # should be pretty generous here and match for symbols last. See
    # https://www.gnu.org/software/emacs/manual/html_node/elisp/Symbol-Type.html
    matchSymbol =
      let
        symbolChar = ''([^${notInSymbol}]|\\.)'';
      in mkMatcher ''(${symbolChar}+)([${notInSymbol}]|$).*'' symbolMaxLength;


    isDigit = lib.flip elem [ "+" "-" "." "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" ];

    maxTokenLength = foldl' max 0 [
      commentMaxLength
      stringMaxLength
      characterMaxLength
      integerMaxLength
      floatMaxLength
      boolVectorMaxLength
      symbolMaxLength
    ];
  in { elisp, startLineNumber ? 1 }:
    let
      # Fold over all the characters in a string, checking for
      # matching tokens.
      #
      # The implementation is a bit obtuse, for optimization reasons:
      # nix doesn't have tail-call optimization, thus a strict fold,
      # which should essentially force a limited version of tco when
      # iterating a list, is our best alternative.
      #
      # The string read from is split into a list of its constituent
      # characters, which is then folded over. Each character is then
      # used to determine a likely matching regex "matcher" to run on
      # the string, starting at the position of the aforementioned
      # character. When an appropriate matcher has been found and run
      # successfully on the string, `emit` adds its result to the list
      # of all matched tokens. The length of the matched token is
      # determined and passed on to the following
      # iteration through `state.skip`. If `state.skip` is positive,
      # nothing will be done in the current iteration, except
      # decrementing `state.skip` for the next one: this skips the
      # characters we've already matched. At each iteration,
      # `state.pos` is also incremented, to keep track of the current
      # string position.
      #
      # The order of the matches is significant - matchSymbol will,
      # for example, also match numbers and characters, so we check
      # for symbols last.

      emit = state: token: extra:
        let
          full = length state.chunk >= accChunkSize;
          chunk = (if full then [] else state.chunk) ++ [ token ];
          chunks = if full then state.chunks ++ [ state.chunk ] else state.chunks;
          result = state // extra // { inherit chunk chunks; };
        in
          if full then seq chunks result else result;

      readToken = state: char:
        let
          comment = matchComment (substring state.pos commentMaxLength elisp);
          character = matchCharacter (substring state.pos characterMaxLength elisp);
          nonBase10Integer = matchNonBase10Integer (substring state.pos integerMaxLength elisp);
          integer = matchInteger (substring state.pos integerMaxLength elisp);
          float = matchFloat (substring state.pos floatMaxLength elisp);
          boolVector = matchBoolVector (substring state.pos boolVectorMaxLength elisp);
          string = matchString (substring state.pos stringMaxLength elisp);
          dot = matchDot (substring state.pos 2 elisp);
          symbol = matchSymbol (substring state.pos symbolMaxLength elisp);
          # Only referenced when building the "unrecognized token" error
          # message, so this full-length slice is forced only on failure.
          rest = substring state.pos maxTokenLength elisp;
        in
          if state.skip > 0 then
            state // {
              pos = state.pos + 1;
              skip = state.skip - 1;
              line = if char == "\n" then state.line + 1 else state.line;
            }
          else if char == "\n" then
            state // {
              pos = state.pos + 1;
              line = state.line + 1;
            }
          else if isWhitespace char then
            state // {
              pos = state.pos + 1;
              inherit (state) line;
            }
          else if char == ";" then
            if comment != null then
              state // {
                pos = state.pos + 1;
                skip = (stringLength comment) - 1;
              }
            else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if char == "(" then
            emit state { type = "openParen"; value = "("; inherit (state) line; } { pos = state.pos + 1; }
          else if char == ")" then
            emit state { type = "closeParen"; value = ")"; inherit (state) line; } { pos = state.pos + 1; }
          else if char == "[" then
            emit state { type = "openBracket"; value = "["; inherit (state) line; } { pos = state.pos + 1; }
          else if char == "]" then
            emit state { type = "closeBracket"; value = "]"; inherit (state) line; } { pos = state.pos + 1; }
          else if char == "'" then
            emit state { type = "quote"; value = "'"; inherit (state) line; } { pos = state.pos + 1; }
          else if char == ''"'' then
            if string != null then
              emit state { type = "string"; value = string; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength string) - 1; }
            else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if char == "#" then
            let nextChar = substring (state.pos + 1) 1 elisp;
            in
              if nextChar == "'" then
                emit state { type = "function"; value = "#'"; inherit (state) line; } { pos = state.pos + 1; skip = 1; }
              else if nextChar == "&" then
                if boolVector != null then
                  emit state { type = "boolVector"; value = boolVector; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength boolVector) - 1; }
                else throw "Unrecognized token on line ${toString state.line}: ${rest}"
              else if nextChar == "s" then
                if substring (state.pos + 2) 1 elisp == "(" then
                  emit state { type = "record"; value = "#s"; inherit (state) line; } { pos = state.pos + 1; skip = 1; }
                else throw "List must follow #s in record on line ${toString state.line}: ${rest}"
              else if nextChar == "[" then
                emit state { type = "byteCode"; value = "#"; inherit (state) line; } { pos = state.pos + 1; }
              else if nonBase10Integer != null then
                emit state { type = "nonBase10Integer"; value = nonBase10Integer; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength nonBase10Integer) - 1; }
              else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if isDigit char then
            if integer != null then
              emit state { type = "integer"; value = integer; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength integer) - 1; }
            else if float != null then
              emit state { type = "float"; value = float; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength float) - 1; }
            else if dot != null then
              emit state { type = "dot"; value = dot; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength dot) - 1; }
            else if symbol != null then
              emit state { type = "symbol"; value = symbol; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength symbol) - 1; }
            else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if char == "?" then
            if character != null then
              emit state { type = "character"; value = character; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength character) - 1; }
            else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if char == "`" then
            emit state { type = "backquote"; value = "`"; inherit (state) line; } { pos = state.pos + 1; }
          else if char == "," then
            if substring (state.pos + 1) 1 elisp == "@" then
              emit state { type = "slice"; value = ",@"; inherit (state) line; } { pos = state.pos + 1; skip = 1; }
            else
              emit state { type = "expand"; value = ","; inherit (state) line; } { pos = state.pos + 1; }
          else if symbol != null then
            emit state { type = "symbol"; value = symbol; inherit (state) line; } { pos = state.pos + 1; skip = (stringLength symbol) - 1; }
          else
            throw "Unrecognized token on line ${toString state.line}: ${rest}";
      in
        let
          final = builtins.foldl' readToken {
            chunk = [];
            chunks = [];
            pos = 0;
            skip = 0;
            line = startLineNumber;
          } (stringToCharacters elisp);
        in
          builtins.concatLists (final.chunks ++ [ final.chunk ]);

  tokenizeElisp = elisp:
    tokenizeElisp' { inherit elisp; };

  # Produce an AST from a list of tokens produced by `tokenizeElisp`.
  parseElisp' = let
    removeIntDelimiter = removeStrings ["+" "."];
    removePlus = removeStrings ["+"];
    removeMinus = removeStrings ["-"];
  in tokens:
    let
      # Convert literal value tokens in a flat list to their
      # corresponding nix representation.
      parseValues = tokens:
        map (token:
          if token.type == "string" then
            token // {
              value = substring 1 (stringLength token.value - 2) token.value;
            }
          else if token.type == "integer" then
            token // {
              value = fromJSON (removeIntDelimiter token.value);
            }
          else if token.type == "symbol" && token.value == "t" then
            token // {
              value = true;
            }
          else if token.type == "float" then
            let
              initial = head (match "([+-]?([[:digit:]]*[.])?[[:digit:]]+(e([+-]?[[:digit:]]+|[+](INF|NaN)))?)" token.value);
              isSpecial = (match "(.+(e[+](INF|NaN)))" initial) != null;
              withoutPlus = removePlus initial;
              withPrefix =
                if substring 0 1 withoutPlus == "." then
                  "0" + withoutPlus
                else if substring 0 2 withoutPlus == "-." then
                  "-0" + removeMinus withoutPlus
                else
                  withoutPlus;
            in
              if !isSpecial && withPrefix != null then
                token // {
                  value = fromJSON withPrefix;
                }
              else
                token
          else
            token
        ) tokens;

      # Convert pairs of opening and closing tokens to their
      # respective collection types, i.e. lists and vectors. Also,
      # normalize the forms of nil, which can be written as either
      # `nil` or `()`, to empty lists.
      #
      # For performance reasons, this is implemented as a fold over the
      # list of tokens, rather than as a recursive function, so that
      # list depth doesn't translate into evaluation recursion depth.
      #
      # The collection currently being built is kept in `current`
      # (along with its type & opening line) _outside_ the stack.
      #
      # Only the enclosing still not finished collection live on state.stack,
      # avoiding calls to `builtins.tail`, which are quadratic.
      parseCollections = tokens:
        let
          parseToken = state: token:
            let
              openColl = if token.type == "openParen" then "list" else if token.type == "openBracket" then "vector" else null;
              closeColl = if token.type == "closeParen" then "list" else if token.type == "closeBracket" then "vector" else null;
            in
              if openColl != null then
                state // {
                  stack = seq state.stack ([ { acc = state.current; type = state.currentType; line = state.currentLine; } ] ++ state.stack);
                  current = accEmpty;
                  currentType = openColl;
                  currentLine = token.line;
                  depth = state.depth + 1;
                }
              else if closeColl != null then
                if state.currentType == closeColl then
                  let
                    currColl = {
                      type = closeColl;
                      value = accFinish state.current;
                      line = state.currentLine;
                      inherit (state) depth;
                    };
                    parent = head state.stack;
                    current = accPush parent.acc currColl;
                  in
                    seq current (state // {
                      inherit current;
                      currentType = parent.type;
                      currentLine = parent.line;
                      stack = tail state.stack;
                      depth = state.depth - 1;
                    })
                else
                  throw "Unmatched ${token.type} on line ${toString token.line}"
              else if token.type == "symbol" && token.value == "nil" then
                let
                  current = accPush state.current {
                    type = "list";
                    depth = state.depth + 1;
                    value = [];
                  };
                in
                  seq current (state // { inherit current; })
              else
                let current = accPush state.current token;
                in seq current (state // { inherit current; });
        in
          accFinish (builtins.foldl' parseToken {
            current = accEmpty;
            currentType = null;
            currentLine = null;
            stack = [];
            depth = -1;
          } tokens).current;

      # Handle dotted pair notation, a syntax where the car and cdr
      # are represented explicitly. See
      # https://www.gnu.org/software/emacs/manual/html_node/elisp/Dotted-Pair-Notation.html#Dotted-Pair-Notation
      # for more info.
      #
      # This mainly entails handling lists that are the cdrs of a
      # dotted pairs, concatenating the lexically distinct lists into
      # the logical list they actually represent.
      #
      # For example:
      # (a . (b . (c . nil))) -> (a b c)
      parseDots = tokens:
        let
          parseToken = state: token:
            if token.type == "dot" then
              if state.inList then
                state // {
                  dotted = true;
                  depthReduction = state.depthReduction + 1;
                }
              else
                throw ''"Dotted pair notation"-dot outside list on line ${toString token.line}''
            else if isList token.value then
              let
                collectionContents = accFinish (foldl' parseToken {
                  acc = accEmpty;
                  dotted = false;
                  inList = token.type == "list";
                  inherit (state) depthReduction;
                } token.value).acc;
                acc =
                  if state.dotted then
                    accPushAll state.acc collectionContents
                  else
                    accPush state.acc (token // {
                      value = collectionContents;
                      depth = token.depth - state.depthReduction;
                    });
              in
                seq acc (state // {
                  inherit acc;
                  dotted = false;
                })
            else
              let acc = accPush state.acc token;
              in seq acc (state // { inherit acc; });
        in
          accFinish (foldl' parseToken { acc = accEmpty; dotted = false; inList = false; depthReduction = 0; } tokens).acc;

      parseQuotes = let
        isQuote = lib.flip elem [ "quote" "expand" "slice" "backquote" "function" "record" "byteCode" ];
      in tokens:
        let
          parseToken = state: token':
            let
              token =
                if isList token'.value then
                  token' // {
                    value = accFinish (foldl' parseToken { acc = accEmpty; quotes = []; } token'.value).acc;
                  }
                else
                  token';
            in
              if isQuote token.type then
                state // {
                  quotes = [ token ] ++ state.quotes;
                }
              else if state.quotes != [] then
                let
                  quote = value: token:
                    token // {
                      inherit value;
                    };
                  quotedValue = foldl' quote token state.quotes;
                  acc = accPush state.acc quotedValue;
                in
                  seq acc (state // {
                    inherit acc;
                    quotes = [];
                  })
              else
                let acc = accPush state.acc token;
                in seq acc (state // { inherit acc; });
        in
          accFinish (foldl' parseToken { acc = accEmpty; quotes = []; } tokens).acc;
    in
      parseQuotes (parseDots (parseCollections (parseValues tokens)));

  parseElisp = elisp:
    parseElisp' (tokenizeElisp elisp);

  fromElisp' = ast:
    let
      readObject = object:
        if isList object.value then
          map readObject object.value
        else if object.type == "quote" then
          ["quote" (readObject object.value)]
        else if object.type == "backquote" then
          ["`" (readObject object.value)]
        else if object.type == "expand" then
          ["," (readObject object.value)]
        else if object.type == "slice" then
          [",@" (readObject object.value)]
        else if object.type == "function" then
          ["#'" (readObject object.value)]
        else if object.type == "byteCode" then
          ["#"] ++ (readObject object.value)
        else if object.type == "record" then
          ["#s"] ++ (readObject object.value)
        else
          object.value;
    in
      map readObject ast;

  fromElisp = elisp:
    fromElisp' (parseElisp elisp);

  # Parse an Org mode babel text and return a list of all code blocks
  # with metadata.
  #
  # The general operation is similar to tokenizeElisp', so check its
  # documentation for a more in-depth description.
  #
  # As in tokenizeElisp', the string read from is split into a list of
  # its constituent characters, which is then folded over. Each
  # character is then used to determine whether we should try to run a
  # match for a `#+begin_src` header or `#+end_src` footer, starting
  # at the position of the aforementioned character. These matches
  # should only be attempted if the current character is `#` and the
  # line has nothing but whitespace before it (noted by
  # `state.leadingWhitespace`).
  #
  # When an appropriate match for a header has been found, its
  # arguments are further parsed and the result is put into the code
  # block's `flags` attribute. The subsequent characters are added to
  # the code block's `body` attribute, until a footer is successfully
  # matched and the block is added to the list of parsed blocks,
  # `state.acc`.
  parseOrgModeBabel = let
    matchBeginCodeBlock = mkMatcher "(#[+][bB][eE][gG][iI][nN]_[sS][rR][cC])([[:space:]]+).*" orgModeBabelCodeBlockHeaderMaxLength;
    matchHeader = mkMatcher "(#[+][hH][eE][aA][dD][eE][rR][sS]?:)([[:space:]]+).*" orgModeBabelCodeBlockHeaderMaxLength;
    matchEndCodeBlock = mkMatcher "(#[+][eE][nN][dD]_[sS][rR][cC][^\n]*).*" orgModeBabelCodeBlockHeaderMaxLength;

    matchBeginCodeBlockLang = match "([[:blank:]]*)([[:alnum:]][[:alnum:]-]*).*";
    matchBeginCodeBlockFlags = mkMatcher "([^\n]*[\n]).*" orgModeBabelCodeBlockHeaderMaxLength;

    isItem = lib.flip elem [ ":" "-" "+" ];

  in text:
    let
      parseToken = state: char:
        let
          rest = substring state.pos orgModeBabelCodeBlockHeaderMaxLength text;
          beginCodeBlock = matchBeginCodeBlock rest;
          header = matchHeader rest;
          endCodeBlock = matchEndCodeBlock rest;
          language = matchBeginCodeBlockLang rest;
          flags = matchBeginCodeBlockFlags rest;

          force = expr: seq state.pos (seq state.line expr);
        in
          if state.skip > 0 then
            state // force {
              pos = state.pos + 1;
              skip = state.skip - 1;
              line = if char == "\n" then state.line + 1 else state.line;
              leadingWhitespace = char == "\n" || (state.leadingWhitespace && isWhitespace char);
            }
          else if char == "#" && state.leadingWhitespace && !state.readBody && beginCodeBlock != null then
            state // {
              pos = state.pos + 1;
              skip = (stringLength beginCodeBlock) - 1;
              leadingWhitespace = false;
              readLanguage = true;
            }
          else if char == "#" && state.leadingWhitespace && !state.readBody && header != null then
            state // {
              pos = state.pos + 1;
              skip = (stringLength header) - 1;
              leadingWhitespace = false;
              readFlags = true;
            }
          else if state.readLanguage then
            if language != null then
              state // {
                block = state.block // {
                  language = elemAt language 1;
                };
                pos = state.pos + 1;
                skip = (foldl' (total: string: total + (stringLength string)) 0 language) - 1;
                leadingWhitespace = false;
                readLanguage = false;
                readFlags = true;
                readBody = true;
              }
            else throw "Language missing or invalid for code block on line ${toString state.line}!"
          else if state.readFlags then
            if flags != null then
              let
                parseFlag = state: item:
                  let
                    prefix = if isString item then substring 0 1 item else null;
                  in
                    if isItem prefix then
                      state // {
                        acc = state.acc // { ${item} = true; };
                        flag = item;
                      }
                    else if state.flag != null then
                      state // {
                        acc = state.acc // { ${state.flag} = item; };
                        flag = null;
                      }
                    else
                      state;
              in
                state // {
                  block = state.block // {
                    flags =
                      (foldl'
                        parseFlag
                        { acc = state.block.flags;
                          flag = null;
                          inherit (state) line;
                        }
                        (fromElisp flags)).acc;
                    startLineNumber = state.line + 1;
                  };
                  pos = state.pos + 1;
                  skip = (stringLength flags) - 1;
                  line = if char == "\n" then state.line + 1 else state.line;
                  leadingWhitespace = char == "\n";
                  readFlags = false;
                }
            else throw "Arguments malformed for code block on line ${toString state.line}!"
          else if char == "#" && state.leadingWhitespace && endCodeBlock != null then
            state // {
              acc = state.acc ++ [ state.block ];
              block = {
                language = null;
                body = "";
                flags = {};
              };
              pos = state.pos + 1;
              skip = (stringLength endCodeBlock) - 1;
              leadingWhitespace = false;
              readBody = false;
            }
          else if state.readBody then
            let
              newState = {
                block = state.block // {
                  body = state.block.body + char;
                };
                pos = state.pos + 1;
                line = if char == "\n" then state.line + 1 else state.line;
                leadingWhitespace = char == "\n" || (state.leadingWhitespace && isWhitespace char);
              };
            in
              if mod state.pos 100 == 0 then
                state // seq state.block.body (force newState)
              else
                state // newState
          else
            state // force {
              pos = state.pos + 1;
              line = if char == "\n" then state.line + 1 else state.line;
              leadingWhitespace = char == "\n" || (state.leadingWhitespace && isWhitespace char);
            };
    in
      (foldl'
        parseToken
        { acc = [];
          pos = 0;
          skip = 0;
          line = 1;
          block = {
            language = null;
            body = "";
            flags = {};
          };
          leadingWhitespace = true;
          readLanguage = false;
          readFlags = false;
          readBody = false;
        }
        (stringToCharacters text)).acc;

  # Run tokenizeElisp' on all Elisp code blocks (with `:tangle yes`
  # set) from an Org mode babel text. If the block doesn't have a
  # `tangle` attribute, it's determined by `defaultArgs`.
  tokenizeOrgModeBabelElisp' = let
    isElisp = lib.flip elem [ "elisp" "emacs-lisp" ];
    doTangle = lib.flip elem [ "yes" ''"yes"'' ];
  in defaultArgs: text:
    let
      codeBlocks =
        filter
          (block:
            let
              tangle = toLower (block.flags.":tangle" or defaultArgs.":tangle" or "no");
              language = toLower block.language;
            in isElisp language && doTangle tangle)
          (parseOrgModeBabel text);
      in
        foldl'
          (result: codeBlock:
            result ++ (tokenizeElisp' {
              elisp = codeBlock.body;
              inherit (codeBlock) startLineNumber;
            })
          )
          []
          codeBlocks;

  tokenizeOrgModeBabelElisp =
    tokenizeOrgModeBabelElisp' {
      ":tangle" = "no";
    };

  parseOrgModeBabelElisp' = defaultArgs: text:
    parseElisp' (tokenizeOrgModeBabelElisp' defaultArgs text);

  parseOrgModeBabelElisp = text:
    parseElisp' (tokenizeOrgModeBabelElisp text);

  fromOrgModeBabelElisp' = defaultArgs: text:
    fromElisp' (parseOrgModeBabelElisp' defaultArgs text);

  fromOrgModeBabelElisp = text:
    fromElisp' (parseOrgModeBabelElisp text);

in
{
  inherit tokenizeElisp parseElisp fromElisp;
  inherit tokenizeElisp' parseElisp' fromElisp';
  inherit tokenizeOrgModeBabelElisp parseOrgModeBabelElisp fromOrgModeBabelElisp;
  inherit tokenizeOrgModeBabelElisp' parseOrgModeBabelElisp' fromOrgModeBabelElisp';
}
