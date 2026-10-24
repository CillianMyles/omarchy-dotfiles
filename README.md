# Omarchy dotfiles

My Omarchy customizations, managed with [chezmoi](https://chezmoi.io).

## New machine

1. Install Omarchy from the ISO with the UK keyboard layout.
2. At the machine's console (keyboard or IP KVM), run:
   ```
   omarchy pkg add chezmoi
   TS_AUTHKEY=tskey-auth-... chezmoi init --apply --force CillianMyles/omarchy-dotfiles
   ```
   - **Tailscale:** `TS_AUTHKEY` is the reusable `tag:agent` auth key from
     Bitwarden. The box joins that key's tailnet unattended, and its key never
     expires. A key joins the tailnet that issued it, so use the one for the
     machine's zone (personal or Dexter's). Leave it out to log in through the
     browser instead.
   - **Console first:** the first apply switches SSH to keys only before it
     writes the keys, so run it at the console, not over a password SSH
     session.
   - **Different keyboard:** before `chezmoi init`, create
     `~/.config/chezmoi/chezmoi.toml` with `[data]` and `keyboard = "us"`
     (FrankenBook). Every other machine is UK (`gb`, set in
     `.chezmoidata.toml`).
   - **Prompts:** the Voxtype dictation installer asks whether to download its
     model.

   `run_onchange_before_10-setup-system.sh.tmpl` runs first (packages, SSH,
   firewall, Tailscale, keyboard layout, headless lid/Wake-on-LAN, wayvnc
   setup), then the config files are written, then
   `run_onchange_after_20-enable-user-services.sh` starts user services
   (wayvnc).
3. From a client whose key is in `private_dot_ssh/private_authorized_keys`,
   `ssh <box>` now works over Tailscale or the home LAN. Save the box's VNC
   password (below) in Bitwarden as `<Box> VNC`.

The rest of a new box (GitHub access, skills, projects) follows the
`box-setup` skill in `CillianMyles/skills`.

System files that live outside `$HOME` are kept in `system/` and installed by
the setup script.

## What every machine gets

- **SSH:** keys only (`system/20-key-only.conf`), for the clients listed in
  `private_dot_ssh/private_authorized_keys`. It's open to the home LAN
  (`192.168.86.0/24` and private IPv6; `<box>.local` answers on wired links) and over
  Tailscale (`<box>`) only.
- **T3 Code** starts at login (`dot_config/hypr/autostart.lua`), because its
  server runs inside the desktop app.
- **Pseudo-headless server:** wayvnc (Tailscale only), the lid stays awake on
  AC or with an external display, no screensaver, and Wake-on-LAN on wired
  connections.
- **Keyboard:** UK unless the machine overrides it. Omarchy's Hyprland config
  reads the layout from `/etc/vconsole.conf`, so it's set in one place.
  Omarchy makes Caps Lock a Compose key; real Caps Lock is both Shifts.

## Software

Tracked here, installed on every machine and kept current by
`omarchy update` (packages, then `mise up`):

- **Packages:** Tailscale, T3 Code (`t3code-bin`), wayvnc, OpenSSH,
  Bitwarden and its CLI, chezmoi, Voxtype, ethtool, tmux, jq and sqlite.
- **mise** (`dot_config/mise/config.toml`): Claude Code, Codex, GitHub CLI,
  Grok and Node 26. Omarchy's own tools (git, Docker and the rest) come with
  Omarchy.

After an update that installs a new kernel, reboot (and unlock the disk) so
modules such as Tailscale's `tun` load.

## VNC

macOS Screen Sharing works: `vnc://<box-name>`. It asks for a password only,
with no username. Screen Sharing speaks RFB 3.3, so it can only use the
classic DES password, which is why `allow_broken_crypto` is on; VNC is only
reachable over Tailscale, which encrypts the connection. Other clients
(TigerVNC, RealVNC) log in as `cillian` with RSA-AES.

Each box generates its own 8-character password on first apply in
`~/.config/wayvnc/password`, which is never committed. Paste it rather than
typing it. To change it, edit that file, then
`chezmoi apply && systemctl --user restart wayvnc`.

Detected automatically: the software-cursor fix (only with the nouveau
driver) and the Apple keyboard fn-key fix (only on Apple hardware).

## Day to day

- Changed a tracked file: `chezmoi re-add && chezmoi cd && git commit -am "..." && git push`
  - `re-add` skips templates (`*.tmpl`: `looknfeel.lua`).
    For those, run `chezmoi merge <path>` or edit with `chezmoi edit <path>`.
- Track a new file: `chezmoi add <path>`
- Made a system change (package, service, firewall): add it to
  `run_onchange_before_10-setup-system.sh.tmpl`
- Pull changes onto another machine: `chezmoi update`, or from Silverbook
  `ssh -t <box> chezmoi update` (the setup script's `sudo` prompts appear in
  your terminal)

Only files that differ from Omarchy's defaults are tracked, so Omarchy
updates still apply to everything else.
