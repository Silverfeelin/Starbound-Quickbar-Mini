-- simple stub to open a defined interface, then set the swap slot item back to what it was before
function update(dt, fireMode, shiftHeld, moves)
  activeItem.setHoldingItem(false)

  local info = config.getParameter("info") or {}

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
    local status, err = pcall(function() require(info.loadScript) end)
    if not status then
      sb.logError("Quickbar: Failed loading '%s':\n%s", info.loadScript, err)
    end
  end

  -- Open interface and swap item back.
  if quickbarConfig then
    activeItem.interact(info.interactionType or "ScriptPane", quickbarConfig, activeItem.ownerEntityId())
  else
    sb.logError("Quickbar: Couldn't open an interface, as no valid config was defined.\nInfo: %s", sb.printJson(info))
  end

  restoreItem()
end

function restoreItem()
  local item = config.getParameter("restore") or { name = "", count = 0, parameters = {} }
  player.setSwapSlotItem(item)
end