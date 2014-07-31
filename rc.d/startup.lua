local awful = require("awful")
local ek = require("ek")
-- some startup programs

awful.util.spawn("setxkbmap -layout de")

ek.runonce("compton -b")
