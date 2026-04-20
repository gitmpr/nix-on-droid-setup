# nix-on-droid-setup

Configuration files for a [nix-on-droid](https://github.com/nix-community/nix-on-droid) setup on a Pixel 10 (aarch64). Tracks what would otherwise be configuration drift.

## What's configured

| File | Installed to | Purpose |
|---|---|---|
| `nix/flake.nix` | `~/.config/nix-on-droid/flake.nix` | Flake entry point, pins nixpkgs 24.05 |
| `nix/nix-on-droid.nix` | `~/.config/nix-on-droid/nix-on-droid.nix` | Package list, timezone, nix settings |
| `home/bash_profile` | `~/.bash_profile` | Sources `/etc/profile` (Nix PATH) and `.bashrc` for login shells |
| `ssh/sshd_config` | `~/.ssh/sshd_config` | SSH daemon config (port 9022, pubkey auth) |
| `nvim/init.lua` | `~/.config/nvim/init.lua` | Neovim config |

## Applying the nix configuration

Run from the nix-on-droid terminal app (not over SSH, where the Nix PATH isn't set up):

```bash
unset TMPDIR && nix-on-droid switch --flake ~/.config/nix-on-droid
```

`unset TMPDIR` is needed because the interactive shell sets `TMPDIR` to the Termux app's tmp directory, which nix-on-droid cannot access (different Android app sandbox). Without it you get a `Permission denied` on `/data/data/com.termux`.

## Starting sshd

There is no service manager on nix-on-droid, so sshd must be started manually from the nix-on-droid terminal app:

```bash
~/.nix-profile/bin/sshd -f ~/.ssh/sshd_config
```

SSH host keys (`~/.ssh/ssh_host_ed25519_key` and `~/.ssh/ssh_host_rsa_key`) are not tracked here. Generate them once with:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ssh_host_ed25519_key -N ""
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ssh_host_rsa_key -N ""
```

## Known limitations

- **Fetching new nixpkgs tarballs fails** with `Can't set permissions to 0755` due to Android filesystem restrictions in the proot environment. This means adding a second nixpkgs input (e.g. nixpkgs-unstable) to the flake does not work. Upgrading the channel requires fetching a fresh tarball and will hit the same issue.
- **Non-interactive SSH sessions** (`ssh host 'command'`) do not get the Nix PATH. The `~/.bash_profile` fix only applies to interactive login shells. Prefix commands with `~/.nix-profile/bin/` as a workaround, e.g. `ssh nix-on-droid '~/.nix-profile/bin/nvim --version'`.
- **Neovim is v0.9.5** (from nixpkgs 24.05). The init.lua OSC52 clipboard block is guarded with a `vim.fn.has('nvim-0.10')` check so it degrades gracefully.
