# Forge

Architecture decisions are recorded in the [ADR index](docs/adrs/0000_index.md).

NixOS base for an x86_64 UEFI LLM server, with user `dwarf`, Docker,
Docker Compose, `rg`, `dig`, `curl`, Git, `nvidia-smi`, and key-only SSH.
GPU drivers and model services depend on your hardware and are not configured.
`nvidia-smi` requires a compatible NVIDIA driver configured for the host GPU;
the utility follows the driver selected by `hardware.nvidia.package`.
The `docker` group grants administrative access to the host.

## First installation

Use the NixOS installer to partition and mount the server's disks at `/mnt`.
Clone this repository to `/mnt/etc/nixos` and run:

```sh
nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix
cd /mnt/etc/nixos
nix --extra-experimental-features 'nix-command flakes' flake lock
```

The hardware file stays local and contains the server's disk UUIDs. Commit
`flake.lock` to this repository before installing; it pins the exact Nixpkgs
revision used by subsequent applies. Nix is needed to generate that file.
Add your SSH public key to `users.users.dwarf.openssh.authorizedKeys.keys`
and commit that configuration too. Adjust the architecture and boot loader if
needed. For an existing installation, retain its `system.stateVersion`.

```sh
nixos-install --flake path:/mnt/etc/nixos#forge
nixos-enter --root /mnt -c 'passwd dwarf'
reboot
```

Keep the checkout at `/etc/nixos` on the installed server and give `dwarf`
ownership of the checkout so Git updates can run without sudo. Set a password
for `dwarf` as shown above so sudo works; SSH uses the configured public key.

## Apply, update, and recover

Run from the checkout as `dwarf`:

```sh
# Reapply the currently checked-out version with its pinned dependencies.
python3 scripts/manage.py apply

# Fetch the upstream branch and apply its latest committed configuration.
python3 scripts/manage.py update

# Switch to the preceding NixOS generation.
python3 scripts/manage.py rollback
```

Updates are manual. `update` requires a clean checkout and a configured Git
upstream, and accepts only fast-forward updates. A build failure leaves the
Git checkout at the fetched revision, allowing `apply` to retry it. Activation
errors can partially change services; use rollback or the boot menu to recover.
Previous generations remain available unless explicitly garbage-collected.

To deploy an older Git revision, check it out and run `apply` (the checkout can
be detached). To return to updates, switch back to your tracked branch first.
For a new checkout, restore the host's hardware file before applying.

To update NixOS packages, run `nix flake update nixpkgs` on a machine with Nix,
review and commit `flake.lock`, then run `update` on forge. Normal deployment
does not refresh dependencies. Configuration and dependency pins reproduce the
system build; mutable Docker images, model files, and container data need their
own versioning and backups.

Docker setup follows the [official NixOS documentation](https://wiki.nixos.org/wiki/Docker/en).
