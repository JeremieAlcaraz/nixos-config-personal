# GitHub Actions QCOW2 Build Pipeline

This document explains how the `build-qcow.yml` workflow works and how to use it to produce a QCOW2 image for Proxmox.

## Overview

The workflow runs on GitHub-hosted Ubuntu runners. Each run performs these steps:

1. Check out the repository.
2. Install Nix using `cachix/install-nix-action`, enabling the `nix-command` and `flakes` features.
3. Invoke `nixos-generators` with the `nixos` flake output to produce a QCOW2 image.
4. Publish the resulting `nixos.qcow2` file as a downloadable artifact.

Because the build happens on a clean Linux runner, you do not need any local tooling on macOS.

## Triggering the workflow

- **Push trigger**: any push to the `main` branch runs the workflow automatically.
- **Manual trigger**: you can trigger it via the *Run workflow* button in the *Actions* tab (`workflow_dispatch`).

## Downloading the image

1. Navigate to **Actions** in GitHub.
2. Open the latest **Build QCOW2 image** run.
3. Download the `nixos-qcow2` artifact. It contains `out/nixos.qcow2`.

## Using the image with Proxmox

After downloading the artifact locally or on a Proxmox host:

```bash
qm create <VMID> --name nixos --memory 4096 --cores 2
qm importdisk <VMID> nixos.qcow2 local-lvm
qm set <VMID> --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-<VMID>-disk-0
qm set <VMID> --boot c --bootdisk scsi0
```

Adjust the resources to fit your environment. The VM will include the Proxmox guest agent and cloud-init support configured in `host/nixos/configuration.nix`.

## Customising the workflow

- Change the `--flake` argument if you expose additional NixOS configurations (e.g. `.#server`).
- Add cache support via [Cachix](https://docs.cachix.org/) to speed up builds on repeated runs.
- Extend the workflow with a deployment step (e.g. upload to S3 or copy to Proxmox via `scp`) if you need automatic distribution.

## Troubleshooting

- If the workflow fails during the Nix build, inspect the run logs for the `Build QCOW2` step.
- Ensure the flake output referenced in `--flake` exists; run `nix flake show` locally to verify.
- Validate configuration changes with `nix flake check` before pushing to reduce CI failures.
