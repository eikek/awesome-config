-- Define a tag table which hold all screen tags.
local awful = require("awful")

config.tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    config.tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, config.layouts[1])
end
