if getgenv().ChillingAntiAFK then
  warn("Chilling's AntiAFK is already running")
  return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local function main()
  local VirtualUser = game:GetService("VirtualUser")
  local Players = game:GetService("Players")
  local lp = Players.LocalPlayer
  
  lp.Idled:Connect(function()
      VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      task.wait(1)
      VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      print("[Chilling's AntiAFK]: AFK Kick Prevented")
  end)

  getgenv().ChillingAntiAFK = true
  print("Started Chilling's AntiAFK")
end

main()
