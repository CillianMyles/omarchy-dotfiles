-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- T3 Code runs its server inside the desktop app, so start it at login: every
-- box hosts T3 for Cillian's other devices, over Tailscale on port 3443.
o.launch_on_start("t3code")
