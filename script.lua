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
