--!strict
-- roblox-modern-lowpoly UI kit. Build styled instances from Style tokens — never hardcode a look.
-- Everything is sized with UDim2 Scale where it matters so UI fits phone, tablet, and console.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Style = require(ReplicatedStorage.Shared.Style)

local Kit = {}

-- ---- primitives ------------------------------------------------------------

function Kit.corner(radius: UDim, parent: Instance): UICorner
    local c = Instance.new("UICorner")
    c.CornerRadius = radius
    c.Parent = parent
    return c
end

function Kit.stroke(thickness: number, color: Color3, parent: Instance): UIStroke
    local s = Instance.new("UIStroke")
    s.Thickness = thickness
    s.Color = color
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function Kit.pad(px: number, parent: Instance): UIPadding
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, px)
    p.PaddingBottom = UDim.new(0, px)
    p.PaddingLeft = UDim.new(0, px)
    p.PaddingRight = UDim.new(0, px)
    p.Parent = parent
    return p
end

-- Glossy top-light overlay (the "candy" finish) over a solid fill.
function Kit.gloss(parent: Instance): UIGradient
    local g = Instance.new("UIGradient")
    g.Rotation = 90
    g.Color = ColorSequence.new(Style.color.white)
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, Style.gloss.topAlpha),
        NumberSequenceKeypoint.new(1, Style.gloss.bottomAlpha),
    })
    g.Parent = parent
    return g
end

-- ---- components ------------------------------------------------------------

-- A rounded, outlined panel — the modal body / a generic card.
function Kit.card(name: string): Frame
    local f = Instance.new("Frame")
    f.Name = name
    f.BackgroundColor3 = Style.color.panel
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.fromScale(0.5, 0.5)
    f.Size = UDim2.fromScale(0.42, 0.62)
    Kit.corner(Style.radius.card, f)
    Kit.stroke(Style.stroke.thick, Style.color.outline, f)
    return f
end

-- Accent header bar with an UPPERCASE title.
function Kit.header(title: string): Frame
    local bar = Instance.new("Frame")
    bar.Name = "Header"
    bar.BackgroundColor3 = Style.color.accent
    bar.Size = UDim2.new(1, 0, 0, 56)
    Kit.corner(Style.radius.card, bar)
    Kit.stroke(Style.stroke.thick, Style.color.outline, bar)

    local label = Instance.new("TextLabel")
    label.Name = "Title"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Style.font.heading
    label.TextScaled = true
    label.TextColor3 = Style.color.accentText
    label.Text = string.upper(title)
    label.Parent = bar
    Kit.pad(Style.pad.md, label)

    return bar
end

-- A vivid, glossy product/currency tile.
function Kit.tile(accent: Color3): Frame
    local t = Instance.new("Frame")
    t.Name = "Tile"
    t.BackgroundColor3 = accent
    t.Size = UDim2.fromScale(0.3, 1)
    Kit.corner(Style.radius.tile, t)
    Kit.stroke(Style.stroke.thick, Style.color.outline, t)
    Kit.gloss(t)
    return t
end

-- A currency pill: rounded, icon + number. Returns the pill and its amount label so callers
-- can update the number without reaching through the tree.
function Kit.currencyPill(icon: string, amount: number): (Frame, TextLabel)
    local pill = Instance.new("Frame")
    pill.Name = "CurrencyPill"
    pill.BackgroundColor3 = Style.color.white
    pill.Size = UDim2.fromOffset(150, 44)
    Kit.corner(Style.radius.pill, pill)
    Kit.stroke(Style.stroke.normal, Style.color.outline, pill)

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, Style.pad.sm)
    layout.Parent = pill

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.fromOffset(28, 28)
    iconLabel.Font = Style.font.number
    iconLabel.TextScaled = true
    iconLabel.Text = icon
    iconLabel.TextColor3 = Style.color.gold
    iconLabel.LayoutOrder = 1
    iconLabel.Parent = pill

    local amountLabel = Instance.new("TextLabel")
    amountLabel.Name = "Amount"
    amountLabel.BackgroundTransparency = 1
    amountLabel.Size = UDim2.fromOffset(90, 28)
    amountLabel.Font = Style.font.number
    amountLabel.TextScaled = true
    amountLabel.TextXAlignment = Enum.TextXAlignment.Left
    amountLabel.Text = tostring(amount)
    amountLabel.TextColor3 = Style.color.ink
    amountLabel.LayoutOrder = 2
    amountLabel.Parent = pill

    return pill, amountLabel
end

-- A chunky pill button with a label.
function Kit.pillButton(text: string, accent: Color3): TextButton
    local b = Instance.new("TextButton")
    b.Name = "PillButton"
    b.AutoButtonColor = true
    b.BackgroundColor3 = accent
    b.Size = UDim2.fromOffset(160, 48)
    b.Font = Style.font.heading
    b.TextScaled = true
    b.TextColor3 = Style.color.white
    b.Text = text
    Kit.corner(Style.radius.pill, b)
    Kit.stroke(Style.stroke.thick, Style.color.outline, b)
    Kit.gloss(b)
    Kit.pad(Style.pad.sm, b)
    return b
end

-- A square side-rail icon button.
function Kit.sideRailButton(icon: string, accent: Color3): TextButton
    local b = Instance.new("TextButton")
    b.Name = "RailButton"
    b.AutoButtonColor = true
    b.BackgroundColor3 = accent
    b.Size = UDim2.fromOffset(52, 52)
    b.Font = Style.font.heading
    b.TextScaled = true
    b.TextColor3 = Style.color.white
    b.Text = icon
    Kit.corner(Style.radius.button, b)
    Kit.stroke(Style.stroke.thick, Style.color.outline, b)
    Kit.gloss(b)
    return b
end

return Kit
