From https://michael.stapelberg.ch/posts/2025-06-01-nixos-installation-declarative/#own-installer

```
export NIX_PATH=nixos-config=$PWD/iso.nix:nixpkgs=channel:nixos-25.05
% nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage
```
- `nix flake lock`

- Maschine auf Proxmox anlegen mit UEFI Bios
- ESC um im KVM-Bios Secure-Boot zu deaktivieren siehe auch
  https://www.thomas-krenn.com/de/wiki/UEFI_VM_-_failed_to_boot:_Access_Denied

- ip -4 a bzw. ip -6 a => ssh <ip-adr>

```
nix run github:nix-community/nixos-anywhere -- \
  --flake .#newnix \
  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
  --target-host falko@192.168.5.187
```

Update remote system after changes to configuration:

```
nix run nixpkgs#nixos-rebuild -- \
  --target-host falko@192.168.5.187 \
  --use-remote-sudo \
  switch \
  --flake .#newnix
```
