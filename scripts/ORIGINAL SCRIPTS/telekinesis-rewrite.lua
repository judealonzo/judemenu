-- original script by DOXPLOV, edited by @imjudealonzo
-- i rewrote this so it's easier to read and i also added a few features
-- original script creator youtube: https://www.youtube.com/c/DOXPLOV/
------------------------------------------------------------------------
local function sandbox(var, func)
	local env = getfenv(func)
	setfenv(func, setmetatable({}, {
		__index = function(_, k)
			return k == "script" and var or env[k]
		end
	}))
	return func
end

local cors = {}
local mas  = Instance.new("Model", game:GetService("Lighting"))

--------------------------
-- Tool & Parts
--------------------------

local Tool = Instance.new("Tool")
Tool.Name         = "Telekinesis Gun"
Tool.CanBeDropped = false
Tool.Parent       = mas

local Handle = Instance.new("Part")
Handle.Name          = "Handle"
Handle.Material      = Enum.Material.Neon
Handle.BrickColor    = BrickColor.new("Cyan")
Handle.Color         = Color3.new(0.0157, 0.6863, 0.9255)
Handle.Transparency  = 1
Handle.CanCollide    = false
Handle.FormFactor    = Enum.FormFactor.Custom
Handle.Size          = Vector3.new(1, 0.4, 0.3)
Handle.CFrame        = CFrame.new(-55.2695, 0.6965, 0.3832,
	0.9640, -4.98e-05, 0.2659, 4.80e-05, 1, 1.33e-05, -0.2659, -5.31e-08, 0.9640)
Handle.BottomSurface = Enum.SurfaceType.Smooth
Handle.TopSurface    = Enum.SurfaceType.Smooth
Handle.Parent        = Tool
Instance.new("CylinderMesh", Handle).Scale = Vector3.new(0.1, 0.1, 0.1)

local Shoot = Instance.new("Part")
Shoot.Name          = "Shoot"
Shoot.Material      = Enum.Material.Neon
Shoot.BrickColor    = BrickColor.new("Cyan")
Shoot.Color         = Color3.new(0.0157, 0.6863, 0.9255)
Shoot.Reflectance   = 0.3
Shoot.Transparency  = 1
Shoot.CanCollide    = false
Shoot.FormFactor    = Enum.FormFactor.Custom
Shoot.Size          = Vector3.new(0.2, 0.25, 0.31)
Shoot.CFrame        = CFrame.new(-54.7998, 0.7743, -0.7574,
	-0.0246, 0.9997, 0.0046, 0.0169, 0.0050, -0.9998, -0.9996, -0.0245, -0.0170)
Shoot.BottomSurface = Enum.SurfaceType.Smooth
Shoot.TopSurface    = Enum.SurfaceType.Smooth
Shoot.Parent        = Tool

local GlowBarrel = Instance.new("Part")
GlowBarrel.Name         = "GlowPart"
GlowBarrel.Material     = Enum.Material.Neon
GlowBarrel.BrickColor   = BrickColor.new("Cyan")
GlowBarrel.Color        = Color3.new(0.0157, 0.6863, 0.9255)
GlowBarrel.Transparency = 0.5
GlowBarrel.Shape        = Enum.PartType.Cylinder
GlowBarrel.Size         = Vector3.new(1.2, 0.65, 2)
GlowBarrel.CFrame       = CFrame.new(-54.8192, 0.7735, -0.0523,
	0.0074, 4.68e-11, -1.0000, 4.73e-11, 1, 1.42e-10, 1.0000, 5.09e-11, 0.0074)
GlowBarrel.Parent       = Tool

local GlowFin1 = Instance.new("Part")
GlowFin1.Name         = "GlowPart"
GlowFin1.Material     = Enum.Material.Neon
GlowFin1.BrickColor   = BrickColor.new("Cyan")
GlowFin1.Color        = Color3.new(0.0157, 0.6863, 0.9255)
GlowFin1.Transparency = 0.5
GlowFin1.Size         = Vector3.new(0.28, 0.26, 0.2)
GlowFin1.CFrame       = CFrame.new(-54.9809, 0.9984, 0.7994,
	0.0074, 0.5630, -0.8265, 4.73e-11, 0.8265, 0.5630, 1.0000, -0.0041, 0.0061)
GlowFin1.Parent       = Tool

local GlowFin2 = Instance.new("Part")
GlowFin2.Name         = "GlowPart"
GlowFin2.Material     = Enum.Material.Neon
GlowFin2.BrickColor   = BrickColor.new("Cyan")
GlowFin2.Color        = Color3.new(0.0157, 0.6863, 0.9255)
GlowFin2.Transparency = 0.5
GlowFin2.Size         = Vector3.new(0.28, 0.26, 0.2)
GlowFin2.CFrame       = CFrame.new(-54.5909, 0.9784, 0.7994,
	-0.0830, -0.5845, -0.8072, 0.0241, 0.8085, -0.5880, 0.9963, -0.0683, -0.0530)
GlowFin2.Parent       = Tool

local AnimateValue = Instance.new("StringValue")
AnimateValue.Name   = "AnimateValue"
AnimateValue.Value  = "None"
AnimateValue.Parent = Tool

------------------------------
-- Glow Scripts
----------------------------------------
local function attachGlowScript(part)
	local s = Instance.new("Script")
	s.Name   = "Glow Script"
	s.Parent = part
	table.insert(cors, sandbox(s, function()
		local levels = {0.5, 0.6, 0.7, 0.8, 0.9, 0.8, 0.7, 0.6}
		while true do
			for _, t in ipairs(levels) do
				script.Parent.Transparency = t
				wait(0.05)
			end
		end
	end))
end

attachGlowScript(GlowBarrel)
attachGlowScript(GlowFin1)
attachGlowScript(GlowFin2)

----------------------------------
-- LineConnect Script
-----------------------------------------

local LineConnect = Instance.new("Script")
LineConnect.Name     = "LineConnect"
LineConnect.Disabled = true
LineConnect.Parent   = Tool
table.insert(cors, sandbox(LineConnect, function()
	wait()
	local part1    = script.Part1.Value
	local part2    = script.Part2.Value
	local parent   = script.Par.Value
	local colorRef = script.Color
	local checkVal = script.Part2

	local line = Instance.new("Part")
	line.Name          = "Laser"
	line.TopSurface    = 0
	line.BottomSurface = 0
	line.Locked        = true
	line.CanCollide    = false
	line.Anchored      = true
	line.formFactor    = 0
	line.Size          = Vector3.new(0.4, 0.4, 1)
	line.Material      = "Neon"
	line.Transparency  = 0.2
	local mesh = Instance.new("BlockMesh", line)

	while true do
		if checkVal.Value == nil then break end
		if not part1 or not part2 or not parent then break end
		if not part1.Parent or not part2.Parent or not parent.Parent then break end

		local dist = (part1.Position - part2.Position).magnitude
		local cf   = CFrame.new(part1.Position, part2.Position)

		line.Parent      = parent
		line.BrickColor  = colorRef.Value.BrickColor
		line.Reflectance = colorRef.Value.Reflectance
		line.CFrame      = CFrame.new(part1.Position + cf.lookVector * dist / 2, part2.Position)
		mesh.Scale       = Vector3.new(0.25, 0.25, dist)
		wait()
	end

	line:Remove()
	script:Remove()
end))

--------------------------------
-- qPerfectionWeld Script
----------------------------------

local WeldScript = Instance.new("Script")
WeldScript.Name   = "qPerfectionWeld"
WeldScript.Parent = Tool
table.insert(cors, sandbox(WeldScript, function()
	local NEVER_BREAK_JOINTS = false
	local HINGE_SURFACES     = {"Hinge", "Motor", "SteppingMotor"}
	local SURFACE_NAMES      = {"TopSurface","BottomSurface","LeftSurface","RightSurface","FrontSurface","BackSurface"}

	local function eachDescendant(instance, fn)
		fn(instance)
		for _, child in ipairs(instance:GetChildren()) do eachDescendant(child, fn) end
	end

	local function nearestParentOfClass(instance, className)
		local node = instance
		repeat
			node = node.Parent
			if node == nil then return nil end
		until node:IsA(className)
		return node
	end

	local function getBaseParts(root)
		local parts = {}
		eachDescendant(root, function(v) if v:IsA("BasePart") then parts[#parts+1] = v end end)
		return parts
	end

	local function hasHingeSurface(part)
		for _, surf in ipairs(SURFACE_NAMES) do
			for _, hinge in ipairs(HINGE_SURFACES) do
				if part[surf].Name == hinge then return true end
			end
		end
		return false
	end

	local function shouldBreakJoints(part)
		if NEVER_BREAK_JOINTS or hasHingeSurface(part) then return false end
		local connected = part:GetConnectedParts()
		if #connected == 1 then return false end
		for _, item in ipairs(connected) do
			if hasHingeSurface(item) or not item:IsDescendantOf(script.Parent) then return false end
		end
		return true
	end

	local function weldTogether(mainPart, part)
		local relVal = part:FindFirstChild("qRelativeCFrameWeldValue")
		local weld   = part:FindFirstChild("qCFrameWeldThingy") or Instance.new("Weld")
		weld.Name    = "qCFrameWeldThingy"
		weld.Part0   = mainPart
		weld.Part1   = part
		weld.C0      = CFrame.new()
		weld.C1      = relVal and relVal.Value or part.CFrame:toObjectSpace(mainPart.CFrame)
		weld.Parent  = part
		if not relVal then
			local v      = Instance.new("CFrameValue", part)
			v.Name       = "qRelativeCFrameWeldValue"
			v.Archivable = true
			v.Value      = weld.C1
		end
	end

	local function doWeld()
		local tool    = nearestParentOfClass(script, "Tool")
		local parts   = getBaseParts(script.Parent)
		local primary = (tool and tool:FindFirstChild("Handle") and tool.Handle:IsA("BasePart") and tool.Handle)
			or (script.Parent:IsA("Model") and script.Parent.PrimaryPart)
			or parts[1]
		if not primary then warn("qPerfectionWeld: No primary part found.") return tool end
		for _, part in ipairs(parts) do
			if shouldBreakJoints(part) then part:BreakJoints() end
		end
		for _, part in ipairs(parts) do
			if part ~= primary then weldTogether(primary, part) end
		end
		for _, part in ipairs(parts) do part.Anchored = false end
		primary.Anchored = false
		return tool
	end

	local tool = doWeld()
	if tool and script.ClassName == "Script" then
		script.Parent.AncestryChanged:Connect(function() doWeld() end)
	end
end))

-------------------
-- Animate Script
------------------------

local AnimateScript = Instance.new("LocalScript")
AnimateScript.Name   = "Animate"
AnimateScript.Parent = Tool
table.insert(cors, sandbox(AnimateScript, function()
	local Tool            = script.Parent
	local welds           = {}
	local arms, torso, neck
	local DEFAULT_NECK_C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

	local function leftArmCF(yaw, y)
		return CFrame.new(1, y or 0.8, 0.9) * CFrame.fromEulerAnglesXYZ(math.rad(290), yaw, math.rad(-90))
	end
	local function rightArmCF(pitch)
		return CFrame.new(-1, 0.8, -1) * CFrame.fromEulerAnglesXYZ(math.rad(pitch), math.rad(-15), 0)
	end

	local function setArms(lc1, rc1)
		if welds[1] then welds[1].C1 = lc1 end
		if welds[2] then welds[2].C1 = rc1 end
	end

	local function playAnimation(frames, delay)
		for _, frame in ipairs(frames) do
			setArms(frame[1], frame[2])
			wait(delay)
		end
	end

	local SHOOT_FRAMES = {
		{leftArmCF(0),    rightArmCF(-90)},
		{leftArmCF(0.05), rightArmCF(-90)},
		{leftArmCF(0.1),  rightArmCF(-95)},
		{leftArmCF(0.3),  rightArmCF(-110)},
		{leftArmCF(0.35), rightArmCF(-115)},
		{leftArmCF(0.4),  rightArmCF(-120)},
		{leftArmCF(0),    rightArmCF(-90)},
	}

	local RELOAD_FRAMES = {
		{leftArmCF(0,    0.8), rightArmCF(-90)},
		{leftArmCF(0.4,  0.8), rightArmCF(-90)},
		{leftArmCF(0.4,  0.8), rightArmCF(-95)},
		{leftArmCF(0.4,  0.8), rightArmCF(-100)},
		{leftArmCF(0.4,  0.8), rightArmCF(-105)},
		{leftArmCF(0.4,  0.8), rightArmCF(-110)},
		{leftArmCF(0.4,  0.8), rightArmCF(-115)},
		{leftArmCF(0.45, 0.8), rightArmCF(-120)},
		{leftArmCF(0.5,  0.9), rightArmCF(-120)},
		{leftArmCF(0.55, 1.0), rightArmCF(-120)},
		{leftArmCF(0.57, 1.1), rightArmCF(-120)},
		{leftArmCF(0.6,  1.2), rightArmCF(-120)},
		{leftArmCF(0.6,  1.3), rightArmCF(-120)},
		{leftArmCF(0,    0.8), rightArmCF(-90)},
	}

	Tool.Equipped:Connect(function(mouse)
		wait(0.01)
		local char = Tool.Parent
		arms  = {char:FindFirstChild("Left Arm"), char:FindFirstChild("Right Arm")}
		torso = char:FindFirstChild("Torso")
		neck  = torso.Neck

		local head          = char:FindFirstChild("Head")
		local leftShoulder  = torso:FindFirstChild("Left Shoulder")
		local rightShoulder = torso:FindFirstChild("Right Shoulder")
		leftShoulder.Part1  = nil
		rightShoulder.Part1 = nil

		local w1 = Instance.new("Weld", head)
		w1.Part0, w1.Part1, w1.C1 = head, arms[1], leftArmCF(0)
		welds[1] = w1

		local w2 = Instance.new("Weld", head)
		w2.Part0, w2.Part1, w2.C1 = head, arms[2], rightArmCF(-90)
		welds[2] = w2

		mouse.Move:Connect(function()
			local dir  = mouse.Hit.p
			local b    = head.Position.Y - dir.Y
			local dist = (head.Position - dir).magnitude
			neck.C0 = DEFAULT_NECK_C0 * CFrame.fromEulerAnglesXYZ(math.asin(b / dist), 0, 0)
			wait(0.1)
		end)
	end)

	Tool.Unequipped:Connect(function()
		if not arms or not torso then return end
		neck.C0 = DEFAULT_NECK_C0
		torso:FindFirstChild("Left Shoulder").Part1  = arms[1]
		torso:FindFirstChild("Right Shoulder").Part1 = arms[2]
		if welds[1] then welds[1].Parent = nil end
		if welds[2] then welds[2].Parent = nil end
	end)

	Tool.AnimateValue.Changed:Connect(function()
		local anim = Tool.AnimateValue.Value
		if anim == "Shoot" then
			playAnimation(SHOOT_FRAMES, 0.00001)
			Tool.AnimateValue.Value = "None"
		elseif anim == "Reload" then
			playAnimation(RELOAD_FRAMES, 0.0001)
			Tool.AnimateValue.Value = "None"
		end
	end)
end))

----------------
-- Aim Script
----------------

local AimScript = Instance.new("LocalScript")
AimScript.Parent = Tool
table.insert(cors, sandbox(AimScript, function()
	local RunService           = game:GetService("RunService")
	local ContextActionService = game:GetService("ContextActionService")
	local UserInputService     = game:GetService("UserInputService")

	local player           = game.Players.LocalPlayer
	local mouse            = player:GetMouse()
	local Tool             = script.Parent
	local screenSpace      = require(Tool:WaitForChild("ScreenSpace"))

	local neck, shoulder, savedNeckC0, savedShoulderC0
	local connection
	local mobileShouldTrack = true

	local function isSitting(character)
		for _, part in ipairs(character.Torso:GetConnectedParts(true)) do
			if part:IsA("Seat") or part:IsA("VehicleSeat") then return true end
		end
		return false
	end

	local function aimAt(targetPos)
		if not mobileShouldTrack then return end
		local char = player.Character
		if char.Humanoid:GetState() == Enum.HumanoidStateType.Swimming then return end

		local torso = char.Torso
		local head  = char.Head
		local arm   = char:FindFirstChild("Right Arm")

		local toMouse   = (targetPos - head.Position).unit
		local angle     = math.acos(math.clamp(toMouse:Dot(Vector3.new(0,1,0)), -1, 1))
		local neckAngle = math.min(angle, math.rad(110))
		neck.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(math.pi - neckAngle, math.pi, 0)

		local armOrigin   = torso.Position + torso.CFrame:vectorToWorldSpace(
			Vector3.new(torso.Size.X/2 + arm.Size.X/2, torso.Size.Y/2 - arm.Size.Z/2, 0))
		local toMouseFlat = ((targetPos - armOrigin) * Vector3.new(1,0,1)).unit
		local lookFlat    = (torso.CFrame.lookVector * Vector3.new(1,0,1)).unit
		local lateral     = math.acos(math.clamp(toMouseFlat:Dot(lookFlat), -1, 1))

		if isSitting(char) then
			lateral = math.min(lateral, math.pi / 2)
			if torso.CFrame.lookVector:Cross(toMouseFlat).Y < 0 then lateral = -lateral end
		end

		shoulder.C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(math.pi/2 - angle, math.pi/2 + lateral, 0)

		if not isSitting(char) then
			torso.CFrame = CFrame.new(torso.Position,
				torso.Position + (Vector3.new(targetPos.X, torso.Position.Y, targetPos.Z) - torso.Position).unit)
		end
	end

	local function mobileFrame(touch, processed)
		if processed then return end
		local nearPos = game.Workspace.CurrentCamera.CoordinateFrame:vectorToWorldSpace(
			screenSpace.ScreenToWorld(touch.Position.X, touch.Position.Y, 1))
		nearPos = game.Workspace.CurrentCamera.CoordinateFrame.p - nearPos
		local farPos = game.Workspace.CurrentCamera.CoordinateFrame:vectorToWorldSpace(
			screenSpace.ScreenToWorld(touch.Position.X, touch.Position.Y, 50)) * -1
		if farPos.magnitude > 900 then farPos = farPos.unit * 900 end
		local _, pos = game.Workspace:FindPartOnRay(Ray.new(nearPos, farPos), player.Character)
		if pos then aimAt(pos) end
	end

	Tool.Equipped:Connect(function()
		local torso     = player.Character.Torso
		neck            = torso.Neck
		savedNeckC0     = neck.C0
		shoulder        = torso:FindFirstChild("Right Shoulder")
		savedShoulderC0 = shoulder.C0

		mouse.Icon = "rbxassetid://2184939409"

		if UserInputService.TouchEnabled then
			connection = UserInputService.TouchMoved:Connect(mobileFrame)
			UserInputService.TouchStarted:Connect(function(_, p) mobileShouldTrack = not p end)
			UserInputService.TouchEnded:Connect(function() mobileShouldTrack = false end)
		else
			connection = RunService.RenderStepped:Connect(function() aimAt(mouse.Hit.p) end)
		end

		game.ReplicatedStorage.ROBLOX_PistolEquipEvent:FireServer()

		mouse.Button1Down:Connect(function()
			game.ReplicatedStorage.ROBLOX_PistolFireEvent:FireServer(mouse.Hit.p)
		end)

		ContextActionService:BindActionToInputTypes("Reload", function()
			game.ReplicatedStorage.ROBLOX_PistolReloadEvent:FireServer()
		end, true, "")

		if workspace.FilteringEnabled then
			while connection do
				wait()
				game.ReplicatedStorage.ROBLOX_PistolUpdateEvent:FireServer(neck.C0, shoulder.C0)
			end
		end
	end)

	Tool.Unequipped:Connect(function()
		if connection then connection:Disconnect() end
		ContextActionService:UnbindAction("Reload")
		game.ReplicatedStorage.ROBLOX_PistolUnequipEvent:FireServer()
		mouse.Icon  = ""
		neck.C0     = savedNeckC0
		shoulder.C0 = savedShoulderC0
	end)
end))

----------------------------------------------------------------------------
-- Main Script  (grab highlight + keybind GUI + rebinding + toggles)
----------------------------------------------------------------------------

local MainScript = Instance.new("LocalScript")
MainScript.Name   = "MainScript"
MainScript.Parent = Tool
table.insert(cors, sandbox(MainScript, function()
	wait()
	local tool             = script.Parent
	local lineconnect      = tool.LineConnect
	local Players          = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local player           = Players.LocalPlayer

	local object    = nil   -- currently grabbed part
	local mousedown = false
	local dist      = nil
	local objval    = nil
	local hooked    = false

	-- BodyPositions
	local BP = Instance.new("BodyPosition")
	BP.maxForce = Vector3.new(math.huge, math.huge, math.huge)
	BP.P        = BP.P * 10

	local hookBP = BP:Clone()
	hookBP.maxForce = Vector3.new(30000, 30000, 30000)

	-- Beam tip sphere 
	local point = Instance.new("Part")
	point.Locked     = true
	point.Anchored   = true
	point.formFactor = 0
	point.Shape      = 0
	point.Material   = "Neon"
	point.BrickColor = BrickColor.new("Toothpaste")
	point.Size       = Vector3.new(1, 1, 1)
	point.CanCollide = false
	local pointMesh = Instance.new("SpecialMesh", point)
	pointMesh.MeshType = "Sphere"
	pointMesh.Scale    = Vector3.new(0.2, 0.2, 0.2)

	local front = tool.Shoot
	local color = tool.Shoot

	-- GRAB HIGHLIGHT
	local GUN_BLUE = Color3.new(0.0157, 0.6863, 0.9255)

	local grabHighlight = Instance.new("Highlight")
	grabHighlight.FillColor           = GUN_BLUE
	grabHighlight.FillTransparency    = 0.45
	grabHighlight.OutlineColor        = Color3.new(1, 1, 1)
	grabHighlight.OutlineTransparency = 0
	grabHighlight.Enabled             = false
	grabHighlight.Parent              = workspace

	local function setHighlight(part)
		if part then
			grabHighlight.Adornee = part
			grabHighlight.Enabled = true
		else
			grabHighlight.Enabled = false
			grabHighlight.Adornee = nil
		end
	end

	-- KEYBIND TABLE
	--   Default hook/reset keys are "f"/"g" (originals were stripped chars).

	local keybinds = {
		{ id = "pull",      key = "q",   label = "Pull Object Closer",    enabled = true },
		{ id = "push",      key = "e",   label = "Push Object Further",   enabled = true },
		{ id = "freeze",    key = "t",   label = "Freeze Object Rotation", enabled = true },
		{ id = "delete",    key = "r",   label = "Disintegrate Object",   enabled = true },
		{ id = "duplicate", key = "x",   label = "Duplicate Object",      enabled = true },
		{ id = "cube",      key = "c",   label = "Spawn Weighted Cube",   enabled = true },
		{ id = "explode",   key = "esc", label = "Explode Object",        enabled = true },
		{ id = "hook",      key = "f",   label = "Hook Player to Object", enabled = true },
		{ id = "reset",     key = "g",   label = "Reset Distance (15)",   enabled = true },
	}

	-- Returns the keybind entry for a given id
	local function kb(id)
		for _, b in ipairs(keybinds) do
			if b.id == id then return b end
		end
	end

	-- True when rawKey (from mouse.KeyDown) matches a stored key string
	local function rawMatches(storedKey, rawKey)
		if storedKey == "esc" then return string.byte(rawKey) == 27 end
		return rawKey:lower() == storedKey
	end

	-- KEYBIND GUI

	-- Remove any leftover GUI from a previous life
	local existing = player.PlayerGui:FindFirstChild("TelekinesisGUI")
	if existing then existing:Destroy() end

	local menuOpen = true

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name         = "TelekinesisGUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent       = player.PlayerGui

	-- Main frame 
	local frame = Instance.new("Frame")
	frame.Name             = "MainFrame"
	frame.Size             = UDim2.new(0, 330, 0, 370)
	frame.Position         = UDim2.new(0.02, 0, 0.28, 0)
	frame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
	frame.BorderSizePixel  = 0
	frame.ClipsDescendants = true
	frame.Parent           = screenGui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local frameStroke = Instance.new("UIStroke", frame)
	frameStroke.Color     = GUN_BLUE
	frameStroke.Thickness = 2

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Name             = "TitleBar"
	titleBar.Size             = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundColor3 = GUN_BLUE
	titleBar.BorderSizePixel  = 0
	titleBar.ZIndex           = 2
	titleBar.Parent           = frame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size               = UDim2.new(1, -50, 1, 0)
	titleLabel.Position           = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text               = "✦  Jude's Telekinesis"
	titleLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize           = 14
	titleLabel.Font               = Enum.Font.GothamBold
	titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
	titleLabel.ZIndex             = 3
	titleLabel.Parent             = titleBar

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size             = UDim2.new(0, 26, 0, 26)
	closeBtn.Position         = UDim2.new(1, -33, 0.5, -13)
	closeBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
	closeBtn.Text             = "✕"
	closeBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize         = 13
	closeBtn.Font             = Enum.Font.GothamBold
	closeBtn.BorderSizePixel  = 0
	closeBtn.ZIndex           = 4
	closeBtn.Parent           = titleBar
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

	closeBtn.MouseButton1Click:Connect(function()
		menuOpen      = false
		frame.Visible = false
	end)

	--Hint line 
	local hintLabel = Instance.new("TextLabel")
	hintLabel.Size               = UDim2.new(1, -16, 0, 18)
	hintLabel.Position           = UDim2.new(0, 10, 0, 44)
	hintLabel.BackgroundTransparency = 1
	hintLabel.Text               = "RCtrl to toggle  •  Click a key badge to rebind"
	hintLabel.TextColor3         = Color3.fromRGB(90, 155, 200)
	hintLabel.TextSize           = 11
	hintLabel.Font               = Enum.Font.Gotham
	hintLabel.TextXAlignment     = Enum.TextXAlignment.Left
	hintLabel.Parent             = frame

	-- Column headers
	local headersFrame = Instance.new("Frame")
	headersFrame.Size               = UDim2.new(1, -16, 0, 20)
	headersFrame.Position           = UDim2.new(0, 8, 0, 65)
	headersFrame.BackgroundTransparency = 1
	headersFrame.Parent             = frame

	local function makeColHeader(text, xOffset, width)
		local lbl = Instance.new("TextLabel")
		lbl.Size            = UDim2.new(0, width, 1, 0)
		lbl.Position        = UDim2.new(0, xOffset, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text            = text
		lbl.TextColor3      = GUN_BLUE
		lbl.TextSize        = 11
		lbl.Font            = Enum.Font.GothamBold
		lbl.TextXAlignment  = Enum.TextXAlignment.Left
		lbl.Parent          = headersFrame
	end
	makeColHeader("ON",    2,  34)
	makeColHeader("KEY",   40, 56)
	makeColHeader("ACTION", 102, 200)

	-- thin divider
	local divider = Instance.new("Frame")
	divider.Size             = UDim2.new(1, -16, 0, 1)
	divider.Position         = UDim2.new(0, 8, 0, 87)
	divider.BackgroundColor3 = GUN_BLUE
	divider.BackgroundTransparency = 0.55
	divider.BorderSizePixel  = 0
	divider.Parent           = frame

	-- Scrolling list
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size                 = UDim2.new(1, -8, 1, -92)
	scrollFrame.Position             = UDim2.new(0, 4, 0, 91)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel      = 0
	scrollFrame.ScrollBarThickness   = 4
	scrollFrame.ScrollBarImageColor3 = GUN_BLUE
	scrollFrame.CanvasSize           = UDim2.new(0, 0, 0, #keybinds * 46)
	scrollFrame.Parent               = frame

	local listLayout = Instance.new("UIListLayout", scrollFrame)
	listLayout.Padding   = UDim.new(0, 4)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- Row tracking for rebinding UI updates
	local rowObjects   = {}   -- [index] = { keyBtn, kb }
	local rebindingIdx = nil  -- index of keybind currently awaiting a new key

	local function cancelRebind()
		if not rebindingIdx then return end
		local ro = rowObjects[rebindingIdx]
		if ro then
			local stored = ro.kb.key
			ro.keyBtn.Text             = stored == "esc" and "ESC" or stored:upper()
			ro.keyBtn.BackgroundColor3 = Color3.fromRGB(22, 30, 48)
		end
		rebindingIdx = nil
	end

	local function updateToggle(btn, enabled)
		if enabled then
			btn.BackgroundColor3 = Color3.fromRGB(30, 170, 75)
			btn.Text             = "ON"
		else
			btn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
			btn.Text             = "OFF"
		end
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end

	local function buildRow(kb_entry, index)
		local isEven = index % 2 == 0
		local row = Instance.new("Frame")
		row.Name             = "Row_" .. index
		row.Size             = UDim2.new(1, -4, 0, 42)
		row.BackgroundColor3 = isEven
			and Color3.fromRGB(16, 20, 30)
			or  Color3.fromRGB(12, 15, 23)
		row.BorderSizePixel  = 0
		row.LayoutOrder      = index
		row.Parent           = scrollFrame
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

		-- Toggle (ON / OFF)
		local toggleBtn = Instance.new("TextButton")
		toggleBtn.Size            = UDim2.new(0, 34, 0, 24)
		toggleBtn.Position        = UDim2.new(0, 4, 0.5, -12)
		toggleBtn.TextSize        = 10
		toggleBtn.Font            = Enum.Font.GothamBold
		toggleBtn.BorderSizePixel = 0
		toggleBtn.Parent          = row
		Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 5)
		updateToggle(toggleBtn, kb_entry.enabled)

		toggleBtn.MouseButton1Click:Connect(function()
			kb_entry.enabled = not kb_entry.enabled
			updateToggle(toggleBtn, kb_entry.enabled)
		end)

		--  Key badge
		local keyBtn = Instance.new("TextButton")
		keyBtn.Size             = UDim2.new(0, 52, 0, 28)
		keyBtn.Position         = UDim2.new(0, 42, 0.5, -14)
		keyBtn.Text             = kb_entry.key == "esc" and "ESC" or kb_entry.key:upper()
		keyBtn.TextSize         = 12
		keyBtn.Font             = Enum.Font.GothamBold
		keyBtn.TextColor3       = Color3.fromRGB(220, 235, 255)
		keyBtn.BackgroundColor3 = Color3.fromRGB(22, 30, 48)
		keyBtn.BorderSizePixel  = 0
		keyBtn.Parent           = row
		Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 5)
		local keyStroke = Instance.new("UIStroke", keyBtn)
		keyStroke.Color     = GUN_BLUE
		keyStroke.Thickness = 1.5

		keyBtn.MouseButton1Click:Connect(function()
			if rebindingIdx == index then
				-- second click cancels rebind
				cancelRebind()
				return
			end
			cancelRebind()
			rebindingIdx           = index
			keyBtn.Text            = "?"
			keyBtn.BackgroundColor3 = Color3.fromRGB(35, 65, 120)
		end)

		-- Action label 
		local actionLbl = Instance.new("TextLabel")
		actionLbl.Size              = UDim2.new(1, -102, 1, 0)
		actionLbl.Position          = UDim2.new(0, 100, 0, 0)
		actionLbl.BackgroundTransparency = 1
		actionLbl.Text              = kb_entry.label
		actionLbl.TextColor3        = Color3.fromRGB(195, 210, 230)
		actionLbl.TextSize          = 12
		actionLbl.Font              = Enum.Font.Gotham
		actionLbl.TextXAlignment    = Enum.TextXAlignment.Left
		actionLbl.TextTruncate      = Enum.TextTruncate.AtEnd
		actionLbl.Parent            = row

		rowObjects[index] = { keyBtn = keyBtn, kb = kb_entry }
	end

	for i, kb_entry in ipairs(keybinds) do
		buildRow(kb_entry, i)
	end

	-- Dragging
	local dragging  = false
	local dragStart = Vector2.new()
	local startPos  = UDim2.new()

	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			startPos  = frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging
		and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- Menu toggle + rebind via UserInputService 
	UserInputService.InputBegan:Connect(function(input, _gameProcessed)
		-- Toggle menu with Right Control
		if input.KeyCode == Enum.KeyCode.RightControl then
			menuOpen      = not menuOpen
			frame.Visible = menuOpen
			return
		end

		-- Capture rebind key press
		if rebindingIdx then
			local newKey
			if input.KeyCode == Enum.KeyCode.Escape then
				newKey = "esc"
			elseif input.KeyCode ~= Enum.KeyCode.Unknown then
				-- KeyCode.Name is e.g. "A", "F1", "LeftShift" — keep it lowercased
				newKey = input.KeyCode.Name:lower()
			end

			if newKey then
				local ro = rowObjects[rebindingIdx]
				if ro then
					ro.kb.key              = newKey
					ro.keyBtn.Text         = newKey == "esc" and "ESC" or newKey:upper()
					ro.keyBtn.BackgroundColor3 = Color3.fromRGB(22, 30, 48)
				end
				rebindingIdx = nil
			end
		end
	end)


	-- LASER SPAWNER
	local function spawnLaser(part1, part2, parent)
		local s = lineconnect:Clone()
		local function makeVal(name, value)
			local v = Instance.new("ObjectValue", s)
			v.Name, v.Value = name, value
			return v
		end
		makeVal("Part1", part1)
		local p2val = makeVal("Part2", part2)
		makeVal("Par", parent)
		makeVal("Color", color)
		if part2 == object then objval = p2val end
		s.Disabled = false
		s.Parent   = workspace
	end

	-- GRAB OBJECT  (with highlight)
	local function grabObject(mouse)
		if mousedown then return end
		mousedown = true

		-- Beam tip travels to cursor until a valid part is found
		coroutine.wrap(function()
			local p = point:Clone()
			p.Parent = tool
			spawnLaser(front, p, workspace)
			while mousedown and object == nil do
				if mouse.Target then
					p.CFrame = CFrame.new(mouse.Hit.p)
				else
					p.CFrame = CFrame.new(
						front.Position + CFrame.new(front.Position, mouse.Hit.p).lookVector * 1000)
				end
				wait()
			end
			if object then spawnLaser(front, object, workspace) end
			p:Remove()
		end)()

		-- Wait for a valid non-anchored target
		while mousedown do
			local t = mouse.Target
			if t and not t.Anchored then
				object = t
				dist   = (object.Position - front.Position).magnitude
				setHighlight(object)   -- ← white outline + blue glow ON
				break
			end
			wait()
		end

		-- Move object
		while mousedown do
			if not object or not object.Parent then break end
			BP.Parent   = object
			BP.position = front.Position
				+ CFrame.new(front.Position, mouse.Hit.p).lookVector * dist
			wait()
		end

		BP:Remove()
		setHighlight(nil)   -- ← highlight OFF
		object = nil
		if objval then objval.Value = nil end
	end

	-- KEY HANDLER  (reads keybind table; skips disabled entries)
	local function handleKey(rawKey, mouse)

		local function check(id)
			local b = kb(id)
			return b and b.enabled and rawMatches(b.key, rawKey)
		end

		-- Pull closer
		if check("pull") then
			dist = math.max((dist or 5) - 5, 5)
		end

		-- Push further
		if check("push") then
			dist = (dist or 0) + 5
		end

		-- Freeze rotation
		if check("freeze") and object then
			local bg = Instance.new("BodyGyro", object)
			bg.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bg.cframe    = CFrame.new(object.CFrame.p)
			repeat wait() until object.CFrame == CFrame.new(object.CFrame.p)
			bg:Remove()
			object.Velocity    = Vector3.new(0, 0, 0)
			object.RotVelocity = Vector3.new(0, 0, 0)
		end

		-- Disintegrate
		if check("delete") and object then
			color.BrickColor = BrickColor.Black()
			point.BrickColor = BrickColor.White()
			setHighlight(nil)
			object.Parent = nil
			wait(0.48)
			color.BrickColor = BrickColor.new("Toothpaste")
			point.BrickColor = BrickColor.new("Toothpaste")
		end

		-- Duplicate
		if check("duplicate") and object then
			local clone = object:Clone()
			for _, v in ipairs(clone:GetChildren()) do
				if v.ClassName == "BodyPosition" or v.ClassName == "BodyGyro" then v:Remove() end
			end
			clone.Parent = object.Parent
			setHighlight(nil)
			object    = clone
			mousedown = false
			mousedown = true
			setHighlight(object)
			spawnLaser(front, object, workspace)
			while mousedown do
				if not object.Parent then break end
				BP.Parent   = object
				BP.position = front.Position
					+ CFrame.new(front.Position, mouse.Hit.p).lookVector * dist
				wait()
			end
			BP:Remove()
			setHighlight(nil)
			object = nil
			if objval then objval.Value = nil end
		end

		-- Spawn weighted cube
		if check("cube") then
			local cube = Instance.new("Part", workspace)
			cube.Locked        = true
			cube.Name          = "WeightedStorageCube"
			cube.Size          = Vector3.new(4, 4, 4)
			cube.formFactor    = 0
			cube.TopSurface    = 0
			cube.BottomSurface = 0
			cube.CFrame        = CFrame.new(mouse.Hit.p) + Vector3.new(0, 2, 0)
			for face = 0, 5 do
				local d = Instance.new("Decal", cube)
				d.Name    = "WeightedStorageCubeDecal"
				d.Texture = "http://www.roblox.com/asset/?id=2662260"
				d.Face    = face
			end
		end

		-- Explode
		if check("explode") and object then
			Instance.new("Explosion", workspace).Position = object.Position
			color.BrickColor = BrickColor.Black()
			point.BrickColor = BrickColor.White()
			setHighlight(nil)
			wait(0.48)
			color.BrickColor = BrickColor.White()
			point.BrickColor = BrickColor.Black()
		end

		-- Hook player to object
		if check("hook") and object then
			if not hooked then
				hooked          = true
				hookBP.position = object.Position
				local torso = tool.Parent:FindFirstChild("Torso")
				if torso then
					hookBP.Parent = torso
					dist = (object.Size.X + object.Size.Y + object.Size.Z) + 5
				end
			else
				hooked        = false
				hookBP.Parent = nil
			end
		end

		-- Reset distance
		if check("reset") then
			dist = 15
		end
	end

	-- EQUIP / UNEQUIP
	tool.Equipped:Connect(function(mouse)
		local human = tool.Parent.Humanoid
		human.Changed:Connect(function()
			if human.Health == 0 then
				mousedown = false
				BP:Remove()
				point:Remove()
				setHighlight(nil)
				tool:Remove()
			end
		end)

		mouse.Button1Down:Connect(function() grabObject(mouse) end)
		mouse.Button1Up:Connect(function()
			mousedown = false
			setHighlight(nil)
		end)
		mouse.KeyDown:Connect(function(key) handleKey(key, mouse) end)
		mouse.Icon = "rbxassetid://2184939409"
	end)

	tool.Unequipped:Connect(function()
		mousedown = false
		setHighlight(nil)
	end)
end))

-- Deploy and tool persistence
for _, v in ipairs(mas:GetChildren()) do
	v.Parent = game:GetService("Players").LocalPlayer.Backpack
	pcall(function() v:MakeJoints() end)
end
mas:Destroy()

for _, v in ipairs(cors) do
	spawn(function() pcall(v) end)
end

local player    = game:GetService("Players").LocalPlayer
local savedTool = player.Backpack:WaitForChild("Telekinesis Gun"):Clone()

player.CharacterAdded:Connect(function()
	wait()
	local hasIt = player.Backpack:FindFirstChild("Telekinesis Gun")
		or (player.Character and player.Character:FindFirstChild("Telekinesis Gun"))
	if not hasIt then
		savedTool:Clone().Parent = player.Backpack
	end
end)
