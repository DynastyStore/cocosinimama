-- LocalScript: Sprint cámara-relativo para TU experiencia (no para explotar otras)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local function waitForCharacter(plr)
    local ch = plr.Character or plr.CharacterAdded:Wait()
    ch:WaitForChild("Humanoid")
    ch:WaitForChild("HumanoidRootPart")
    return ch
end

local character = waitForCharacter(player)
local humanoid = character:FindFirstChildOfClass("Humanoid")

-- Parámetros
local BASE_SPEED = 16             -- WalkSpeed base típico
local SPRINT_MULT = 1.7           -- multiplicador de sprint
local isSprinting = false

-- Estado de inputs
local inputW, inputA, inputS, inputD = false, false, false, false

local function updateSprint(state)
    isSprinting = state
    humanoid.WalkSpeed = BASE_SPEED * (isSprinting and SPRINT_MULT or 1)
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftShift then updateSprint(true) end
    if input.KeyCode == Enum.KeyCode.W then inputW = true end
    if input.KeyCode == Enum.KeyCode.A then inputA = true end
    if input.KeyCode == Enum.KeyCode.S then inputS = true end
    if input.KeyCode == Enum.KeyCode.D then inputD = true end
end)

UIS.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftShift then updateSprint(false) end
    if input.KeyCode == Enum.KeyCode.W then inputW = false end
    if input.KeyCode == Enum.KeyCode.A then inputA = false end
    if input.KeyCode == Enum.KeyCode.S then inputS = false end
    if input.KeyCode == Enum.KeyCode.D then inputD = false end
end)

-- Movimiento cámara-relativo, corrige W/S invertidas
RunService.RenderStepped:Connect(function()
    if not character or not character.Parent then
        character = waitForCharacter(player)
        humanoid = character:FindFirstChildOfClass("Humanoid")
        updateSprint(false)
        return
    end

    local cam = workspace.CurrentCamera
    local look = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector

    -- proyectar en plano XZ para evitar y (vertical)
    look = Vector3.new(look.X, 0, look.Z).Unit
    right = Vector3.new(right.X, 0, right.Z).Unit

    local moveVec = Vector3.zero
    if inputW then moveVec += look end        -- W hacia adelante (no invertido)
    if inputS then moveVec -= look end        -- S hacia atrás
    if inputA then moveVec -= right end
    if inputD then moveVec += right end

    if moveVec.Magnitude > 0 then
        moveVec = moveVec.Unit
        humanoid:Move(moveVec, false)
    else
        humanoid:Move(Vector3.zero, false)
    end
end)

-- Por si el personaje respawnea
player.CharacterAdded:Connect(function(ch)
    character = ch
    humanoid = character:WaitForChild("Humanoid")
    updateSprint(false)
end)
