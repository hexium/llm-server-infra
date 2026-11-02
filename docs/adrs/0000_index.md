# Architecture decision records

These records describe the decisions implemented in the Forge server repository.
Accepted records describe the chosen design; they do not imply that installation
or deployment validation has been completed.

| ADR | Decision | Status |
| --- | --- | --- |
| [0001](0001_declarative_nixos_host.md) | Configure Forge declaratively with NixOS | Accepted |
| [0002](0002_pinned_dependencies_and_local_hardware.md) | Pin dependencies and keep hardware configuration local | Accepted |
| [0003](0003_python_management_and_recovery.md) | Manage manual deployments and recovery with Python | Accepted |
| [0004](0004_docker_and_server_access.md) | Use Docker for workloads and key-only SSH for administration | Accepted |

Record new decisions in sequentially numbered Markdown files with context,
decision, and consequences. Preserve historical records; when replacing a
decision, mark it superseded and link to its replacement. Update this index.

See the [setup and operating instructions](../../README.md) for commands.
