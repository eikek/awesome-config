-- found here: http://tsdh.wordpress.com/2009/03/04/integrating-emacs-org-mode-with-the-awesome-window-manager/
--
-- the current agenda popup
local naughty = require("naughty")
local org = {}

-- do some highlighting and show the popup
function org.show_agenda ()
   local fd = io.open("/tmp/org-agenda.txt", "r")
   if not fd then
      return
   end
   local text = fd:read("*a")
   local doneColor = "#A9FF87"
   local todoColor = "#ff0000"
   fd:close()
   -- highlight week agenda line
   text = text:gsub("(Week%-agenda[ ]+%(W%d%d?%):)", "<span weight='bold' color='#ffffff' underline='single'>%1</span>")
   -- highlight dates
   text = text:gsub("(%w+[ ]+%d%d? %w+ %d%d%d%d)", "<span color='#6BB5FF'>%1</span>")
   -- highlight times
   text = text:gsub("(%d%d?:%d%d)", "%1")
   -- highlight tags
   text = text:gsub("(:[^ ]+:)([ ]*n)", "%1%2")
   -- highlight TODOs
   text = text:gsub("(TODO) ", "<span color='".. todoColor .. "'>%1</span> ")
   text = text:gsub("(BUG) ", "<span color='".. todoColor .."'>%1</span> ")
   text = text:gsub("(WAITING) ", "<span color='".. todoColor .."'>%1</span> ")
   text = text:gsub("(DONE) ", "<span color='".. doneColor .."'>%1</span> ")
   text = text:gsub("(WONTFIX) ", "<span color='".. doneColor .."'>%1</span> ")
   -- highlight categories
   text = text:gsub("([ ]+%w+:) ", "%1 ")
   org_agenda_pupup = naughty.notify(
      { text     = text,
        timeout  = 999999999,
        width    = 600,
        position = "bottom_right",
        screen   = mouse.screen })
end

-- dispose the popup
function org.dispose_agenda ()
   if org_agenda_pupup ~= nil then
      naughty.destroy(org_agenda_pupup)
      org.org_agenda_pupup = nil
   end
end

return org
