getgenv().MainEnabled = true

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local CookingPotService_RE = ReplicatedStorage.GameEvents.CookingPotService_RE
local SubmitFoodService_RE = ReplicatedStorage.GameEvents.SubmitFoodService_RE

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local backpack = lp.Backpack
local char = lp.Character

if not backpack then
    warn("Unable to get local player's backpack")
end
if not char then
    warn("Unable to get local player's character")
end

-- Anti AFK
lp.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    print("Simulated user input to prevent AFK kick")
end)

local function RemoveToolsFromCharacter()
    for i, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then
            v.Parent = backpack
        end
    end
end

local function GetFruitFromInventory(name)
    for i, v in pairs(backpack:GetChildren()) do
        if v:IsA("Tool") then
            -- 'b' attribute appears to be the item type
            local type = v:GetAttribute("b")
            -- 'j' is for fruits
            if type ~= "j" then continue end

            -- 'f' is the fruit's name
            local fruitName = v:GetAttribute("f")

            if fruitName and fruitName == name then return v end
        end
    end

    return nil
end

local function GetPlayerRootPart(player)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart
    end
    return nil
end

local function GetPlayerHumanoid(player)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
        return char.Humanoid
    end
    return nil
end

local function GetPlayerProximityPrompt(player)
    local rootpart = GetPlayerRootPart(player)
    if not rootpart then return end

	local proxPrompt = rootpart:FindFirstChildOfClass("ProximityPrompt")
    if not proxPrompt then
        warn("Unable to find players Proximity Prompt: ", player.Name)
    end

    return proxPrompt
end

local function TradeFruit(player)
    local localRootPart = GetPlayerRootPart(lp)
    if not localRootPart then return end

    localRootPart.CanCollide = false
    task.wait()

    local otherRootPart = GetPlayerRootPart(player)
    if not otherRootPart then return end
    
    local lastCFrame = localRootPart.CFrame

    localRootPart:PivotTo(otherRootPart.CFrame)
    task.wait(0.25)

    local proxPrompt = GetPlayerProximityPrompt(player)
    if not proxPrompt then return end

    fireproximityprompt(proxPrompt)
    task.wait(0.25)

    localRootPart:PivotTo(lastCFrame)
end

local function HoldFruit(fruitName)
    RemoveToolsFromCharacter()
    task.wait()
    local fruit = GetFruitFromInventory(fruitName)
    if not fruit then return false end
    fruit.Parent = char
    task.wait()
    return true
end

-- Cooking Utility
local function SubmitHeldPlant()
    CookingPotService_RE:FireServer(
        "SubmitHeldPlant"
    )
end

local function GetFoodFromPot()
    CookingPotService_RE:FireServer(
        "GetFoodFromPot"
    )
end

local function StartCook()
    CookingPotService_RE:FireServer(
        "CookBest"
    )
end

-- Main loop

local function main()
    print("Entered main")

    while task.wait() do
        if not getgenv().MainEnabled then
            break
        end

        -- Trading
        if not HoldFruit("Sunflower") then continue end

        for _, player in pairs(game.Players:GetChildren()) do
            if player == lp then continue end

            TradeFruit(player)
            print("Traded fruit to: ", player.Name)
        end

        task.wait(1)
        
        RemoveToolsFromCharacter()
        task.wait(1)
        if not HoldFruit("Sunflower") then continue end
        task.wait(1)
        SubmitHeldPlant()
        task.wait(5)
        RemoveToolsFromCharacter()
        task.wait(1)
        StartCook()
        task.wait(1)
        GetFoodFromPot()

        task.wait(1)
    end
end

main()
