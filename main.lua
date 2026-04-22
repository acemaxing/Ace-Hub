-- Custom UI for Ace Hub - Fisch (Safe & Fast)
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Clean up any existing UI
if PlayerGui:FindFirstChild("AceHubTP") then
    PlayerGui.AceHubTP:Destroy()
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AceHubTP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Ace Hub - Fisch TP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Input Styling Helper
local function createInput(name, pos, placeholder)
    local input = Instance.new("TextBox")
    input.Name = name
    input.Size = UDim2.new(0.8, 0, 0, 30)
    input.Position = pos
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.PlaceholderText = placeholder
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 16
    input.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = input
    return input
end

local X_Input = createInput("X_Coord", UDim2.new(0.1, 0, 0.2, 0), "X Coordinate")
local Y_Input = createInput("Y_Coord", UDim2.new(0.1, 0, 0.4, 0), "Y Coordinate")
local Z_Input = createInput("Z_Coord", UDim2.new(0.1, 0, 0.6, 0), "Z Coordinate")

local TP_Button = Instance.new("TextButton")
TP_Button.Name = "TeleportButton"
TP_Button.Size = UDim2.new(0.8, 0, 0, 35)
TP_Button.Position = UDim2.new(0.1, 0, 0.8, 0)
TP_Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TP_Button.Text = "Teleport"
TP_Button.TextColor3 = Color3.fromRGB(255, 255, 255)
TP_Button.Font = Enum.Font.SourceSansBold
TP_Button.TextSize = 18
TP_Button.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = TP_Button

-- Teleport Logic
TP_Button.MouseButton1Click:Connect(function()
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local x = tonumber(X_Input.Text)
        local y = tonumber(Y_Input.Text)
        local z = tonumber(Z_Input.Text)
        
        if x and y and z then
            hrp.CFrame = CFrame.new(x, y, z)
        end
    end
end)

-- Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 2)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.Font = Enum.Font.SourceSansBold
Close.TextSize = 20
Close.Parent = MainFrame

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
