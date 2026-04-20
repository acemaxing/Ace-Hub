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

local MainTab = Window:CreateTab("Main", 4483362458)

local Toggle = MainTab:CreateToggle({
   Name = "Test Toggle",
   CurrentValue = false,
   Flag = "TestToggle",
   Callback = function(Value)
      if Value then
         print("Toggle activated")
      else
         print("Toggle deactivated")
      end
   end,
})

Rayfield:LoadConfiguration()