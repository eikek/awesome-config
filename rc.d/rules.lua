local beautiful = require("beautiful")
awful.rules = require("awful.rules")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = config.clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "R_x11" },
      properties = { }, callback = awful.client.setslave },
    { rule = { class = "java-lang-Thread", name = "Nice2" },
      properties = { tag = config.tags[1][5] } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Qt4-ssh-askpass" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = config.tags[1][2] } },
}
-- }}}
