{ pkgs, ... }: {
  services.openssh = {
    enable = true;
    permitRootLogin = "no"; # Disable root login for security
    allowUsers = [ "your_username" ]; # Replace with your username
    extraConfig = ''
      # Additional custom SSHD config
      Port 22; # Default port, or change it if desired
    '';
  };
}
