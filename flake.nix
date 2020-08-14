{
  description = "Bleeding edge Emacs overlay";

  outputs = { self }: {
    # self: super: must be named final: prev: for `nix flake check` to be happy
    overlay = final: prev:
      import ./default.nix final prev;
  };
}
