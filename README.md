# nixlab

Nix Homelab config, sandbox to play around with. Very WIP and will change a lot.

# THE PLAN

Nix EVERYTHING!!!

- Seonhee
    - iPhone 13 Pro Max with Tailscale (cannot meaningfully set up Nix on this)

- Akiyama
    - Intel N100 mini PC running Proxmox (I'm scared to install Nix anything on this)

- Haruka
    - M1 Mac using Nix-Darwin + home-manager + homebrew

- Saeko
    - Main home server running 10GbE + SSD array + Ryzen APU
    - Transcodes video for Jellyfin, converts H265 footage to ProRes, main "compute" node

- Nanba
    - HP T620 thin client running AdGuard Home, Tailscale, and Cloudflare Tunnel
    - Impermanence configuration with root filesystem running in RAM

- Sayama
    - Proxmox Debian VM (will be Nix'd soon) that runs Tailscale exit node as backup

- Baba
    - Proxmox Debian VM (will also be Nix'd soon) that runs AdGuard Home for redundancy

- Kaito
    - 1U shucked drive backup server 
    - Runs restic backups to Backblaze
    - Drive spindown
    - Impermanence configuration

- Saejima
    - NixOS gaming and editing PC
    - NVIDIA 4070 Super
    - Intel i5-13600K
    - Steam games through Proton
    - DaVinci Resolve, 10GbE card to edit over the network from Saeko

All in the cards.

The goal is to have simple, yet robust secrets management and easy deployment using deploy-rs.
