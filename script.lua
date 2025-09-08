local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- CONFIG
local SPEED = 60  -- Valor razonable. Puedes subir a 80 si es seguro.
local KEY = Enum.KeyCode.LeftShift  -- Activar velocidad al mantener tecla

-- State
local UserInputService = game:GetService("UserInputService")
local boosting = false

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == KEY then
        boosting = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if not gp and input.KeyCode == KEY then
        boosting = false
    end
end)

-- Movimiento
RunService.RenderStepped:Connect(function(dt)
    if boosting and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local moveVec = lp:GetMouse().Hit.Position - hrp.Position
        moveVec = Vector3.new(moveVec.X, 0, moveVec.Z).Unit
        hrp.CFrame = hrp.CFrame + (moveVec * SPEED * dt)
    end
end)
