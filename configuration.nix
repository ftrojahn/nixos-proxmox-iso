{ modulesPath, lib, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware-configuration.nix
      ./disk-config.nix
    ];

  # Adding falko as trusted user means
  # we can upgrade the system via SSH (see Makefile).
  nix.settings.trusted-users = [ "falko" "root" ];
  # Clean the Nix store every week.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "newnix";
  time.timeZone = "Europe/Berlin";

  # Use systemd for networking
  services.resolved.enable = true;
  networking.useDHCP = false;
  systemd.network.enable = true;

  systemd.network.networks."10-e" = {
    matchConfig.Name = "e*";  # enp9s0 (10G) or enp8s0 (1G)
    networkConfig = {
      IPv6AcceptRA = true;
      DHCP = "yes";
    };
  };

  i18n.supportedLocales = [
    "de_DE.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "de_DE.UTF-8";

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  users.mutableUsers = true; # the password defined here will only be set when the user is created for the first time
  security.sudo.wheelNeedsPassword = false;
  users.users.falko = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBd90MOdbf7ySixzrRiNE3y84oIdUxZymg/IAIV4WxmD support@trojahn.de-2023"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO5MpAt4LSfzlFYz2vcbbkFMtuIKL4znr3S6FFC4K22ahix38EJVLK24H6lDDI+Gm9PN2NzZtbuJI7nzWlcbWrPinnurm5KNqZV7q9BI+EzVQqoel6WiYgEHeQOeHLW/xMVtQ3aaFNr6S5WglAwDTgbzvMs8kygpxqgGzLZ68zM772jxJAKlpB5xRVMOCMzC4HCqnrzAGASizMcY9Jf3ONrj+Tg/X4bRPmIwepQZNsHhQWUKhNT88+dxkJ5Kt754M9YhuzkBF/HFqbJ+GZI8UyzVkwHauME3yFXE/3j2qyhOwLn5v9nxghZIYpRDhIfoOx8YNsA18t+XNo/CN62/7l falko-netcup"
    ];

    isNormalUser = true;
    description = "Falko Trojahn";
    extraGroups = [ "wheel" ];
    # https://mynixos.com/nixpkgs/option/users.users.%3Cname%3E.initialPassword
    # initialHashedPassword = "XXXXX";  # random - just set it over ssh?
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
  ];

  programs.bash.completion.enable = true;
  environment.shellAliases = {
    # NixOS
    # generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    generations = "nixos-rebuild list-generations";
    generations-1 = "echo \"/nix/var/nix/profiles/system-`generations | awk '{print \$1}' | tail -n1`-link\"";
    generations-2 = "echo \"/nix/var/nix/profiles/system-`generations | awk '{print \$1}' | tail -n2 | head -n1`-link\"";
    generations-3 = "echo \"/nix/var/nix/profiles/system-`generations | awk '{print \$1}' | tail -n3 | head -n1`-link\"";
    nixdiff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    nixdiff1 = "nvd diff `generations-2` `generations-1` ";
    nixdiff2 = "nvd diff `generations-3` `generations-2` ";
    # no better idea?
    apt-show-versions = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq ";
    dpkg-l = "nix-build '<nixpkgs>' --no-link -A";
    depends = "nix run nixpkgs#nix-tree";
    suspends = "sudo journalctl -b -u systemd-suspend | cut -d: -f1,2,4";
  };
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
