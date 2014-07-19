awful = require("awful")

-- some other utiltity functions
local ek = {}

-- returns first or n lines of program output
function ek.exec(cmd, n)
   local h = assert(io.popen(cmd))
   local result
   if n == nil or n == 1 then
      result = h:lines()()
   else
      result = {}
      for l in h:lines() do table.insert(result, l) end
   end
   h:close()
   return result
end

-- detect active ifs connected to the "outside"
function ek.detect_if() 
   local out = ek.exec("ip route get 99.0.0.0")
   return string.match(out or "", "dev (%w+)")
end

-- get this hostname
function ek.get_hostname()
   return ek.exec("hostname")
end

-- takes a screenshot and saves it to dir. if sel is true the mouse is
-- used to select a window or an rectangle. otherwise its a complete
-- screenshot
function ek.screenshot(dir, sel) 
   -- i actually wanted to use scrot, but it did not work with -s?!
   local opts = "-root"
   if sel then opts = "-screen" end
   local name = (dir or "./") .. "%Y-%m-%d_$wx$h.png"
   local cmd = "XCURSOR_THEME=redglass xwd ".. 
      opts .."| convert - ".. 
      config.screenshotdir .."$(date +%Y%m%d-%H%M%S).png"
   os.execute("mkdir -p ".. dir)
   awful.util.spawn_with_shell(cmd, false)
end

-- run a program once
function ek.runonce(cmd)
   local prg = string.match(cmd, "(%w+)")
   local pid = ek.exec("pidof "..prg)
   if not pid then
      awful.util.spawn(cmd)
   end
end

-- checks if a file exists by trying to open it
function ek.file_exists(name)
   local f = io.open(name, "r")
   local result = f ~= nil
   if f then f:close() end
   return result
end

-- returns a function that calls the given function but remembers the
-- result
function ek.memoize(f)
   local val = nil
   local init = true
   return function(...)
      if not init then return val else
         val = f(...)
         init = false
         return val
      end
   end
end

function ek.volume_up() 
   awful.util.spawn("amixer set Master 5%+")
end

function ek.volume_down()
   awful.util.spawn("amixer set Master 5%-")
end

return ek
