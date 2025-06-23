local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUserService = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local lp = game.Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")
local SeedShop = PlayerGui:WaitForChild("Seed_Shop")
local SeedShopScrollingFrame = SeedShop:WaitForChild("Frame"):WaitForChild("ScrollingFrame")
local BuySeedStock = ReplicatedStorage.GameEvents.BuySeedStock
local GearShop = PlayerGui:WaitForChild("Gear_Shop")
local GearShopScrollingFrame = GearShop:WaitForChild("Frame"):WaitForChild("ScrollingFrame")
local BuyGearStock = ReplicatedStorage.GameEvents.BuyGearStock
local NPCS = game.Workspace:WaitForChild("NPCS")
local PetStand = NPCS:WaitForChild("Pet Stand")
local EggLocations = PetStand:WaitForChild("EggLocations")
local Data = ReplicatedStorage:WaitForChild("Data")
local PetEggDataMod = require(Data:WaitForChild("PetEggData"))
local BuyPetEgg = ReplicatedStorage.GameEvents.BuyPetEgg
local CosmeticCrateShopDataMod = require(Data:WaitForChild("CosmeticCrateShopData"))
local CosmeticItemShopDataMod = require(Data:WaitForChild("CosmeticItemShopData"))
local CosmeticShopUI = PlayerGui:WaitForChild("CosmeticShop_UI")
local CosmeticShopContentFrame = CosmeticShopUI:WaitForChild("CosmeticShop"):WaitForChild("Main"):WaitForChild("Holder"):WaitForChild("Shop"):WaitForChild("ContentFrame")
local CosmeticShopTopSegment = CosmeticShopContentFrame:WaitForChild("TopSegment")
local CosmeticShopBottomSegment = CosmeticShopContentFrame:WaitForChild("BottomSegment")
local BuyCosmeticItem = ReplicatedStorage.GameEvents.BuyCosmeticItem
local BuyCosmeticCrate = ReplicatedStorage.GameEvents.BuyCosmeticCrate

local mouse = lp:GetMouse()
local centerX = mouse.ViewSizeX / 2
local centerY = mouse.ViewSizeY / 2

local CoroutineArray = {}

local configs = {
    AutoBuySeedShop = false,
    SeedShopFilter = {},
    AutoBuyGearShop = false,
    GearShopFilter = {},
    AutoBuyEggShop = false,
    EggShopFilter = {},
    AutoBuyCosmeticShop = false,
    CosmeticShopFilter = {},
}

local ActivePage = nil
local PageCount = 0
local ActiveDropDown = nil

-- GUI Instances:

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabBar = Instance.new("Frame")
local TabBarScrollingFrame = Instance.new("ScrollingFrame")
local TabBarUIListLayout = Instance.new("UIListLayout")
local TabBar_ScrollLeftButton = Instance.new("TextButton")
local TabBar_ScrollRightButton = Instance.new("TextButton")
local TabBar_Exit = Instance.new("TextButton")
local TabBar_Minimize = Instance.new("TextButton")
local DraggableFrame = Instance.new("Frame")

-- GUI Properties:

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

-- Logic for making the GUI draggable
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

TabBar_Exit.MouseButton1Down:Connect(function()
    -- End Coroutines
    for i, v in pairs(CoroutineArray) do
        if v then
            coroutine.close(v)
        end
    end

    ScreenGui:Destroy()
    script:Destroy()
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

-- Function for adding a Page to the GUI, also adds a Tab for the Page
local function AddGuiPage(PageName)
    PageCount = PageCount + 1

    -- Add Tab Button To Top Scrolling Bar
    local TabBar_Button = Instance.new("TextButton")
    TabBar_Button.Name = "TabBar_Button" .. tostring(PageCount)
    TabBar_Button.Parent = TabBarScrollingFrame
    TabBar_Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabBar_Button.BackgroundTransparency = 0.400
    TabBar_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabBar_Button.BorderSizePixel = 0
    TabBar_Button.Position = UDim2.new(0, 0, 0, 0)
    TabBar_Button.Size = UDim2.new(0, 100, 1, 0)
    TabBar_Button.Font = Enum.Font.SourceSans
    TabBar_Button.Text = PageName
    TabBar_Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    TabBar_Button.TextScaled = true
    TabBar_Button.TextSize = 14.000
    TabBar_Button.TextWrapped = true

    -- Add Page
    local Page = Instance.new("Frame")
    Page.Name = "Page" .. tostring(PageCount)
    Page.Parent = MainFrame
    Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Page.BackgroundTransparency = 0.600
    Page.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Page.BorderSizePixel = 0
    Page.Position = UDim2.new(0, 0, 0.101850346, 0)
    Page.Size = UDim2.new(1, 0, 0.898149729, 0)
    Page.Visible = false
    Page:SetAttribute("PageNumber", PageCount)
    Page:SetAttribute("LeftCount", 0)
    Page:SetAttribute("RightCount", 0)

    -- Add Scrolling Frame For Page
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = Page
    ScrollingFrame.Active = false
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.Selectable = false
    ScrollingFrame.AutomaticSize = Enum.AutomaticSize.None
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.ClipsDescendants = true

    -- Add Left Options Frame
    local LeftOptions = Instance.new("Frame")
    LeftOptions.Name = "LeftOptions"
    LeftOptions.Parent = ScrollingFrame
    LeftOptions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LeftOptions.BackgroundTransparency = 1.000
    LeftOptions.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LeftOptions.BorderSizePixel = 0
    LeftOptions.Position = UDim2.new(0, 0, -1.81740887e-07, 0)
    LeftOptions.Size = UDim2.new(0.5, 0, 1, 0)

    -- Add Right Options Frame
    local RightOptions = Instance.new("Frame")
    RightOptions.Name = "RightOptions"
    RightOptions.Parent = ScrollingFrame
    RightOptions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RightOptions.BackgroundTransparency = 1.000
    RightOptions.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RightOptions.BorderSizePixel = 0
    RightOptions.Position = UDim2.new(0.5, 0, 0, 0)
    RightOptions.Size = UDim2.new(0.5, 0, 1, 0)

    TabBar_Button.MouseButton1Down:Connect(function()
        if ActivePage then
            ActivePage.Visible = false
        end
        ActivePage = Page
        ActivePage.Visible = true
    end)

    return Page
end

-- Function For Adding A Toggle to the Leftside of the Page
local function AddPageLeftOptionToggle(Page, ToggleName, Function, ConfigKeyValue)
    local LeftOptionCount = tonumber(Page:GetAttribute("LeftCount"))
    
    -- Frame to Hold Contents
    local ToggleHolder = Instance.new("Frame")
    ToggleHolder.Name = "ToggleHolder"
    ToggleHolder.Parent = Page.ScrollingFrame.LeftOptions
    ToggleHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleHolder.BackgroundTransparency = 1.000
    ToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleHolder.BorderSizePixel = 0
    ToggleHolder.Size = UDim2.new(1, 0, 0, 40)
    ToggleHolder.Position = UDim2.new(0, 0, 0, 40 * LeftOptionCount) -- Position Properly

    -- Red/Green Toggle Indicator
    local Frame = Instance.new("Frame")
    Frame.Parent = ToggleHolder
    Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.884373009, 0, 0.261206686, 0)
    Frame.Size = UDim2.new(0.0576629899, 0, 0.396292746, 0)

    -- Toggle Button
    local TextButton = Instance.new("TextButton")
    TextButton.Parent = ToggleHolder
    TextButton.BackgroundColor3 = Color3.fromRGB(236, 236, 236)
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BorderSizePixel = 0
    TextButton.Position = UDim2.new(0.0399999991, 0, 0.100000001, 0)
    TextButton.Size = UDim2.new(0.800000012, 0, 0.75, 0)
    TextButton.Font = Enum.Font.SourceSans
    TextButton.Text = ToggleName
    TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.TextScaled = true
    TextButton.TextSize = 14.000
    TextButton.TextWrapped = true

    -- Button UI Corner
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TextButton

    -- Increment Page Left Options Count Attribute by 1
    Page:SetAttribute("LeftCount", tonumber(Page:GetAttribute("LeftCount")) + 1)

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
            success = coroutine.resume(NewCoroutine)
            table.insert(CoroutineArray, NewCoroutine)
        end
    end)

    return ToggleHolder
end

-- Function For Adding A Dropdown to the Rightside of the Page
local function AddPageRightOptionDropdown(Page, DropdownName, Array, ConfigArray)
    local RightOptionCount = tonumber(Page:GetAttribute("RightCount"))
    -- ButtonHolder stores a reference to all of the buttons added in this dropdown
    local ButtonHolder = {}
    local TempCount = 0

    local DropdownHolder = Instance.new("Frame")
    DropdownHolder.Name = "DropdownHolder"
    DropdownHolder.Parent = Page.ScrollingFrame.RightOptions
    DropdownHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownHolder.BackgroundTransparency = 1.000
    DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownHolder.BorderSizePixel = 0
    DropdownHolder.Size = UDim2.new(0.967071235, 0, 0, 40)
    DropdownHolder.ZIndex = 9999 - RightOptionCount
    DropdownHolder.Position = UDim2.new(0, 0, 0, 40 * RightOptionCount) -- Position Properly

    local TextButton = Instance.new("TextButton")
    TextButton.Parent = DropdownHolder
    TextButton.BackgroundColor3 = Color3.fromRGB(236, 236, 236)
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BorderSizePixel = 0
    TextButton.Position = UDim2.new(0.0400000289, 0, 0.0999998003, 0)
    TextButton.Size = UDim2.new(0.932641447, 0, 0.75, 0)
    TextButton.Font = Enum.Font.SourceSans
    TextButton.Text = "\\/ " .. DropdownName .. " \\/"
    TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.TextScaled = true
    TextButton.TextSize = 14.000
    TextButton.TextWrapped = true
    TextButton.ZIndex = 2

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TextButton

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "DropdownFrame"
    DropdownFrame.Parent = DropdownHolder
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(175, 175, 175)
    DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Position = UDim2.new(0.0400001705, 0, 0.849997282, 0)
    DropdownFrame.Size = UDim2.new(0.932641387, 0, 5, 0)
    DropdownFrame.Visible = false

    local UICorner2 = Instance.new("UICorner")
    UICorner2.Parent = DropdownFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = DropdownFrame
    ScrollingFrame.Active = true
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.AutomaticSize = Enum.AutomaticSize.None
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.ClipsDescendants = true

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
    if #Array > 5 then
        local SelectAllButton = Instance.new("TextButton")
        SelectAllButton.Parent = ScrollingFrame
        SelectAllButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SelectAllButton.BackgroundTransparency = 0.500
        SelectAllButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SelectAllButton.BorderSizePixel = 0
        SelectAllButton.Position = UDim2.new(0, 0, 0, 0)
        SelectAllButton.Size = UDim2.new(1, 0, 0, 30)
        SelectAllButton.Font = Enum.Font.SourceSans
        SelectAllButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        SelectAllButton.TextSize = 14.000
        SelectAllButton.Text = "Select/Deselect All"

        local UICorner3 = Instance.new("UICorner")
        UICorner3.Parent = SelectAllButton

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
                Button.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
            return
        end)

        TempCount = TempCount + 1
    end

    -- Add Options Inside Dropdown
    for i, v in pairs(Array) do
        local NewButton = Instance.new("TextButton")
        NewButton.Parent = ScrollingFrame
        NewButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NewButton.BackgroundTransparency = 0.500
        NewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NewButton.BorderSizePixel = 0
        NewButton.Position = UDim2.new(0, 0, 0, 0)
        NewButton.Size = UDim2.new(1, 0, 0, 30)
        NewButton.Font = Enum.Font.SourceSans
        NewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        NewButton.TextSize = 14.000
        NewButton.Text = tostring(v)
        
        local UICorner3 = Instance.new("UICorner")
        UICorner3.Parent = NewButton

        NewButton.MouseButton1Down:Connect(function()
            local ButtonName = tostring(NewButton.Text)
            if ConfigArray[ButtonName] then
                ConfigArray[ButtonName] = false
                NewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            else
                ConfigArray[ButtonName] = true
                NewButton.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
        end)

        table.insert(ButtonHolder, NewButton)

        TempCount = TempCount + 1
    end

    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, TempCount * 30)

    return DropdownHolder
end

-- Function For Automatically Purchasing Seeds from the Seed Shop
-- Only Buys Selected Seeds
local AutoBuySeedShopFunction = function()
    local WaitTime = 0.001
    while wait(WaitTime) do
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
                        wait(0.1)
                        BuySeedStock:FireServer(SeedName)
                    end
                end
            end
            wait(0.1)
        end
        WaitTime = 10
    end
end

-- Function For Automatically Purchasing Gear from the Gear Shop
-- Only Buys Selected Gear
local AutoBuyGearShopFunction = function()
    local WaitTime = 0.001
    while wait(WaitTime) do
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
                        wait(0.1)
                        BuyGearStock:FireServer(GearName)
                    end
                end
            end
            wait(0.1)
        end
        WaitTime = 10
    end
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

local function BuyAllEggs()
    for i=1, 3 do
        BuyPetEgg:FireServer(i)
        wait(0.1)
    end
end

local AutoBuyEggsFunction = function()
    local WaitTime = 0.001
    while wait(WaitTime) do
        if not configs.AutoBuyEggShop then return end

        for _, object in pairs(EggLocations:GetChildren()) do
            if configs.EggShopFilter[tostring(object.Name)] then
                print(object.Name .. " Found!")
                print("Buying All Eggs")
                BuyAllEggs()
                break
            end
        end
        WaitTime = 10
    end
end

-- Retrieves the possible egg shop items from PetEggData Module
-- Returns a sorted array (by Price) of egg names
local function GetEggsArray()
    local EggsInShopArray = {}
    for i, v in pairs(PetEggDataMod) do
        EggsInShopArray[v.Price] = i
    end

    EggsInShopArray = SortArray(EggsInShopArray)

    return EggsInShopArray
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

local AutoBuyCosmeticsFunction = function()
    local WaitTime = 0.001
    while wait(WaitTime) do
        if not configs.AutoBuyCosmeticShop then return end

        LoopCosmeticLayer(CosmeticShopTopSegment)
        LoopCosmeticLayer(CosmeticShopBottomSegment)

        WaitTime = 10
    end
end

-- Gets all possible Cosmetic Shop stocked items and crates
-- Returns a sorted array (by Price) of item names
local function GetAllPossibleCosmeticItemsArray()
    local AllCosmeticsArray = {}
    for i, v in pairs(CosmeticCrateShopDataMod) do
        AddToTable_PossibleDuplicate(AllCosmeticsArray, i, v)
    end
    for i, v in pairs(CosmeticItemShopDataMod) do
        AddToTable_PossibleDuplicate(AllCosmeticsArray, i, v)
    end
    AllCosmeticsArray = SortArray(AllCosmeticsArray)
    return AllCosmeticsArray
end

local Page1 = AddGuiPage("Auto Buy")
local Page2 = AddGuiPage("Auto Farm")
local Page3 = AddGuiPage("Event")
local Page4 = AddGuiPage("Visual")
local Page5 = AddGuiPage("Config")
local Page5 = AddGuiPage("Config")
local Page5 = AddGuiPage("Config")

AddPageLeftOptionToggle(Page1, "Seed Shop", AutoBuySeedShopFunction, "AutoBuySeedShop")
AddPageRightOptionDropdown(Page1, "Seeds", GetSeedShopArray(), configs.SeedShopFilter)

AddPageLeftOptionToggle(Page1, "Gear Shop", AutoBuyGearShopFunction, "AutoBuyGearShop")
AddPageRightOptionDropdown(Page1, "Gear", GetGearShopArray(), configs.GearShopFilter)

AddPageLeftOptionToggle(Page1, "Egg Shop", AutoBuyEggsFunction, "AutoBuyEggShop")
AddPageRightOptionDropdown(Page1, "Eggs", GetEggsArray(), configs.EggShopFilter)

AddPageLeftOptionToggle(Page1, "Cosmetic Shop", AutoBuyCosmeticsFunction, "AutoBuyCosmeticShop")
AddPageRightOptionDropdown(Page1, "Cosmetics", GetAllPossibleCosmeticItemsArray(), configs.CosmeticShopFilter)

UpdatePageScrollingFrame(Page1)
UpdateTabBarScrollingFrame()

SetDefaultPage(Page1)