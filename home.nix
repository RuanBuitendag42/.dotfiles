{ config
, pkgs
, ...
}: {
  imports = [
    ./config/packages.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ruanb";
  home.homeDirectory = "/home/ruanb";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/kitty".source = ./config/kitty;
    ".config/nvim".source = ./config/nvim;
    ".config/tmux/tmux.conf".source = ./config/tmux/tmux.conf;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ruanb/etc/profile.d/hm-session-vars.sh
  #
  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = [ "en_ZA.UTF-8/UTF-8" ];
  };

  home.sessionVariables = {
    LANG = "en_ZA.UTF-8";
    LC_ALL = "en_ZA.UTF-8";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
