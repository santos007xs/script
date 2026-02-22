-- ESP Name acima da cabeça

local function createESP(player)
    if player == game.Players.LocalPlayer then return end

    local function setup(character)
        local head = character:WaitForChild("Head", 5)
        if not head then return end

        -- Remove ESP antigo
        if head:FindFirstChild("NameESP") then
            head.NameESP:Destroy()
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameESP"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = player.Name
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Parent = billboard
    end

    if player.Character then
        setup(player.Character)
    end

    player.CharacterAdded:Connect(setup)
end

-- Aplicar em todos
for _, player in pairs(game.Players:GetPlayers()) do
    createESP(player)
end

game.Players.PlayerAdded:Connect(createESP)
