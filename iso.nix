{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  i18n.supportedLocales = [
    "de_DE.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false;
  users.users.falko = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBd90MOdbf7ySixzrRiNE3y84oIdUxZymg/IAIV4WxmD support@trojahn.de-2023"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO5MpAt4LSfzlFYz2vcbbkFMtuIKL4znr3S6FFC4K22ahix38EJVLK24H6lDDI+Gm9PN2NzZtbuJI7nzWlcbWrPinnurm5KNqZV7q9BI+EzVQqoel6WiYgEHeQOeHLW/xMVtQ3aaFNr6S5WglAwDTgbzvMs8kygpxqgGzLZ68zM772jxJAKlpB5xRVMOCMzC4HCqnrzAGASizMcY9Jf3ONrj+Tg/X4bRPmIwepQZNsHhQWUKhNT88+dxkJ5Kt754M9YhuzkBF/HFqbJ+GZI8UyzVkwHauME3yFXE/3j2qyhOwLn5v9nxghZIYpRDhIfoOx8YNsA18t+XNo/CN62/7l falko-netcup"
    ];

    isNormalUser = true;
    description = "Falko Trojahn";
    extraGroups = [ "wheel" ];
    ## initialPassword = "TODO";  # just set it before building
    shell = pkgs.bash;
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    git  # for checking out github.com/stapelberg/configfiles
    rsync
    bash
    vim
    wget
    curl
    rxvt-unicode  # for terminfo
    lshw
  ];

  # programs.bash.enable = true;
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
