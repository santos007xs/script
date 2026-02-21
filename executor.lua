local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 36)
topbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topbar.BorderSizePixel = 0
topbar.Parent = frame
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 12)

local topbarFix = Instance.new("Frame")
topbarFix.Size = UDim2.new(1, 0, 0, 12)
topbarFix.Position = UDim2.new(0, 0, 1, -12)
topbarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topbarFix.BorderSizePixel = 0
topbarFix.Parent = topbar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Lua Executor"
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topbar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -96)
scrollFrame.Position = UDim2.new(0, 10, 0, 46)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 180)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = frame
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 8)

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, 0, 0, 0)
box.AutomaticSize = Enum.AutomaticSize.Y
box.BackgroundTransparency = 1
box.TextColor3 = Color3.fromRGB(180, 220, 255)
box.TextSize = 12
box.Font = Enum.Font.Code
box.Text = ""
box.PlaceholderText = "-- escreva seu script aqui..."
box.PlaceholderColor3 = Color3.fromRGB(70, 70, 80)
box.MultiLine = true
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextWrapped = true
box.Parent = scrollFrame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 0, 40)
btn.Position = UDim2.new(0, 10, 1, -50)
btn.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
btn.Text = "▶  Execute"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 13
btn.Font = Enum.Font.GothamBold
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
    loadstring(box.Text)()
end)

local dragging, dragStart, startPos
topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
topbar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
