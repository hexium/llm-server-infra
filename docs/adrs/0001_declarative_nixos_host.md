# 0001: Configure Forge declaratively with NixOS

Date: 2026-11-01  
Status: Accepted

## Context

The LLM server needs hostname `forge`, main user `dwarf`, Docker, `rg`, `dig`,
and `curl`. Its configuration must be versioned and reapplicable.

## Decision

Define the host in `configuration.nix` and expose it as
`nixosConfigurations.forge` through `flake.nix`. Include Git, Python, and Docker
Compose for operation. Use x86_64 Linux, UEFI systemd-boot, and DHCP as initial
hardware and network assumptions.

Set `system.stateVersion` to `26.05` for a new installation. Retain an existing
installation's original state version when adopting this configuration.

## Consequences

Host changes can be reviewed in Git and applied through NixOS rebuilds.
Architecture, boot mode, and generated disk configuration must be checked on the
target before installation. Package upgrades do not by themselves justify
changing `system.stateVersion`. GPU drivers and inference services remain future
hardware-specific decisions.
