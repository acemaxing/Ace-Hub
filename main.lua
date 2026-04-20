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

Rayfield:LoadConfiguration()