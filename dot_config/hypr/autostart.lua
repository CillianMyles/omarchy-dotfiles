-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- T3 Code runs its server inside the desktop app, so start it at login: every
-- box hosts T3 for Cillian's other devices, over Tailscale on port 3443.
-- Launch it by its desktop entry, which both installs provide: Omarchy's
-- self-updating AppImage (~/.local/share/t3code, Omarchy 4.5 onwards) and the
-- older t3code-bin package that Omarchy 4.5's migration replaces.
o.launch_on_start("t3code.desktop")
