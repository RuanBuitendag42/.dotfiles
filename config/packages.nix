{ pkgs, ... }: {
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" ]; })

    # Make used for initial system setup kinf of stuff
    gnumake

    # Dev
    nodePackages.nodejs
    cargo

    # Shell
    zsh-powerlevel10k
    tmux
    neovim
    github-cli
    lazygit
    bat
    fzf
    zsh-fzf-tab
    zoxide
    eza

    # Shell Utils
    unzip

    # SSH and WOL
    openssh
    ethtool
    wakeonlan # For sending WoL packets

    # LSP
    alejandra

    # Graphics drivers
    mesa
    glfw
    libglvnd
    libGL

    ### Work
    awscli2
    kubectl
    kubectx
    k9s

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
