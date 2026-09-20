------------------
---- MONITORS ----
------------------

hl.monitor({
  output = "HDMI-A-2",
  mode = "3840x2160@60", -- preferred
  position = "0x0", -- auto
  scale = "1.5",
})

-------------------
---- VARIABLES ----
-------------------

local colors = require("colors")

local layout = {
  border = {
    width = 2,
    radius = {
      size = 10,
      inner = 7,
    },
  },
  gap = {
    size = 20,
    inner = 10,
  },
  -- css: filter: blur(calc(size * sqrt(passes) * 0.85px)),
  blur = {
    size = 3,
    passes = 4,
  },
}

-- Programs
local terminal = "ghostty"
local fileManager = "dolphin"
local appLauncher = "fuzzel --launch-prefix=runapp"
local browser = "firefox"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("runapp quickshell")
  hl.exec_cmd("runapp cursor-clip --daemon")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in = layout.gap.size / 2,
    gaps_out = layout.gap.size,

    border_size = layout.border.width,

    resize_on_border = true,

    col = {
      active_border = colors.accent,
      inactive_border = colors.inactive,
    },
  },

  decoration = {
    rounding = layout.border.radius.size,

    shadow = {
      range = 15,
      color = colors.background_dark,
    },
  },
})

--------------------
---- ANIMATIONS ----
--------------------
-- TODO: do I really need all these curves??
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("spring", { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "spring", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "almostLinear", style = "popin 87%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.79, spring = "spring" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "almostLinear", style = "fade" })

hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slidevert" })

------------------
----  LAYOUT  ----
------------------

hl.config({
  general = {
    layout = "master",
  },

  master = {
    mfact = 0.65,
  },
})

----------------
----  MISC  ----
----------------

hl.config({
  misc = {
    session_lock_xray = true,
  },
})

--------------------
----  XWAYLAND  ----
--------------------

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

------------------
---- MAPPINGS ----
------------------

local mod = "SUPER"
local secondaryMod = "SUPER + SHIFT"

-- stylua: ignore start
-- hl.bind(mod .. " + T",            hl.dsp.global("meshell:test"))
-- hl.bind(mod .. " + S",            hl.dsp.global("meshell:bar"))
hl.bind(mod .. " + P",            hl.dsp.global("meshell:powerMenu"))
-- hl.bind(mod .. " + C",            hl.dsp.global("meshell:pickHexColorCopy"))

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

---------------------------------------------
---- WINDOW-, WORKSPACE- AND LAYER-RULES ----
---------------------------------------------

-- Ignore maximize requests from all apps
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

-- Five persistent workspaces
for i = 1, 5 do
  hl.workspace_rule({
    workspace = tostring(i),
    persistent = true,
  })
end

-----------------
---- PLUGINS ----
-----------------

-- HyprCapture
if hl.plugin.hyprcapture ~= nil then
  hl.config({
    plugin = {
      hyprcapture = {
        window_background = "real",
        allow_quick = true,
        record_fps = 60,
        record_codec = "auto",
        record_window_fps_limit = 0,
        record_window_real_bg_fps_limit = 0,
        record_countdown_seconds = 3,
        capture_fullscreen_clients_as_monitor = true,
      },
    },
  })

  hl.bind(mod .. " + S", hl.plugin.hyprcapture.open)
  hl.bind(secondaryMod .. " + S", hl.plugin.hyprcapture.open_editor)
end

-- HyprDynamicCursors
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

-- HyprGlass
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
