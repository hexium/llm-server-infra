# 0004: Use Docker for workloads and key-only SSH for administration

Date: 2026-11-01  
Status: Accepted

## Context

The server must support Docker and remote administration by `dwarf`. Specific
models, GPU hardware, and inference endpoints have not been selected.

## Decision

Enable the NixOS Docker service and install Docker Compose. Create `dwarf` as a
normal user in the `wheel` and `docker` groups.

Enable SSH with public-key authentication, disable password and keyboard
interactive authentication, and disallow direct root SSH login. Keep the NixOS
firewall enabled. Add the operator's public key before deployment and set a local
password for sudo during installation.

Do not select GPU drivers, deploy inference containers, or configure model-serving
ports until workload and hardware requirements are known.

## Consequences

The operator can administer the host through sudo and manage Docker workloads.
Docker group membership grants administrative control of the host. SSH access
requires provisioning a valid public key; the committed key list is initially
empty. Workload-specific networking, image pins, storage, and backups need
additional configuration when services are introduced.
