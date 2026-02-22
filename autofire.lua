getgenv().AutoFireEnabled = false
getgenv().AutoFireFiring = false

getgenv().StartAutoFire = function(target)
    getgenv().AutoFireEnabled = true
    getgenv().AutoFireTarget = target

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
