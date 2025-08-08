# AGENTS

This repository contains NixOS and Home Manager configuration.

## Guidelines

- Use English for commit messages and code comments.
- Format any modified Nix files with `nix fmt`.
- After making changes, run the tests:

```bash
nix flake check
```

Commit only when the check succeeds.
