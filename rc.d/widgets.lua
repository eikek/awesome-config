local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local vicious = require("vicious")
local volume_widget = require("volume_widget")
local menubar = require("menubar")

-- Set the terminal for applications that require it
menubar.utils.terminal = config.terminal

-- Widgets are created by adding factories to the local `widgets'
-- table. The table is then traversed and the resulting widget and its
-- factory is added to the `config.widgets' table:
--
--     config.widgets["name"].factory  -- the factory
--     config.widgets["name"].widget[s] -- the widget for screen s
--
-- Therefore the factorie must be named. The `position' element
-- specified to which side (left, middle or right) the widget is
-- added. Widgets are added to the layout in the order they were
-- created.
--
-- The "factory" is a table with at least one `create' function that
-- creates the widget. It receives the current screen and the factory
-- table. If a widget can be reused across screens, wrap the `create'
-- function in `ek.memoize'.

config.widgets = {}
local widgets = {}

function widgets.add(factory)
   if not factory.name then
      error("The widget factory must be named.")
   end
   table.insert(widgets, factory)
end


-- Cpu widget
widgets.add({ 
      name = "cpu",
      position = "right",
      create = ek.memoize(function(s, this)
         local cpuwidget = wibox.widget.textbox()
         vicious.register(cpuwidget, vicious.widgets.cpu, " Cpu: <b>$1%</b> | ")
         return cpuwidget
      end)
})

-- net widget
widgets.add({
      name = "net",
      position = "right",
      create = ek.memoize(function(s, this)
            local ifname = ek.detect_if()
            local netwidget = wibox.widget.textbox()
            local text = 'Net: <span color="#CC9393">${'..  ifname ..' down_kb}</span> <span color="#7F9F7F">${'.. ifname ..' up_kb}</span> | '
            vicious.register(netwidget, vicious.widgets.net, text, 3)
            return netwidget
      end)
})

-- simple volume widget
widgets.add({
      name = "volume",
      position = "right",
      create = ek.memoize(function(s, this)
            return volume_widget.create()
      end)
})

-- Text Clock
widgets.add({
      name = "clock",
      position = "right",
      create = ek.memoize(function(s, this)
            return awful.widget.textclock()
      end)
})

-- layout box
widgets.add({
      name = "layouts",
      position = "right",
      create = function(s)
         local mylayoutbox = awful.widget.layoutbox(s)
         mylayoutbox:buttons(
            awful.util.table.join(
               awful.button({ }, 1, function () awful.layout.inc(config.layouts, 1) end),
               awful.button({ }, 3, function () awful.layout.inc(config.layouts, -1) end),
               awful.button({ }, 4, function () awful.layout.inc(config.layouts, 1) end),
               awful.button({ }, 5, function () awful.layout.inc(config.layouts, -1) end)
         ))
         return mylayoutbox
      end
})

-- awesome logo (menu removed)
widgets.add({
      name = "logo",
      position = "left",
      create = ek.memoize(function(s, this)
         return awful.widget.launcher({ 
               image = beautiful.awesome_icon,
               menu = awful.menu()
         })
      end)
})

-- tag list
widgets.add({
      name = "taglist",
      position = "left",
      buttons = awful.util.table.join(
         awful.button({ }, 1, awful.tag.viewonly),
         awful.button({ modkey }, 1, awful.client.movetotag),
         awful.button({ }, 3, awful.tag.viewtoggle),
         awful.button({ modkey }, 3, awful.client.toggletag),
         awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
         awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
      ),
      create = function(s, this) 
         return awful.widget.taglist(s, awful.widget.taglist.filter.all, this.buttons)
      end
})

-- prompt box
widgets.add({
      name = "promptbox",
      position = "left",
      create = function(s, this)
         return awful.widget.prompt()
      end
})

-- task list
widgets.add({
      name = "tasklist",
      position = "middle",
      buttons = awful.util.table.join(
         awful.button({ }, 1, function (c)
               if c == client.focus then
                  c.minimized = true
               else
                  -- Without this, the following
                  -- :isvisible() makes no sense
                  c.minimized = false
                  if not c:isvisible() then
                     awful.tag.viewonly(c:tags()[1])
                  end
                  -- This will also un-minimize
                  -- the client, if needed
                  client.focus = c
                  c:raise()
               end
         end),
         awful.button({ }, 3, function ()
               if instance then
                  instance:hide()
                  instance = nil
               else
                  instance = awful.menu.clients({
                        theme = { width = 250 }
                  })
               end
         end),
         awful.button({ }, 4, function ()
               awful.client.focus.byidx(1)
               if client.focus then client.focus:raise() end
         end),
         awful.button({ }, 5, function ()
               awful.client.focus.byidx(-1)
               if client.focus then client.focus:raise() end
      end)),
      create = function(s, this) 
         return awful.widget.tasklist(s, 
                                      awful.widget.tasklist.filter.currenttags, 
                                      this.buttons)
      end
})

-- add widgets
for s=1,screen.count() do
   mywibox = awful.wibox({ position = "top", screen = s })

   local positions = {
      left =  wibox.layout.fixed.horizontal(),
      middle = wibox.layout.fixed.horizontal(),
      right = wibox.layout.fixed.horizontal()
   }

   for _, maker in ipairs(widgets) do
      if (type(maker) == "table") then --skip the `add' function
         local pos = maker.position or "right"
         local widget = maker.create(s, maker)
         if widget then
            print("Add widget " .. maker.name)
            positions[pos]:add(widget)
            -- add to config 
            if not config.widgets[maker.name] then
               config.widgets[maker.name] = {}
            end
            if not config.widgets[maker.name].widget then
               config.widgets[maker.name].widget = {}
            end
            config.widgets[maker.name].factory = maker
            config.widgets[maker.name].widget[s] = widget
         else
            print("Widget ".. maker.name .." is nil")
         end
      end
   end
   if s == 1 then positions.right:add(wibox.widget.systray()) end

   local layout = wibox.layout.align.horizontal()
   layout:set_left(positions.left)
   layout:set_middle(positions.middle)
   layout:set_right(positions.right)
   mywibox:set_widget(layout)
end
