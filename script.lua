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

-- Crear Slider para velocidad
local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(1, -20, 0, 40)
sliderContainer.Position = UDim2.new(0, 10, 0, 150)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Parent = frame

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0.7, 0, 1, 0)
sliderLabel.Position = UDim2.new(0, 0, 0, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Velocidad: 34"
sliderLabel.TextColor3 = Color3.new(1,1,1)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 14
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = sliderContainer

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.25, 0, 0.4, 0)
sliderBar.Position = UDim2.new(0.75, 0, 0.3, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(80,80,80)
sliderBar.Parent = sliderContainer

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0.4,0,1,0)
knob.Position = UDim2.new(0,0,0,0)
knob.BackgroundColor3 = Color3.new(1,1,1)
knob.Parent = sliderBar
local knobCorner = Instance.new("UICorner", knob)
knobCorner.CornerRadius = UDim.new(1,0)

-- Función para actualizar velocidad
local dragging = false
local dragInput
local dragStart
local knobStart

local function updateSpeed(input)
    local delta = input.Position.X - dragStart.X
    local newPos = math.clamp(knobStart.X.Offset + delta, 0, sliderBar.AbsoluteSize.X - knob.AbsoluteSize.X)
    knob.Position = UDim2.new(0, newPos, 0, 0)
    local speed = 18 + (newPos / (sliderBar.AbsoluteSize.X - knob.AbsoluteSize.X)) * 50 -- rango 18-68
    sliderLabel.Text = "Velocidad: "..math.floor(speed)
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = speed end
end

knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        knobStart = knob.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSpeed(input)
    end
end)
