# 0003: Manage manual deployments and recovery with Python

Date: 2026-11-01  
Status: Accepted

## Context

Operators need to reapply the checked-out configuration, update from Git, and
recover a previous system generation. The requested management language is
Python, and the script name is `manage`.

## Decision

Provide `scripts/manage.py` using only the Python standard library. Invoke
external commands with argument lists and propagate command failures.

| Action | Behavior |
| --- | --- |
| `apply` (default) | Rebuild and switch using the current checkout and dependency lock. |
| `update` | Require a clean checkout, pull the configured upstream with `--ff-only`, then apply. |
| `rollback` | Run `sudo nixos-rebuild switch --rollback`. |

Resolve the checkout location from the script path. Use sudo for system changes.
Keep updates operator-triggered; configure no unattended update timer.

## Consequences

Reapplication does not fetch Git changes or refresh dependencies. An older Git
revision can be checked out and applied explicitly. Normal updates require
returning to a branch with a configured upstream.

An unsuccessful update leaves the checkout at the fetched revision, allowing an
apply retry. Activation failures may partially change services. Rollback changes
the NixOS generation, not the Git checkout or application data. Boot-menu recovery
depends on retaining previous generations; no automatic garbage collection is
configured here.
