--// Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--// Variables del jugador
local player = Players.LocalPlayer
local savedPosition = nil
local flying = false

--// Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GGHubSpeed"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

--// Marco principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Bordes redondeados
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Cocosini Mama.COM"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Función para arrastrar el frame
local dragging
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

--// Función para crear toggles
local function createToggle(name, posY, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 30)
    container.Position = UDim2.new(0, 10, 0, posY)
    container.BackgroundTransparency = 1
    container.Name = name
    container.Parent = frame

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.7, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.Gotham
    text.TextSize = 14
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.2, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = container

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0.4, 0, 1, 0)
    knob.Position = UDim2.new(0, 0, 0, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = toggleBtn

    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local btnCorner = Instance.new("UICorner", toggleBtn)
    btnCorner.CornerRadius = UDim.new(1, 0)

    local on = false
    toggleBtn.MouseButton1Click:Connect(function()
        on = not on
        local tween = TweenService:Create(
            knob,
            TweenInfo.new(0.2),
            { Position = on and UDim2.new(0.6, 0, 0, 0) or UDim2.new(0, 0, 0, 0) }
        )
        tween:Play()
        callback(on)
    end)
end

--// Toggle: Speed Boost
createToggle("Speed boost", 35, function(enabled)
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = enabled and 38 or 18
    end
end)

--// Toggle: Save Position
-- No es realmente un toggle, guarda la posición actual al activarse
createToggle("Guardar posicion", 70, function(_)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPosition = hrp.Position
    end
end)

--// Toggle: Steal seguro
createToggle("Robar", 105, function(_)
    if not savedPosition then return end

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Guardamos la velocidad original
    local originalSpeed = hum.WalkSpeed
    hum.WalkSpeed = 100 -- aumentá según quieras que vaya más rápido

    -- Mover hacia la posición guardada de manera segura
    hum:MoveTo(savedPosition)

    -- Conexión para detectar cuando llega
    local arrivedConn
    arrivedConn = hrp:GetPropertyChangedSignal("Position"):Connect(function()
        if (savedPosition - hrp.Position).Magnitude < 3 then
            arrivedConn:Disconnect()
            hum.WalkSpeed = originalSpeed -- restaurar velocidad
        end
    end)
end)
