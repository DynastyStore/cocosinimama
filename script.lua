local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local SPEED = 0
local holding = false

-- Keybind
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        holding = false
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

-- Movimiento con fuerza realista
RunService.RenderStepped:Connect(function(dt)
    if holding and hrp then
        local moveDirection = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection += Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection += Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += Vector3.new(1, 0, 0) end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            local camCF = workspace.CurrentCamera.CFrame
            local moveWorld = (camCF.RightVector * moveDirection.X + camCF.LookVector * moveDirection.Z).Unit
            hrp.AssemblyLinearVelocity = moveWorld * SPEED
        else
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

-- GUI para ajustar velocidad
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local slider = Instance.new("TextButton", gui)
slider.Size = UDim2.new(0, 200, 0, 40)
slider.Position = UDim2.new(0, 20, 0, 100)
slider.Text = "Velocidad: 0"
slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
slider.TextColor3 = Color3.new(1, 1, 1)
slider.Font = Enum.Font.SourceSans
slider.TextSize = 16

slider.MouseButton1Click:Connect(function()
    SPEED = (SPEED + 10) % 150
    slider.Text = "Velocidad: " .. SPEED
end)
