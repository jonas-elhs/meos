-- VARIABLES
local colors = dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua")

local layout = {
  border = {
    width = "2",
    radius = {
      size = "10",
      inner = "7",
    },
  },
  gap = {
    size = "20",
    inner = "10",
  },
  -- css: filter: blur(calc(size * sqrt(passes) * 0.85px)),
  blur = {
    size = "5",
    passes = "4",
  },
}

local terminal = "ghostty"
local fileManager = "dolphin"
local appLauncher = "fuzzel --launch-prefix=runapp"
local browser = "firefox"

local mod = "SUPER"
local secondaryMod = "SUPER + SHIFT"

-- MONITORS
hl.monitor({
  output = "HDMI-A-2",
  mode = "3840x2160@60",
  position = "0x0",
  scale = "1.5",
})

-- AUTO START
hl.on("hyprland.start", function()
  hl.exec_cmd("runapp hypridle")
  hl.exec_cmd("runapp quickshell")
  hl.exec_cmd("runapp cursor-clip --daemon")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-- ANIMATIONS
hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 5,
  bezier = "default",
  style = "slidevert",
})

-- RULES
for i = 1, 5 do
  hl.workspace_rule({
    workspace = tostring(i),
    persistent = true,
  })
end

hl.layer_rule({
  match = { namespace = "meshell-shell" },
  blur = true,
  ignore_alpha = 0,
})

-- CONFIGURATION
hl.config({
  xwayland = {
    force_zero_scaling = true,
  },

  master = {
    mfact = 0.65,
  },

  general = {
    layout = "master",
    gaps_in = tostring(tonumber(layout.gap.size) / 2),
    gaps_out = layout.gap.size,
    border_size = tonumber(layout.border.width),

    col = {
      active_border = colors.accent,
      inactive_border = colors.inactive,
    },
  },

  decoration = {
    rounding = tonumber(layout.border.radius.size),

    blur = {
      size = tonumber(layout.blur.size),
      passes = tonumber(layout.blur.passes),
      popups = true,
    },

    shadow = {
      range = 15,
      color = colors.background_dark,
    },
  },

  misc = {
    session_lock_xray = true,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
})

-- KEYBINDINGS
-- stylua: ignore start
hl.bind(mod .. " + T",            hl.dsp.global("meshell:test"))
hl.bind(mod .. " + S",            hl.dsp.global("meshell:bar"))
hl.bind(mod .. " + P",            hl.dsp.global("meshell:powerMenu"))
hl.bind(mod .. " + C",            hl.dsp.global("meshell:pickHexColorCopy"))

-- General
hl.bind(mod .. " + Return",       hl.dsp.exec_cmd("runapp " .. terminal))
hl.bind(mod .. " + B",            hl.dsp.exec_cmd("runapp " .. browser))
hl.bind(mod .. " + R",            hl.dsp.exec_cmd("runapp " .. appLauncher))
hl.bind(mod .. " + E",            hl.dsp.exec_cmd("runapp " .. fileManager))
hl.bind(mod .. " + ALT + V",      hl.dsp.exec_cmd("runapp cursor-clip"))

hl.bind(mod .. " + Q",            hl.dsp.window.close())
hl.bind(secondaryMod .. " + Q",   hl.dsp.exec_cmd("hyprshutdown"))

hl.bind(mod .. " + M",            hl.dsp.layout("swapwithmaster"))

-- Windows
hl.bind(mod .. " + V",            hl.dsp.window.float())
hl.bind(mod .. " + F",            hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(secondaryMod .. " + F",   hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(mod .. " + H",            hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J",            hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K",            hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L",            hl.dsp.focus({ direction = "r" }))

hl.bind(mod .. " + mouse:272",    hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273",    hl.dsp.window.resize(), { mouse = true })

hl.bind(secondaryMod .. " + H",   hl.dsp.window.move({ direction = "l" }))
hl.bind(secondaryMod .. " + J",   hl.dsp.window.move({ direction = "d" }))
hl.bind(secondaryMod .. " + K",   hl.dsp.window.move({ direction = "u" }))
hl.bind(secondaryMod .. " + L",   hl.dsp.window.move({ direction = "r" }))

-- Workspaces
hl.bind(mod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))

for i = 1, 10 do
  local key = i % 10

  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(secondaryMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- stylua: ignore end

-- PLUGINS
if hl.plugin.hyprcapture ~= nil then
  hl.config({
    plugin = {
      hyprcapture = {
        window_background = "real",
        notification_backend = "system",
        allow_quick = true,
        fusion_mode = true,
        record_fps = 60,
        record_codec = "auto",
        record_window_fps_limit = 0,
        record_window_real_bg_fps_limit = 0,
        record_countdown_seconds = 3,
        capture_fullscreen_clients_as_monitor = true,
      },
    },
  })

  hl.bind(secondaryMod .. " + S", hl.plugin.hyprcapture.open)
end

if hl.plugin.dynamic_cursors ~= nil then
  hl.config({
    plugin = {
      dynamic_cursors = {
        enabled = true,
        mode = "stretch",
        threshold = 2,

        shake = {
          enabled = false,
        },
      },
    },
  })
end

if hl.plugin.hyprglass then
  local hg = hl.plugin.hyprglass

  hg.config({
    default_theme = "dark",
    default_preset = "glass",
    layers = { enabled = 1 },
  })

  hg.preset("glass", {
    blur_strength = 3,
    blur_iterations = 4,
  })
end
