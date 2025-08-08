# Configuration Nix

Ce dépôt contient ma configuration NixOS basée sur les flakes et Home Manager.

## Structure

```text
.
├── flake.lock
├── flake.nix
├── home-manager
│   └── home.nix
├── host
│   └── nixos
│       ├── configuration.nix
│       └── hardware-configuration.nix
└── modules
    ├── alacritty
    ├── aliases
    ├── fonts
    ├── git
    ├── lazygit
    ├── misc
    ├── navi
    ├── niri
    └── waybar
```

## Rôle des principaux éléments

- **flake.nix** : point d’entrée de la flake. Déclare les entrées (nixpkgs, home-manager, neovim) et assemble la configuration complète.
- **flake.lock** : verrouille les versions des dépendances pour assurer des builds reproductibles.
- **home-manager/** : configuration utilisateur gérée par Home Manager (ici pour l’utilisateur `jeremie`).
- **host/nixos/** : fichiers spécifiques à la machine NixOS (configuration système et matériel).
- **modules/** : modules Nix personnalisés pour divers programmes (Alacritty, Waybar, Git, etc.).

## Utilisation

Construire ou appliquer la configuration :

```bash
nixos-rebuild switch --flake .#nixos
```

Vérifier la flake :

```bash
nix flake check
```

## Prérequis

- nix
- nixos
- patience
- patience
- patience

Mais le jeu en vaut la chandelle !
