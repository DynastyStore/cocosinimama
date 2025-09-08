local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

-- Estado
local SPEED = 0
local holding = false

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 80)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, -10, 0.4, 0)
label.Position = UDim2.new(0, 5, 0, 5)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.Text = "Velocidad: 0"
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.TextXAlignment = Enum.TextXAlignment.Left

local bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(1, -20, 0.3, 0)
bar.Position = UDim2.new(0, 10, 0.6, 0)
bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local knob = Instance.new("Frame", bar)
knob.Size = UDim2.new(0, 20, 1, 0)
knob.Position = UDim2.new(0, 0, 0, 0)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

-- Dragging
local dragging = false
local dragStart = nil
local knobStart = nil

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
        local delta = input.Position.X - dragStart.X
        local newX = math.clamp(knobStart.X.Offset + delta, 0, bar.AbsoluteSize.X - knob.AbsoluteSize.X)
        knob.Position = UDim2.new(0, newX, 0, 0)

        local ratio = newX / (bar.AbsoluteSize.X - knob.AbsoluteSize.X)
        SPEED = math.floor(20 + ratio * 100) -- rango 20–120
        label.Text = "Velocidad: " .. SPEED
    end
end)

-- Input hold key to activate
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        holding = false
    end
end)

-- Movimiento CFrame (indetectable)
RunService.RenderStepped:Connect(function(dt)
    if holding and player.Character and hrp then
        local moveDirection = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection += Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection += Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += Vector3.new(1, 0, 0) end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            local camCF = workspace.CurrentCamera.CFrame
            local moveWorld = (camCF.RightVector * moveDirection.X + camCF.LookVector * moveDirection.Z)
            hrp.CFrame = hrp.CFrame + (moveWorld.Unit * SPEED * dt)
        end
    end
end)
