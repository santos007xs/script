-- =======================
-- FLUENT + LOGIN SYSTEM
-- =======================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Key System",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(490, 260),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- =======================
-- TABS (SOMENTE LOGIN)
-- =======================
local Tabs = {
    Login = Window:AddTab({ Title = "Login", Icon = "lock" }),
}

-- =======================
-- KEY LOGIN SYSTEM
-- =======================
local userKey = ""
local validKey = false

-- Input da Key
local KeyInput = Tabs.Login:AddInput("KeyInput", {
    Title = "Digite sua Key",
    Default = "",
    Placeholder = "AAAAA-BBBBB-CCCCC",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        userKey = Value
    end
})

-- Botão de Login
Tabs.Login:AddButton({
    Title = "Login",
    Description = "Validar Key",
    Callback = function()
        userKey = KeyInput.Value

        if userKey == "" then
            Fluent:Notify({
                Title = "Erro",
                Content = "Digite uma key válida!",
                Duration = 3
            })
            return
        end

        local Keys = loadstring(game:HttpGet("https://raw.githubusercontent.com/santos007xs/script/refs/heads/main/keys.lua"))()

        if Keys[userKey] then
            validKey = true

            -- Remove a interface inteira do Key System
            Window:Destroy()

            -- Executa o script2 quando a key é validada
            loadstring(game:HttpGet("https://raw.githubusercontent.com/santos007xs/script/refs/heads/main/main.lua"))()

            Fluent:Notify({
                Title = "Login OK",
                Content = "Key válida! Acesso liberado.",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Key inválida",
                Content = "Key não encontrada!",
                Duration = 3
            })
        end
    end
})

-- =======================
-- REMOVER CONFIGS (SEM SETTINGS)
-- =======================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

Window:SelectTab(1)

Fluent:Notify({
    Title = "Key system",
    Content = "Carregado! Faça login para continuar.",
    Duration = 5
})
