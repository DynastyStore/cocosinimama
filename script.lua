local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
-- local PhysicsService = game:GetService("PhysicsService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local SPEED = 50
local holding = false

-- Asignar personaje a capa sin colisiones
-- local function setNoCollision()
-- 	for _, part in ipairs(char:GetDescendants()) do
-- 		if part:IsA("BasePart") then
-- 			PhysicsService:SetPartCollisionGroup(part, "NoCollide")
-- 		end
-- 	end
-- end

-- Crear CollisionGroup si no existe
-- pcall(function()
-- 	PhysicsService:CreateCollisionGroup("NoCollide")
-- end)
-- PhysicsService:CollisionGroupSetCollidable("NoCollide", "Default", false)
-- PhysicsService:CollisionGroupSetCollidable("NoCollide", "NoCollide", false)

-- Toggle activado
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		holding = true
		-- setNoCollision()
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

-- Movimiento
RunService.RenderStepped:Connect(function()
	if holding and hrp then
		local moveDirection = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += Vector3.new(0, 0, 1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection += Vector3.new(0, 0, -1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection += Vector3.new(-1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += Vector3.new(1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end

		if moveDirection.Magnitude > 0 then
			moveDirection = moveDirection.Unit
			local camCF = workspace.CurrentCamera.CFrame
			local moveWorld = (camCF.RightVector * moveDirection.X + camCF.LookVector * moveDirection.Z + Vector3.new(0, moveDirection.Y, 0)).Unit
			hrp.AssemblyLinearVelocity = moveWorld * SPEED
		else
			hrp.AssemblyLinearVelocity = Vector3.zero
		end
	end
end)

-- GUI toggle
local gui = Instance.new("ScreenGui")
gui.Name = "FlyToggleGui"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 200, 0, 40)
toggle.Position = UDim2.new(0, 20, 0, 100)
toggle.Text = "Modo Vuelo: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSans
toggle.TextSize = 16

toggle.MouseButton1Click:Connect(function()
	holding = not holding
	toggle.Text = "Modo Vuelo: " .. (holding and "ON" or "OFF")
	if not holding and hrp then
		hrp.AssemblyLinearVelocity = Vector3.zero
	end
	if holding then
		-- setNoCollision()
	end
end)
