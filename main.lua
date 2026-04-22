-- Custom UI for Ace Hub - Fisch (Safe, Fast & Minimizable)
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Variables for Floating TP
local CrosshairGui = nil
local TargetMarker = nil
local RenderSteppedConnection = nil

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
MainFrame.Size = UDim2.new(0, 250, 0, 260) -- Increased height to fit new toggle
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -130)
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

-- Minimize Button (-)
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 25, 0, 25)
Minimize.Position = UDim2.new(1, -55, 0, 2)
Minimize.BackgroundTransparency = 1
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(200, 200, 200)
Minimize.Font = Enum.Font.SourceSansBold
Minimize.TextSize = 25
Minimize.Parent = MainFrame

-- Restore Button (Invisible until minimized)
local Restore = Instance.new("TextButton")
Restore.Name = "RestoreButton"
Restore.Size = UDim2.new(0, 50, 0, 30)
Restore.Position = UDim2.new(0, 10, 0, 10)
Restore.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Restore.Text = "Ace"
Restore.TextColor3 = Color3.fromRGB(255, 255, 255)
Restore.Font = Enum.Font.SourceSansBold
Restore.Visible = false
Restore.Parent = ScreenGui

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 6)
RestoreCorner.Parent = Restore

Minimize.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    Restore.Visible = true
end)

Restore.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    Restore.Visible = false
end)

-- Close Button (X)
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
    -- Cleanup floating TP objects before destroying the main GUI
    if RenderSteppedConnection then RenderSteppedConnection:Disconnect() end
    if TargetMarker then TargetMarker:Destroy() end
    if CrosshairGui then CrosshairGui:Destroy() end
    ScreenGui:Destroy()
end)

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

local X_Input = createInput("X_Coord", UDim2.new(0.1, 0, 0.15, 0), "X Coordinate")
local Y_Input = createInput("Y_Coord", UDim2.new(0.1, 0, 0.28, 0), "Y Coordinate")
local Z_Input = createInput("Z_Coord", UDim2.new(0.1, 0, 0.41, 0), "Z Coordinate")

local TP_Button = Instance.new("TextButton")
TP_Button.Name = "TeleportButton"
TP_Button.Size = UDim2.new(0.8, 0, 0, 35)
TP_Button.Position = UDim2.new(0.1, 0, 0.55, 0)
TP_Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TP_Button.Text = "Teleport"
TP_Button.TextColor3 = Color3.fromRGB(255, 255, 255)
TP_Button.Font = Enum.Font.SourceSansBold
TP_Button.TextSize = 18
TP_Button.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = TP_Button

-- Floating TP Toggle Helper
local function createToggle(name, pos, text, callback)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(0.8, 0, 0, 30)
    container.Position = pos
    container.BackgroundTransparency = 1
    container.Parent = MainFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 15
    label.Parent = container
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 40, 0, 20)
    button.Position = UDim2.new(1, -40, 0.5, -10)
    button.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    button.Text = ""
    button.Parent = container
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 10)
    bCorner.Parent = button
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.Parent = button
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    
    local enabled = false
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            indicator:TweenPosition(UDim2.new(0, 22, 0.5, -8), "Out", "Quad", 0.2, true)
        else
            button.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            indicator:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
        end
        callback(enabled)
    end)
    return container
end

-- Floating TP Toggle Logic
local function toggleFloatingTP(value)
    if value then
        -- Enable Floating TP
        CrosshairGui = Instance.new("ScreenGui")
        CrosshairGui.Name = "FloatingTPGui"
        CrosshairGui.ResetOnSpawn = false
        CrosshairGui.Parent = PlayerGui
        
        -- Center Crosshair Dot
        local Crosshair = Instance.new("Frame")
        Crosshair.Name = "Crosshair"
        Crosshair.Size = UDim2.new(0, 4, 0, 4)
        Crosshair.Position = UDim2.new(0.5, -2, 0.5, -2)
        Crosshair.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Crosshair.BorderSizePixel = 0
        Crosshair.Parent = CrosshairGui
        
        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(1, 0)
        cCorner.Parent = Crosshair
        
        -- Floating TP Button
        local FloatingButton = Instance.new("TextButton")
        FloatingButton.Name = "TPHereButton"
        FloatingButton.Size = UDim2.new(0, 120, 0, 50)
        FloatingButton.Position = UDim2.new(0.8, 0, 0.7, 0)
        FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        FloatingButton.Text = "🎯 TP HERE"
        FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FloatingButton.Font = Enum.Font.SourceSansBold
        FloatingButton.TextSize = 18
        FloatingButton.Parent = CrosshairGui
        
        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(0, 8)
        fCorner.Parent = FloatingButton
        
        -- Target Marker Disc
        TargetMarker = Instance.new("Part")
        TargetMarker.Name = "TargetMarker"
        TargetMarker.Shape = Enum.PartType.Cylinder
        TargetMarker.Size = Vector3.new(0.2, 4, 4)
        TargetMarker.Rotation = Vector3.new(0, 0, 90)
        TargetMarker.Material = Enum.Material.Neon
        TargetMarker.Color = Color3.fromRGB(255, 0, 0)
        TargetMarker.Transparency = 0.5
        TargetMarker.Anchored = true
        TargetMarker.CanCollide = false
        TargetMarker.Parent = workspace
        
        -- Raycast and Marker Update
        RenderSteppedConnection = RunService.RenderStepped:Connect(function()
            local rayOrigin = Camera.CFrame.Position
            local rayDirection = Camera.CFrame.LookVector * 1000
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {Player.Character, TargetMarker}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            if raycastResult then
                TargetMarker.Position = raycastResult.Position
                TargetMarker.Visible = true
            else
                TargetMarker.Visible = false
            end
        end)
        
        -- TP Button Event
        FloatingButton.MouseButton1Click:Connect(function()
            local char = Player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and TargetMarker then
                hrp.CFrame = CFrame.new(TargetMarker.Position + Vector3.new(0, 3, 0))
            end
        end)
    else
        -- Disable and Cleanup
        if CrosshairGui then CrosshairGui:Destroy() CrosshairGui = nil end
        if TargetMarker then TargetMarker:Destroy() TargetMarker = nil end
        if RenderSteppedConnection then RenderSteppedConnection:Disconnect() RenderSteppedConnection = nil end
    end
end

-- Add the Toggle to UI
createToggle("FloatingTP", UDim2.new(0.1, 0, 0.75, 0), "Floating Crosshair TP", toggleFloatingTP)

-- Teleport Logic (Coordinate-based)
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
