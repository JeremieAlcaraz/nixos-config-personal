#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 0 ]; then
  find . -name '*.nix' -print0 | xargs -0 -r nixpkgs-fmt
else
  args=()
  for path in "$@"; do
    case "$path" in
      *.nix) args+=("$path") ;;
      *) : ;;
    esac
  done
  if [ "${#args[@]}" -gt 0 ]; then
    nixpkgs-fmt "${args[@]}"
  fi
fi
