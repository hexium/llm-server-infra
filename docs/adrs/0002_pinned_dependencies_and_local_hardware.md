# 0002: Pin dependencies and keep hardware configuration local

Date: 2026-11-01  
Status: Accepted

## Context

Reapplying a repository revision should use the same Nixpkgs revision. Disk UUIDs
and other generated hardware settings belong to the installed machine.

## Decision

Use the `nixos-26.05` Nixpkgs input and commit a generated `flake.lock`. Refresh
dependencies explicitly with `nix flake update nixpkgs`, then review and commit
the lock change. Deployments pass `--no-update-lock-file`.

Generate `hardware-configuration.nix` on the target and ignore it in Git. Import
it from the host configuration and use a `path:` flake reference so the local,
ignored file is included during evaluation.

## Consequences

Deployment requires both the lock file and local hardware file. The management
script checks for them. The lock file has not yet been generated because Nix is
unavailable in the authoring environment; generating and committing it is a
first-installation prerequisite.

A replacement checkout must receive the correct hardware file. Git revisions
alone do not capture this file, container data, model files, or mutable container
images; these require separate preservation or versioning.
