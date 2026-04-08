--[[

	- [ stav.lua ] -
	kool aid rewrite

	CREATED: [ 16/03 ] (2026)

]]
if not shared.place then shared.place = game.PlaceId end

local lib = {
	Signal = {
		Connections = {},
		newconn = function(self, signal, func)
			local conn = signal:Connect(func)
			table.insert(self.Connections, conn)

			return conn
		end
	}
}

local cloneref = cloneref or function(obj)
	return obj
end

local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textService = cloneref(game:GetService('TextService'))
local playersService = cloneref(game:GetService('Players'))
local runService = cloneref(game:GetService('RunService'))
local lplr = playersService.LocalPlayer

local gameCamera = workspace.CurrentCamera
local gethui = get_hidden_ui or gethui or function()
	return (runService:IsStudio() and lplr.PlayerGui) or cloneref(game:GetService('CoreGui'))
end

local cfg = {}
local configSys = {
	canSave = true,
	file = 'koolaid/configs/'..shared.place..'.json',
	Save = function(self)
		if runService:IsStudio() then return end
		if not self.canSave then return end

		writefile(self.file, httpService:JSONEncode(cfg))
	end,
	Load = function(self)
		if runService:IsStudio() then return end

		if isfile(self.file) then
			cfg = httpService:JSONDecode(readfile(self.file))
		end
	end
}

configSys:Load()

if not runService:IsStudio() then
	for _, v in {'kool.aid', 'kool.aid/configs'} do
		if not isfolder(v) then
			makefolder(v)
		end
	end
end

local ScreenGUI = Instance.new('ScreenGui')
ScreenGUI.Name = '\0'
ScreenGUI.ResetOnSpawn = false
ScreenGUI.DisplayOrder = 1/0
ScreenGUI.Parent = gethui()

local function makeStroke(strokeMode, color, joinMode, strokeSizeMode, thickness, transparency, parent)
	local stroke = Instance.new('UIStroke')
	stroke.ApplyStrokeMode = strokeMode
	stroke.StrokeSizingMode = strokeSizeMode
	stroke.Color = color
	stroke.LineJoinMode = joinMode
	stroke.Thickness = thickness
	stroke.Transparency = transparency
	stroke.Parent = parent

	return stroke
end

local function makeCorner(radius, parent)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius
	corner.Parent = parent

	return corner
end

local function makePadding(pB, pL, pR, pT, parent)
	local padding = Instance.new('UIPadding')
	padding.PaddingBottom = pB
	padding.PaddingLeft = pL
	padding.PaddingRight = pR
	padding.PaddingTop = pT
	padding.Parent = parent

	return padding
end

--[[
	Credits to nothm // 1DollarH4ck on Roblox for the makeDraggable function
		(I got lazy and didn't want to code the makeDraggable function)
]]

local function makeDraggable(Frame)
	local Dragging, DragStart, StartPos

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			DragStart = input.Position
			StartPos = Frame.Position
		end
	end)

	Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = false
		end
	end)

	inputService.InputChanged:Connect(function(input)
		if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local Delta = input.Position - DragStart
			Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end
	end)
end

-- Main
local MainFrame = Instance.new('Frame')
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 107, 107)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.Size = UDim2.fromOffset(650, 450)
MainFrame.Parent = ScreenGUI
makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(255, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, 0.7, MainFrame)

local MainContainer = Instance.new('Frame')
MainContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainContainer.BackgroundTransparency = 0.8
MainContainer.BorderSizePixel = 0
MainContainer.Size = UDim2.new(0, 200, 1, 0)
MainContainer.Parent = MainFrame

local OtherContainer = Instance.new('Frame')
OtherContainer.AnchorPoint = Vector2.new(1, 0)
OtherContainer.BackgroundTransparency = 1
OtherContainer.BorderSizePixel = 0
OtherContainer.Position = UDim2.new(1, -5, 0, 5)
OtherContainer.Size = UDim2.new(1, -210, 1, -10)
OtherContainer.Parent = MainFrame

--[[

	PlayerContainer

]]

do
	local PlayerContainer = Instance.new('Frame')
	PlayerContainer.AnchorPoint = Vector2.new(0, 1)
	PlayerContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	PlayerContainer.BackgroundTransparency = 0.8
	PlayerContainer.BorderSizePixel = 0
	PlayerContainer.Position = UDim2.fromScale(0, 1)
	PlayerContainer.Size = UDim2.new(1, 0, 0, 55)
	PlayerContainer.Parent = MainContainer

	local PlayerIcon = Instance.new('ImageLabel')
	PlayerIcon.BackgroundTransparency = 1
	PlayerIcon.BorderSizePixel = 0
	PlayerIcon.Size = UDim2.new(0, 55, 1, 0)
	PlayerIcon.Image = playersService:GetUserThumbnailAsync(lplr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	PlayerIcon.ScaleType = Enum.ScaleType.Fit
	PlayerIcon.Parent = PlayerContainer

	local PlayerInfo = Instance.new('Frame')
	PlayerInfo.AnchorPoint = Vector2.new(1, 0)
	PlayerInfo.BackgroundTransparency = 1
	PlayerInfo.BorderSizePixel = 0
	PlayerInfo.Position = UDim2.fromScale(1, 0)
	PlayerInfo.Size = UDim2.new(1, -55, 1, 0)
	PlayerInfo.Parent = PlayerContainer
	makePadding(UDim.new(0, 10), UDim.new(0, 8), UDim.new(0, 8), UDim.new(0, 0), PlayerInfo)

	local PlayerInfoLayout = Instance.new('UIListLayout')
	PlayerInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
	PlayerInfoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	PlayerInfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	PlayerInfoLayout.Parent = PlayerInfo

	local PlrDisplayName = Instance.new('TextLabel')
	PlrDisplayName.BackgroundTransparency = 1
	PlrDisplayName.BorderSizePixel = 0
	PlrDisplayName.Size = UDim2.new(1, 0, 0, 25)
	PlrDisplayName.FontFace = Font.fromName('Montserrat', Enum.FontWeight.Medium)
	PlrDisplayName.Text = lplr.DisplayName
	PlrDisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlrDisplayName.TextSize = 14
	PlrDisplayName.TextXAlignment = Enum.TextXAlignment.Left
	PlrDisplayName.TextYAlignment = Enum.TextYAlignment.Center
	PlrDisplayName.Parent = PlayerInfo
	makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0,0,0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, PlrDisplayName)

	local PlrRank = Instance.new('TextLabel')
	PlrRank.BackgroundTransparency = 1
	PlrRank.BorderSizePixel = 0
	PlrRank.Size = UDim2.new(1, 0, 0, 5)
	PlrRank.FontFace = Font.fromName('Montserrat', Enum.FontWeight.Medium)
	PlrRank.Text = 'Free'
	PlrRank.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlrRank.TextSize = 12
	PlrRank.TextXAlignment = Enum.TextXAlignment.Left
	PlrRank.TextYAlignment = Enum.TextYAlignment.Center
	PlrRank.Parent  = PlayerInfo
	makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0,0,0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, PlrRank)
end

-- Visual
local VisualFrame = Instance.new('Frame')
VisualFrame.BackgroundTransparency = 1
VisualFrame.BorderSizePixel = 0
VisualFrame.Size = UDim2.fromScale(1, 1)
VisualFrame.Parent = ScreenGUI

--[[

    Notifications

]]

do
	local activeNotifs = {}
	local function removeNotification(guiObj)
		local ind = table.find(activeNotifs, guiObj)
		if ind then
			table.remove(activeNotifs, ind)
		end

		local SlideOut = tweenService:Create(guiObj, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(1.5, 0, guiObj.Position.Y.Scale, guiObj.Position.Y.Offset)
		})

		SlideOut:Play()
		SlideOut.Completed:Connect(function()
			guiObj:Destroy()

			for i,v in activeNotifs do
				local targetY = 0.85 - ((i - 1) * (90 / workspace.CurrentCamera.ViewportSize.Y))
				tweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
					Position = UDim2.new(1, 0, targetY, (i - 1) * -5)
				}):Play()
			end
		end)
	end

	function lib:Notify(text, duration)
		if #activeNotifs >= 6 then
			removeNotification(activeNotifs[#activeNotifs])
		end

		local Notification = Instance.new('Frame')
		Notification.AnchorPoint = Vector2.new(1, 0.85)
		Notification.AutomaticSize = Enum.AutomaticSize.X
		Notification.BackgroundColor3 = Color3.fromRGB(204, 86, 86)
		Notification.BorderSizePixel = 0
		Notification.Position = UDim2.new(1.5, 0, 0.85, 0)
		Notification.Size = UDim2.fromOffset(0, 80)
		Notification.Parent = VisualFrame
		makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(255, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, 0.7, Notification)
		makePadding(UDim.new(0, 0), UDim.new(0, 9), UDim.new(0, 9), UDim.new(0, 2), Notification)

		activeNotif = Notification
		local NotificationLayout = Instance.new('UIListLayout')
		NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
		NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		NotificationLayout.Parent = Notification

		local Title = Instance.new('TextLabel')
		Title.AutomaticSize = Enum.AutomaticSize.X
		Title.BackgroundTransparency = 1
		Title.BorderSizePixel = 0
		Title.Size = UDim2.fromOffset(0, 30)
		Title.FontFace = Font.fromName('Montserrat', Enum.FontWeight.SemiBold)
		Title.Text = 'kool.aid'
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 18
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.Parent = Notification
		makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0,0,0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, Title)

		local Description = Instance.new('TextLabel')
		Description.AutomaticSize = Enum.AutomaticSize.X
		Description.BackgroundTransparency = 1
		Description.BorderSizePixel = 0
		Description.Size = UDim2.fromOffset(0, 30)
		Description.FontFace = Font.fromName('Montserrat')
		Description.Text = text
		Description.TextColor3 = Color3.fromRGB(255, 255, 255)
		Description.TextSize = 20
		Description.TextXAlignment = Enum.TextXAlignment.Left
		Description.TextYAlignment = Enum.TextYAlignment.Top
		Description.Parent = Notification
		makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0,0,0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, Description)

		local BarBack = Instance.new('Frame')
		BarBack.BackgroundColor3 = Color3.fromRGB(127, 44, 41)
		BarBack.BorderSizePixel = 0
		BarBack.Size = UDim2.new(1, 0, 0, 10)
		BarBack.Position = UDim2.new(0, 0, 1, -10)
		BarBack.AnchorPoint = Vector2.new(0, 1)
		BarBack.Parent = Notification

		local BarFill = Instance.new('Frame')
		BarFill.AnchorPoint = Vector2.new(1, 0)
		BarFill.BackgroundColor3 = Color3.fromRGB(241, 83, 77)
		BarFill.BorderSizePixel = 0
		BarFill.Position = UDim2.fromScale(1, 0)
		BarFill.Size = UDim2.new(1, 0, 1, 0)
		BarFill.Parent = BarBack

		table.insert(activeNotifs, 1, Notification)
		for i,v in activeNotifs do
			local targetY = 0.85 - ((i - 1) * (90 / workspace.CurrentCamera.ViewportSize.Y))
			tweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
				Position = UDim2.new(1, 0, targetY, (i - 1) * -5)
			}):Play()
		end

		tweenService:Create(BarFill, TweenInfo.new(duration or 3, Enum.EasingStyle.Linear), {
			Size = UDim2.new(0, 0, 1, 0)
		}):Play()

		task.delay(duration or 3, function()
			if table.find(activeNotifs, Notification) then
				removeNotification(Notification)
			end
		end)
	end
end

--[[

	Tabs

]]

local Tabs, activeTab = {}, nil

do
	local TabsContainer = Instance.new('Frame')
	TabsContainer.BackgroundTransparency = 1
	TabsContainer.BorderSizePixel = 0
	TabsContainer.Size = UDim2.new(1, 0, 1, -75)
	TabsContainer.Parent = MainContainer
	makePadding(UDim.new(0, 0), UDim.new(0, 10), UDim.new(0, 10), UDim.new(0, 10), TabsContainer)

	local TabsLayout = Instance.new('UIListLayout')
	TabsLayout.Padding = UDim.new(0, 15)
	TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabsLayout.Parent = TabsContainer

	lib.Signal:newconn(inputService.InputBegan, function(key, gpe)
		if gpe then return end

		if key.KeyCode == Enum.KeyCode.RightShift then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	function lib:CreateTab(name, image)
		local Tab = Instance.new('TextButton')
		Tab.BackgroundTransparency = 1
		Tab.Name = name
		Tab.Size = UDim2.new(1, 0, 0, 50)
		Tab.Text = ''
		Tab.Parent = TabsContainer

		makeCorner(UDim.new(0, 8), Tab)
		makePadding(UDim.new(0, 0), UDim.new(0, 10), UDim.new(0, 0), UDim.new(0, 0), Tab)
		makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(67, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, 0.8, Tab)

		local TabLayout = Instance.new('UIListLayout')
		TabLayout.Padding = UDim.new(0, 5)
		TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabLayout.FillDirection = Enum.FillDirection.Horizontal
		TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		TabLayout.Parent = Tab

		if image and typeof(image) == 'string' then
			local TabIcon = Instance.new('ImageLabel')
			TabIcon.BackgroundTransparency = 1
			TabIcon.BorderSizePixel = 0
			TabIcon.Size = UDim2.fromOffset(30, 30)
			TabIcon.Image = image
			TabIcon.ScaleType = Enum.ScaleType.Fit
			TabIcon.Parent = Tab
		end

		local TabName = Instance.new('TextLabel')
		TabName.BackgroundTransparency = 1
		TabName.BorderSizePixel = 0
		TabName.Size = UDim2.new(0.5, 50, 1, 0)
		TabName.FontFace = Font.fromName('Montserrat', Enum.FontWeight.SemiBold)
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.Text = name
		TabName.TextSize = 20
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.Parent = Tab
		makePadding(UDim.new(0, 0), UDim.new(0, image and 7 or 0), UDim.new(0, 0), UDim.new(0, 0), TabName)
		makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0,0,0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, TabName)

		local ModuleContainer = Instance.new('ScrollingFrame')
		ModuleContainer.BackgroundTransparency = 1
		ModuleContainer.BorderSizePixel = 0
		ModuleContainer.Size = UDim2.new(1, 0, 1, 0)
		ModuleContainer.CanvasSize = UDim2.fromScale(0, 9999)
		ModuleContainer.ScrollBarThickness = 0
		ModuleContainer.ScrollingDirection = Enum.ScrollingDirection.Y
		ModuleContainer.Parent = OtherContainer

		local ModuleCLayout = Instance.new('UIListLayout')
		ModuleCLayout.Padding = UDim.new(0, 4)
		ModuleCLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ModuleCLayout.FillDirection = Enum.FillDirection.Horizontal
		ModuleCLayout.Wraps = true
		ModuleCLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		ModuleCLayout.Parent = ModuleContainer

		if not activeTab then
			activeTab = ModuleContainer
		else
			ModuleContainer.Visible = not ModuleContainer.Visible
		end

		Tabs[name] = {
			TabInst = Tab,
			ContainerInst = ModuleContainer,
			Modules = {},
			CreateModule = function(self, Table)
				if type(cfg[Table.Name]) ~= 'table' then
					cfg[Table.Name] = {
						Enabled = false,
						Keybind = 'Unknown',
						Toggles = {},
						Dropdowns = {},
						Sliders = {}
					}
				end

				local RModuleContainer = Instance.new('Frame')
				RModuleContainer.AutomaticSize = Enum.AutomaticSize.Y
				RModuleContainer.BackgroundTransparency = 1
				RModuleContainer.BorderSizePixel = 0
				RModuleContainer.Size = UDim2.fromOffset(218, 0)
				RModuleContainer.Parent = ModuleContainer
				makePadding(UDim.new(0, 5), UDim.new(0, 5), UDim.new(0, 5), UDim.new(0, 5), RModuleContainer)

				local ModuleLayout = Instance.new('UIListLayout')
				ModuleLayout.Padding = UDim.new(0, 15)
				ModuleLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ModuleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
				ModuleLayout.Parent = RModuleContainer

				local ModuleButton = Instance.new('TextButton')
				ModuleButton.BackgroundTransparency = 1
				ModuleButton.Size = UDim2.new(1, 0, 0, 50)
				ModuleButton.Text = ''
				ModuleButton.Parent = RModuleContainer
				makeCorner(UDim.new(0, 8), ModuleButton)

				local ModuleStroke = makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(67, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, cfg[Table.Name].Enabled and 0.55 or 0.8, ModuleButton)

				local ModuleName = Instance.new('TextLabel')
				ModuleName.BackgroundTransparency = 1
				ModuleName.BorderSizePixel = 0
				ModuleName.Size = UDim2.new(1, -55, 1, 0)
				ModuleName.FontFace = Font.fromName('Montserrat')
				ModuleName.Text = Table.Name
				ModuleName.TextColor3 = Color3.fromRGB(255, 255, 255)
				ModuleName.TextScaled = true
				ModuleName.TextXAlignment = Enum.TextXAlignment.Left
				ModuleName.Parent = ModuleButton
				makePadding(UDim.new(0, 0), UDim.new(0, 12), UDim.new(0, 0), UDim.new(0, 0), ModuleName)
				makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, ModuleName)

				local TextConstraintNme = Instance.new('UITextSizeConstraint')
				TextConstraintNme.MaxTextSize = 20
				TextConstraintNme.MinTextSize = 1
				TextConstraintNme.Parent = ModuleName

				local OptionsFrame = Instance.new('Frame')
				OptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
				OptionsFrame.BackgroundTransparency = 1
				OptionsFrame.Size = UDim2.fromScale(1, 0)
				OptionsFrame.Visible = false
				OptionsFrame.Parent = nil
				makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(67, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, 0.8, OptionsFrame)
				makePadding(UDim.new(0, 8), UDim.new(0, 10), UDim.new(0, 10), UDim.new(0, 8), OptionsFrame)
				makeCorner(UDim.new(0, 8), OptionsFrame)

				local OptionsLayout = Instance.new('UIListLayout')
				OptionsLayout.Padding = UDim.new(0, 8)
				OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
				OptionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
				OptionsLayout.Parent = OptionsFrame

				local moduleHandler = {
					Enabled = cfg[Table.Name].Enabled,
					Toggle = function(self)
						self.Enabled = not self.Enabled
						cfg[Table.Name].Enabled = not cfg[Table.Name].Enabled

						tweenService:Create(ModuleStroke, TweenInfo.new(0.1), {Transparency = self.Enabled and 0.55 or 0.8}):Play()
						lib:Notify(Table.Name..' has been 'self.Enabled and 'enabled!' or 'disabled!', 2)
						if Table.Function then
							task.spawn(Table.Function, self.Enabled)
						end

						configSys:Save()
					end,
				}

				function moduleHandler.CreateToggle(self, tab)
					if not cfg[Table.Name].Toggles[tab.Name] then
						cfg[Table.Name].Toggles[tab.Name] = {Enabled = false}
					end

					if OptionsFrame.Parent == nil then
						OptionsFrame.Parent = RModuleContainer
					end

					local MiniTogFrame = Instance.new('Frame')
					MiniTogFrame.BackgroundTransparency = 1
					MiniTogFrame.BorderSizePixel = 0
					MiniTogFrame.Size = UDim2.new(1, 0, 0, 35)
					MiniTogFrame.Parent = OptionsFrame

					local Title = Instance.new('TextLabel')
					Title.BackgroundTransparency = 1
					Title.Size = UDim2.new(1, -40, 1, 0)
					Title.FontFace = Font.fromName('Montserrat')
					Title.Text = tab.Name
					Title.TextColor3 = Color3.fromRGB(255, 255, 255)
					Title.TextScaled = true
					Title.TextXAlignment = Enum.TextXAlignment.Left
					Title.Parent = MiniTogFrame
					makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, Title)

					local TitleConstraint = Instance.new('UITextSizeConstraint')
					TitleConstraint.MaxTextSize = 20
					TitleConstraint.MinTextSize = 1
					TitleConstraint.Parent = Title

					local ToggleButton = Instance.new('TextButton')
					ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
					ToggleButton.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
					ToggleButton.BackgroundTransparency = 0.9
					ToggleButton.Position = UDim2.fromScale(1, 0.5)
					ToggleButton.Size = UDim2.new(0, 30, 1, -5)
					ToggleButton.Text = ''
					ToggleButton.Parent = MiniTogFrame
					makeCorner(UDim.new(0, 8), ToggleButton)

					local MiniTogStroke = makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(67, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, 0.8, ToggleButton)

					local moduleHandler = {
						Enabled = cfg[Table.Name].Toggles[tab.Name].Enabled,
						Toggle = function(self)
							self.Enabled = not self.Enabled
							cfg[Table.Name].Toggles[tab.Name].Enabled = not cfg[Table.Name].Toggles[tab.Name].Enabled

							tweenService:Create(MiniTogStroke, TweenInfo.new(0.1), {Transparency = self.Enabled and 0.55 or 0.8}):Play()
							if tab.Function then
								task.spawn(tab.Function, self.Enabled)
							end

							configSys:Save()
						end,
					}

					lib.Signal:newconn(ToggleButton.MouseButton1Click, function()
						moduleHandler:Toggle()
					end)

					if cfg[Table.Name].Toggles[tab.Name].Enabled then
						tweenService:Create(MiniTogStroke, TweenInfo.new(0.1), {Transparency = cfg[Table.Name].Toggles[tab.Name].Enabled and 0.55 or 0.8}):Play()
						if tab.Function then
							task.spawn(tab.Function, cfg[Table.Name].Toggles[tab.Name].Enabled)
						end
					end

					return moduleHandler
				end

				function moduleHandler.CreateSlider(self, tab)
					if not cfg[Table.Name].Sliders[tab.Name] then
						cfg[Table.Name].Sliders[tab.Name] = {Value = tab.Default or tab.Min}
					end

					if OptionsFrame.Parent == nil then
						OptionsFrame.Parent = RModuleContainer
					end

					local isDragging = false
					local SliderFrame = Instance.new('Frame')
					SliderFrame.BackgroundTransparency = 1
					SliderFrame.BorderSizePixel = 0
					SliderFrame.Size = UDim2.new(1, 0, 0, 35)
					SliderFrame.Parent = OptionsFrame

					local SliderTitle = Instance.new('TextLabel')
					SliderTitle.BackgroundTransparency = 1
					SliderTitle.BorderSizePixel = 0
					SliderTitle.Size = UDim2.new(1, 0, 0, 20)
					SliderTitle.FontFace = Font.fromName('Montserrat')
					SliderTitle.Text = tab.Name
					SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
					SliderTitle.TextSize = 16
					SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
					SliderTitle.Parent = SliderFrame
					makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, SliderTitle)

					local SliderVal = Instance.new('TextBox')
					SliderVal.AnchorPoint = Vector2.new(1, 0)
					SliderVal.BackgroundTransparency = 1
					SliderVal.BorderSizePixel = 1
					SliderVal.ClearTextOnFocus = true
					SliderVal.Position = UDim2.fromScale(1, 0)
					SliderVal.Size = UDim2.fromOffset(80, 20)
					SliderVal.FontFace = Font.fromName('Montserrat')
					SliderVal.Text = cfg[Table.Name].Sliders[tab.Name].Value
					SliderVal.TextColor3 = Color3.fromRGB(255, 255, 255)
					SliderVal.TextSize = 15
					SliderVal.TextXAlignment = Enum.TextXAlignment.Right
					SliderVal.Parent = SliderFrame
					makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, SliderVal)

					local SliderBck = Instance.new('Frame')
					SliderBck.AnchorPoint = Vector2.new(0, 1)
					SliderBck.BackgroundColor3 = Color3.fromRGB(127, 44, 41)
					SliderBck.BorderSizePixel = 0
					SliderBck.Position = UDim2.fromScale(0, 1)
					SliderBck.Size = UDim2.new(1, 0, 0, 10)
					SliderBck.Parent = SliderFrame

					local SliderFill = Instance.new('Frame')
					SliderFill.BackgroundColor3 = Color3.fromRGB(221, 76, 71)
					SliderFill.BorderSizePixel = 0
					SliderFill.Size = UDim2.fromScale(0.5, 1)
					SliderFill.Parent = SliderBck

					local SliderButton = Instance.new('TextButton')
					SliderButton.Size = UDim2.new(1, 0, 1, 0)
					SliderButton.BackgroundTransparency = 1
					SliderButton.Text = ''
					SliderButton.ZIndex = 2
					SliderButton.Parent = SliderBck

					local percent = (cfg[Table.Name].Sliders[tab.Name].Value - tab.Min) / (tab.Max - tab.Min)
					SliderFill.Size = UDim2.new(percent, 0, 1, 0)

					local moduleHandler = {
						Value = cfg[Table.Name].Sliders[tab.Name].Value,
						Min = tab.Min,
						Max = tab.Max,
						Set = function(self, value)
							value = math.clamp(value, self.Min, self.Max)
							if tab.Round then
								value = math.floor(value / tab.Round) * tab.Round
							end

							self.Value = value
							cfg[Table.Name].Sliders[tab.Name].Value = value

							SliderFill.Size = UDim2.new((value - self.Min) / (self.Max - self.Min), 0, 1, 0)
							SliderVal.Text = string.format('%.2f', value)

							if tab.Function then
								task.spawn(tab.Function, value)
							end

							configSys:Save()
						end
					}

					local function updateSlider(input)
						local X = math.clamp(((input.Position.X - SliderBck.AbsolutePosition.X) / SliderBck.AbsoluteSize.X), 0, 1)
						local value = tab.Min + (X * (tab.Max - tab.Min))
						moduleHandler:Set(value)
					end

					lib.Signal:newconn(SliderButton.MouseButton1Down,function()
						isDragging = true
					end)

					lib.Signal:newconn(SliderButton.MouseButton1Click, function()
						local mouse = inputService:GetMouseLocation()
						updateSlider({Position = Vector2.new(mouse.X, mouse.Y)})
					end)

					lib.Signal:newconn(SliderVal.FocusLost, function(pressed)
						if not pressed then return end

						local numVal = tonumber(SliderVal.Text)
						if numVal then
							local val = math.clamp(numVal, tab.Min, tab.Max)
							moduleHandler:Set(val)
						else
							SliderVal.Text = string.format('%.2f', moduleHandler.Value)
						end
					end)

					lib.Signal:newconn(inputService.InputEnded, function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							isDragging = false
						end
					end)

					lib.Signal:newconn(inputService.InputChanged, function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
							updateSlider(input)
						end
					end)

					if cfg[Table.Name].Sliders[tab.Name].Value then
						value = math.clamp(cfg[Table.Name].Sliders[tab.Name].Value, tab.Min, tab.Max)
						if tab.Round then
							value = math.floor(value / tab.Round) * tab.Round
						end

						SliderFill.Size = UDim2.new((value - tab.Min) / (tab.Max - tab.Min), 0, 1, 0)
						SliderVal.Text = string.format('%.2f', value)

						if tab.Function then
							task.spawn(tab.Function, value)
						end
					end

					return moduleHandler
				end

				function moduleHandler.CreateDropdown(self, tab)
					if not cfg[Table.Name].Dropdowns[tab.Name] then
						cfg[Table.Name].Dropdowns[tab.Name] = {Value = tab.Default or tab.Options[1]}
					end

					if OptionsFrame.Parent == nil then
						OptionsFrame.Parent = RModuleContainer
					end

					local DropdownFrame = Instance.new('Frame')
					DropdownFrame.BackgroundTransparency = 1
					DropdownFrame.BorderSizePixel = 0
					DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
					DropdownFrame.Parent = OptionsFrame

					local DropdownTitle = Instance.new('TextLabel')
					DropdownTitle.AnchorPoint = Vector2.new(0, 0.5)
					DropdownTitle.BackgroundTransparency = 1
					DropdownTitle.BorderSizePixel = 0
					DropdownTitle.Position = UDim2.fromScale(0, 0.5)
					DropdownTitle.Size = UDim2.new(1, -70, 0, 30)
					DropdownTitle.FontFace = Font.fromName('Montserrat')
					DropdownTitle.Text = tab.Name
					DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
					DropdownTitle.TextScaled = true
					DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
					DropdownTitle.Parent = DropdownFrame
					makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, DropdownTitle)

					local DropdownTitleConstraint = Instance.new('UITextSizeConstraint')
					DropdownTitleConstraint.MaxTextSize = 20
					DropdownTitleConstraint.MinTextSize = 1
					DropdownTitleConstraint.Parent = DropdownTitle

					local DropdownButton = Instance.new('TextButton')
					DropdownButton.AnchorPoint = Vector2.new(1, 0.5)
					DropdownButton.BackgroundColor3 = Color3.fromRGB(221, 76, 71)
					DropdownButton.Position = UDim2.fromScale(1, 0.5)
					DropdownButton.Size = UDim2.fromOffset(60, 30)
					DropdownButton.FontFace = Font.fromName('Montserrat')
					DropdownButton.Text = cfg[Table.Name].Dropdowns[tab.Name].Value
					DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					DropdownButton.TextSize = 14
					DropdownButton.Parent = DropdownFrame
					makeCorner(UDim.new(0, 4), DropdownButton)
					makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, DropdownButton)

					local DropdownHolder = Instance.new('Frame')
					DropdownHolder.AutomaticSize = Enum.AutomaticSize.Y
					DropdownHolder.BackgroundTransparency = 1
					DropdownHolder.BorderSizePixel = 0
					DropdownHolder.Position = UDim2.fromScale(0, 0.95)
					DropdownHolder.Size = UDim2.fromScale(1, 1)
					DropdownHolder.Visible = false
					DropdownHolder.Parent = DropdownButton

					local DropdownLayout = Instance.new('UIListLayout')
					DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
					DropdownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
					DropdownLayout.Parent = DropdownHolder

					local moduleHandler = {
						Value = cfg[Table.Name].Dropdowns[tab.Name].Value,
						Set = function(self, val)
							cfg[Table.Name].Dropdowns[tab.Name].Value = val
							self.Value = val

							DropdownButton.Text = val
							DropdownHolder.Visible = false

							if tab.Function then
								task.spawn(tab.Function, val)
							end

							configSys:Save()
						end,
					}

					for i,v in tab.Options do
						local OptionButton = Instance.new('TextButton')
						OptionButton.BackgroundColor3 = Color3.fromRGB(209, 72, 67)
						OptionButton.BorderSizePixel = 0
						OptionButton.Size = UDim2.fromOffset(60, 30)
						OptionButton.ZIndex = 2
						OptionButton.FontFace = Font.fromName('Montserrat')
						OptionButton.Text = v
						OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
						OptionButton.TextScaled = true
						OptionButton.TextWrapped = true
						OptionButton.Parent = DropdownHolder
						makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, OptionButton)

						local OptionConstraint = Instance.new('UITextSizeConstraint')
						OptionConstraint.MaxTextSize = 14
						OptionConstraint.MinTextSize = 1
						OptionConstraint.Parent = OptionButton

						lib.Signal:newconn(OptionButton.MouseButton1Click, function()
							moduleHandler:Set(v)
						end)
					end

					if cfg[Table.Name].Dropdowns[tab.Name].Value then
						DropdownButton.Text = cfg[Table.Name].Dropdowns[tab.Name].Value
						DropdownHolder.Visible = false

						if tab.Function then
							task.spawn(tab.Function, cfg[Table.Name].Dropdowns[tab.Name].Value)
						end
					end

					lib.Signal:newconn(DropdownButton.MouseButton1Click, function()
						DropdownHolder.Visible = not DropdownHolder.Visible
					end)

					return moduleHandler
				end

				lib.Signal:newconn(ModuleButton.MouseButton1Click, function()
					moduleHandler:Toggle()
				end)

				lib.Signal:newconn(ModuleButton.MouseButton2Click, function()
					OptionsFrame.Visible = not OptionsFrame.Visible
				end)

				if cfg[Table.Name].Enabled and Table.Function then
					tweenService:Create(ModuleStroke, TweenInfo.new(0.1), {Transparency = cfg[Table.Name].Enabled and 0.55 or 0.8}):Play()
					if Table.Function then
						task.spawn(Table.Function, cfg[Table.Name].Enabled)
					end
				end

				local KeybindTog = Instance.new('TextButton')
				KeybindTog.AnchorPoint = Vector2.new(0.95, 0.5)
				KeybindTog.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				KeybindTog.BackgroundTransparency = 0.9
				KeybindTog.Position = UDim2.fromScale(0.95, 0.5)
				KeybindTog.Size = UDim2.fromOffset(35, 35)
				KeybindTog.FontFace = Font.fromName('Montserrat')
				KeybindTog.Text = ''
				KeybindTog.TextColor3 = Color3.fromRGB(255, 255, 255)
				KeybindTog.TextSize = 20
				KeybindTog.Parent = ModuleButton

				makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, KeybindTog)
				makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(67, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, 0.8, KeybindTog)
				makeCorner(UDim.new(0, 6), KeybindTog)

				if cfg[Table.Name].Keybind and cfg[Table.Name].Keybind ~= 'Unknown' then
					KeybindTog.Text = cfg[Table.Name].Keybind
				end

				lib.Signal:newconn(KeybindTog.MouseButton1Click, function()
					local conn
					conn = inputService.InputBegan:Connect(function(key, gpe)
						if gpe then return end

						if key.KeyCode ~= Enum.KeyCode.Unknown and key.KeyCode ~= Enum.KeyCode.Backspace then
							cfg[Table.Name].Keybind = tostring(key.KeyCode):gsub('Enum.KeyCode.', '')
							KeybindTog.Text = cfg[Table.Name].Keybind
						elseif key.KeyCode == Enum.KeyCode.Backspace then
							cfg[Table.Name].Keybind = tostring(Enum.KeyCode.Unknown):gsub('Enum.KeyCode.', '')
							KeybindTog.Text = ''
						end

						conn:Disconnect()
					end)
				end)

				lib.Signal:newconn(inputService.InputBegan, function(key, gpe)
					if gpe then return end

					if key.KeyCode ~= Enum.KeyCode.Unknown and key.KeyCode == Enum.KeyCode[cfg[Table.Name].Keybind] then
						moduleHandler:Toggle()
					end
				end)

				self.Modules[Table.Name] = moduleHandler

				for i, v in self.ContainerInst:GetChildren() do
					if v:IsA('Frame') then
						v.ZIndex = -i
					end
				end

				return moduleHandler
			end,
		}

		lib.Signal:newconn(Tab.MouseButton1Click, function()
			for i,v in Tabs do
				v.ContainerInst.Visible = false
			end

			activeTab = Tabs[name].ContainerInst
			Tabs[name].ContainerInst.Visible = true
		end)

		return Tabs[name]
	end
end

--[[

	Target HUD

]]

do
	local TargetHUDFContainer = Instance.new('Frame')
	TargetHUDFContainer.AnchorPoint = Vector2.new(0.5, 0.85)
	TargetHUDFContainer.AutomaticSize = Enum.AutomaticSize.X
	TargetHUDFContainer.BackgroundColor3 = Color3.fromRGB(204, 86, 86)
	TargetHUDFContainer.BorderSizePixel = 0
	TargetHUDFContainer.Position = UDim2.fromScale(0.5, 0.85)
	TargetHUDFContainer.Size = UDim2.fromOffset(200, 70)
	TargetHUDFContainer.Visible = false
	TargetHUDFContainer.Parent = VisualFrame
	makeDraggable(TargetHUDFContainer)
	makePadding(UDim.new(0, 0), UDim.new(0, 8), UDim.new(0, 8), UDim.new(0, 0), TargetHUDFContainer)
	makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(255, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, 0.7, TargetHUDFContainer)

	local THCLayout = Instance.new('UIListLayout')
	THCLayout.Padding = UDim.new(0, 10)
	THCLayout.FillDirection = Enum.FillDirection.Horizontal
	THCLayout.SortOrder = Enum.SortOrder.LayoutOrder
	THCLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	THCLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	THCLayout.Parent = TargetHUDFContainer

	local TargetIcon = Instance.new('ImageLabel')
	TargetIcon.BackgroundTransparency = 1
	TargetIcon.BorderSizePixel = 0
	TargetIcon.Size = UDim2.fromOffset(55, 55)
	TargetIcon.ScaleType = Enum.ScaleType.Fit
	TargetIcon.Parent = TargetHUDFContainer
	makeStroke(Enum.ApplyStrokeMode.Border, Color3.fromRGB(0, 0, 0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 3, 0.7, TargetIcon)

	local TargetHUDContainer = Instance.new('Frame')
	TargetHUDContainer.AutomaticSize = Enum.AutomaticSize.X
	TargetHUDContainer.BackgroundTransparency = 1
	TargetHUDContainer.BorderSizePixel = 0
	TargetHUDContainer.Size = UDim2.fromOffset(120, 60)
	TargetHUDContainer.Parent = TargetHUDFContainer

	local TargetHUDLayout = Instance.new('UIListLayout')
	TargetHUDLayout.Padding = UDim.new(0, 14)
	TargetHUDLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TargetHUDLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	TargetHUDLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TargetHUDLayout.Parent = TargetHUDContainer

	local PlayerName = Instance.new('TextLabel')
	PlayerName.AutomaticSize = Enum.AutomaticSize.X
	PlayerName.BackgroundTransparency = 1
	PlayerName.BorderSizePixel = 0
	PlayerName.Size = UDim2.fromOffset(0, 0)
	PlayerName.FontFace = Font.fromName('Montserrat', Enum.FontWeight.SemiBold)
	PlayerName.Text = ''
	PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlayerName.TextSize = 14
	PlayerName.Parent = TargetHUDContainer
	makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0,0,0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, PlayerName)

	local PlrHealthPercentage = Instance.new('TextLabel')
	PlrHealthPercentage.AutomaticSize = Enum.AutomaticSize.X
	PlrHealthPercentage.BackgroundTransparency = 1
	PlrHealthPercentage.BorderSizePixel = 0
	PlrHealthPercentage.Size = UDim2.fromOffset(0, 0)
	PlrHealthPercentage.FontFace = Font.fromName('Montserrat', Enum.FontWeight.SemiBold)
	PlrHealthPercentage.Text = '100%'
	PlrHealthPercentage.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlrHealthPercentage.TextSize = 12
	PlrHealthPercentage.Parent = TargetHUDContainer
	makeStroke(Enum.ApplyStrokeMode.Contextual, Color3.fromRGB(0,0,0), Enum.LineJoinMode.Miter, Enum.StrokeSizingMode.FixedSize, 2, 0.75, PlrHealthPercentage)

	function lib:CreateTargetHUD(visibility, plrnme, humanoid, thumbnail)
		TargetHUDFContainer.Visible = visibility

		if plrnme and humanoid then
			PlayerName.Text = plrnme
			PlrHealthPercentage.Text = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)..'%'
			TargetIcon.Image = thumbnail ~= nil and thumbnail or 'rbxassetid://134476270255159'
		end
	end
end

do
	function lib:Uninject()
		configSys.canSave = false

		for i,v in lib.Signal.Connections do
			v:Disconnect()
		end

		for i,v in Tabs do
			for x,d in v.Modules do
				if d.Enabled then
					d:Toggle()
				end
			end
		end

		ScreenGUI:Destroy()
		lib = nil
	end
end

lib.Tabs = {
	Combat = lib:CreateTab('Combat', 'rbxassetid://16095745917'),
	Movement = lib:CreateTab('Movement', 'rbxassetid://10723354671'),
	Render = lib:CreateTab('Render', 'rbxassetid://11963367322'),
	World = lib:CreateTab('World', 'rbxassetid://10734897956'),
	Misc = lib:CreateTab('Misc', 'rbxassetid://10734910187')
}

lib.Tabs.Misc:CreateModule({
	Name = 'Uninject',
	Function = function(callback)
		if callback then
			lib:Uninject()
		end
	end,
})

--[[
	Documentation Example
	by @stav


lib.Tabs = {
	Combat = lib:CreateTab('Combat', 'rbxassetid://16095745917'),
	Movement = lib:CreateTab('Movement', 'rbxassetid://10723354671'),
	Render = lib:CreateTab('Render', 'rbxassetid://11963367322'),
	World = lib:CreateTab('World', 'rbxassetid://10734897956'),
	Misc = lib:CreateTab('Misc', 'rbxassetid://10734910187')
}

local Killaura
Killaura = lib.Tabs.Combat:CreateModule({
	Name = 'Killaura',
	Function = function(callback)
		print(callback)
	end,
})
Killaura:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 18,
	Function = function(callback)
		print(callback)
	end,
})
Killaura:CreateToggle({
	Name = 'Face Target',
	Function = function(callback)
		print(callback)
	end,
})
Killaura:CreateDropdown({
	Name = 'Sort',
	Options = {'Health', 'Distance'},
	Default = 'Health', -- Default should automatically be the Default option or Options[1]
	Function = function(callback)
		print(callback)
	end,
})

lib.Tabs.Combat:CreateModule({
	Name = 'NoKnockback',
	Function = function(callback)
		print(callback)
	end,
})

lib.Tabs.Combat:CreateModule({
	Name = 'Aimbot',
	Function = function(callback)
		print(callback)
	end,
})

lib.Tabs.Movement:CreateModule({
	Name = 'NoSlow',
	Function = function(callback)
		print(callback)
	end,
})

lib.Tabs.Misc:CreateModule({
	Name = 'Uninject',
	Function = function(callback)
		if callback then
			lib:Uninject()
		end
	end,
})
]]

shared.Library = lib
return lib
