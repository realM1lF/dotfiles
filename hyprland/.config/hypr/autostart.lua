-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Auto-detect work/home monitor layout on login.
o.exec_on_start(os.getenv("HOME") .. "/.config/hypr/scripts/workspace-setup.sh auto")
