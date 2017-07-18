--

function openInterface(info)
  -- Type checking
  if type(info) == "string" then
    info = { config = root.assetJson(info) }
  elseif type(info) ~= "table" then
    sb.logError("Quickbar: Interface '%s' could not be opened. Expected a string or table.", info)
    restoreItem()
    return
  end

  -- Globally store configuration.
  if type(info.config) == "string" then
    quickbarConfig = root.assetJson(info.config)
  elseif type(info.config) == "table" then
    quickbarConfig = info.config
  end

  -- Allow dynamic modification of the loaded configuration through global 'quickbarConfig'.
  if quickbarConfig and info.loadScript then
    loadScript(info.loadScript)
  end

  -- Open interface.
  if quickbarConfig then
    player.interact(info.interactionType or "ScriptPane", quickbarConfig)
  else
    sb.logError("Quickbar: Couldn't open an interface, as no valid config was defined.\nInfo: %s", sb.printJson(info))
  end
end

local wList = "scroll.list"

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

function loadScript(script)
  local status, err = pcall(function() require(info.loadScript) end)
  if not status then
    sb.logError("Quickbar: Failed loading '%s':\n%s", info.loadScript, err)
  end
end
