{ config, lib, pkgs, ... }:

{
  environment.packages = with pkgs; [
    # Editor
    neovim

    # GNU core utilities - sort, head, tail, cat, ls, wc, cut, etc.
    coreutils

    # Common shell utilities
    procps
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    which
    less
    file
    curl

    # SSH daemon
    openssh

    # Daily-use tools (referenced in .bashrc)
    git
    fzf
    bat
    tree
    jq
    ncurses # for tput

    # Kubernetes
    kubectl
  ];

  # Backup etc files instead of failing to activate if a file already exists
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "Europe/Berlin";
}
