-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local invisible = false
local highlight
local rainbowToggle = false

-- Interface
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "MatrixLab - School FR RP",
   LoadingTitle = "MatrixLab",
   LoadingSubtitle = "by Spacyxx",
   Theme = "Ocean",
   ToggleUIKeybind = "K",
   ConfigurationSaving = { Enabled = true, FileName = "Big Hub" },

   KeySystem = true,
   KeySettings = {
       Tittle = "MatrixLab Key",
       Subtitle = "MatrixLab",
       Note = ".gg/G2jgaX5932 | By @spacyxxu",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"MatrixLab"}
   }
})

local MainTab = Window:CreateTab("Main", "brick-wall")
local GiveTab = Window:CreateTab("Item", 4483362458)
local PlayerTab = Window:CreateTab("Player", "user")
local EspTab = Window:CreateTab("ESP", "person-standing")
local TrollTab = Window:CreateTab("Troll", "laugh")

-- ===== Fonctions principales ===== --

-- 1) Bypass ban vocal
MainTab:CreateButton({
    Name = "Bypass Ban Vocal",
    Callback = function()
        pcall(function()
            LocalPlayer:FindFirstChildOfClass("PlayerScripts"):Destroy()
            print("Bypass vocal exécuté.")
        end)
    end,
})

-- 2) Items
local giveItems = {
    "Arc en bois", "Bague de fiançailles", "Ballon 10M", "Ballon Event Phénix",
    "Ballon des 1 an", "Ballon special 1M", "Ballon special 5M",
    "BallonD'aniversaire", "Banana", "Carte VIP 3 mois", "Chips barbecue"
}

GiveTab:CreateSection("All Item")
for _, name in ipairs(giveItems) do
    GiveTab:CreateButton({
        Name = name,
        Callback = function()
            local folder = ReplicatedStorage:FindFirstChild("Tools")
            if folder then
                local tool = folder:FindFirstChild(name)
                if tool then
                    tool:Clone().Parent = LocalPlayer.Backpack
                end
            end
        end
    })
end

GiveTab:CreateSection("Clear")
GiveTab:CreateButton({
    Name = "Clear Item",
    Callback = function()
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
    end
})

-- 3) Player – SpinBot & WalkSpeed
local spinning = false
local spinSpeed = 10
local walkEnabled = false
local walkSpeed = 16

RunService.RenderStepped:Connect(function()
    if spinning and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame *= CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end)

local function ApplyWalkSpeed()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = walkEnabled and walkSpeed or 16
    end
end

PlayerTab:CreateSection("~~Fun")
PlayerTab:CreateToggle({
    Name = "SpinBot",
    CurrentValue = false,
    Callback = function(val)
        spinning = val
    end
})
PlayerTab:CreateSlider({
    Name = "SpinBot Speed",
    Range = {0, 150}, Increment = 1, CurrentValue = spinSpeed, Suffix = "RPM",
    Callback = function(val)
        spinSpeed = val
    end
})

PlayerTab:CreateSection("~~Mouvement")
PlayerTab:CreateToggle({
    Name = "Enable WalkSpeed",
    CurrentValue = false,
    Callback = function(val)
        walkEnabled = val
        ApplyWalkSpeed()
    end
})
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 100}, Increment = 1, CurrentValue = walkSpeed, Suffix = "stud/s",
    Callback = function(val)
        walkSpeed = val
        ApplyWalkSpeed()
    end
})

-- 4) ESP
local espEnabled = false
local highlights = {}
local nameTags = {}

local function removeESP(player)
    if highlights[player] then highlights[player]:Destroy() highlights[player] = nil end
    if nameTags[player] then nameTags[player]:Destroy() nameTags[player] = nil end
end

local function applyESP(player)
    if player == LocalPlayer or not player.Character then return end

    removeESP(player)

    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(255, 0, 111)
    h.OutlineColor = Color3.new(1,1,1)
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = player.Character
    highlights[player] = h

    local tag = Instance.new("BillboardGui")
    tag.Size = UDim2.new(0, 100, 0, 40)
    tag.StudsOffset = Vector3.new(0, 3, 0)
    tag.AlwaysOnTop = true

    local label = Instance.new("TextLabel", tag)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true

    local head = player.Character:FindFirstChild("Head")
    if head then
        tag.Parent = head
    end
    nameTags[player] = tag
end

local function updateESP()
    for _, pl in pairs(Players:GetPlayers()) do
        if espEnabled then
            applyESP(pl)
        else
            removeESP(pl)
        end
    end
end

EspTab:CreateToggle({
    Name = "ESP (Highlight + Pseudo)",
    CurrentValue = false,
    Callback = function(val)
        espEnabled = val
        updateESP()
    end
})

Players.PlayerAdded:Connect(function(pl)
    pl.CharacterAdded:Connect(function()
        wait(1)
        if espEnabled then applyESP(pl) end
    end)
end)
Players.PlayerRemoving:Connect(removeESP)

-- 5) Troll – Copier Apparence avec HumanoidDescription
local function getPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

local function copyAppearance(targetName)
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
        warn("Joueur ou Humanoid cible introuvable : " .. tostring(targetName))
        return
    end

    local localChar = LocalPlayer.Character
    local localHumanoid = localChar and localChar:FindFirstChildOfClass("Humanoid")
    if not localHumanoid then
        warn("Humanoid local introuvable")
        return
    end

    local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

    -- Récupère la description d'apparence du joueur cible
    local success, description = pcall(function()
        return targetHumanoid:GetAppliedDescription()
    end)
    if not success or not description then
        warn("Impossible d'obtenir la description du joueur cible")
        return
    end

    -- Appliquer la description sur le personnage local
    localHumanoid:ApplyDescription(description)

    print("✅ Apparence copiée de ".. targetName .." appliquée.")
end

local function setInvisible(state)
    local char = LocalPlayer.Character
    if not char then return end

    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = state and 1 or 0
            if part.Name == "HumanoidRootPart" then
                part.Transparency = 0
            end
        elseif part:IsA("Decal") then
            part.Transparency = state and 1 or 0
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = state and 1 or 0
            end
        end
    end
end

local function setInvisibleWithRainbowOutline(state)
    local char = LocalPlayer.Character
    if not char then return end

    -- Rendre invisible
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = state and 1 or 0
            if part.Name == "HumanoidRootPart" then
                part.Transparency = 0
            end
        elseif part:IsA("Decal") then
            part.Transparency = state and 1 or 0
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = state and 1 or 0
            end
        end
    end

    if state then
        -- Créer le Highlight si nécessaire
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Parent = char
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.OutlineTransparency = 0
            highlight.FillTransparency = 1 -- pas de remplissage
        end
        rainbowToggle = true
    else
        -- Supprimer le contour si désactivé
        if highlight then
            highlight:Destroy()
            highlight = nil
        end
        rainbowToggle = false
    end
end

local hue = 0
RunService.RenderStepped:Connect(function(dt)
    if rainbowToggle and highlight then
        hue = (hue + dt * 0.5) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        highlight.OutlineColor = color
    end
end)

local dropdown
dropdown = TrollTab:CreateDropdown({
    Name = "Copier l'apparence (Not Work)",
    Options = getPlayerNames(),
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(option)
        copyAppearance(option)
    end,
})
TrollTab:CreateToggle({
    Name = "Invisible (Local)",
    CurrentValue = false,
    Callback = function(val)
        invisible = val
        setInvisible(invisible)
    end,
})
TrollTab:CreateToggle({
	Name = "Rainbow (Not Work)",
	CurrentValue = false,
	Callback = function(val)
		setInvisibleWithRainbowOutline(val)
	end,
})

local function updateDropdown()
    if dropdown then
        dropdown:SetOptions(getPlayerNames())
    end
end

Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)
