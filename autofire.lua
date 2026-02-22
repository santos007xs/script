getgenv().StartAutoFire = function(target)
    getgenv().AutoFireEnabled = true
    getgenv().AutoFireTarget = target

    -- ativa shiftlock nativo do roblox
    pcall(function()
        local PlayerModule = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
        local controls = PlayerModule:GetControls()
        local camera = PlayerModule:GetCameras()
        camera:SetCameraType("Track")
    end)

    task.spawn(function()
        while getgenv().AutoFireEnabled do
            task.wait(0.05)
            if not getgenv().AutoFireTarget then continue end

            local char = getgenv().AutoFireTarget.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if not char or not hum or not root then continue end
            if hum.Health <= 0 then continue end

            local UIS = game:GetService("UserInputService")
            if UIS:IsKeyDown(Enum.KeyCode.Insert) then continue end
            if UIS:GetFocusedTextBox() ~= nil then continue end

            local camera = workspace.CurrentCamera
            local screenPos, onScreen = camera:WorldToScreenPoint(root.Position)
            if not onScreen then continue end

            -- simula shiftlock apontando o personagem pro alvo
            local myChar = game.Players.LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local hrp = myRoot
                local lookAt = Vector3.new(root.Position.X, hrp.Position.Y, root.Position.Z)
                hrp.CFrame = CFrame.new(hrp.Position, lookAt)
            end

            camera.CFrame = CFrame.new(camera.CFrame.Position, root.Position)

            if not getgenv().AutoFireFiring then
                getgenv().AutoFireFiring = true
                pcall(function() mouse1press() end)
                task.wait(0.05)
                pcall(function() mouse1release() end)
                getgenv().AutoFireFiring = false
            end
        end
    end)
end

getgenv().StopAutoFire = function()
    getgenv().AutoFireEnabled = false
    getgenv().AutoFireFiring = false
    pcall(function() mouse1release() end)
end
