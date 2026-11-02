#!/usr/bin/env python3
"""Apply, update, or roll back the Forge NixOS configuration."""

import argparse
from pathlib import Path
import subprocess
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "action", choices=("apply", "update", "rollback"), default="apply", nargs="?"
    )
    args = parser.parse_args()
    repo = Path(__file__).resolve().parent.parent

    try:
        if args.action == "rollback":
            subprocess.run(["sudo", "nixos-rebuild", "switch", "--rollback"], check=True)
            return 0

        if args.action == "update":
            status = subprocess.run(
                ["git", "status", "--porcelain"],
                cwd=repo, capture_output=True, text=True, check=True,
            )
            if status.stdout:
                print("Commit or stash local changes before updating.", file=sys.stderr)
                return 1
            subprocess.run(["git", "pull", "--ff-only"], cwd=repo, check=True)

        if not all(
            (repo / name).is_file()
            for name in ("flake.lock", "hardware-configuration.nix")
        ):
            print(
                "Missing flake.lock or hardware-configuration.nix; see README.md.",
                file=sys.stderr,
            )
            return 1

        # Include the ignored hardware file without refreshing dependency pins.
        subprocess.run(
            [
                "sudo", "nixos-rebuild", "switch", "--flake",
                f"path:{repo}#forge", "--no-update-lock-file",
            ],
            cwd=repo, check=True,
        )
        return 0
    except subprocess.CalledProcessError as error:
        return error.returncode if error.returncode > 0 else 1
    except OSError as error:
        print(str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
