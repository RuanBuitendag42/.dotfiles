{ pkgs
, config
, ...
}: {
  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      # Nix LSP
      alejandra
    ];
  };
}
