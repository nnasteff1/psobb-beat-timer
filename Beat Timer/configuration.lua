local function ConfigurationWindow(configuration, customTheme)
  local this = {
    title = "Beat Timer - Configuration",
    fontScale = 1.0,
    open = false,
    changed = false,
  }

  local _configuration = configuration

  local function PresentColorEditor(label, default, custom)
    custom = custom or 0xFFFFFFFF

    local changed = false
    local i_default =
    {
        bit.band(bit.rshift(default, 24), 0xFF),
        bit.band(bit.rshift(default, 16), 0xFF),
        bit.band(bit.rshift(default, 8), 0xFF),
        bit.band(default, 0xFF)
    }
    local i_custom =
    {
        bit.band(bit.rshift(custom, 24), 0xFF),
        bit.band(bit.rshift(custom, 16), 0xFF),
        bit.band(bit.rshift(custom, 8), 0xFF),
        bit.band(custom, 0xFF)
    }

    local ids = { "##X", "##Y", "##Z", "##W" }
    local fmt = { "A:%3.0f", "R:%3.0f", "G:%3.0f", "B:%3.0f" }

    imgui.BeginGroup()
    imgui.PushID(label)

    imgui.PushItemWidth(75)
    for n = 1, 4, 1 do
        local changedDragInt = false
        if n ~= 1 then
            imgui.SameLine(0, 5)
        end

        changedDragInt, i_custom[n] = imgui.DragInt(ids[n], i_custom[n], 1.0, 0, 255, fmt[n])
        if changedDragInt then
            this.changed = true
        end
    end
    imgui.PopItemWidth()

    imgui.SameLine(0, 5)
    imgui.ColorButton(i_custom[2] / 255, i_custom[3] / 255, i_custom[4] / 255, i_custom[1] / 255)
    if imgui.IsItemHovered() then
        imgui.SetTooltip(
            string.format(
                "#%02X%02X%02X%02X",
                i_custom[4],
                i_custom[1],
                i_custom[2],
                i_custom[3]
            )
        )
    end

    imgui.SameLine(0, 5)
    imgui.Text(label)

    default =
    bit.lshift(i_default[1], 24) +
    bit.lshift(i_default[2], 16) +
    bit.lshift(i_default[3], 8) +
    bit.lshift(i_default[4], 0)

    custom =
    bit.lshift(i_custom[1], 24) +
    bit.lshift(i_custom[2], 16) +
    bit.lshift(i_custom[3], 8) +
    bit.lshift(i_custom[4], 0)

    if custom ~= default then
        imgui.SameLine(0, 5)
        if imgui.Button("Revert") then
            custom = default
            this.changed = true
        end
    end

    imgui.PopID()
    imgui.EndGroup()

    return custom
end


  local _showWindowSettings = function()
    local success

    if imgui.TreeNodeEx("General", "DefaultClosed") then
      if imgui.Checkbox("Enable", _configuration.EnableWindow) then
        _configuration.EnableWindow = not _configuration.EnableWindow
        this.changed = true
      end
    
      if customTheme then
        if imgui.Checkbox("Use custom theme", _configuration.useCustomTheme) then
            _configuration.useCustomTheme = not _configuration.useCustomTheme
           this.changed = true
        end
      end

      if imgui.Checkbox("No title bar", _configuration.NoTitleBar == "NoTitleBar") then
        if _configuration.NoTitleBar == "NoTitleBar" then
          _configuration.NoTitleBar = ""
        else
          _configuration.NoTitleBar = "NoTitleBar"
        end
        this.changed = true
      end

      if imgui.Checkbox("No resize", _configuration.NoResize == "NoResize") then
        if _configuration.NoResize == "NoResize" then
          _configuration.NoResize = ""
        else
          _configuration.NoResize = "NoResize"
        end
        this.changed = true
      end
      
      if imgui.Checkbox("Transparent window", _configuration.Transparent) then
        _configuration.Transparent = not _configuration.Transparent
        this.changed = true
      end
      
      success, _configuration.fontScale = imgui.InputFloat("Font Scale", _configuration.fontScale)
      if success then
        this.changed = true
      end
      
      
      imgui.Text("\nPosition and Size")
      imgui.PushItemWidth(150)
      success, _configuration.X = imgui.InputInt("X", _configuration.X)
      imgui.PopItemWidth()
      if success then
        _configuration.Changed = true
        this.changed = true
      end
      
      imgui.SameLine(0, 38)
      imgui.PushItemWidth(150)
      success, _configuration.Y = imgui.InputInt("Y", _configuration.Y)
      imgui.PopItemWidth()
      if success then
        _configuration.Changed = true
        this.changed = true
      end
      
      imgui.PushItemWidth(150)
      success, _configuration.Width = imgui.InputInt("Width", _configuration.Width)
      imgui.PopItemWidth()
      if success then
        _configuration.Changed = true
        this.changed = true
      end
      
      imgui.SameLine(0, 10)
      imgui.PushItemWidth(150)
      success, _configuration.Height = imgui.InputInt("Height", _configuration.Height)
      imgui.PopItemWidth()
      if success then
        _configuration.Changed = true
        this.changed = true
      end

      imgui.TreePop()
    end

    if imgui.TreeNodeEx("Display", "DefaultClosed") then
      if imgui.Checkbox("Show .beat clock", _configuration.ShowBeatClock) then
        _configuration.ShowBeatClock = not _configuration.ShowBeatClock
        this.changed = true
      end
      if imgui.Checkbox("Color Enabled", _configuration.ColorEnabled) then
        _configuration.ColorEnabled = not _configuration.ColorEnabled
        this.changed = true
      end
      if _configuration.ColorEnabled then
        if _configuration.HeavenPunisherColor then
          _configuration.HeavenPunisherColor = PresentColorEditor("HP active color", 0xFF00FF00, _configuration.HeavenPunisherColor)
        end
        if _configuration.NoHeavenPunisherColor then
          _configuration.NoHeavenPunisherColor = PresentColorEditor("HP inactive color", 0xFFFF0000, _configuration.NoHeavenPunisherColor)
        end
        if _configuration.WarningColor then
          _configuration.WarningColor = PresentColorEditor("10 minute warning color", 0xFFF0DC07, _configuration.WarningColor)
        end
        if _configuration.BeatTimeColor and _configuration.ShowBeatClock then
          _configuration.BeatTimeColor = PresentColorEditor(".beat clock color", 0xFFFFFFFF, _configuration.BeatTimeColor)
        end
      end
    end
  end

  this.Update = function()
    if this.open == false then
      return
    end

    local success

    imgui.SetNextWindowSize(500, 400, 'FirstUseEver')
    success, this.open = imgui.Begin(this.title, this.open)
    imgui.SetWindowFontScale(this.fontScale)

    _showWindowSettings()

    imgui.End()
  end

  return this
end

return {
  ConfigurationWindow = ConfigurationWindow,
}