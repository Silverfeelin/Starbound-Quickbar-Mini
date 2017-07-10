--

function openInterface(info)
  if player.isLounging() then
    pane.playSound("/sfx/interface/clickon_error.ogg")
    return
  end

  -- Silverfeelin: This is the bit that differs from StardustLib.
  local item = root.assetJson("/sys/stardust/quickbar/quickbarItem.config")
  item.parameters.info = info
  item.parameters.restore = player.swapSlotItem()
  player.setSwapSlotItem(item)
end

local wList = "scroll.list"

local prefix = ""

function addItem(item, prefix)
  prefix = type(prefix) == "string" and prefix or ""
  local label = string.format("%s%s", prefix, item.label)

  local wLi = string.format("%s.%s", wList, widget.addListItem(wList))
  local wLabel = string.format("%s.%s", wLi, "label")
  local wBtnContainer = string.format("%s.%s", wLi, "buttonContainer")

  widget.setText(wLabel, label)
  widget.registerMemberCallback(wBtnContainer, "click", function()
    openInterface({ config = item.pane, loadScript = item.loadScript })
  end)

  local wBtn = string.format("%s.%s.%s", wBtnContainer, widget.addListItem(wBtnContainer), "button")
  if item.icon then
    local icon = item.icon
    if icon:sub(1,1) ~= "/" then icon = "/quickbar/" .. icon end
    widget.setButtonOverlayImage(wBtn, icon)
  end
end

function addItems(items, prefix)
  if type(items) ~= "table" or #items == 0 then return end

  for _,v in ipairs(items) do
    addItem(v, prefix)
  end
end

function init()
  widget.clearListItems(wList)

  local items = root.assetJson("/quickbar/icons.json") or {}
  addItems(items.priority, "^#7fff7f;")
  if player.isAdmin() then
    addItems(items.admin, "^#bf7fff;")
  end
  addItems(items.normal)
end
