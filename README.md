# NixOS configuration

Personal NixOS configuration file.

stylua is sourced from unstable channel, as of this commit, stylua in stable "24.11" channel is outdated.

To use this config, adding unstable channel is required:
```
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
nix-channel --update
```

Enables extra configs and settings:
- GRUB for dual boot,
- tuxedo keyboard drivers,
- Nvidia with Optimus PRIME: Sync Mode,
- KDE Plasma,
- Printing service, including network printers discovery,
- User does not have to provide sudo password for anything,
- Bluetooth service,
- Docker, with docker compose,
- zsh shell



