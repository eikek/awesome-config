
awful = require("awful")
require("awful.autofocus")
require("beautiful")
require("naughty")
require("gears")

config = {}
config.dir = os.getenv("AWESOME_CONFIG_DIR") or awful.util.getdir("config")

if (not string.find(package.path, "modules/?.lua")) then
   package.path = package.path .. ";" .. config.dir .. "/modules/?.lua"
end

ek = require("ek")

modkey = "Mod4"
config.titlebars_enabled = false
config.hostname = ek.get_hostname()
config.terminal = "xfce4-terminal"
config.editor = os.getenv("EDITOR") or "emacs"
config.screenshotdir = "$HOME/tmp/"
config.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.fair,
   awful.layout.suit.floating,
   --    awful.layout.suit.fair.horizontal,
   --    awful.layout.suit.spiral,
   --    awful.layout.suit.spiral.dwindle,
   --    awful.layout.suit.max,
   --    awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier
}

function rcfile(name)
   return config.dir .. "/rc.d/" .. name
end

dofile(rcfile("error.lua"))
dofile(rcfile("startup.lua"))
dofile(rcfile("theme.lua"))
dofile(rcfile("tags.lua"))
dofile(rcfile("widgets.lua"))
dofile(rcfile("keybindings.lua"))
dofile(rcfile("rules.lua"))
dofile(rcfile("signals.lua"))

-- load files by hostname
local hostnames = { "nyx", "shang", "ithaka" }
for _, hname in pairs(hostnames) do
   local hfile = "rc.d/".. hname ..".lua"
   if (config.hostname == hname and ek.file_exists(hfile)) then
      dofile(hfile)
   end
end
