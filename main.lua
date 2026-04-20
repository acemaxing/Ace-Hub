local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Ace Hub",
   LoadingTitle = "Ace Hub",
   LoadingSubtitle = "by Ace",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AceHub",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

local PlayerTab = Window:CreateTab("Player", 4483362458)

local WalkSpeedSlider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      local Character = game.Players.LocalPlayer.Character
      if Character and Character:FindFirstChild("Humanoid") then
         Character.Humanoid.WalkSpeed = Value
      end
   end,
})

local JumpPowerSlider = PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 1,
   Suffix = " Power",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
      local Character = game.Players.LocalPlayer.Character
      if Character and Character:FindFirstChild("Humanoid") then
         Character.Humanoid.JumpPower = Value
      end
   end,
})

-- Blade Ball Section
local BladeBallTab = Window:CreateTab("Blade Ball", 4483362458)

local ParryDistance = 25
local AutoParryEnabled = false
local LastParryTime = 0
local ParryCooldown = 0.1

local ParryDistanceSlider = BladeBallTab:CreateSlider({
   Name = "Parry Distance",
   Range = {10, 60},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 25,
   Flag = "ParryDistance",
   Callback = function(Value)
      ParryDistance = Value
   end,
})

local AutoParryToggle = BladeBallTab:CreateToggle({
   Name = "Auto Parry",
   CurrentValue = false,
   Flag = "AutoParry",
   Callback = function(Value)
      AutoParryEnabled = Value
   end,
})

-- Auto Parry Logic
game:GetService("RunService").Heartbeat:Connect(function()
   if not AutoParryEnabled then return end
   
   local LocalPlayer = game.Players.LocalPlayer
   local Character = LocalPlayer.Character
   local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
   
   if not RootPart then return end
   
   -- Find the ball
   local Ball = workspace:FindFirstChild("Ball")
   if not Ball and workspace:FindFirstChild("Balls") then
      Ball = workspace.Balls:FindFirstChildWhichIsA("BasePart") or workspace.Balls:FindFirstChild("Ball")
   end
   
   if Ball and (tick() - LastParryTime) > ParryCooldown then
      local Distance = (RootPart.Position - Ball.Position).Magnitude
      if Distance <= ParryDistance then
         game:GetService("ReplicatedStorage").Remotes.Block:FireServer()
         LastParryTime = tick()
      end
   end
end)

Rayfield:LoadConfiguration()