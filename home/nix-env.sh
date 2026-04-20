# ~/.nix-env.sh
# Minimal Nix profile PATH setup for non-interactive shells.
#
# Intended to be sourced via BASH_ENV so that commands run over SSH
# (e.g. `ssh nix-on-droid 'some-command'`) find Nix-installed binaries.
#
# NOTE: As of nix-on-droid with OpenSSH 9.7p1, SetEnv BASH_ENV in sshd_config
# does not appear to propagate to the shell environment (likely stripped by
# proot or the nix-on-droid session setup). Left here for documentation and
# future reference.
#
# To activate (in ~/.ssh/sshd_config):
#   SetEnv BASH_ENV=/data/data/com.termux.nix/files/home/.nix-env.sh

export PATH="/data/data/com.termux.nix/files/home/.nix-profile/bin:${PATH}"
