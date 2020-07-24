# WARNING: This file was automatically imported from
# https://github.com/talyz/fromElisp. Don't make any changes to it
# locally - they will be discarded on update!

{ pkgs ? import <nixpkgs> {},
  commentMaxLength ? 300,
  stringMaxLength ? 3000,
  characterMaxLength ? 50,
  integerMaxLength ? 50,
  floatMaxLength ? 50,
  boolVectorMaxLength ? 50,
  symbolMaxLength ? 50
}:

with pkgs.lib;
with builtins;

let

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

  removeStrings = stringsToRemove: string:
    let
      len = length stringsToRemove;
      listOfNullStrings = genList (const "") len;
    in
      replaceStrings stringsToRemove listOfNullStrings string;

  # Split a string of elisp into individual tokens and add useful
  # metadata.
  tokenizeElisp = elisp:
    let
      # These are the only characters that can not be unescaped in a
      # symbol name. We match the inverse of these to get the actual
      # symbol characters and use them to differentiate between
      # symbols and tokens that could potentially look like symbols,
      # such as numbers. Due to the leading bracket, this has to be
      # placed _first_ inside a bracket expression.
      notInSymbol = '']["'`,#;\\()[:space:][:cntrl:]'';

      matchComment = mkMatcher "(;[^\n]*[\n]).*" commentMaxLength;

      matchString = mkMatcher ''("([^"\\]|\\.)*").*'' stringMaxLength;

      matchCharacter = mkMatcher ''([?]((\\[sSHMAC]-)|\\\^)*(([^][\\()]|\\[][\\()])|\\[^^SHMACNuUx0-7]|\\[uU][[:digit:]a-fA-F]+|\\x[[:digit:]a-fA-F]*|\\[0-7]{1,3}|\\N\{[^}]+}))([${notInSymbol}?]|$).*'' characterMaxLength;

      matchNonBase10Integer = mkMatcher ''(#([BOX]|[[:digit:]]{1,2}r)[[:digit:]a-fA-F]+)([${notInSymbol}]|$).*'' integerMaxLength;

      matchInteger = mkMatcher ''([+-]?[[:digit:]]+[.]?)([${notInSymbol}]|$).*'' integerMaxLength;

      matchBoolVector = mkMatcher ''(#&[[:digit:]]+"([^"\\]|\\.)*").*'' boolVectorMaxLength;

      matchFloat = mkMatcher ''([+-]?([[:digit:]]*[.][[:digit:]]+|([[:digit:]]*[.])?[[:digit:]]+e([[:digit:]]+|[+](INF|NaN))))([${notInSymbol}]|$).*'' floatMaxLength;

      matchDot = mkMatcher ''([.])([${notInSymbol}]|$).*'' 2;

      # Symbols can contain pretty much any characters - the general
      # rule is that if nothing else matches, it's a symbol, so we
      # should be pretty generous here and match for symbols last. See
      # https://www.gnu.org/software/emacs/manual/html_node/elisp/Symbol-Type.html
      matchSymbol =
        let
          symbolChar = ''([^${notInSymbol}]|\\.)'';
        in mkMatcher ''(${symbolChar}+)([${notInSymbol}]|$).*'' symbolMaxLength;

      maxTokenLength = foldl' max 0 [
        commentMaxLength
        stringMaxLength
        characterMaxLength
        integerMaxLength
        floatMaxLength
        boolVectorMaxLength
        symbolMaxLength
      ];

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
      # successfully on the string, its result is added to
      # `state.acc`, a list of all matched tokens. The length of the
      # matched token is determined and passed on to the following
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
      readToken = state: char:
        let
          rest = substring state.pos maxTokenLength elisp;
          comment = matchComment rest;
          character = matchCharacter rest;
          nonBase10Integer = matchNonBase10Integer rest;
          integer = matchInteger rest;
          float = matchFloat rest;
          function = matchFunction rest;
          boolVector = matchBoolVector rest;
          string = matchString rest;
          dot = matchDot rest;
          symbol = matchSymbol rest;
        in
          if state.skip > 0 then
            state // {
              pos = state.pos + 1;
              skip = state.skip - 1;
              line = if char == "\n" then state.line + 1 else state.line;
            }
          else if char == "\n" then
            let
              mod = state.line / 1000;
              newState = {
                pos = state.pos + 1;
                line = state.line + 1;
                inherit mod;
              };
            in
              state // (
                # Force evaluation of old state every 1000 lines. Nix
                # doesn't have a modulo builtin, so we have to save
                # the result of an integer division and compare
                # between runs.
                if mod > state.mod then
                  seq state.acc newState
                else
                  newState
              )
          else if elem char [ " " "\t" "\r" ] then
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
            state // {
              acc = state.acc ++ [{ type = "openParen"; value = "("; inherit (state) line; }];
              pos = state.pos + 1;
            }
          else if char == ")" then
            state // {
              acc = state.acc ++ [{ type = "closeParen"; value = ")"; inherit (state) line; }];
              pos = state.pos + 1;
            }
          else if char == "[" then
            state // {
              acc = state.acc ++ [{ type = "openBracket"; value = "["; inherit (state) line; }];
              pos = state.pos + 1;
            }
          else if char == "]" then
            state // {
              acc = state.acc ++ [{ type = "closeBracket"; value = "]"; inherit (state) line; }];
              pos = state.pos + 1;
            }
          else if char == "'" then
            state // {
              acc = state.acc ++ [{ type = "quote"; value = "'"; inherit (state) line; }];
              pos = state.pos + 1;
            }
          else if char == ''"'' then
            if string != null then
              state // {
                acc = state.acc ++ [{ type = "string"; value = string; inherit (state) line; }];
                pos = state.pos + 1;
                skip = (stringLength string) - 1;
              }
            else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if char == "#" then
            let nextChar = substring 1 1 rest;
            in
              if nextChar == "'" then
                state // {
                  acc = state.acc ++ [{ type = "function"; value = "#'"; inherit (state) line; }];
                  pos = state.pos + 1;
                  skip = 1;
                }
              else if nextChar == "&" then
                if boolVector != null then
                  state // {
                    acc = state.acc ++ [{ type = "boolVector"; value = boolVector; inherit (state) line; }];
                    pos = state.pos + 1;
                    skip = (stringLength boolVector) - 1;
                  }
                else throw "Unrecognized token on line ${toString state.line}: ${rest}"
              else if nextChar == "s" then
                if substring 2 1 rest == "(" then
                  state // {
                    acc = state.acc ++ [{ type = "record"; value = "#s"; inherit (state) line; }];
                    pos = state.pos + 1;
                    skip = 1;
                  }
                else throw "List must follow #s in record on line ${toString state.line}: ${rest}"
              else if nextChar == "[" then
                state // {
                  acc = state.acc ++ [{ type = "byteCode"; value = "#"; inherit (state) line; }];
                  pos = state.pos + 1;
                }
              else if nonBase10Integer != null then
                state // {
                  acc = state.acc ++ [{ type = "nonBase10Integer"; value = nonBase10Integer; inherit (state) line; }];
                  pos = state.pos + 1;
                  skip = (stringLength nonBase10Integer) - 1;
                }
              else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if elem char [ "+" "-" "." "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" ] then
            if integer != null then
              state // {
                acc = state.acc ++ [{ type = "integer"; value = integer; inherit (state) line; }];
                pos = state.pos + 1;
                skip = (stringLength integer) - 1;
              }
            else if float != null then
              state // {
                acc = state.acc ++ [{ type = "float"; value = float; inherit (state) line; }];
                pos = state.pos + 1;
                skip = (stringLength float) - 1;
              }
            else if dot != null then
              state // {
                acc = state.acc ++ [{ type = "dot"; value = dot; inherit (state) line; }];
                pos = state.pos + 1;
                skip = (stringLength dot) - 1;
              }
            else if symbol != null then
              state // {
                acc = state.acc ++ [{ type = "symbol"; value = symbol; inherit (state) line; }];
                pos = state.pos + 1;
                skip = (stringLength symbol) - 1;
              }
            else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if char == "?" then
            if character != null then
              state // {
                acc = state.acc ++ [{ type = "character"; value = character; inherit (state) line; }];
                pos = state.pos + 1;
                skip = (stringLength character) - 1;
              }
            else throw "Unrecognized token on line ${toString state.line}: ${rest}"
          else if char == "`" then
            state // {
              acc = state.acc ++ [{ type = "backquote"; value = "`"; inherit (state) line; }];
              pos = state.pos + 1;
            }
          else if char == "," then
            if substring 1 1 rest == "@" then
              state // {
                acc = state.acc ++ [{ type = "slice"; value = ",@"; inherit (state) line; }];
                skip = 1;
                pos = state.pos + 1;
              }
            else
              state // {
                acc = state.acc ++ [{ type = "expand"; value = ","; inherit (state) line; }];
                pos = state.pos + 1;
              }
          else if symbol != null then
            state // {
              acc = state.acc ++ [{ type = "symbol"; value = symbol; inherit (state) line; }];
              pos = state.pos + 1;
              skip = (stringLength symbol) - 1;
            }
          else
            throw "Unrecognized token on line ${toString state.line}: ${rest}";
    in (builtins.foldl' readToken { acc = []; pos = 0; skip = 0; line = 1; mod = 0; } (stringToCharacters elisp)).acc;

  # Produce an AST from a string of elisp.
  parseElisp = elisp:
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
              value = fromJSON (removeStrings ["+"] token.value);
            }
          else if token.type == "symbol" && token.value == "t" then
            token // {
              value = true;
            }
          else if token.type == "float" then
            let
              float = match "([+-]?([[:digit:]]*[.])?[[:digit:]]+(e[+-]?[[:digit:]]+)?)" token.value;
            in
              if float != null then
                token // {
                  value = fromJSON (removeStrings ["+"] (head float));
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
      # For performance reasons, this is implemented as a fold over
      # the list of tokens, rather than as a recursive function. To
      # keep track of list depth when sublists are parsed, a list,
      # `state.acc`, is used as a stack. When entering a sublist, an
      # empty list is pushed to `state.acc`, and items in the sublist
      # are subsequently added to this list. When exiting the list,
      # `state.acc` is popped and the completed list is added to the
      # new head of `state.acc`, i.e. the outer list, which we were
      # parsing before entering the sublist.
      #
      # Evaluation of old state is forced with `seq` in a few places,
      # because nix otherwise keeps it around, eventually resulting in
      # a stack overflow.
      parseCollections = tokens:
        let
          parseToken = state: token:
            let
              openColl = if token.type == "openParen" then "list" else if token.type == "openBracket" then "vector" else null;
              closeColl = if token.type == "closeParen" then "list" else if token.type == "closeBracket" then "vector" else null;
            in
              if openColl != null then
                state // {
                  acc = [ [] ] ++ seq (head state.acc) state.acc;
                  inColl = [ openColl ] ++ state.inColl;
                  depth = state.depth + 1;
                  line = [ token.line ] ++ state.line;
                }
              else if closeColl != null then
                if (head state.inColl) == closeColl then
                  let
                    outerColl = elemAt state.acc 1;
                    currColl = {
                      type = closeColl;
                      value = head state.acc;
                      line = head state.line;
                      inherit (state) depth;
                    };
                    rest = tail (tail state.acc);
                  in
                    state // seq state.acc {
                      acc = [ (outerColl ++ [ currColl ]) ] ++ rest;
                      inColl = tail state.inColl;
                      depth = state.depth - 1;
                      line = tail state.line;
                    }
                else
                  throw "Unmatched ${token.type} on line ${toString token.line}"
              else if token.type == "symbol" && token.value == "nil" then
                let
                  currColl = head state.acc;
                  rest = tail state.acc;
                  emptyList = {
                    type = "list";
                    depth = state.depth + 1;
                    value = [];
                  };
                in
                  state // seq currColl { acc = [ (currColl ++ [ emptyList ]) ] ++ rest; }
              else
                let
                  currColl = head state.acc;
                  rest = tail state.acc;
                in
                  state // seq currColl { acc = [ (currColl ++ [ token ]) ] ++ rest; };
        in
          head (builtins.foldl' parseToken { acc = [ [] ]; inColl = [ null ]; depth = -1; line = []; } tokens).acc;

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
                collectionContents = foldl' parseToken {
                  acc = [];
                  dotted = false;
                  inList = token.type == "list";
                  inherit (state) depthReduction;
                } token.value;
              in
                state // {
                  acc = state.acc ++ (
                    if state.dotted then
                      collectionContents.acc
                    else
                      [
                        (token // {
                          value = collectionContents.acc;
                          depth = token.depth - state.depthReduction;
                        })
                      ]
                  );
                  dotted = false;
                }
            else
              state // {
                acc = state.acc ++ [token];
              };
        in
          (foldl' parseToken { acc = []; dotted = false; inList = false; depthReduction = 0; } tokens).acc;

      parseQuotes = tokens:
        let
          parseToken = state: token':
            let
              token =
                if isList token'.value then
                  token' // {
                    value = (foldl' parseToken { acc = []; quotes = []; } token'.value).acc;
                  }
                else
                  token';
            in
              if elem token.type [ "quote" "expand" "slice" "backquote" "function" "record" "byteCode" ] then
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
                in
                  state // {
                    acc = state.acc ++ [ quotedValue ];
                    quotes = [];
                  }
              else
                state // {
                  acc = state.acc ++ [ token ];
                };
        in
          (foldl' parseToken { acc = []; quotes = []; } tokens).acc;
    in
      parseQuotes (parseDots (parseCollections (parseValues (tokenizeElisp elisp))));

  fromElisp = elisp:
    let
      ast = parseElisp elisp;
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
in
{
  inherit tokenizeElisp parseElisp fromElisp;
}
