local VirtualUserService = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()
local centerX = mouse.ViewSizeX / 2
local centerY = mouse.ViewSizeY / 2

local configs = {}

local ActivePage = nil
local PageCount = 0

-- GUI Instances:

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabBar = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local TabBar_ScrollLeftButton = Instance.new("TextButton")
local TabBar_ScrollRightButton = Instance.new("TextButton")
local TabBar_Exit = Instance.new("TextButton")
local TabBar_Minimize = Instance.new("TextButton")
local ToggleHolder = Instance.new("Frame")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local ToggleHolder_2 = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextButton_2 = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local DropdownHolder = Instance.new("Frame")
local TextButton_3 = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local DropdownFrame = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local TextButton_4 = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local TextButton_5 = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")
local DropdownHolder_2 = Instance.new("Frame")
local TextButton_6 = Instance.new("TextButton")
local UICorner_7 = Instance.new("UICorner")
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
TabBar.Size = UDim2.new(1, 0, 0.100000001, 0)

ScrollingFrame.Parent = TabBar
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.BackgroundTransparency = 1.000
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.0470411181, 0, 0.242632911, 0)
ScrollingFrame.Size = UDim2.new(0.800075233, 0, 0.757367074, 0)
ScrollingFrame.CanvasSize = UDim2.new(2, 0, 2, 0)
ScrollingFrame.ScrollBarThickness = 0

UIListLayout.Parent = ScrollingFrame
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

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

ToggleHolder_2.Name = "ToggleHolder"
ToggleHolder_2.Parent = LeftOptions
ToggleHolder_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleHolder_2.BackgroundTransparency = 1.000
ToggleHolder_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleHolder_2.BorderSizePixel = 0
ToggleHolder_2.Position = UDim2.new(0, 0, 0.0599999987, 0)
ToggleHolder_2.Size = UDim2.new(1, 0, 0.0602981113, 0)

Frame_2.Parent = ToggleHolder_2
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.884373009, 0, 0.261206686, 0)
Frame_2.Size = UDim2.new(0.0576629899, 0, 0.396292746, 0)

TextButton_2.Parent = ToggleHolder_2
TextButton_2.BackgroundColor3 = Color3.fromRGB(236, 236, 236)
TextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.BorderSizePixel = 0
TextButton_2.Position = UDim2.new(0.0399999991, 0, 0.100000001, 0)
TextButton_2.Size = UDim2.new(0.800000012, 0, 0.75, 0)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = "Gear Shop"
TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.TextScaled = true
TextButton_2.TextSize = 14.000
TextButton_2.TextWrapped = true

UICorner_2.Parent = TextButton_2

DropdownHolder.Name = "DropdownHolder"
DropdownHolder.Parent = RightOptions
DropdownHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DropdownHolder.BackgroundTransparency = 1.000
DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
DropdownHolder.BorderSizePixel = 0
DropdownHolder.Size = UDim2.new(0.967071235, 0, 0.0602981113, 0)
DropdownHolder.ZIndex = 2

TextButton_3.Parent = DropdownHolder
TextButton_3.BackgroundColor3 = Color3.fromRGB(236, 236, 236)
TextButton_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_3.BorderSizePixel = 0
TextButton_3.Position = UDim2.new(0.0400000289, 0, 0.0999998003, 0)
TextButton_3.Size = UDim2.new(0.932641447, 0, 0.75, 0)
TextButton_3.Font = Enum.Font.SourceSans
TextButton_3.Text = "\\/ Seeds \\/"
TextButton_3.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_3.TextScaled = true
TextButton_3.TextSize = 14.000
TextButton_3.TextWrapped = true

UICorner_3.Parent = TextButton_3

DropdownFrame.Name = "DropdownFrame"
DropdownFrame.Parent = DropdownHolder
DropdownFrame.BackgroundColor3 = Color3.fromRGB(175, 175, 175)
DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.Position = UDim2.new(0.0400001705, 0, 0.849997282, 0)
DropdownFrame.Size = UDim2.new(0.932641387, 0, 7.09460688, 0)
DropdownFrame.Visible = false

UICorner_4.Parent = DropdownFrame

TextButton_4.Parent = DropdownFrame
TextButton_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton_4.BackgroundTransparency = 0.500
TextButton_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_4.BorderSizePixel = 0
TextButton_4.Position = UDim2.new(1.65181788e-07, 0, 0, 0)
TextButton_4.Size = UDim2.new(1.00000036, 0, 0.115000002, 0)
TextButton_4.Font = Enum.Font.SourceSans
TextButton_4.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_4.TextSize = 14.000

UICorner_5.Parent = TextButton_4

TextButton_5.Parent = DropdownFrame
TextButton_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton_5.BackgroundTransparency = 0.500
TextButton_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_5.BorderSizePixel = 0
TextButton_5.Position = UDim2.new(0, 0, 0.115000002, 0)
TextButton_5.Size = UDim2.new(1.00000036, 0, 0.115000002, 0)
TextButton_5.Font = Enum.Font.SourceSans
TextButton_5.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_5.TextSize = 14.000

UICorner_6.Parent = TextButton_5

DropdownHolder_2.Name = "DropdownHolder"
DropdownHolder_2.Parent = RightOptions
DropdownHolder_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DropdownHolder_2.BackgroundTransparency = 1.000
DropdownHolder_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
DropdownHolder_2.BorderSizePixel = 0
DropdownHolder_2.Position = UDim2.new(0, 0, 0.0599999987, 0)
DropdownHolder_2.Size = UDim2.new(0.967071235, 0, 0.0602981113, 0)

TextButton_6.Parent = DropdownHolder_2
TextButton_6.BackgroundColor3 = Color3.fromRGB(236, 236, 236)
TextButton_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_6.BorderSizePixel = 0
TextButton_6.Position = UDim2.new(0.0400000289, 0, 0.0999998003, 0)
TextButton_6.Size = UDim2.new(0.932641447, 0, 0.75, 0)
TextButton_6.Font = Enum.Font.SourceSans
TextButton_6.Text = "\\/ Gear Items \\/"
TextButton_6.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_6.TextScaled = true
TextButton_6.TextSize = 14.000
TextButton_6.TextWrapped = true

UICorner_7.Parent = TextButton_6

DraggableFrame.Name = "DraggableFrame"
DraggableFrame.Parent = MainFrame
DraggableFrame.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
DraggableFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
DraggableFrame.BorderSizePixel = 0
DraggableFrame.Position = UDim2.new(5.21438835e-07, 0, 0, 0)
DraggableFrame.Size = UDim2.new(1.00000048, 0, 0.0243000202, 0)

local function GuiDrag(xOffset, yOffset)
    local MousePos = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
    local viewSizeX = mouse.ViewSizeX
    local viewSizeY = mouse.ViewSizeY + GuiService:GetGuiInset().Y
    MainBackground.Position = UDim2.new((MousePos.X - xOffset) / viewSizeX, 0, (MousePos.Y - yOffset) / viewSizeY, 0)
end

DraggableFrame.InputBegan:Connect(function(InputObject)
    if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
        local MousePos = userInputService:GetMouseLocation() - GuiService:GetGuiInset()
        local xOffset = MousePos.X - MainBackground.AbsolutePosition.X
        local yOffset = MousePos.Y - MainBackground.AbsolutePosition.Y
        RunService:BindToRenderStep("GuiDrag", 999, function() GuiDrag(xOffset, yOffset) end)
    end
end)

DraggableFrame.InputEnded:Connect(function(InputObject)
    if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
        RunService:UnbindFromRenderStep("GuiDrag")
    end
end)

TabBar_Exit.MouseButton1Down:Connect(function()
    ScreenGui:Destroy()
end)

TabBar_Minimize.MouseButton1Down:Connect(function()
    ScreenGui.Enabled = false
end)

local function AddGuiPage(PageName : string)
    PageCount = PageCount + 1

    -- Add Tab Button To Top Scrolling Bar
    local TabBar_Button = Instance.new("TextButton")
    TabBar_Button.Name = "TabBar_Button" .. tostring(PageCount)
    TabBar_Button.Parent = ScrollingFrame
    TabBar_Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabBar_Button.BackgroundTransparency = 0.400
    TabBar_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabBar_Button.BorderSizePixel = 0
    TabBar_Button.Position = UDim2.new(0, 0, -7.18412139e-07, 0)
    TabBar_Button.Size = UDim2.new(0.400000006, 0, 0.38793546, 0)
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
    Page:SetAttribute("PageNumber", PageCount)
    Page:SetAttribute("LeftCount", 0)
    Page:SetAttribute("RightCount", 0)

    -- Add Scrolling Frame For Page
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = Page
    ScrollingFrame.Active = true
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.ScrollBarThickness = 5

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
        Page.Visible = true
        ActivePage = Page
    end)
end

local function AddPageLeftOptionToggle(Page, ToggleName, Function : function)
    local PageNumber = tonumber(Page:GetAttribute("PageNumber"))
    local LeftOptionCount = tonumber(Page:GetAttribute("LeftCount"))
    
    -- Frame to Hold Contents
    local ToggleHolder = Instance.new("Frame")
    ToggleHolder.Name = "ToggleHolder"
    ToggleHolder.Parent = Page.LeftOptions
    ToggleHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleHolder.BackgroundTransparency = 1.000
    ToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleHolder.BorderSizePixel = 0
    ToggleHolder.Size = UDim2.new(1, 0, 0.0602981113, 0)
    ToggleHolder.Position = UDim2.new(0, 0, 0.06 * LeftOptionCount, 0) -- Position Properly

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
    TextButton:SetAttribute("Enabled", false)

    -- Button UI Corner
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TextButton

    -- Increment Page Left Options Count Attribute by 1
    Page:SetAttribute("LeftCount", tonumber(Page:GetAttribute("LeftCount")) + 1)

    local NewCoroutine
    TextButton.MouseButton1Down:Connect(function()
        if TextButton:GetAttribute("Enabled") then
            Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            TextButton:SetAttribute("Enabled", false)

            NewCoroutine = coroutine.create(Function)
            success = coroutine.resume(NewCoroutine)
        else
            Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            TextButton:SetAttribute("Enabled", true)

            coroutine.close(NewCoroutine)
        end
    end)
end

local function AddPageRightOptionDropdown(Page, DropDownName)

end