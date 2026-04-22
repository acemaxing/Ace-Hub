local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Ace Hub - Fisch",
   LoadingTitle = "Ace Hub",
   LoadingSubtitle = "by Ace",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AceHubFisch",
      FileName = "AceHub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvite",
      RememberJoins = true
   },
   KeySystem = false,
})

local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local X_Coord = ""
local Y_Coord = ""
local Z_Coord = ""

TeleportTab:CreateInput({
   Name = "X Coordinate",
   PlaceholderText = "Enter X...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      X_Coord = Text
   end,
})

TeleportTab:CreateInput({
   Name = "Y Coordinate",
   PlaceholderText = "Enter Y...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      Y_Coord = Text
   end,
})

TeleportTab:CreateInput({
   Name = "Z Coordinate",
   PlaceholderText = "Enter Z...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      Z_Coord = Text
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Coordinates",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character
      local hrp = character and character:FindFirstChild("HumanoidRootPart")

      if hrp then
         local x = tonumber(X_Coord)
         local y = tonumber(Y_Coord)
         local z = tonumber(Z_Coord)

         if x and y and z then
            hrp.CFrame = CFrame.new(x, y, z)
            Rayfield:Notify({
               Title = "Teleport Successful",
               Content = "Teleported to " .. x .. ", " .. y .. ", " .. z,
               Duration = 3,
               Image = 4483362458,
            })
         else
            Rayfield:Notify({
               Title = "Invalid Input",
               Content = "Please ensure all coordinates are valid numbers.",
               Duration = 3,
               Image = 4483362458,
            })
         end
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "HumanoidRootPart not found.",
            Duration = 3,
            Image = 4483362458,
         })
      end
   end,
})
