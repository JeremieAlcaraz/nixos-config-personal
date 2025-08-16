# Adopter Nix et NixOS

> Résumé exécutif : j’ai choisi Nix/NixOS pour sa déclarativité, sa reproductibilité totale, l’unification système ↔ utilisateur (Home Manager), une gestion des secrets propre, des environnements de dev impeccables, des rollbacks natifs, et la possibilité de remplacer une bonne partie de Docker dans mon quotidien.

---

## 1) Pourquoi cette philosophie me convient

- **Déclaratif, pas impératif** : je décris l’état voulu, Nix le construit.
- **Traçable et réversible** : chaque changement devient une **génération** versionnée, avec **rollback** instantané.
- **Isolation déterministe** : les dépendances sont **pinnées** et immuables dans `/nix/store`.
- **Cohérence** : un seul langage (Nix) pour le système, l’utilisateur, le dev et l’infra.

> 🔁 Métaphore : c’est comme un “Git des machines”. Je commit un état, je peux revenir en arrière, et cloner le même état ailleurs.

---

## 2) Home Manager : mon bureau, partout

- **But** : décrire l’environnement _utilisateur_ (zsh, tmux, neovim, fonts, apps) de façon déclarative.
- **Bénéfice** : je débarque sur une nouvelle machine → **même expérience** en 1 commande.
- **Intégration** : je l’intègre au module NixOS (pas en standalone) pour garder **un seul point de vérité**.

**Extrait** (schéma d’intention) :

```nix
# modules/home/default.nix
{ inputs, pkgs, ... }:
{
  home-manager = {
    useUserPackages = true;
    users.jeremie = { pkgs, ... }: {
      home.stateVersion = "24.05";
      programs.zsh.enable = true;
      programs.git = {
        enable = true;
        userName = "Jérémie Alcaraz";
        userEmail = "me@example.com";
      };
      programs.neovim.enable = true;
      # … alias, fonts, apps, etc.
    };
  };
}

```

---

## 3) Secrets propres avec sops-nix (+ 1Password si besoin)

- **Problème d’avant** : `.env` disséminés, gestion à la main, risque de fuite.
- **Solution** : **sops-nix** chiffre mes secrets (avec `age`/`gpg`), je versionne en sécurité.
- **Flux** : je chiffre une fois → Nix injecte **au bon endroit** (fichiers/services/variables).

**Exemple minimal** :

```nix
# modules/secrets/default.nix
{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.defaultSopsFile = ./secrets.yaml;   # chiffré
  sops.age.keyFile = "/home/jeremie/.config/sops/age/keys.txt";

  sops.secrets."github/token" = { };
  environment.variables.GITHUB_TOKEN = config.sops.secrets."github/token".path;
}

```

> 🧩 Avec 1Password : je peux stocker ma clé age/gpg dans 1Password et la récupérer au bootstrap. Gains : sécurité + reproductibilité.

---

## 4) Reproductibilité totale (et sereine)

- **Pinning** : Flakes verrouillent versions et entrées.
- **Bootstrap** : une machine neuve → clone du dépôt → `nixos-rebuild switch --flake .#fleur-01` → **setup identique**.
- **Backups “logiques”** : je sauvegarde _la déclaration_, pas des états aléatoires.

**Commandes utiles** :

```bash
# Construire et activer l’état
sudo nixos-rebuild switch --flake .#fleur-01

# Tester sans ancrer au boot
sudo nixos-rebuild test --flake .#fleur-01

# Rollback (système)
sudo nixos-rebuild switch --rollback

```

---

## 5) Remplacer (souvent) Docker : devShells & environnements

- **DevShells** : environnements éphémères, propres, reproductibles, **sans** conteneuriser.
- **Moins d’overhead** : parfait pour CLIs, toolchains, SDKs, langages multiples.
- **Toujours possible** : quand Docker est requis, **Nix sait générer une image Docker**.

**DevShell exemple** :

```nix
# flake.nix (extrait)
devShells.x86_64-linux.default = with pkgs; mkShell {
  buildInputs = [ nodejs_20 go_1_22 jq ];
  shellHook = ''
    echo "DevShell prêt : Node, Go, jq"
  '';
};

```

**Image Docker depuis Nix** :

```nix
# flake.nix (extrait)
packages.x86_64-linux.myAppImage = pkgs.dockerTools.buildImage {
  name = "my-app";
  tag = "latest";
  contents = [ pkgs.curl ];
  config.Cmd = [ "/bin/sh" "-c" "echo Hello from Nix-built image && sleep 3600" ];
};

```

```bash
# Exporter l’image au format tar et la charger
nix build .#myAppImage
docker load < result

```

> 🔎 Règle pratique : pour le dev local, je privilégie nix develop/devShells. Pour déployer où Docker est standard, je génère l’image via Nix.

---

## 6) Arborescence flake simple et claire

```
nix-config/
├─ flake.nix
├─ flake.lock
├─ hosts/
│  ├─ fleur-01/                 # machine 1
│  │  ├─ configuration.nix
│  │  └─ hardware-configuration.nix
│  └─ fleur-02/                 # machine 2
├─ modules/
│  ├─ home/                     # Home Manager (utilisateur)
│  ├─ desktop/                  # Niri, Alacritty, etc.
│  ├─ networking/               # Tailscale, SSH, firewall
│  ├─ secrets/                  # sops-nix
│  └─ services/                 # services (nginx, postgres…)
└─ overlays/                    # Overlays nixpkgs (si besoin)

```

**flake.nix (squelette)** :

```nix
{
  description = "Infra NixOS + Home Manager de Jeremie";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations = {
      fleur-01 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/fleur-01/configuration.nix
          ./modules/home                      # Home Manager intégré
          ./modules/secrets                   # sops-nix
          # ./modules/desktop ./modules/services ./modules/networking …
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
        ];
      };
      # fleur-02 = …
    };

    devShells.${system}.default = with pkgs; mkShell {
      buildInputs = [ git jq ];
    };
  };
}

```

---

## 7) Déploiement et multi-machines

- **Local** : `nixos-rebuild --flake .#fleur-01`.
- **Distant** : `nixos-rebuild --target-host root@ip --flake .#fleur-01`
  (ou outils dédiés : **deploy-rs**, **Colmena**, **Morph** pour orchestrez plusieurs hôtes).
- **CI/CD** : build des configurations et **cachage** binaire (⚡ **Cachix**) → clones et déploiements ultra-rapides.

---

## 8) Rollbacks et maintenance

- **Rollbacks** au boot (sélection de génération GRUB) ou via `-rollback`.
- **Nettoyage** :

```bash
# Supprimer anciennes générations système & utilisateur
sudo nix-collect-garbage -d
nix profile wipe-history --older-than 30d

# Dédupliquer et compresser le store
sudo nix store optimise

```

- **Mises à jour** :

```bash
# Mettre à jour les inputs du flake
nix flake update
# Rebuild
sudo nixos-rebuild switch --flake .#fleur-01

```

---

## 9) Bonnes pratiques (opinionnées)

- **Un dépôt = une vérité** : host vars, modules, home, secrets (chemins) **dans le flake**.
- **Découper par domaines** : `desktop`, `services`, `networking`, `secrets`, `home`.
- **Petits commits** + message clair (comme pour du code).
- **Pinning strict** (flakes) et **canaux stables** (nixos-_release_).
- **CI + cache binaire** (Cachix) pour accélérer les builds.
- **DevShell par projet** (langages outillés sans polluer le système).

---

## 10) Comparaisons rapides

| Besoin     | Avant                        | Avec Nix                     |
| ---------- | ---------------------------- | ---------------------------- |
| Installs   | scripts, doc manuelle, drift | fichiers `.nix` déclaratifs  |
| Onboarding | long, fragile                | `clone` + `rebuild`          |
| Secrets    | `.env`, copiés               | sops-nix, chiffrés, injectés |
| Dev env    | nvm/pyenv/rbenv locaux       | `nix develop`/devShells      |
| Rollback   | compliqué                    | natif, instantané            |
| Docker     | partout par défaut           | souvent inutile en dev local |

---

## 11) Limites et trade-offs

- **Courbe d’apprentissage** du langage Nix (fonctionnel, pur).
- **Temps de build** initiaux (atténués par Cachix et le cache).
- **Espace disque** : le store garde des générations (→ GC régulier).
- **Packaging** : certains projets exotiques demandent un peu de cuisine (overlays/patches).
- **macOS** (si Home Manager sur Darwin) : quelques divergences vs Linux à prévoir.

---

## 12) Itinéraire de migration (dotfiles → Nix)

1. **Inventaire** : lister ce que je configure à la main (shell, apps, services).
2. **Flake minimal** : 1 host + Home Manager intégré.
3. **Portage incrémental** : déplacer alias, thèmes, apps, service **par bloc**.
4. **Secrets** : introduire sops-nix, chiffrer, supprimer `.env`.
5. **DevShells** : créer un shell par projet.
6. **CI & cache** : brancher Cachix, activer builds.
7. **Nettoyage** : supprimer scripts/makefiles devenus obsolètes.

---

## 13) Exemples rapides “copier-coller”

**Entrer dans le devShell du repo** :

```bash
nix develop   # ou: nix develop .#default

```

**Lister les générations** :

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

```

**Construire sans activer (dry-run build)** :

```bash
nix build .#nixosConfigurations.fleur-01.config.system.build.toplevel

```

**Déployer à distance** :

```bash
sudo nixos-rebuild switch \
  --flake .#fleur-01 \
  --target-host root@192.0.2.10 \
  --build-host root@192.0.2.10

```

---

## 14) Glossaire express

- **Flake** : paquet logique Nix versionné (inputs/outputs), avec “lockfile”.
- **Derivation** : unité de build dans le store.
- **Overlay** : extension/modif de nixpkgs.
- **Home Manager** : déclaration de l’environnement utilisateur.
- **sops-nix** : chiffrement et injection de secrets.
- **DevShell** : environnement de dev reproductible.
- **Cachix** : cache binaire partagé.

---

## Conclusion

Nix/NixOS alignent mes priorités : **philosophie claire**, **simplicité déclarative**, **stack unifiée**, **sécurité** (secrets), **confort dev** (devShells), **rollbacks** et **déploiement** propres. Je n’empile plus des outils hétérogènes : je **compose** dans un seul paradigme. Résultat : **moins de friction**, **plus de sérénité**, et une **reproductibilité** que je n’avais jamais eue avant.

---

### Bonus : One-pager récap (à coller en haut de la page Notion)

- **Promesse** : même environnement partout, en 1 commande.
- **Piliers** : déclaratif, immuable, rollback, secrets chiffrés, devShells.
- **Remplace** : scripts maison, `.env` dispersés, beaucoup d’usages Docker en local.
- **Outils** : NixOS + Home Manager + sops-nix + (Cachix/Colmena si multi-hôtes).
- **Commandes** : `nixos-rebuild switch --flake .#host`, `nix flake update`, `nix develop`, `nix-collect-garbage -d`.

Si tu veux, je te prépare la **version flake complète** adaptée à ton dépôt (avec `hosts/fleur-*`, modules et un `devShell` typé Node/Go) pour un _copier-coller_ direct.
