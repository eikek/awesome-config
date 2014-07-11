-- on github: https://github.com/esn89/volumetextwidget/blob/master/textvolume.lua
-- based on http://awesome.naquadah.org/wiki/Volume_control_and_display

local wibox = require("wibox")
local awful = require("awful")

local volume = {}


function volume.update_volume(widget)
   local fd = io.popen("amixer sget Master")
   local status = fd:read("*all")
   fd:close()

   local volume = string.match(status or "", "(%d?%d?%d)%%")
   volume = string.format("% 3d", volume or 0)

   status = string.match(status, "%[(o[^%]]*)%]")

   if string.find(status or "off", "on", 1, true) then
   -- For the volume number percentage
       volume = volume .. "%"
   else
   -- For displaying the mute status.
       volume = volume .. "M"
       
   end
   widget:set_markup("Vol:<span color=\"#ffffc9\">" .. volume .. "</span> |")
end

function volume.create()
   local volume_widget = wibox.widget.textbox()
   volume_widget:set_align("right")

   volume.update_volume(volume_widget)

   mytimer = timer({ timeout = 0.2 })
   mytimer:connect_signal("timeout", function () volume.update_volume(volume_widget) end)
   mytimer:start()

   return volume_widget
end

return volume
