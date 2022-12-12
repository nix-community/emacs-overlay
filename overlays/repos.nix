self: super: {
  emacs-overlay =
    (super.emacs-overlay or {})
    // {
      repos =
        super.callPackage ../repos {};
    };
}
