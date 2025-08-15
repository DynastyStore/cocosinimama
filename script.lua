local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")

-- Crear GUI de salida
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local textLabel = Instance.new("TextLabel", screenGui)
textLabel.Size = UDim2.new(0.3, 0, 0.3, 0)
textLabel.Position = UDim2.new(0, 10, 0, 10)
textLabel.BackgroundTransparency = 0.5
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Top
textLabel.TextWrapped = true

RunService.RenderStepped:Connect(function()
    if hrp and hum then
        local info = ""
        info ..= "Posición: " .. tostring(hrp.Position) .. "\n"
        info ..= "WalkSpeed: " .. tostring(hum.WalkSpeed) .. "\n"

        -- Partes cercanas
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Position - hrp.Position).Magnitude < 10 then
                info ..= "Cerca de: " .. part.Name .. " Dist: " .. math.floor((part.Position - hrp.Position).Magnitude) .. "\n"
            end
        end

        textLabel.Text = info
    end
end)



-- Servicios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestSpeedGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

-- Bordes redondeados
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Control de Velocidad"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Función para mover el frame
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Variables de velocidad
local currentSpeed = 34
local minSpeed, maxSpeed = 18, 68

-- Label para mostrar velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Text = "Velocidad: "..currentSpeed
speedLabel.Parent = frame

-- Slider
local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.8,0,0,20)
sliderBar.Position = UDim2.new(0.1,0,0,70)
sliderBar.BackgroundColor3 = Color3.fromRGB(80,80,80)
sliderBar.Parent = frame

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0.1,0,1,0)
knob.Position = UDim2.new((currentSpeed-minSpeed)/(maxSpeed-minSpeed)*0.9,0,0,0)
knob.BackgroundColor3 = Color3.fromRGB(200,200,200)
knob.Parent = sliderBar

local knobCorner = Instance.new("UICorner", knob)
knobCorner.CornerRadius = UDim.new(1,0)

-- TextBox para escribir velocidad
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.3,0,0,25)
speedBox.Position = UDim2.new(0.35,0,0,100)
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.Text = tostring(currentSpeed)
speedBox.ClearTextOnFocus = false
speedBox.Parent = frame

-- Función para actualizar velocidad
local function setSpeed(speed)
    currentSpeed = math.clamp(speed, minSpeed, maxSpeed)
    speedLabel.Text = "Velocidad: "..math.floor(currentSpeed)
    speedBox.Text = tostring(math.floor(currentSpeed))
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = currentSpeed
    end
end

-- Drag del knob
do
    local draggingKnob = false
    local dragStart
    local knobStart

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingKnob = true
            dragStart = input.Position
            knobStart = knob.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingKnob = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingKnob and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position.X - dragStart.X
            local newOffset = math.clamp(knobStart.X.Offset + delta, 0, sliderBar.AbsoluteSize.X - knob.AbsoluteSize.X)
            knob.Position = UDim2.new(0,newOffset,0,0)
            local speed = minSpeed + (newOffset/(sliderBar.AbsoluteSize.X - knob.AbsoluteSize.X))*(maxSpeed-minSpeed)
            setSpeed(speed)
        end
    end)
end

-- Escribir manualmente en TextBox
speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(speedBox.Text)
        if value then
            setSpeed(value)
            -- Ajustar knob
            knob.Position = UDim2.new(0, (currentSpeed-minSpeed)/(maxSpeed-minSpeed)*(sliderBar.AbsoluteSize.X - knob.AbsoluteSize.X), 0, 0)
        end
    end
end)
