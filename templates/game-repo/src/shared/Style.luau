--!strict
-- Design tokens for the `roblox-modern-lowpoly` preset — the "80% of Roblox games" look.
-- Every UI value comes from here; UI code (see client/ui/Kit) must never hardcode colors, radii,
-- strokes, or fonts. Reference: standards/ui-reference/. Settings: docs/FACTORY_SETTINGS.md.

local Style = {}

Style.preset = "roblox-modern-lowpoly"

-- Palette — saturated, high-contrast, "sticker" look with thick dark outlines.
Style.color = {
    panel = Color3.fromRGB(245, 245, 248), -- modal body
    panelAlt = Color3.fromRGB(228, 230, 236), -- inset / secondary surface
    ink = Color3.fromRGB(40, 44, 58), -- primary text
    inkSoft = Color3.fromRGB(120, 126, 140), -- secondary text
    white = Color3.fromRGB(255, 255, 255),
    outline = Color3.fromRGB(28, 30, 42), -- thick dark stroke (the defining trait)

    accent = Color3.fromRGB(235, 64, 52), -- header / primary accent (shop red)
    accentText = Color3.fromRGB(255, 255, 255),

    -- Vivid tile accents.
    teal = Color3.fromRGB(46, 196, 182),
    purple = Color3.fromRGB(142, 92, 232),
    blue = Color3.fromRGB(56, 132, 240),
    orange = Color3.fromRGB(245, 138, 44),
    yellow = Color3.fromRGB(250, 196, 42),
    green = Color3.fromRGB(74, 196, 84),
    red = Color3.fromRGB(235, 64, 52),

    -- Currency.
    gold = Color3.fromRGB(250, 196, 42),
    gem = Color3.fromRGB(56, 200, 232),
}

-- Corner radii. Chunky by default (UDim: Scale, Offset).
Style.radius = {
    tile = UDim.new(0, 14),
    card = UDim.new(0, 22),
    button = UDim.new(0, 16),
    pill = UDim.new(1, 0), -- fully rounded
}

-- Stroke weights (px). Thick, dark outlines are the signature of the style.
Style.stroke = {
    thin = 2,
    normal = 3,
    thick = 4,
}

-- Spacing scale (px offsets).
Style.pad = {
    xs = 4,
    sm = 8,
    md = 12,
    lg = 20,
    xl = 32,
}

-- Typography: rounded/chunky display, clean numeric.
Style.font = {
    heading = Enum.Font.FredokaOne,
    body = Enum.Font.GothamMedium,
    number = Enum.Font.GothamBold,
}

-- Glossy top-light overlay values. A UIGradient (Rotation 90, white color) using these
-- transparency stops gives the glossy "candy" finish over a solid fill.
Style.gloss = {
    topAlpha = 0.25, -- overlay transparency at the top (more white)
    bottomAlpha = 0.85, -- overlay transparency at the bottom (nearly clear)
}

-- Soft drop shadow tuning.
Style.shadow = {
    color = Color3.fromRGB(0, 0, 0),
    transparency = 0.75,
    offset = 6,
}

return Style
