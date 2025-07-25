-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local invisible = false
local highlight
local rainbowToggle = false

-- Interfaces
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()
local Window = Luna:CreateWindow({
	Name = "MatrixHub - Give Items | BETA", -- This Is Title Of Your Window
	Subtitle = nil, -- A Gray Subtitle next To the main title.
	LogoID = "82795327169782", -- The Asset ID of your logo. Set to nil if you do not have a logo for Luna to use.
	LoadingEnabled = true, -- Whether to enable the loading animation. Set to false if you do not want the loading screen or have your own custom one.
	LoadingTitle = "MatrixHub", -- Header for loading screen
	LoadingSubtitle = "by @spacyxxu", -- Subtitle for loading screen

	ConfigSettings = {
		RootFolder = nil, -- The Root Folder Is Only If You Have A Hub With Multiple Game Scripts and u may remove it. DO NOT ADD A SLASH
		ConfigFolder = "Big Hub" -- The Name Of The Folder Where Luna Will Store Configs For This Script. DO NOT ADD A SLASH
	},

	KeySystem = false, -- As Of Beta 6, Luna Has officially Implemented A Key System!
	KeySettings = {
		Title = "Luna Example Key",
		Subtitle = "Key System",
		Note = "Best Key System Ever! Also, Please Use A HWID Keysystem like Pelican, Luarmor etc. that provide key strings based on your HWID since putting a simple string is very easy to bypass",
		SaveInRoot = false, -- Enabling will save the key in your RootFolder (YOU MUST HAVE ONE BEFORE ENABLING THIS OPTION)
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		Key = {"Example Key"}, -- List of keys that will be accepted by the system, please use a system like Pelican or Luarmor that provide key strings based on your HWID since putting a simple string is very easy to bypass
		SecondAction = {
			Enabled = true, -- Set to false if you do not want a second action,
			Type = "Link", -- Link / Discord.
			Parameter = "" -- If Type is Discord, then put your invite link (DO NOT PUT DISCORD.GG/). Else, put the full link of your key system here.
		}
	}
})

local Tab = Window:CreateTab({
	Name = "Items",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true -- This will determine whether the big header text in the tab will show
});
local BTab = Window:CreateTab({
	Name = "ESP",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true
});
local CTab = Window:CreateTab({
	Name = "Value",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true,
})

-- Items
local giveItems = {
    "Arc en bois", "Bague de fiançailles", "Ballon 10M", "Ballon Event Phénix",
    "Ballon des 1 an", "Ballon special 1M", "Ballon special 5M",
    "BallonD'aniversaire", "Banana", "Carte VIP 3 mois", "Chips barbecue",
	"Amongus", "Barre de chocolat", "Cadeau de noel", "Cadeau des 1 an bleu",
	"Cadeau des 1 an jaune", "Café 10M", "Cahier 10M", "Carte souvenir Phénix",
	"Chainsaw", "Chainsaw2", "Coupe Oxi", "Feu d'artifice 10M", "Foxiade Ultra gold",
	"Frites", "gateau des 1 an", "Liasse de robux", "Note #9", "Oeuf de paques en or",
	"Pain d'épice", "Peluche Poulaki édititon gold", "Poulakick 'Sensation'", "PushTool",
	"PushToolV2", "Rose", "Trophée School Fr en Or", "Trophée trouveur de bugs",
	"Tête de Mr. Poulaki"
}

Tab:CreateSection("All Item")
for _, name in ipairs(giveItems) do
    Tab:CreateButton({
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
Tab:CreateSection("Ceci est une BETA, si les objet sont seuelement visible par vous c'est tous a fait normal.")
Tab:CreateButton({
    Name = "Clear Item",
    Callback = function()
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
    end
})

-- BTab
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

BTab:CreateToggle({
    Name = "ESP (Highlight + Pseudo)",
	Description = nil,
    CurrentValue = false,
    Callback = function(val)
        espEnabled = val
        updateESP()
    end
})
BTab:CreateSection("Les pseudo s'applique a tous le monde mais le Highlight s'applique que a certain skin.")

Players.PlayerAdded:Connect(function(pl)
    pl.CharacterAdded:Connect(function()
        wait(1)
        if espEnabled then applyESP(pl) end
    end)
end)
Players.PlayerRemoving:Connect(removeESP)

-- CTab
CTab:CreateInput({
	Name = "Modifier son argent",
	Description = nil,
	PlaceholderText = "Ex: 5555",
	CurrentValue = "", -- the current text
	Numeric = true, -- When true, the user may only type numbers in the box (Example walkspeed)
	MaxCharacters = nil, -- if a number, the textbox length cannot exceed the number
	Enter = false, -- When true, the callback will only be executed when the user presses enter.
    	Callback = function(Text)
			local value = tonumber(Text)
			if not value then
				Luna:Notification({
					Title = "Warning",
					Icon = "notifications_active",
					ImageSource = "Material",
					Content = "La valeur écrite n'est pas valide."
				})
				return
			end

			local stats = LocalPlayer:FindFirstChild("leaderstats")
			if stats and stats.FindFirstChild("Argent") then
				stats.Argent.Value = value
				Luna:Notification({
					Title = "Money",
					Icon = "notifications_active",
					ImageSource = "Material",
					Content = "L'agent a était modifier par :" .. value
				})
			else
				Luna:Notification({
					Title = "Warn",
					Icon = "notifications_active",
					ImageSource = "Materail",
					Content = "leaderstats ou Argent introuvable"
				})
			end
    	end
}, "Input") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
CTab:CreateSection("Malheuresment sa ne marche pas pour le moment, mais sa arrive bientôt (en Local par contre)")
