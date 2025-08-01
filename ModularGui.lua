-- Tested and Working on Latest Version of Delta
-- Configs not finished yet, everything else should be good and the item lists stay updated automatically
-- Hope you find this helpful :)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Data Arrays
local CoroutineArray = {}
local MutationsArray = {}
local SeedsArray = {}

-- Local Player
local lp = game.Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

-- General Variables
local Data = ReplicatedStorage:WaitForChild("Data")
local Modules = ReplicatedStorage:WaitForChild("Modules")

-- Modular Scripts
local CalculatePlantValue = require(Modules:WaitForChild("CalculatePlantValue"))
local CosmeticCrateShopData = require(Data:WaitForChild("CosmeticCrateShopData"))
local CosmeticItemShopData = require(Data:WaitForChild("CosmeticItemShopData"))
local PetEggData = require(Data:WaitForChild("PetEggData"))
local MutationHandler = require(Modules:WaitForChild("MutationHandler"))
local SeedData = require(Data:WaitForChild("SeedData"))

-- Auto Buy Variables
local SeedShop = PlayerGui:WaitForChild("Seed_Shop")
local SeedShopScrollingFrame = SeedShop:WaitForChild("Frame"):WaitForChild("ScrollingFrame")
local BuySeedStock = ReplicatedStorage.GameEvents.BuySeedStock

local GearShop = PlayerGui:WaitForChild("Gear_Shop")
local GearShopScrollingFrame = GearShop:WaitForChild("Frame"):WaitForChild("ScrollingFrame")
local BuyGearStock = ReplicatedStorage.GameEvents.BuyGearStock

local PetShopUI = PlayerGui:WaitForChild("PetShop_UI")
local PetShopScrollingFrame = PetShopUI:WaitForChild("Frame"):WaitForChild("ScrollingFrame")
local BuyPetEgg = ReplicatedStorage.GameEvents.BuyPetEgg

local CosmeticShopUI = PlayerGui:WaitForChild("CosmeticShop_UI")
local CosmeticShopContentFrame = CosmeticShopUI:WaitForChild("CosmeticShop"):WaitForChild("Main"):WaitForChild("Holder"):WaitForChild("Shop"):WaitForChild("ContentFrame")
local CosmeticShopTopSegment = CosmeticShopContentFrame:WaitForChild("TopSegment")
local CosmeticShopBottomSegment = CosmeticShopContentFrame:WaitForChild("BottomSegment")
local BuyCosmeticItem = ReplicatedStorage.GameEvents.BuyCosmeticItem
local BuyCosmeticCrate = ReplicatedStorage.GameEvents.BuyCosmeticCrate

-- Farm Variables
local FarmFolder
local FarmsFolder = game.Workspace:WaitForChild("Farm")
local FruitMutationsUI = lp.PlayerGui.FruitMutation_UI
local FruitName  = FruitMutationsUI.Frame.FruitName
local FruitMutation = FruitMutationsUI.Frame.FruitMutation
local Plant_RE = ReplicatedStorage.GameEvents.Plant_RE

-- Visual Variables
local HoneyUI = PlayerGui:WaitForChild("Honey_UI"):WaitForChild("Frame")
local GearTPUI = PlayerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Gear")
local PetsTPUI = PlayerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Pets")

-- Config Table
local configs = {
    AutoBuySeedShop = false,
    SeedShopFilter = {},
    AutoBuyGearShop = false,
    GearShopFilter = {},
    AutoBuyEggShop = false,
    EggShopFilter = {},
    AutoBuyCosmeticShop = false,
    CosmeticShopFilter = {},

    AutoCollect = false,
    AutoCollectBlockedPlants = {},
    AutoCollectBlockedVariants = {},
    AutoCollectBlockedMutations = {},
    AutoCollectMinimumValue = 0,
    AutoCollectMinimumWeight = 0,
    AutoPlant = false,
    AutoPlantAllowedSeeds = {},
    AutoPlantSeedLimits = {},

    AlwaysShowHoney = false,
    ToggleGearTP = false,
    TogglePetsTP = false,

    WaitTime = 10,
}

-- Color Scheme --
local FrameColor = Color3.fromRGB(255, 255, 255)

-- Gui Variables
--local function GetAutoExecuteConfig()
--    if isfolder and makefolder then
--        if not isfolder("ChillingGAGAutoExecute") then
--            makefolder("ChillingGAGAutoExecute")
--            return false
--        end
--
--        if readfile and isfile and isfile("ChillingGAGAutoExecute/AutoExecute.txt") then
--            configs = HttpService:JSONDecode(readfile("ChillingGAGAutoExecute/AutoExecute.txt"))
--            return true
--        end
--    end
--    return false
--end

local function GetAutoExecuteConfig()
    return false
end

local DefaultPlantCount = 20
local ActivePage = nil
local PageCount = 0
local ActiveDropDown = nil
local ConfigScrollingFrame = nil
local AutoExecuteConfig = GetAutoExecuteConfig()
local SelectedConfig = ""
if AutoExecuteConfig then
    SelectedConfig = "AutoExecute"
else
    SelectedConfig = "autosave"
end

-- Utility Functions --

local ScreenGui = Instance.new("ScreenGui")
local function CloseScript()
    -- End Coroutines
    for i, v in pairs(CoroutineArray) do
        if v then
            coroutine.close(v)
        end
    end

    -- Disable Configs
    for i, v in pairs(configs) do
        if (v == true) then
            configs[i] = false
        end
    end

    ScreenGui:Destroy()
    --script:Destroy()
end

-- Returns:
--      TRUE if local player character, humanoid, and rootpart are valid
-- Description:
--      Gets the local player's Humanoid and HumanoidRootPart

local rootpart
local humanoid
local function GetPlayer()
    local char = lp.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart") then
        rootpart = char.HumanoidRootPart
        humanoid = char.Humanoid
        return true
    end
	warn("GetPlayer: Unable to Find Player")
    return false
end

-- Returns:
--      TRUE if local player character, humanoid, and rootpart are valid
-- Description:
--      Repeatedly checks for valid local player character, humanoid, and rootpart

local function WaitForPlayer()
	local loopCount = 0
    local loopTime = 60*8   -- 8 minutes
	while task.wait(1) do
        print("WaitForPlayer: Searching For Player")
            
        if GetPlayer() then break end

        if loopCount > loopTime then
            warn("WaitForPlayer: Waited and Could Not Find Player, Closing Script, please try re-executing.")
            break
        end
		loopCount = loopCount + 1
	end

	return rootpart ~= nil and humanoid ~= nil
end

-- Parameters: 
--      player: Player Object Reference
-- Returns:
--      farm folder/directory or nil
-- Description:
--      Loops through all Farms and returns the Farm Folder with matching player name

local function GetPlayerFarm(player)
    for _, farm in pairs(FarmsFolder:GetChildren()) do
        local ImportantFolder = farm:FindFirstChild("Important")
        local DataFolder = ImportantFolder:FindFirstChild("Data")
        
		if DataFolder.Owner.Value == player.Name then
            FarmFolder = farm
            return true
        end
    end
    warn("GetPlayerFarm: Unable to find player farm")
    return false
end

-- Parameters: 
--      player: Player Object Reference
-- Returns:
--      TRUE if player farm is found
-- Description:
--      Repeatedly checks for valid local player character, humanoid, and rootpart

local function WaitForPlayerFarm(player)
	local loopCount = 0
    local loopTime = 60*8   -- 8 minutes
	while task.wait(1) do
        print("WaitForPlayerFarm: Searching For Player Farm")
            
        if GetPlayerFarm(player) then break end

        if loopCount > loopTime then
            warn("WaitForPlayerFarm: Waited and Could Not Find Player Farm, Closing Script, please try re-executing.")
            break
        end
		loopCount = loopCount + 1
	end

	return FarmFolder ~= nil
end

-- Main Gui Components --

local MainFrame = Instance.new("Frame")
local TabBar = Instance.new("Frame")
local TabBarScrollingFrame = Instance.new("ScrollingFrame")
local TabBarUIListLayout = Instance.new("UIListLayout")
local TabBar_ScrollLeftButton = Instance.new("TextButton")
local TabBar_ScrollRightButton = Instance.new("TextButton")
local TabBar_Exit = Instance.new("TextButton")
local TabBar_Minimize = Instance.new("TextButton")
local DraggableFrame = Instance.new("Frame")

-- Main Gui Properties --

ScreenGui.Parent = game:WaitForChild("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "Chilling's GaG GUI"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 0.500
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0.449999988, 0, 0.449999988, 0)

TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
TabBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBar.BorderSizePixel = 0
TabBar.Size = UDim2.new(1, 0, 0.1, 0)

TabBarScrollingFrame.Parent = TabBar
TabBarScrollingFrame.Active = true
TabBarScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabBarScrollingFrame.BackgroundTransparency = 1.000
TabBarScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBarScrollingFrame.BorderSizePixel = 0
TabBarScrollingFrame.Position = UDim2.new(0.0470411181, 0, 0.242632911, 0)
TabBarScrollingFrame.Size = UDim2.new(0.8, 0, 0.75, 0)
TabBarScrollingFrame.AutomaticSize = Enum.AutomaticSize.None
TabBarScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBarScrollingFrame.ScrollBarThickness = 0
TabBarScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X

TabBarUIListLayout.Parent = TabBarScrollingFrame
TabBarUIListLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

TabBar_ScrollLeftButton.Name = "TabBar_ScrollLeftButton"
TabBar_ScrollLeftButton.Parent = TabBar
TabBar_ScrollLeftButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabBar_ScrollLeftButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBar_ScrollLeftButton.BorderSizePixel = 0
TabBar_ScrollLeftButton.Position = UDim2.new(0, 0, 0.242632911, 0)
TabBar_ScrollLeftButton.Size = UDim2.new(0.0470411181, 0, 0.7758708, 0)
TabBar_ScrollLeftButton.Font = Enum.Font.SourceSans
TabBar_ScrollLeftButton.Text = "<"
TabBar_ScrollLeftButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TabBar_ScrollLeftButton.TextSize = 14.000

TabBar_ScrollRightButton.Name = "TabBar_ScrollRightButton"
TabBar_ScrollRightButton.Parent = TabBar
TabBar_ScrollRightButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabBar_ScrollRightButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBar_ScrollRightButton.BorderSizePixel = 0
TabBar_ScrollRightButton.Position = UDim2.new(0.84799999, 0, 0.24300018, 0)
TabBar_ScrollRightButton.Size = UDim2.new(0.0469999984, 0, 0.775503695, 0)
TabBar_ScrollRightButton.Font = Enum.Font.SourceSans
TabBar_ScrollRightButton.Text = ">"
TabBar_ScrollRightButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TabBar_ScrollRightButton.TextSize = 14.000

TabBar_Exit.Name = "TabBar_Exit"
TabBar_Exit.Parent = TabBar
TabBar_Exit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabBar_Exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBar_Exit.BorderSizePixel = 0
TabBar_Exit.Position = UDim2.new(0.951490402, 0, 0.24300018, 0)
TabBar_Exit.Size = UDim2.new(0.0485098734, 0, 0.748455703, 0)
TabBar_Exit.Font = Enum.Font.SourceSans
TabBar_Exit.Text = "x"
TabBar_Exit.TextColor3 = Color3.fromRGB(0, 0, 0)
TabBar_Exit.TextSize = 14.000

TabBar_Minimize.Name = "TabBar_Minimize"
TabBar_Minimize.Parent = TabBar
TabBar_Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabBar_Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabBar_Minimize.BorderSizePixel = 0
TabBar_Minimize.Position = UDim2.new(0.904999971, 0, 0.24300018, 0)
TabBar_Minimize.Size = UDim2.new(0.0485098734, 0, 0.748455703, 0)
TabBar_Minimize.Font = Enum.Font.SourceSans
TabBar_Minimize.Text = "-"
TabBar_Minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
TabBar_Minimize.TextSize = 14.000

DraggableFrame.Name = "DraggableFrame"
DraggableFrame.Parent = MainFrame
DraggableFrame.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
DraggableFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
DraggableFrame.BorderSizePixel = 0
DraggableFrame.Position = UDim2.new(5.21438835e-07, 0, 0, 0)
DraggableFrame.Size = UDim2.new(1.00000048, 0, 0.0243000202, 0)

-- Logic for making the Gui draggable
local dragging
local dragInput
local dragStart
local startPos

local function DragUpdate(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

DraggableFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

DraggableFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        DragUpdate(input)
    end
end)

-- Config --

local configfoldername = "ChillingGAG"
local json

--if isfolder and makefolder then
--    if not isfolder(configfoldername) then
--        print("Created New Folder")
--        makefolder(configfoldername)
--    end
--end
--
--if writefile then
--    json = HttpService:JSONEncode(configs)
--    writefile(configfoldername .. "/" .. "autosave.txt", json)
--end

--local function SaveConfig(filename)
--    if writefile then
--        json = HttpService:JSONEncode(configs)
--        print(json)
--        writefile(configfoldername .. "/" .. filename .. ".txt", json)
--    end
--end

local function SaveConfig()
    return nil
end
--
--local function LoadConfig(filename)
--    if readfile and isfile and isfile(configfoldername .. "/" .. filename .. ".txt") then
--        configs = HttpService:JSONDecode(readfile(configfoldername .. "/" .. filename .. ".txt"))
--    end
--end

local function LoadConfig()
    return nil
end
--
--local function GetConfigsArrayFromFolder()
--    local ConfigsArray = {}
--    for i, v in pairs(listfiles(configfoldername)) do
--        local name = v:split("/")[2]:split(".")[1]
--        table.insert(ConfigsArray, name)
--    end
--    return ConfigsArray
--end

local function GetConfigsArrayFromFolder()
    return nil
end

TabBar_Exit.MouseButton1Down:Connect(function()
    CloseScript()
end)

TabBar_Minimize.MouseButton1Down:Connect(function()
    ScreenGui.Enabled = false
end)

local function RemoveCoroutine(Coroutine)
    for i, v in pairs(CoroutineArray) do
        if v == Coroutine then
            table.remove(CoroutineArray, i)
            coroutine.close(Coroutine)
        end
    end
end

local function SetDefaultPage(Page)
    ActivePage = Page
    ActivePage.Visible = true
end

local function UpdateTabBarScrollingFrame()
    TabBarScrollingFrame.CanvasSize = UDim2.new(0, 100 * PageCount, 0, 0)
end

local function UpdatePageScrollingFrame(Page)
    Page.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 200 + math.max(Page:GetAttribute("LeftCount"), Page:GetAttribute("RightCount")) * 40)
end

-- Creates a new Frame Instance meant to hold a button, dropdown, or other interactive features
local function CreateFeatureHolder(InstanceName, InstanceParent, PositionCount)
    local NewHolder = Instance.new("Frame")
    NewHolder.Name = InstanceName
    NewHolder.Parent = InstanceParent
    NewHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NewHolder.BackgroundTransparency = 1.000
    NewHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NewHolder.BorderSizePixel = 0
    NewHolder.Size = UDim2.new(1, 0, 0, 40)
    NewHolder.ZIndex = 9999 - PositionCount
    NewHolder.Position = UDim2.new(0, 0, 0, 40 * PositionCount) -- Position Properly
    return NewHolder
end

local function CreateNewFrame(InstanceName, InstanceParent, InstanceTransparency, InstancePosition, InstanceSize)
    local NewFrame = Instance.new("Frame")
    NewFrame.Name = InstanceName
    NewFrame.Parent = InstanceParent
    NewFrame.BackgroundColor3 = FrameColor
    NewFrame.BackgroundTransparency = InstanceTransparency
    NewFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NewFrame.BorderSizePixel = 0
    NewFrame.Position = InstancePosition
    NewFrame.Size = InstanceSize
    return NewFrame
end

local function CreateNewTextLabel(InstanceName, InstanceParent, InstancePosition, InstanceSize, InstanceText, InstanceZIndex)
    local NewTextLabel = Instance.new("TextLabel")
    NewTextLabel.Name = InstanceName
    NewTextLabel.Parent = InstanceParent
    NewTextLabel.BackgroundColor3 = Color3.fromRGB(236, 236, 236)
    NewTextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NewTextLabel.BorderSizePixel = 0
    NewTextLabel.Position = InstancePosition
    NewTextLabel.Size = InstanceSize
    NewTextLabel.Font = Enum.Font.SourceSans
    NewTextLabel.Text = InstanceText
    NewTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    NewTextLabel.TextScaled = true
    NewTextLabel.TextSize = 14.000
    NewTextLabel.TextWrapped = true
    NewTextLabel.ZIndex = InstanceZIndex
    return NewTextLabel
end

local function CreateNewTextButton(InstanceName, InstanceParent, InstanceTransparency, InstancePosition, InstanceSize, InstanceText, InstanceZIndex)
    local NewTextButton = Instance.new("TextButton")
    NewTextButton.Name = InstanceName
    NewTextButton.Parent = InstanceParent
    NewTextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NewTextButton.BackgroundTransparency = InstanceTransparency
    NewTextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NewTextButton.BorderSizePixel = 0
    NewTextButton.Position = InstancePosition
    NewTextButton.Size = InstanceSize
    NewTextButton.Font = Enum.Font.SourceSans
    NewTextButton.Text = InstanceText
    NewTextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    NewTextButton.TextScaled = true
    NewTextButton.TextSize = 14.000
    NewTextButton.TextWrapped = true
    NewTextButton.ZIndex = InstanceZIndex
    return NewTextButton
end

local function CreateNewTextBox(InstanceName, InstanceParent, InstanceTransparency, InstancePosition, InstanceSize, InstancePlaceholderText, InstanceText, InstanceZIndex)
    local NewTextBox = Instance.new("TextBox")
    NewTextBox.Name = InstanceName
    NewTextBox.Parent = InstanceParent
    NewTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NewTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NewTextBox.BorderSizePixel = 0
    NewTextBox.BackgroundTransparency = InstanceTransparency
    NewTextBox.Position = InstancePosition
    NewTextBox.Size = InstanceSize
    NewTextBox.Font = Enum.Font.SourceSans
    NewTextBox.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
    NewTextBox.PlaceholderText = InstancePlaceholderText
    NewTextBox.Text = InstanceText
    NewTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    NewTextBox.TextSize = 14.000
    NewTextBox.ZIndex = InstanceZIndex
    return NewTextBox
end

local function CreateNewScrollingFrame(InstanceName, InstanceParent, InstanceAutomaticSize, InstanceScrollingDirection)
    local NewScrollingFrame = Instance.new("ScrollingFrame")
    NewScrollingFrame.Parent = InstanceParent
    NewScrollingFrame.Active = false
    NewScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NewScrollingFrame.BackgroundTransparency = 1.000
    NewScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NewScrollingFrame.BorderSizePixel = 0
    NewScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    NewScrollingFrame.ScrollBarThickness = 10
    NewScrollingFrame.Selectable = false
    NewScrollingFrame.AutomaticSize = InstanceAutomaticSize
    NewScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    NewScrollingFrame.ScrollingDirection = InstanceScrollingDirection
    NewScrollingFrame.ClipsDescendants = true
    return NewScrollingFrame
end

-- Function for adding a Page to the GUI, also adds a Tab for the Page
local function AddGuiPage(PageName)
    PageCount = PageCount + 1

    -- Add Tab Button To Top Scrolling Bar
    local TabBarButton = CreateNewTextButton("TabBarButton" .. tostring(PageCount), TabBarScrollingFrame, 0.4, UDim2.new(0, 0, 0, 0), UDim2.new(0, 100, 1, 0), PageName, 1)

    -- Add Page
    local Page = CreateNewFrame("Page" .. tostring(PageCount), MainFrame, 0.6, UDim2.new(0, 0, 0.1, 0), UDim2.new(1, 0, 0.9, 0))
    Page.Visible = false
    Page:SetAttribute("PageNumber", PageCount)
    Page:SetAttribute("LeftCount", 0)
    Page:SetAttribute("RightCount", 0)

    TabBarButton.MouseButton1Down:Connect(function()
        if ActivePage then
            ActivePage.Visible = false
        end
        ActivePage = Page
        ActivePage.Visible = true
    end)

    -- Add Scrolling Frame For Page
    local ScrollingFrame = CreateNewScrollingFrame("ScrollingFrame", Page, Enum.AutomaticSize.None, Enum.ScrollingDirection.Y)

    -- Add Left Options Frame
    local LeftOptions = CreateNewFrame("LeftOptions", ScrollingFrame, 1, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 1, 0))

    -- Add Right Options Frame
    local RightOptions = CreateNewFrame("RightOptions", ScrollingFrame, 1, UDim2.new(0.5, 0, 0, 0), UDim2.new(0.5, 0, 1, 0))

    return Page
end

-- Function For Adding A Toggle to the Leftside of the Page
local function AddPageLeftOptionToggle(Page, ToggleName, Function, ConfigKeyValue, RequiresCoroutine)
    local LeftOptionCount = tonumber(Page:GetAttribute("LeftCount"))
    
    -- Frame to Hold Contents
    local ToggleHolder = CreateFeatureHolder("ToggleHolder", Page.ScrollingFrame.LeftOptions, LeftOptionCount)

    -- Toggle Button
    local TextButton = CreateNewTextButton("TextButton", ToggleHolder, 0, UDim2.new(0.05, 0, 0.1, 0), UDim2.new(0.8, 0, 0.75, 0), ToggleName, 1)

    -- Red/Green Toggle Indicator
    local Frame = CreateNewFrame("Frame", ToggleHolder, 0, UDim2.new(0.88, 0, 0.26, 0), UDim2.new(0.05, 0, 0.4, 0))

    -- Button UI Corner
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TextButton

    UICorner = Instance.new("UICorner")
    UICorner.Parent = Frame

    -- Increment Page Left Options Count Attribute by 1
    Page:SetAttribute("LeftCount", tonumber(Page:GetAttribute("LeftCount")) + 1)

    if RequiresCoroutine then
        local NewCoroutine = nil
        TextButton.MouseButton1Down:Connect(function()
            if NewCoroutine then
                Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                configs[ConfigKeyValue] = false

                RemoveCoroutine(NewCoroutine)
                NewCoroutine = nil
            else
                Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                configs[ConfigKeyValue] = true

                NewCoroutine = coroutine.create(Function)
                local success = coroutine.resume(NewCoroutine)
                if success then
                    table.insert(CoroutineArray, NewCoroutine)
                end
            end
        end)
    else
        TextButton.MouseButton1Down:Connect(function()
            if configs[ConfigKeyValue] then
                Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                configs[ConfigKeyValue] = false

                Function()
            else
                Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                configs[ConfigKeyValue] = true

                Function()
            end
        end)
    end

    return ToggleHolder
end

-- Function For Adding A Dropdown to the Rightside of the Page
local function AddPageRightOptionDropdown(Page, DropdownName, DropdownArray, ConfigArray, TextColor)
    local RightOptionCount = tonumber(Page:GetAttribute("RightCount"))
    -- ButtonHolder stores a reference to all of the buttons added in this dropdown
    local ButtonHolder = {}
    local TempCount = 0

    local DropdownHolder = CreateFeatureHolder("DropdownHolder", Page.ScrollingFrame.RightOptions, RightOptionCount)

    local TextButton = CreateNewTextButton("TextButton", DropdownHolder, 0, UDim2.new(0.05, 0, 0.1, 0), UDim2.new(0.9, 0, 0.75, 0), "\\/ " .. DropdownName .. " \\/", 2)

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TextButton

    local DropdownFrame = CreateNewFrame("DropdownFrame", DropdownHolder, 0, UDim2.new(0.05, 0, 0.85, 0), UDim2.new(0.9, 0, 5, 0))
    DropdownFrame.Visible = false

    UICorner = Instance.new("UICorner")
    UICorner.Parent = DropdownFrame

    local ScrollingFrame = CreateNewScrollingFrame("ScrollingFrame", DropdownFrame, Enum.AutomaticSize.None, Enum.ScrollingDirection.Y)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ScrollingFrame
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TextButton.MouseButton1Down:Connect(function()
        if ActiveDropDown == DropdownFrame then
            ActiveDropDown.Visible = false
            ActiveDropDown = nil
        else
            if ActiveDropDown then
                ActiveDropDown.Visible = false
            end
            ActiveDropDown = DropdownFrame
            ActiveDropDown.Visible = true
        end
    end)

    -- Increment Page Right Options Count Attribute by 1
    Page:SetAttribute("RightCount", tonumber(Page:GetAttribute("RightCount")) + 1)

    -- Adding A Select/Deselect All Button First, only for larger arrays
    if #DropdownArray > 5 then
        
        local SelectAllButton = CreateNewTextButton("TextButton", ScrollingFrame, 0.5, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), "Select/Deselect All", 2)

        UICorner = Instance.new("UICorner")
        UICorner.Parent = SelectAllButton

        SelectAllButton.MouseButton1Down:Connect(function()
            local Deselect = false
            for _, Button in pairs(ButtonHolder) do
                if ConfigArray[tostring(Button.Text)] then
                    Deselect = true
                end
            end

            if Deselect then
                for _, Button in pairs(ButtonHolder) do
                    ConfigArray[tostring(Button.Text)] = false
                    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
                end
                return
            end
            for _, Button in pairs(ButtonHolder) do
                ConfigArray[tostring(Button.Text)] = true
                Button.TextColor3 = TextColor
            end
            return
        end)

        TempCount = TempCount + 1
    end

    -- Add Options Inside Dropdown
    for i, v in pairs(DropdownArray) do
        local NewButton = CreateNewTextButton("TextButton", ScrollingFrame, 0.5, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), tostring(v), 2)
        
        UICorner = Instance.new("UICorner")
        UICorner.Parent = NewButton

        NewButton.MouseButton1Down:Connect(function()
            local ButtonName = tostring(NewButton.Text)
            if ConfigArray[ButtonName] then
                ConfigArray[ButtonName] = false
                NewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            else
                ConfigArray[ButtonName] = true
                NewButton.TextColor3 = TextColor
            end
        end)

        table.insert(ButtonHolder, NewButton)

        TempCount = TempCount + 1
    end

    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, TempCount * 30)

    return DropdownHolder
end

-- Function For Adding A Dropdown With TextBoxes to the Rightside of the Page
local function AddPageRightOptionDropdownTextbox(Page, DropdownName, DropdownArray, ConfigKey)
    local RightOptionCount = tonumber(Page:GetAttribute("RightCount"))
    -- ButtonHolder stores a reference to all of the buttons added in this dropdown
    local BoxHolder = {}
    local TempCount = 0

    local DropdownHolder = CreateFeatureHolder("DropdownHolder", Page.ScrollingFrame.RightOptions, RightOptionCount)

    local TextButton = CreateNewTextButton("TextButton", DropdownHolder, 0, UDim2.new(0.05, 0, 0.1, 0), UDim2.new(0.9, 0, 0.75, 0), "\\/ " .. DropdownName .. " \\/", 2)

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TextButton

    local DropdownFrame = CreateNewFrame("DropdownFrame", DropdownHolder, 0, UDim2.new(0.05, 0, 0.85, 0), UDim2.new(0.9, 0, 5, 0))
    DropdownFrame.Visible = false

    UICorner = Instance.new("UICorner")
    UICorner.Parent = DropdownFrame

    local ScrollingFrame = CreateNewScrollingFrame("ScrollingFrame", DropdownFrame, Enum.AutomaticSize.None, Enum.ScrollingDirection.Y)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ScrollingFrame
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TextButton.MouseButton1Down:Connect(function()
        if ActiveDropDown == DropdownFrame then
            ActiveDropDown.Visible = false
            ActiveDropDown = nil
        else
            if ActiveDropDown then
                ActiveDropDown.Visible = false
            end
            ActiveDropDown = DropdownFrame
            ActiveDropDown.Visible = true
        end
    end)

    -- Increment Page Right Options Count Attribute by 1
    Page:SetAttribute("RightCount", tonumber(Page:GetAttribute("RightCount")) + 1)

    -- Adding A Set All Button First, only for larger arrays
    if #DropdownArray > 5 then
        local NewHolder = CreateNewFrame("Frame", ScrollingFrame, 1, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30))
        NewHolder.ZIndex = 2

        local SetAllButton = CreateNewTextButton("TextButton", NewHolder, 0, UDim2.new(0, 0, 0, 0), UDim2.new(0.6, 0, 1, 0), "Set All", 2)

        UICorner = Instance.new("UICorner")
        UICorner.Parent = SetAllButton

        local TextBox = CreateNewTextBox("TextBox", NewHolder, 0, UDim2.new(0.6, 0, 0, 0), UDim2.new(0.4, 0, 1, 0), tostring(DefaultPlantCount), "", 3)

        TextBox:GetPropertyChangedSignal("Text"):Connect(function()
            local NewText = TextBox.Text
            -- Remove any non-digit characters
            local NumericText = NewText:gsub("%D", "")
            if NewText ~= NumericText then
                TextBox.Text = NumericText
            end
        end)

        SetAllButton.MouseButton1Down:Connect(function()
            for i, v in pairs(BoxHolder) do
                if TextBox.Text ~= "" then
                    v.TextBox.Text = TextBox.Text
                else
                    v.TextBox.Text = TextBox.PlaceholderText
                end
            end
        end)

        UICorner = Instance.new("UICorner")
        UICorner.Parent = TextBox

        TempCount = TempCount + 1
    end

    -- Add Options Inside Dropdown
    for i, v in pairs(DropdownArray) do
        local NewHolder = CreateNewFrame("Frame", ScrollingFrame, 1, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30))
        NewHolder.ZIndex = 2

        local NewTextLabel = CreateNewTextLabel("TextLabel", NewHolder, UDim2.new(0, 0, 0, 0), UDim2.new(0.6, 0, 1, 0), tostring(v), 3)

        local TextBox = CreateNewTextBox("TextBox", NewHolder, 0, UDim2.new(0.6, 0, 0, 0), UDim2.new(0.4, 0, 1, 0), tostring(DefaultPlantCount), "", 3)

        configs[ConfigKey][tostring(v)] = DefaultPlantCount

        TextBox:GetPropertyChangedSignal("Text"):Connect(function()
            local NewText = TextBox.Text
            -- Remove any non-digit characters
            local NumericText = NewText:gsub("%D", "")
            if NewText ~= NumericText then
                TextBox.Text = NumericText
            end

            configs[ConfigKey][tostring(v)] = tonumber(TextBox.Text)
        end)

        UICorner = Instance.new("UICorner")
        UICorner.Parent = TextBox

        table.insert(BoxHolder, NewHolder)

        TempCount = TempCount + 1
    end

    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, TempCount * 30)

    return DropdownHolder
end

-- Function For Adding A Textbox to the Rightside of the Page
local function AddPageRightOptionTextbox(Page, NewPlaceholderText, ConfigKey)
    local RightOptionCount = tonumber(Page:GetAttribute("RightCount"))

    local DropdownHolder = CreateFeatureHolder("DropdownHolder", Page.ScrollingFrame.RightOptions, RightOptionCount)

    local TextBox = CreateNewTextBox("TextBox", DropdownHolder, 0, UDim2.new(0.05, 0, 0, 0), UDim2.new(.9, 0, 0.75, 0), tostring(NewPlaceholderText), "", 2)

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TextBox

    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local NewText = TextBox.Text
        -- Remove any non-digit characters
        local NumericText = NewText:gsub("%D", "")
        if NewText ~= NumericText then
            TextBox.Text = NumericText
        end

        configs[ConfigKey] = tonumber(TextBox.Text)
    end)

    -- Increment Page Right Options Count Attribute by 1
    Page:SetAttribute("RightCount", tonumber(Page:GetAttribute("RightCount")) + 1)

    return DropdownHolder
end

local function AddPageRightEmpty(Page)
    -- Increment Page Right Options Count Attribute by 1
    Page:SetAttribute("RightCount", tonumber(Page:GetAttribute("RightCount")) + 1)
end

local function AddPageLeftEmpty(Page)
    -- Increment Page Right Options Count Attribute by 1
    Page:SetAttribute("LeftCount", tonumber(Page:GetAttribute("LeftCount")) + 1)
end

--local function UpdateConfigDropdown()
--    -- Remove Options
--    for i, v in pairs(ConfigScrollingFrame:GetChildren()) do
--        if v.ClassName ~= "UIListLayout" then
--            v:Destroy()
--        end
--    end
--
--    local TempCount = 0
--    -- Add Options Inside Dropdown
--    for i, v in pairs(GetConfigsArrayFromFolder()) do
--        local NewButton = CreateNewTextButton("TextButton", ConfigScrollingFrame, 0.5, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), tostring(v), 2)
--        
--        local UICorner = Instance.new("UICorner")
--        UICorner.Parent = NewButton
--
--        NewButton.MouseButton1Down:Connect(function()
--            local ButtonName = tostring(NewButton.Text)
--            ConfigScrollingFrame.Parent.Parent.TextButton.Text = ButtonName
--            SelectedConfig = ButtonName
--        end)
--
--        TempCount = TempCount + 1
--    end
--end

local function UpdateConfigDropdown()
    return nil
end

local function SetupConfigPage(Page)
    -- Save Config TextBox
    local TextBoxHolder = CreateFeatureHolder("HoldingFrame", Page.ScrollingFrame.RightOptions, 0)

    local TextBox = CreateNewTextBox("TextBox", TextBoxHolder, 0, UDim2.new(0.05, 0, 0, 0), UDim2.new(0.9, 0, 0.75, 0), "Config Name", "", 2)

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TextBox

    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local NewText = TextBox.Text
        -- Remove any non-digit characters
        local NumericText = NewText:gsub("%A", "")
        if NewText ~= NumericText then
            TextBox.Text = NumericText
        end
    end)

    local SaveConfigButtonHolder = CreateFeatureHolder("SaveConfigButtonHolder", Page.ScrollingFrame.LeftOptions, 0)

    -- Save Config Button
    local SaveConfigButton = CreateNewTextButton("TextButton", SaveConfigButtonHolder, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.75, 0), "Save Config", 1)

    -- Button UI Corner
    UICorner = Instance.new("UICorner")
    UICorner.Parent = SaveConfigButton

    SaveConfigButton.MouseButton1Down:Connect(function()
        if TextBox.Text ~= "" then
            SaveConfig(TextBox.Text)
        end
    end)

    local LoadConfigButtonHolder = CreateFeatureHolder("SaveConfigButtonHolder", Page.ScrollingFrame.LeftOptions, 1)

    -- Load Config Button
    local LoadConfigButton = CreateNewTextButton("TextButton", LoadConfigButtonHolder, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.75, 0), "Load Config", 1)

    -- Button UI Corner
    UICorner = Instance.new("UICorner")
    UICorner.Parent = LoadConfigButton

    LoadConfigButton.MouseButton1Down:Connect(function()
        LoadConfig(SelectedConfig)
    end)

    -- Selected Config Label
    local AutoExecuteConfigTextLabelHolder = CreateFeatureHolder("DropdownHolder", Page.ScrollingFrame.RightOptions, 2)

    local AutoExecuteConfigTextLabel = CreateNewTextLabel("TextLabel", AutoExecuteConfigTextLabelHolder, UDim2.new(0.05, 0, 0, 0), UDim2.new(0.9, 0, 0.75, 0), tostring(SelectedConfig), 2)

    -- Set Auto Execute Config
    local SetAutoExecuteHolder = CreateFeatureHolder("SaveConfigButtonHolder", Page.ScrollingFrame.LeftOptions, 2)

    local SetAutoExecuteButton = CreateNewTextButton("TextButton", SetAutoExecuteHolder, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.75, 0), "Set as Auto Execute", 1)

    -- Button UI Corner
    UICorner = Instance.new("UICorner")
    UICorner.Parent = SetAutoExecuteButton

    SetAutoExecuteButton.MouseButton1Down:Connect(function()
        AutoExecuteConfigTextLabel.Text = tostring(SelectedConfig)
    end)

    -- Select Config Dropdown
    local DropdownHolder = CreateFeatureHolder("DropdownHolder", Page.ScrollingFrame.RightOptions, 1)

    local TextButton = CreateNewTextButton("TextButton", DropdownHolder, 0, UDim2.new(0.05, 0, 0, 0), UDim2.new(.9, 0, 0.75, 0), "\\/ Select Config \\/", 1)

    UICorner = Instance.new("UICorner")
    UICorner.Parent = TextButton

    local DropdownFrame = CreateNewFrame("DropdownFrame", DropdownHolder, 0, UDim2.new(0.05, 0, 0.85, 0), UDim2.new(0.9, 0, 5, 0))
    DropdownFrame.Visible = false

    UICorner = Instance.new("UICorner")
    UICorner.Parent = DropdownFrame

    ConfigScrollingFrame = CreateNewScrollingFrame("ScrollingFrame", DropdownFrame, Enum.AutomaticSize.None, Enum.ScrollingDirection.Y)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ConfigScrollingFrame
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TextButton.MouseButton1Down:Connect(function()
        if ActiveDropDown == DropdownFrame then
            ActiveDropDown.Visible = false
            ActiveDropDown = nil
        else
            if ActiveDropDown then
                ActiveDropDown.Visible = false
            end
            ActiveDropDown = DropdownFrame
            ActiveDropDown.Visible = true
            --UpdateConfigDropdown()
        end
    end)

    -- Delete Config Button
    local DeleteConfigButtonHolder = CreateFeatureHolder("SaveConfigButtonHolder", Page.ScrollingFrame.LeftOptions, 3)

    local DeleteConfigButton = CreateNewTextButton("TextButton", DeleteConfigButtonHolder, 0, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.75, 0), "Delete Config", 1)

    -- Button UI Corner
    UICorner = Instance.new("UICorner")
    UICorner.Parent = DeleteConfigButton

   --DeleteConfigButton.MouseButton1Down:Connect(function()
   --    
   --end)
end

-- AutoBuy Features --

-- Function For Automatically Purchasing Seeds from the Seed Shop
-- Only Buys Selected Seeds
local AutoBuySeedShopFunction = function()
    local WaitTime = 0.001
    while task.wait(WaitTime) do
        if not configs.AutoBuySeedShop then return end

        for _, object in pairs(SeedShopScrollingFrame:GetChildren()) do
            if object:FindFirstChild("Main_Frame") then
                local SeedName = object.Name

                if not configs.SeedShopFilter[SeedName] then
                    continue
                end

                local InStock = (object.Main_Frame.Cost_Text.Text ~= "NO STOCK")
                if InStock then
                    local SeedStock = object.Main_Frame.Stock_Text.Text:match("%d+")
                    print("Purchasing " .. tostring(SeedStock) .. " of " .. SeedName)
                    for i = 1, SeedStock do
                        task.wait()
                        BuySeedStock:FireServer(SeedName)
                    end
                end
            end
            task.wait()
        end
        WaitTime = configs.WaitTime
    end
end

-- Function For Automatically Purchasing Gear from the Gear Shop
-- Only Buys Selected Gear
local AutoBuyGearShopFunction = function()
    local WaitTime = 0.001
    while task.wait(WaitTime) do
        if not configs.AutoBuyGearShop then return end

        for _, object in pairs(GearShopScrollingFrame:GetChildren()) do
            if object:FindFirstChild("Main_Frame") then
                local GearName = object.Name

                if not configs.GearShopFilter[GearName] then
                    continue
                end

                local InStock = (object.Main_Frame.Cost_Text.Text ~= "NO STOCK")
                if InStock then
                    local GearStock = object.Main_Frame.Stock_Text.Text:match("%d+")
                    print("Purchasing " .. tostring(GearStock) .. " of " .. GearName)
                    for i = 1, GearStock do
                        BuyGearStock:FireServer(GearName)
                        task.wait()
                    end
                end
            end
            task.wait()
        end
        WaitTime = configs.WaitTime
    end
end

-- Table Utilities --

local function PrintArray(array)
    local _string = ""
    for i, v in pairs(array) do
        _string = _string .. v .. ", "
    end
    print(string.sub(_string, 0, -3))
end

local function ArrayToString(array)
    local _string = ""
    for i, v in pairs(array) do
        _string = _string .. v .. ", "
    end
    return string.sub(_string, 0, -3)
end

-- Adds possible duplicate keys to table by incrementing key by 1
-- until the table slot is nil
local function AddToTable_PossibleDuplicate(Table, key, object)
    local PriceOffset = 0
    while Table[object.Price + PriceOffset] do
        PriceOffset = PriceOffset + 1
    end
    Table[object.Price + PriceOffset] = tostring(key)
end

-- Given an array with unordered integer keys, sorts keys and then sorts array
local function SortArray(Array)
    local SortedArray = {}
    local SortedKeys = {}
    for key in pairs(Array) do
        table.insert(SortedKeys, key)
    end

    table.sort(SortedKeys)

    for _, key in ipairs(SortedKeys) do
        table.insert(SortedArray, Array[key])
    end
    return SortedArray
end

-- Features --

-- Function For Automatically Purchasing Gear from the Gear Shop
-- Only Buys Selected Gear
local AutoBuyEggShopFunction = function()
    local WaitTime = 0.001
    while task.wait(WaitTime) do
        if not configs.AutoBuyEggShop then return end

        for _, object in pairs(PetShopScrollingFrame:GetChildren()) do
            if object:FindFirstChild("Main_Frame") then
                local EggName = object.Name

                if not configs.EggShopFilter[EggName] then
                    continue
                end

                local InStock = (object.Main_Frame.Cost_Text.TEXT.Text ~= "NO STOCK")
                if InStock then
                    local EggStock = object.Main_Frame.Stock_Text.Text:match("%d+")
                    print("Purchasing " .. tostring(EggStock) .. " of " .. EggName)
                    for i = 1, EggStock do
                        BuyPetEgg:FireServer(EggName)
                        task.wait()
                    end
                end
            end
            task.wait()
        end
        WaitTime = configs.WaitTime
    end
end

-- Function for properly collecting crates and other cosmetic items
-- since they require different remote events
local function PurchaseCosmetic(ItemName)
    if ItemName:find("Crate") then
        print("Crate")
        BuyCosmeticCrate:FireServer(ItemName)
        return
    end
    print("Other Item")
    BuyCosmeticItem:FireServer(ItemName)
    return
end

-- Function that loops the 2 cosmetic shop layers
-- Checks stock and purchases if in stock and selected
local function LoopCosmeticLayer(Layer)
    for _, object in pairs(Layer:GetChildren()) do
        if object:FindFirstChild("Main") then
            local ItemName = object.Name
            if not configs.CosmeticShopFilter[ItemName] then
                continue
            end
            local InStock = (object.Main.Stock.STOCK_TEXT.Text ~= "X0 Stock")
            if InStock then
                local ItemStock = object.Main.Stock.STOCK_TEXT.Text:match("%d+")
                print("Purchasing " .. tostring(ItemStock) .. " of " .. ItemName)
                for i = 1, ItemStock do
                    wait(0.1)
                    PurchaseCosmetic(ItemName)
                end
            end
        end
        wait(0.1)
    end
end

-- Function that loops the cosmetics auto buy
local AutoBuyCosmeticsFunction = function()
    local WaitTime = 0.001
    while wait(WaitTime) do
        if not configs.AutoBuyCosmeticShop then return end

        LoopCosmeticLayer(CosmeticShopTopSegment)
        LoopCosmeticLayer(CosmeticShopBottomSegment)

        WaitTime = configs.WaitTime
    end
end

-- Farm Features

-- Parameters:
--      fruit: A fruit object
-- Returns:
--      ProximityPrompt object or nil
-- Description:
--      Loops through Descendants of given fruit object and returns the ProximityPrompt object

local function GetFruitProximityPrompt(fruit)
	for _, object in pairs(fruit:GetDescendants()) do
		if object.ClassName == "ProximityPrompt" then
			return object
		end
	end
	return nil
end

-- Parameters:
--      InputString: a raw mutations string
-- Returns:
--      Formatted mutations string and mutations array
-- Description:
--      Uses regex to target patterns that, start with a capital, contain only letters, and
--      have more than one lowercase trailing character

local function ParseMutations(InputString)
	local mutationsString = ""
	local mutationsArray = {}
	for word in string.gmatch(InputString, "%f[%a]%u%l+") do
		table.insert(mutationsArray, word)
		mutationsString = mutationsString .. " " .. word
	end

	return mutationsString, mutationsArray
end

-- Parameters:
--      object: any object
-- Returns:
--      N/A
-- Description:
--      Destroys all child ParticleEmitters and other effects

local function DestroyEmitters(object)
    for _, child in pairs(object:GetChildren()) do
		if child.ClassName == "ParticleEmitter" then
			child:Destroy()
		end
		if child.Name == "FrozenShell" then
			child:Destroy()
		end
	end
end

-- Parameters:
--      object: any object
-- Returns:
--      N/A
-- Description:
--      Disables effects without actually destroying them from the workspace

local function DisableEffects(object)
	for _, child in pairs(object:GetChildren()) do
		if child.ClassName == "ParticleEmitter" then
			child.Enabled = false
		end
		if child.Name == "FrozenShell" then
			child.Transparency = 1
		end
	end
end

-- Parameters:
--      object: any object
-- Returns:
--      N/A
-- Description:
--      Restores disabled effects

local function EnableEffects(object)
	for _, child in pairs(object:GetChildren()) do
		if child.ClassName == "ParticleEmitter" then
			child.Enabled = true
		end
		if child.Name == "FrozenShell" then
			child.Transparency = 0.5
		end
	end
end

-- Parameters:
--      string: any string
-- Returns:
--      true if the string matches a mutation
--      false is not
-- Description:
--      Checks the given string against all mutation names

local function CheckIfMutation(mutation)
    for i, v in pairs(MutationsArray) do
        if v == mutation then
            return true
        end
    end
    return false
end

-- Parameters:
--      object: fruit object
-- Returns:
--      Table containing all the mutations on the fruit
-- Description:
--      Loops through object's attributes and looks for matching
--      mutation names, to yield all mutations on object

local function GetFruitMutations(fruit)
    local mutationsOnFruitArray = {}
    for key, value in pairs(fruit:GetAttributes()) do
        if CheckIfMutation(key) then
            table.insert(mutationsOnFruitArray, key)
        end
    end
    return mutationsOnFruitArray
end

-- Parameters:
--      object: fruit object
-- Returns:
--      The fruits variant string value
--      nil if no variant value found
-- Description:
--      Returns a fruits variant string value

local function GetFruitVariant(fruit)
    if fruit:FindFirstChild("Variant") then
        return fruit.Variant.Value
    end
    return nil
end

-- Parameters:
--      object: fruit object
-- Returns:
--      The fruits weight number value
--      nil if no weight value found
-- Description:
--      Returns a fruits weight number value

local function GetFruitWeight(fruit)
    if fruit:FindFirstChild("Weight") then
        return fruit.Weight.Value
    end
    return nil
end

-- Parameters:
--      object: fruit object
-- Returns:
--      true if the fruit is collected
--      false otherwise
-- Description:
--      Checks the fruit for selected/blocked plant types, fruit mutations, fruit variant, fruit weight
--      Collects fruit only if all checks pass

local function CollectFruit(fruit)
    local FruitName = fruit.Name
    local FruitMutationsArray = GetFruitMutations(fruit)
    local FruitVariant = GetFruitVariant(fruit)
    local FruitWeight = GetFruitWeight(fruit)

    print()
    print("Collecting Fruit")
    Print("Name: ", FruitName)
    Print("Variant: ", FruitVariant)
    Print("Weight: ", FruitWeight)
    Print("Mutations: ", ArrayToString(FruitMutationsArray))
    print()

    -- Check Blocked Plants
    if configs.AutoCollectBlockedPlants[FruitName] then
        print("Skipping blocked plant type " .. tostring(FruitName))
        return false
    end

    -- Check Blocked Variants
    if configs.AutoCollectBlockedVariants[FruitVariant] then
        print("Skipping blocked variant " .. tostring(FruitVariant))
        return false
    end

    -- Check Minimum Weight
    if FruitWeight < configs.AutoCollectMinimumWeight then
        print("Skipping, not enough fruit weight " .. tostring(FruitWeight))
        return false
    end

    -- Check Mutations
    for i, mutation in pairs(FruitMutationsArray) do
        if configs.AutoCollectBlockedMutations[mutation] then
            print("Skipping blocked mutation " .. tostring(mutation))
            return false
        end
    end

    -- Collect after all checks passed
    print("Collecting")
    return true
end

-- Parameters: 
--      N/A
-- Returns:
--      N/A
-- Description:
--      Loops through plants and fruits and collects non-blocked plants, non-blocked mutations, and non-blocked variants

local AutoCollectFruitsFunction = function()
	local ImportantFolder = FarmFolder:FindFirstChild("Important")
    local PlantsPhysicalFolder = ImportantFolder:FindFirstChild("Plants_Physical")
    
    for i, plant in pairs(PlantsPhysicalFolder:GetChildren()) do
        print(plant.Name)

        if configs.AutoCollectBlockedPlants[plant.Name] then
            print("Skipping blocked plant")
            continue
        end
        
        if plant:FindFirstChild("Fruits") then
            for j, fruit in pairs(plant.Fruits:GetChildren()) do
                CollectFruit(fruit)
                wait(0.01)
            end
        else
            CollectFruit(plant)
        end
        wait(0.01)
    end
end

local function UnequipAllFromBackpack()
    local backpack = lp:FindFirstChild("Backpack")
    for i, v in pairs(lp.Character:GetChildren()) do
        if v.ClassName and v.ClassName == "Tool" then
            v.Parent = backpack
        end
    end
end

local function EquipFromBackpack(object)
    if not GetPlayer() then
        warn("EquipFromBackpack: Unable to get valid player")
        return
    end

    -- Clear tools from player
    UnequipAllFromBackpack()

    task.wait(0.01)
    object.Parent = lp.Character
end

local function FindSeedInBackpack(SeedName)
    if GetPlayer() and lp:FindFirstChild("Backpack") then
        for _, object in pairs(lp.Backpack:GetChildren()) do
            if object and object.Name ~= nil and string.find(object.Name, "Seed") and string.find(object.Name, SeedName) then
                return object
            end
        end
    end
    return nil
end

-- Gets the Center Position of the Farm
local function GetAutoPlantCenter()
    local ImportantFolder = FarmFolder:FindFirstChild("Important")
    local PlantLocations = ImportantFolder:FindFirstChild("Plant_Locations")
    local objects = PlantLocations:GetChildren()
    
    return Vector3.new(objects[1].CFrame.x, objects[1].CFrame.y, objects[1].CFrame.z)
end

local function PlantSeed(Seed, Location, Count)
    for i=1, Count do
        print("Planted " .. Seed)
        Plant_RE:FireServer(Location, Seed)
        wait(0.05)
    end
end

local function FindInArray(Table, Value)
    for i, v in pairs(Table) do
        if v == Value then
            return true
        end
    end
    return false
end

local function GetFarmPlantCount()
    local ImportantFolder = FarmFolder:FindFirstChild("Important")
    local PlantsPhysicalFolder = ImportantFolder:FindFirstChild("Plants_Physical")

    local CountTable = {}
    for i, v in pairs(PlantsPhysicalFolder:GetChildren()) do
        if FindInArray(SeedsArray, v.Name) then
            if not CountTable[tostring(v.Name)] then
                CountTable[tostring(v.Name)] = 0
            end
            CountTable[tostring(v.Name)] = CountTable[tostring(v.Name)] + 1
        end
    end
    return CountTable
end

local AutoPlantFunction = function()
    local WaitTime = 0.001
    while wait(WaitTime) do
        local PlantCount = GetFarmPlantCount()

        print("Start")
        for i, v in pairs(SeedsArray) do
            if PlantCount[tostring(v)] == nil or (PlantCount[tostring(v)] > configs.AutoPlantSeedLimits[tostring(v)]) then
                continue
            end
            if configs.AutoPlantAllowedSeeds[tostring(v)] == nil or not configs.AutoPlantAllowedSeeds[tostring(v)] then
                continue
            end
            local SeedInBackback = FindSeedInBackpack(v)
            if SeedInBackback then
                EquipFromBackpack(SeedInBackback)
                wait(0.1)
                print(v, PlantCount[tostring(v)], configs.AutoPlantSeedLimits[tostring(v)])
                PlantSeed(v, GetAutoPlantCenter(), configs.AutoPlantSeedLimits[tostring(v)] - PlantCount[tostring(v)])
            end
        end
        WaitTime = configs.WaitTime
    end
end

-- Visual Features --

-- Loop enables the HoneyUI's Visibility
local AlwaysShowHoney = function()
    local WaitTime = 0.001
    while task.wait(WaitTime) do
        HoneyUI.Visible = true
        WaitTime = configs.WaitTime
    end
end

-- Toggles the Gear TP UI
local ToggleGearTP = function()
    GearTPUI.Visible = configs.ToggleGearTP
end

-- Toggles the Pets TP UI
local TogglePetsTP = function()
    PetsTPUI.Visible = configs.TogglePetsTP
end

-- Get Array Functions --

-- Gets all seed/plant names and orders them by price
local function GetSeedsArray()
    SeedsArray = {}
    for i, v in pairs(SeedData) do
        if (type(v) == "table") then
            AddToTable_PossibleDuplicate(SeedsArray, i, v)
        end
    end
    SeedsArray = SortArray(SeedsArray)
    return SeedsArray
end

-- Gets the seeds in the seed shop from the GUI
-- returns a sorted array (by LayoutOrder) of seed names
local function GetSeedShopArray()
    local SeedShopArray = {}
    for _, object in pairs(SeedShopScrollingFrame:GetChildren()) do
        if object:FindFirstChild("Main_Frame") then
            SeedShopArray[tonumber(object.LayoutOrder)] = object.Name
        end
    end
    SeedShopArray = SortArray(SeedShopArray)
    return SeedShopArray
end

-- Retrieves the current gear shop items by looping through the GUI objects
-- Returns a sorted array (by LayoutOrder) of gear item names
local function GetGearShopArray()
    local GearShopArray = {}
    for _, object in pairs(GearShopScrollingFrame:GetChildren()) do
        if object:FindFirstChild("Main_Frame") then
            GearShopArray[tonumber(object.LayoutOrder)] = object.Name
        end
    end
    GearShopArray = SortArray(GearShopArray)
    return GearShopArray
end

-- Retrieves the possible egg shop items from PetEggData Module
-- Returns a sorted array (by Price) of egg names
local function GetEggsArray()
    local EggsInShopArray = {}
    for i, v in pairs(PetEggData) do
        EggsInShopArray[v.Price] = i
    end
    EggsInShopArray = SortArray(EggsInShopArray)
    return EggsInShopArray
end

-- Gets all possible Cosmetic Shop stocked items and crates
-- Returns a sorted array (by Price) of item names
local function GetAllPossibleCosmeticItemsArray()
    local AllCosmeticsArray = {}
    for i, v in pairs(CosmeticCrateShopData) do
        AddToTable_PossibleDuplicate(AllCosmeticsArray, i, v)
    end
    for i, v in pairs(CosmeticItemShopData) do
        AddToTable_PossibleDuplicate(AllCosmeticsArray, i, v)
    end
    AllCosmeticsArray = SortArray(AllCosmeticsArray)
    return AllCosmeticsArray
end

-- Returns a simple table of the 3 possible variant names
local function GetVariantsArray()
    return {"Normal", "Gold", "Rainbow",}
end

-- Returns a table, in no particular order, of all mutation names
local function GetMutationsArray()
    MutationsArray = {}
    for i, v in pairs(MutationHandler["MutationNames"]) do
        table.insert(MutationsArray, tostring(i))
    end
    return MutationsArray
end

-- Retrieves Data Arrays
GetSeedsArray()
GetMutationsArray()

-- Creating Modular GUI --

-- GUI Function Formatting
-- AddGuiPage(string : PageName)
-- AddPageLeftOptionToggle(GuiPageObject : Page, string : ButtonName, function : FunctionToRun, string : ConfigName, bool : NeedsCoroutine?)
-- NeedsCoroutine? true means the function is a looping function and will be created on a new coroutine
--                 false means the function is a normal toggle, one time execution per enable and disable

local AutoBuyPage = AddGuiPage("Auto Buy")
local FarmPage = AddGuiPage("Farm")
local EventPage = AddGuiPage("Event")
local VisualsPage = AddGuiPage("Visual")
local ConfigPage = AddGuiPage("Config")

AddPageLeftOptionToggle(AutoBuyPage, "Seed Shop", AutoBuySeedShopFunction, "AutoBuySeedShop", true)
AddPageRightOptionDropdown(AutoBuyPage, "Seeds", GetSeedShopArray(), configs.SeedShopFilter, Color3.fromRGB(0, 255, 0))

AddPageLeftOptionToggle(AutoBuyPage, "Gear Shop", AutoBuyGearShopFunction, "AutoBuyGearShop", true)
AddPageRightOptionDropdown(AutoBuyPage, "Gear", GetGearShopArray(), configs.GearShopFilter, Color3.fromRGB(0, 255, 0))

AddPageLeftOptionToggle(AutoBuyPage, "Egg Shop", AutoBuyEggShopFunction, "AutoBuyEggShop", true)
AddPageRightOptionDropdown(AutoBuyPage, "Eggs", GetEggsArray(), configs.EggShopFilter, Color3.fromRGB(0, 255, 0))

AddPageLeftOptionToggle(AutoBuyPage, "Cosmetic Shop", AutoBuyCosmeticsFunction, "AutoBuyCosmeticShop", true)
AddPageRightOptionDropdown(AutoBuyPage, "Cosmetics", GetAllPossibleCosmeticItemsArray(), configs.CosmeticShopFilter, Color3.fromRGB(0, 255, 0))

AddPageLeftOptionToggle(FarmPage, "Auto Collect", AutoCollectFruitsFunction, "AutoCollect", true)
AddPageLeftEmpty(FarmPage)
AddPageLeftEmpty(FarmPage)
AddPageLeftEmpty(FarmPage)
AddPageLeftEmpty(FarmPage)
AddPageRightOptionDropdown(FarmPage, "Blocked Plants", SeedsArray, configs.AutoCollectBlockedPlants, Color3.fromRGB(255, 0, 0))
AddPageRightOptionDropdown(FarmPage, "Blocked Variants", GetVariantsArray(), configs.AutoCollectBlockedVariants, Color3.fromRGB(255, 0, 0))
AddPageRightOptionDropdown(FarmPage, "Blocked Mutations", MutationsArray, configs.AutoCollectBlockedMutations, Color3.fromRGB(255, 0, 0))
AddPageRightOptionTextbox(FarmPage, "Minimum Value", configs.AutoCollectMinimumValue)
AddPageRightOptionTextbox(FarmPage, "Minimum Weight", configs.AutoCollectMinimumWeight)

AddPageLeftOptionToggle(FarmPage, "Auto Plant", AutoPlantFunction, "AutoPlant", true)
AddPageLeftEmpty(FarmPage)
AddPageLeftEmpty(FarmPage)
AddPageRightOptionDropdown(FarmPage, "Allowed Plants", SeedsArray, configs.AutoPlantAllowedSeeds, Color3.fromRGB(0, 255, 0))
AddPageRightOptionDropdownTextbox(FarmPage, "Plant Limits", SeedsArray, "AutoPlantSeedLimits")

AddPageLeftOptionToggle(VisualsPage, "Always Show Honey", AlwaysShowHoney, "AlwaysShowHoney", true)
AddPageRightEmpty(VisualsPage)
AddPageLeftOptionToggle(VisualsPage, "Toggle Gear TP", ToggleGearTP, "ToggleGearTP", false)
AddPageRightEmpty(VisualsPage)
AddPageLeftOptionToggle(VisualsPage, "Toggle Pets TP", TogglePetsTP, "TogglePetsTP", false)
AddPageRightEmpty(VisualsPage)

UpdatePageScrollingFrame(AutoBuyPage)
UpdatePageScrollingFrame(FarmPage)
UpdatePageScrollingFrame(VisualsPage)
UpdateTabBarScrollingFrame()

SetupConfigPage(ConfigPage)
SetDefaultPage(FarmPage)

local function main()
	print("Entered Main")

    if not GetPlayer() then
		if not WaitForPlayer() then
            CloseScript()
        end
	end

    if not GetPlayerFarm(lp) then
        if not WaitForPlayerFarm(lp) then
            CloseScript()
        end
    end
end

main()
