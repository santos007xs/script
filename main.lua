-- FLUENT
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- WINDOW
local Window = Fluent:CreateWindow({
    Title = "Saint Hub",
    SubTitle = "Feito pelo ",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- TABS
local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Server = Window:AddTab({ Title = "Server", Icon = "server" }),
    Teleporta = Window:AddTab({ Title = "Teleporta", Icon = "teleport" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    Brainrots = Window:AddTab({ Title = "Brainrots", Icon = "brain" })
}

local Options = Fluent.Options

-- ================= SPEED HACK =================
local speedEnabled = false
local speedValue = 16
local humanoid

local function getHumanoid()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
end

getHumanoid()
LocalPlayer.CharacterAdded:Connect(getHumanoid)

Tabs.Main:AddToggle("SpeedHack", {
    Title = "Speed Hack",
    Default = false
}):OnChanged(function()
    speedEnabled = Options.SpeedHack.Value
    if humanoid and not speedEnabled then
        humanoid.WalkSpeed = 16
    end
end)

Tabs.Main:AddSlider("SpeedValue", {
    Title = "Speed",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        speedValue = v
    end
})

RunService.RenderStepped:Connect(function()
    if speedEnabled and humanoid then
        humanoid.WalkSpeed = speedValue
    end
end)

Tabs.Main:AddButton({
    Title = "Respawn",
    Description = "Dar respawn no personagem",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end
})

-- ================= COLLECT =================
local collectEnabled = false
local collectDelay = 1
local collectList = {
    workspace.Bases.Base1.Slots.Slot1.Collect,
    workspace.Bases.Base1.Slots.Slot2.Collect,
    workspace.Bases.Base1.Slots.Slot4.Collect,
    workspace.Bases.Base1.Slots.Slot3.Collect,
}

Tabs.Main:AddToggle("Collect", {
    Title = "Collect",
    Default = false
}):OnChanged(function()
    collectEnabled = Options.Collect.Value
end)

Tabs.Main:AddInput("CollectDelay", {
    Title = "Delay (1 a 10)",
    Default = "1",
    Placeholder = "1",
    Numeric = true,
    Callback = function(v)
        local num = tonumber(v)
        if num and num >= 1 and num <= 10 then
            collectDelay = num
        else
            collectDelay = 1
        end
    end
})

spawn(function()
    while true do
        if collectEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, part in ipairs(collectList) do
                if not collectEnabled then break end
                if part and part:IsDescendantOf(game) then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(part.Position.X, -3, part.Position.Z)
                    wait(collectDelay)
                end
            end
        end
        wait(0.1)
    end
end)

-- ================= ANTI TSUNAMI =================
local antiTsunamiEnabled = false

Tabs.Main:AddToggle("AntiTsunami", {
    Title = "Anti Tsunami",
    Default = false
}):OnChanged(function()
    antiTsunamiEnabled = Options.AntiTsunami.Value
end)

spawn(function()
    while true do
        if antiTsunamiEnabled then
            local tsunamis = workspace:FindFirstChild("ActiveTsunamis")
            if tsunamis then
                for _, tsu in ipairs(tsunamis:GetChildren()) do
                    if tsu:IsA("BasePart") then
                        tsu.CanCollide = false
                        tsu.CanTouch = false
                        tsu.Transparency = 1
                    elseif tsu:IsA("Model") then
                        for _, part in ipairs(tsu:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                                part.CanTouch = false
                                part.Transparency = 1
                            end
                        end
                    end
                end
            end
        end
        wait(0.2)
    end
end)

-- ================= INSTA PROMPT =================
local instaPromptEnabled = false

Tabs.Main:AddToggle("InstaPrompt", {
    Title = "Insta Prompt",
    Default = false
}):OnChanged(function()
    instaPromptEnabled = Options.InstaPrompt.Value
end)

spawn(function()
    while true do
        if instaPromptEnabled then
            for i, v in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if v.ClassName == "ProximityPrompt" then
                    v.HoldDuration = 0
                end
            end
        end
        wait(0.5)
    end
end)

-- ================= SERVER HOP =================
local function serverHop()
    local placeId = game.PlaceId
    local servers = {}
    local cursor = ""

    repeat
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end

        local data = HttpService:JSONDecode(game:HttpGet(url))
        for _, v in pairs(data.data) do
            if v.playing < v.maxPlayers then
                table.insert(servers, v.id)
            end
        end
        cursor = data.nextPageCursor
    until not cursor or #servers > 0

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], LocalPlayer)
    end
end

Tabs.Server:AddButton({
    Title = "Server Hop",
    Description = "Trocar para outro servidor",
    Callback = function()
        serverHop()
    end
})

-- ================= TELEPORTA (Dropdown + Botão) =================
local locations = {
    ["Area Cosmica"] = Vector3.new(1563, -3, 22),
}

local selectedLocation = "Area Cosmica"

local Dropdown = Tabs.Teleporta:AddDropdown("Dropdown", {
    Title = "Escolha a Área",
    Values = {"Area Cosmica"},
    Multi = false,
    Default = 1,
})

Dropdown:SetValue("Area Cosmica")

Dropdown:OnChanged(function(Value)
    selectedLocation = Value
end)

Tabs.Teleporta:AddButton({
    Title = "Ir para Área Selecionada",
    Description = "Move seu personagem para a área selecionada",
    Callback = function()
        local pos = locations[selectedLocation]
        if pos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local endPos = Vector3.new(pos.X, -3, pos.Z)

            hrp.CFrame = CFrame.new(hrp.Position.X, -3, hrp.Position.Z)

            local distance = (hrp.Position - endPos).Magnitude
            local time = distance / 80

            local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(endPos)})
            tween:Play()
        end
    end
})

-- ================= Noclip =================
local noclipEnabled = false
Tabs.Misc:AddToggle("Noclip", {
    Title = "Noclip",
    Default = false
}):OnChanged(function()
    noclipEnabled = Options.Noclip.Value
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ================= ANTI AFK =================
Tabs.Misc:AddToggle("AntiAFK", {
    Title = "Anti AFK",
    Default = false
}):OnChanged(function()
    local enabled = Options.AntiAFK.Value
    if enabled then
        spawn(function()
            while Options.AntiAFK.Value do
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                wait(60)
            end
        end)
    end
end)

-- ================= VIP WALLS (sem dano) =================
Tabs.Misc:AddButton({
    Title = "Remover VIP Walls (sem dano)",
    Description = "Desativa colisão e toca para não dar dano",
    Callback = function()
        local walls = {
            workspace.VIPWalls:GetChildren()[7],
            workspace.VIPWalls.VIP,
            workspace.VIPWalls:GetChildren()[4],
            workspace.VIPWalls:GetChildren()[2],
            workspace.VIPWalls:GetChildren()[5],
            workspace.VIPWalls:GetChildren()[6],
            workspace.VIPWalls:GetChildren()[3],
        }

        for _, wall in ipairs(walls) do
            if wall and wall:IsA("BasePart") then
                wall.CanCollide = false
                wall.CanTouch = false
                wall.Transparency = 1
            end
        end
    end
})

-- ================= BRAINROTS =================
local brainrotESP = nil
local brainrotSelected = nil
local brainrotDropdown = nil
local areaDropdown = nil

local brainrotList = {}
local brainrotNames = {}

local brainrotAreas = {
    "Common",
    "Cosmic",
    "Epic",
    "Legendary",
    "Mythical",
    "Rare",
    "Secret",
    "Uncommon",
    "Celestial"
}

local selectedArea = "Common"

local function refreshBrainrots(area)
    brainrotList = {}
    brainrotNames = {}

    local active = workspace:FindFirstChild("ActiveBrainrots")
    if not active then return end

    local areaFolder = active:FindFirstChild(area)
    if not areaFolder then return end

    for _, brain in ipairs(areaFolder:GetChildren()) do
        if brain:IsA("Model") then
            if not brainrotNames[brain.Name] then
                brainrotNames[brain.Name] = true
                table.insert(brainrotList, brain)
            end
        end
    end

    local values = {}
    for _, v in ipairs(brainrotList) do
        table.insert(values, v.Name)
    end

    if brainrotDropdown then
        brainrotDropdown:SetValues(values)
        brainrotDropdown:SetValue(values[1] or "")
    end
end

-- AREA DROPDOWN
areaDropdown = Tabs.Brainrots:AddDropdown("AreaDropdown", {
    Title = "Área",
    Values = brainrotAreas,
    Multi = false,
    Default = 1,
})

areaDropdown:OnChanged(function(Value)
    selectedArea = Value
    refreshBrainrots(selectedArea)
end)

    Tabs.Brainrots:AddParagraph({
        Title = "Como usar",
        Content = "Vai pra area safe onde seu brainrot esta, aquela que nao toma dano quando o tsunami passa. seleciona a area onde ele esta e depois dar refresh dai seleciona o brainrot e usa o botao coleta"
    })

-- BRAINROT DROPDOWN
brainrotDropdown = Tabs.Brainrots:AddDropdown("BrainrotDropdown", {
    Title = "Brainrots",
    Values = {},
    Multi = false,
    Default = 1,
})

brainrotDropdown:OnChanged(function(Value)
    for _, v in ipairs(brainrotList) do
        if v.Name == Value then
            brainrotSelected = v
            break
        end
    end
end)

-- REFRESH BUTTON
Tabs.Brainrots:AddButton({
    Title = "Refresh Brainrots",
    Description = "Atualiza o dropdown",
    Callback = function()
        refreshBrainrots(selectedArea)
    end
})

-- ESP do selecionado
local function createESP(target)
    if brainrotESP then
        brainrotESP:Destroy()
        brainrotESP = nil
    end

    if not target then return end

    local part = target:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "BrainrotESP"
    box.Adornee = part
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = part.Size
    box.Transparency = 0.5
    box.Parent = part

    brainrotESP = box
end

RunService.RenderStepped:Connect(function()
    if brainrotSelected and brainrotSelected.Parent then
        createESP(brainrotSelected)
    else
        if brainrotESP then
            brainrotESP:Destroy()
            brainrotESP = nil
        end
    end
end)

-- Teleporte + coleta + volta (instantâneo)
local function teleportAndCollect(brainrot)
    if not brainrot then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = LocalPlayer.Character.HumanoidRootPart
    local oldPos = hrp.CFrame

    local targetPart = brainrot:FindFirstChildWhichIsA("BasePart", true)
    if not targetPart then return end

    hrp.CFrame = CFrame.new(targetPart.Position.X, -3, targetPart.Position.Z)

    wait(0.1)

    local prompt = brainrot:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        prompt.HoldDuration = 0
        prompt:InputHoldBegin()
        wait(0.05)
        prompt:InputHoldEnd()
    end

    hrp.CFrame = oldPos
end

Tabs.Brainrots:AddButton({
    Title = "Teleporte e Coleta",
    Description = "Teleporta, aperta prompt e volta",
    Callback = function()
        teleportAndCollect(brainrotSelected)
    end
})

-- ================= ESP (FLOORS) =================
local espEnabled = false
local espTargets = {
    workspace.Floors.Common,
    workspace.Floors.Cosmic,
    workspace.Floors.Epic,
    workspace.Floors.Rare,
    workspace.Floors.Mythical,
    workspace.Floors.Legendary,
    workspace.Floors.Uncommon,
    workspace.Floors,
}

local espObjects = {}

local function removeAllESP()
    for _, obj in ipairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end

local function createESPForFloor(floor)
    if not floor then return end

    for _, part in ipairs(floor:GetDescendants()) do
        if part:IsA("BasePart") then
            if part:FindFirstChild("ESPName") then
                part.ESPName:Destroy()
            end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESPName"
            billboard.Adornee = part
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = part

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = part.Name
            text.TextScaled = true
            text.TextStrokeTransparency = 0
            text.TextColor3 = Color3.new(1, 1, 1)
            text.Parent = billboard

            table.insert(espObjects, billboard)
        end
    end
end

Tabs.ESP:AddToggle("ESPNames", {
    Title = "ESP Names (Floors)",
    Default = false
}):OnChanged(function()
    espEnabled = Options.ESPNames.Value

    if not espEnabled then
        removeAllESP()
        return
    end

    removeAllESP()
    for _, floor in ipairs(espTargets) do
        createESPForFloor(floor)
    end
end)

-- ================= ADDONS =================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/utility")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

Fluent:Notify({
    Title = "Utility Hub",
    Content = "Script carregado",
    Duration = 5
})
