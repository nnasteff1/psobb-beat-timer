-- imports
local core_mainmenu = require("core_mainmenu")
local cfg = require("Beat Timer.configuration")
local lib_theme_loaded, lib_theme = pcall(require, "Theme Editor.theme")

-- options
local optionsLoaded, options = pcall(require, "Beat Timer.options")
local optionsFileName = "addons/Beat Timer/options.lua"
local firstPresent = true
local ConfigurationWindow

if optionsLoaded then
  options.configurationEnableWindow = options.configurationEnableWindow == nil and true or options.configurationEnableWindow
  options.enable = options.enable == nil and true or options.enable
  options.EnableWindow = options.EnableWindow == nil and true or options.EnableWindow
  options.useCustomTheme = options.useCustomTheme == nil and false or options.useCustomTheme
  options.NoTitleBar = options.NoTitleBar or ""
  options.NoResize = options.NoResize or ""
  options.Transparent = options.Transparent == nil and false or options.Transparent
  options.fontScale = options.fontScale or 1.0
  options.X = options.X or 100
  options.Y = options.Y or 100
  options.Width = options.Width or 150
  options.Height = options.Height or 80
  options.Changed = options.Changed or false
  options.NoHighContrast = options.HighContrast == nil and false or options.HighContrast
  options.ShowBeatClock = options.ShowBeatClock == nil and true or options.ShowBeatClock
  options.BeatTimeColor = options.BeatTimeColor or -992249
  options.HeavenPunisherColor = options.HeavenPunisherColor or -12321024
  options.NoHeavenPunisherColor = options.NoHeavenPunisherColor or -1232344
else
  options = {
    configurationEnableWindow = true,
    enable = true,
    EnableWindow = true,
    useCustomTheme = false,
    NoTitleBar = "",
    NoResize = "",
    Transparent = false,
    fontScale = 1.15,
    X = 400,
    Y = 500,
    Width = 170,
    Height = 92,
    Changed = false,
    NoHighContrast = false,
    ShowBeatClock = true,
    BeatTimeColor = -992249,
    HeavenPunisherColor = -12321024,
    NoHeavenPunisherColor = -1232344
  }
end

local function SaveOptions(options)
  local file = io.open(optionsFileName, "w")
  if file ~= nil then
    io.output(file)

    io.write("return {\n")
    io.write(string.format("  configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
    io.write(string.format("  enable = %s,\n", tostring(options.enable)))
    io.write("\n")
    io.write(string.format("  EnableWindow = %s,\n", tostring(options.EnableWindow)))
    io.write(string.format("  useCustomTheme = %s,\n", tostring(options.useCustomTheme)))
    io.write(string.format("  NoTitleBar = \"%s\",\n", options.NoTitleBar))
    io.write(string.format("  NoResize = \"%s\",\n", options.NoResize))
    io.write(string.format("  Transparent = %s,\n", tostring(options.Transparent)))
    io.write(string.format("  fontScale = %s,\n", tostring(options.fontScale)))
    io.write(string.format("  X = %s,\n", tostring(options.X)))
    io.write(string.format("  Y = %s,\n", tostring(options.Y)))
    io.write(string.format("  Width = %s,\n", tostring(options.Width)))
    io.write(string.format("  Height = %s,\n", tostring(options.Height)))
    io.write(string.format("  Changed = %s,\n", tostring(options.Changed)))
    io.write(string.format("  NoHighContrast = %s,\n", tostring(options.NoHighContrast)))
    io.write(string.format("  BeatTimeColor = %s,\n", tostring(options.BeatTimeColor)))
    io.write(string.format("  HeavenPunisherColor = %s,\n", tostring(options.HeavenPunisherColor)))
    io.write(string.format("  NoHeavenPunisherColor = %s,\n", tostring(options.NoHeavenPunisherColor)))
    io.write("}\n")

    io.close(file)
  end
end

-- Custom colored text with hex shifted to ARGB
local function TextCustomColored(color, text)
  if not color then return imgui.Text(text) end
  color =  
  {
    bit.band(bit.rshift(color, 16), 0xFF)/255,
    bit.band(bit.rshift(color, 8), 0xFF)/255,
    bit.band(color, 0xFF)/255,
    bit.band(bit.rshift(color, 24), 0xFF)/255
  }
  return imgui.TextColored(color[1], color[2], color[3], color[4], text)
end


-- Function to get the current Swatch Internet Time
local function getSwatchInternetTime()
  -- Get the current time in UTC
  local utcTime = os.time(os.date("*t"))
  
  -- Calculate the time in Biel Mean Time (BMT), which is UTC+1
  local bmtTime = utcTime + 3600
  
  -- Calculate the number of seconds since the start of the day in BMT
  local secondsSinceMidnight = bmtTime % 86400
  
  -- Calculate the number of .beats
  local beats = (secondsSinceMidnight / 86.4)
  
  -- Return the .beats as a float
  return beats
end

-- Function to determine if we have Divine Punishment or not
local function doWeHaveDivinePunishment()
  local currentBeats = getSwatchInternetTime()
  if currentBeats < 100 or math.fmod(currentBeats, 200) == 0 then
    return true
  end
  return false
end

-- Function to calculate the time until the next hundredth beat time
local function getTimeUntilNextHundredthBeat()
  local currentBeats = getSwatchInternetTime()
  local nextHundredthBeat = math.ceil(currentBeats / 100) * 100
  local beatsUntilNextHundredth = nextHundredthBeat - currentBeats
  
  -- Convert beats to seconds (1 beat = 86.4 seconds)
  local secondsUntilNextHundredth = beatsUntilNextHundredth * 86.4
  
  -- Calculate hours, minutes, and seconds
  local hours = math.floor(secondsUntilNextHundredth / 3600)
  local minutes = math.floor((secondsUntilNextHundredth % 3600) / 60)
  local seconds = math.floor(secondsUntilNextHundredth % 60)
  
  if hours == 0 then
    return string.format("%02d:%02d", minutes, seconds)
  end

  -- Return the formatted string
  return string.format("%1d:%02d:%02d", hours, minutes, seconds)
end

local function getFormattedBeatTime()
  beats = getSwatchInternetTime()
  if beats < 100 then
    return string.format("@ 0%.2f", beats)
  end
  return string.format("@ %.2f", getSwatchInternetTime())
end

-- Shows the timer
local function showTimer()
    local timeTilNextEvent = getTimeUntilNextHundredthBeat()
    local currentBeats = getFormattedBeatTime()

    -- Display the time until the next .beat event
    if doWeHaveDivinePunishment() then
      if options.NoHighContrast then
        imgui.Text(timeTilNextEvent)
        return
      end
      TextCustomColored(options.HeavenPunisherColor, timeTilNextEvent)
    else
      if options.NoHighContrast then
        imgui.Text(timeTilNextEvent)
        return
      end
      TextCustomColored(options.NoHeavenPunisherColor, timeTilNextEvent)
    end

    -- Display the beat time if it's enabled
    if options.ShowBeatClock then
      if options.NoHighContrast then
        imgui.Text(currentBeats)
      else
        TextCustomColored(options.BeatTimeColor, currentBeats)
      end
    end
end

-- config setup and drawing
local function present()
  if options.configurationEnableWindow then
    ConfigurationWindow.open = true
    options.configurationEnableWindow = false
  end

  ConfigurationWindow.Update()
  if ConfigurationWindow.changed then
    ConfigurationWindow.changed = false
    SaveOptions(options)
  end

  if options.enable == false then
    return
  end
  
  if lib_theme_loaded and options.useCustomTheme then
    lib_theme.Push()
  end
  
  if options.Transparent == true then
    imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
  end

  if options.EnableWindow then

    if firstPresent or options.Changed then
      options.Changed = false
      
      imgui.SetNextWindowPos(options.X, options.Y, "Always")
      imgui.SetNextWindowSize(options.Width, options.Height, "Always");
    end
    
    if imgui.Begin("Beat Timer", nil, { options.NoTitleBar, options.NoResize }) then
      imgui.SetWindowFontScale(options.fontScale)

      -- Print the beat timer
      showTimer();
    end
    imgui.End()
  end
  
  if options.Transparent == true then
    imgui.PopStyleColor()
  end
  
  if lib_theme_loaded and options.useCustomTheme then
    lib_theme.Pop()
  end
  
  if firstPresent then
    firstPresent = false
  end
end

local function init()
  ConfigurationWindow = cfg.ConfigurationWindow(options, lib_theme_loaded)

  local function mainMenuButtonHandler()
    ConfigurationWindow.open = not ConfigurationWindow.open
  end

  core_mainmenu.add_button("Beat Timer", mainMenuButtonHandler)
  
  if lib_theme_loaded == false then
    print("Beat Timer : lib_theme couldn't be loaded")
  end
  
  return {
    name = "Beat Timer",
    version = "1.0.2",
    author = "Nate Nasteff",
    description = "Displays a timer for the next .beat event",
    present = present
  }
end

return {
  __addon = {
    init = init
  }
}