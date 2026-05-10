-- original script by DOXPLOV, edited by @imjudealonzo
-- i rewrote this so it's easier to read and i also added a few features
-- original script creator youtube: https://www.youtube.com/c/DOXPLOV/
------------------------------------------------------------------------


-- Sandboxes a function so "script" refers to the given instance
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
Tool.Name        = "Telekinesis Gun"
Tool.CanBeDropped = false
Tool.Parent      = mas

-- Invisible handle (required by Roblox for tool grip)
local Handle = Instance.new("Part")
Handle.Name         = "Handle"
Handle.Material     = Enum.Material.Neon
Handle.BrickColor   = BrickColor.new("Cyan")
Handle.Color        = Color3.new(0.0157, 0.6863, 0.9255)
Handle.Transparency = 1
Handle.CanCollide   = false
Handle.FormFactor   = Enum.FormFactor.Custom
Handle.Size         = Vector3.new(1, 0.4, 0.3)
Handle.CFrame       = CFrame.new(-55.2695, 0.6965, 0.3832,
	0.9640, -4.98e-05, 0.2659, 4.80e-05, 1, 1.33e-05, -0.2659, -5.31e-08, 0.9640)
Handle.BottomSurface = Enum.SurfaceType.Smooth
Handle.TopSurface    = Enum.SurfaceType.Smooth
Handle.Parent        = Tool
Instance.new("CylinderMesh", Handle).Scale = Vector3.new(0.1, 0.1, 0.1)

-- Muzzle / shoot point
local Shoot = Instance.new("Part")
Shoot.Name         = "Shoot"
Shoot.Material     = Enum.Material.Neon
Shoot.BrickColor   = BrickColor.new("Cyan")
Shoot.Color        = Color3.new(0.0157, 0.6863, 0.9255)
Shoot.Reflectance  = 0.3
Shoot.Transparency = 1
Shoot.CanCollide   = false
Shoot.FormFactor   = Enum.FormFactor.Custom
Shoot.Size         = Vector3.new(0.2, 0.25, 0.31)
Shoot.CFrame       = CFrame.new(-54.7998, 0.7743, -0.7574,
	-0.0246, 0.9997, 0.0046, 0.0169, 0.0050, -0.9998, -0.9996, -0.0245, -0.0170)
Shoot.BottomSurface = Enum.SurfaceType.Smooth
Shoot.TopSurface    = Enum.SurfaceType.Smooth
Shoot.Parent        = Tool

-- Glowing barrel cylinder
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
GlowBarrel.Parent = Tool

-- Top decorative fin
local GlowFin1 = Instance.new("Part")
GlowFin1.Name         = "GlowPart"
GlowFin1.Material     = Enum.Material.Neon
GlowFin1.BrickColor   = BrickColor.new("Cyan")
GlowFin1.Color        = Color3.new(0.0157, 0.6863, 0.9255)
GlowFin1.Transparency = 0.5
GlowFin1.Size         = Vector3.new(0.28, 0.26, 0.2)
GlowFin1.CFrame       = CFrame.new(-54.9809, 0.9984, 0.7994,
	0.0074, 0.5630, -0.8265, 4.73e-11, 0.8265, 0.5630, 1.0000, -0.0041, 0.0061)
GlowFin1.Parent = Tool

-- Bottom decorative fin
local GlowFin2 = Instance.new("Part")
GlowFin2.Name         = "GlowPart"
GlowFin2.Material     = Enum.Material.Neon
GlowFin2.BrickColor   = BrickColor.new("Cyan")
GlowFin2.Color        = Color3.new(0.0157, 0.6863, 0.9255)
GlowFin2.Transparency = 0.5
GlowFin2.Size         = Vector3.new(0.28, 0.26, 0.2)
GlowFin2.CFrame       = CFrame.new(-54.5909, 0.9784, 0.7994,
	-0.0830, -0.5845, -0.8072, 0.0241, 0.8085, -0.5880, 0.9963, -0.0683, -0.0530)
GlowFin2.Parent = Tool

-- AnimateValue used by the Animate script to trigger arm animations
local AnimateValue = Instance.new("StringValue")
AnimateValue.Name   = "AnimateValue"
AnimateValue.Value  = "None"
AnimateValue.Parent = Tool

----------------------------------------------------------------------------------------------
-- Glow Scripts (one per glowing part — pulses transparency up and down)
-----------------------------------------------------------------------------------------------

local GLOW_LEVELS = {0.5, 0.6, 0.7, 0.8, 0.9, 0.8, 0.7, 0.6}

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

----------------------------------------------------------------------------
-- LineConnect Script (draws a laser beam between two parts; spawned dynamically)
--------------------------------------------------------------------------------

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
	local checkVal = script.Part2  -- laser disappears when this is nil

	local line = Instance.new("Part")
	line.Name        = "Laser"
	line.TopSurface  = 0
	line.BottomSurface = 0
	line.Locked      = true
	line.CanCollide  = false
	line.Anchored    = true
	line.formFactor  = 0
	line.Size        = Vector3.new(0.4, 0.4, 1)
	line.Material    = "Neon"
	line.Transparency = 0.2
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

--------------------------------------------------------------------------------
-- qPerfectionWeld Script (welds all parts in the model to the Handle)
--------------------------------------------------------------------------------

local WeldScript = Instance.new("Script")
WeldScript.Name   = "qPerfectionWeld"
WeldScript.Parent = Tool
table.insert(cors, sandbox(WeldScript, function()
	local NEVER_BREAK_JOINTS = false

	local HINGE_SURFACES   = {"Hinge", "Motor", "SteppingMotor"}
	local SURFACE_NAMES    = {"TopSurface","BottomSurface","LeftSurface","RightSurface","FrontSurface","BackSurface"}

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
			if hasHingeSurface(item) or not item:IsDescendantOf(script.Parent) then
				return false
			end
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
			local v        = Instance.new("CFrameValue", part)
			v.Name         = "qRelativeCFrameWeldValue"
			v.Archivable   = true
			v.Value        = weld.C1
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
		for _, part in ipairs(parts) do
			part.Anchored = false
		end
		primary.Anchored = false

		return tool
	end

	local tool = doWeld()
	if tool and script.ClassName == "Script" then
		script.Parent.AncestryChanged:Connect(function() doWeld() end)
	end
end))

-------------------------------------------------------------------------------------------
-- Animate Script (arm/neck poses when tool is equipped, with shoot/reload anims)
-----------------------------------------------------------------------------------------

local AnimateScript = Instance.new("LocalScript")
AnimateScript.Name   = "Animate"
AnimateScript.Parent = Tool
table.insert(cors, sandbox(AnimateScript, function()
	local Tool = script.Parent
	local welds = {}
	local arms, torso, neck
	local DEFAULT_NECK_C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

	-- Helper: build weld CFrames for each arm
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

	-- Each frame: {leftArmCF, rightArmCF}
	local SHOOT_FRAMES = {
		{leftArmCF(0),    rightArmCF(-90)},
		{leftArmCF(0.05), rightArmCF(-90)},
		{leftArmCF(0.1),  rightArmCF(-95)},
		{leftArmCF(0.3),  rightArmCF(-110)},
		{leftArmCF(0.35), rightArmCF(-115)},
		{leftArmCF(0.4),  rightArmCF(-120)},
		{leftArmCF(0),    rightArmCF(-90)},  -- return to idle
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
		{leftArmCF(0,    0.8), rightArmCF(-90)},  -- return to idle
	}

	Tool.Equipped:Connect(function(mouse)
		wait(0.01)
		local char = Tool.Parent
		arms  = {char:FindFirstChild("Left Arm"), char:FindFirstChild("Right Arm")}
		torso = char:FindFirstChild("Torso")
		neck  = torso.Neck

		local head           = char:FindFirstChild("Head")
		local leftShoulder   = torso:FindFirstChild("Left Shoulder")
		local rightShoulder  = torso:FindFirstChild("Right Shoulder")
		leftShoulder.Part1   = nil
		rightShoulder.Part1  = nil

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

---------------------------------------------------------------------------
-- Aim Script (rotates character neck/shoulder/torso to track the mouse)
--------------------------------------------------------------------------------

local AimScript = Instance.new("LocalScript")
AimScript.Parent = Tool
table.insert(cors, sandbox(AimScript, function()
	local RunService          = game:GetService("RunService")
	local ContextActionService = game:GetService("ContextActionService")
	local UserInputService    = game:GetService("UserInputService")

	local player      = game.Players.LocalPlayer
	local mouse       = player:GetMouse()
	local Tool        = script.Parent
	local screenSpace = require(Tool:WaitForChild("ScreenSpace"))

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

		-- Vertical angle (neck + shoulder)
		local toMouse   = (targetPos - head.Position).unit
		local angle     = math.acos(math.clamp(toMouse:Dot(Vector3.new(0,1,0)), -1, 1))
		local neckAngle = math.min(angle, math.rad(110))
		neck.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(math.pi - neckAngle, math.pi, 0)

		-- Horizontal angle (torso rotation)
		local armOrigin  = torso.Position + torso.CFrame:vectorToWorldSpace(
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
		mouse.Icon    = ""
		neck.C0       = savedNeckC0
		shoulder.C0   = savedShoulderC0
	end)
end))

----------------------------------------------------------------------------
-- Main Script (telekinesis grab, move, and utility key bindings)
--------------------------------------------------------------------------

local MainScript = Instance.new("LocalScript")
MainScript.Name   = "MainScript"
MainScript.Parent = Tool
table.insert(cors, sandbox(MainScript, function()
	wait()
	local tool        = script.Parent
	local lineconnect = tool.LineConnect

	local object    = nil   -- currently grabbed part
	local mousedown = false
	local dist      = nil
	local objval    = nil   -- ObjectValue pointing to grabbed part (for laser cleanup)
	local hooked    = false

	-- Strong BodyPosition for moving grabbed objects
	local BP = Instance.new("BodyPosition")
	BP.maxForce = Vector3.new(math.huge, math.huge, math.huge)
	BP.P        = BP.P * 10

	-- Weaker BodyPosition for hooking the player to an object
	local hookBP = BP:Clone()
	hookBP.maxForce = Vector3.new(30000, 30000, 30000)

	-- Small glowing sphere that travels with the beam tip
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

	local front = tool.Shoot   -- origin of the beam
	local color = tool.Shoot   -- source of beam color (reads BrickColor/Reflectance)

	-- Clones the LineConnect script and wires it up between two parts
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

	-- Handles the full grab lifecycle: find target -> move target -> release
	local function grabObject(mouse)
		if mousedown then return end
		mousedown = true

		-- Beam tip coroutine: moves a point part until a grab is confirmed
		coroutine.wrap(function()
			local p = point:Clone()
			p.Parent = tool
			spawnLaser(front, p, workspace)
			while mousedown and object == nil do
				if mouse.Target then
					p.CFrame = CFrame.new(mouse.Hit.p)
				else
					p.CFrame = CFrame.new(front.Position + CFrame.new(front.Position, mouse.Hit.p).lookVector * 1000)
				end
				wait()
			end
			if object then spawnLaser(front, object, workspace) end
			p:Remove()
		end)()

		-- Waits for a valid, non-anchored part under the cursor
		while mousedown do
			local t = mouse.Target
			if t and not t.Anchored then
				object = t
				dist   = (object.Position - front.Position).magnitude
				break
			end
			wait()
		end

		-- Move object to follow cursor
		while mousedown do
			if not object or not object.Parent then break end
			BP.Parent   = object
			BP.position = front.Position + CFrame.new(front.Position, mouse.Hit.p).lookVector * dist
			wait()
		end

		BP:Remove()
		object = nil
		if objval then objval.Value = nil end
	end

	-- Key bindings while tool is equipped
	local function handleKey(key, mouse)
		key = key:lower()

		if key == "q" then
			dist = math.max((dist or 5) - 5, 5)                   -- pull object closer

		elseif key == "e" then
			dist = (dist or 0) + 5                                 -- push object further

		elseif key == "t" and object then                          -- freeze object rotation
			local bg = Instance.new("BodyGyro", object)
			bg.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bg.cframe    = CFrame.new(object.CFrame.p)
			repeat wait() until object.CFrame == CFrame.new(object.CFrame.p)
			bg:Remove()
			object.Velocity    = Vector3.new(0, 0, 0)
			object.RotVelocity = Vector3.new(0, 0, 0)

		elseif key == "r" and object then                          -- disintegrate object
			color.BrickColor = BrickColor.Black()
			point.BrickColor = BrickColor.White()
			object.Parent = nil
			wait(0.48)
			color.BrickColor = BrickColor.new("Toothpaste")
			point.BrickColor = BrickColor.new("Toothpaste")

		elseif key == "x" and object then                          -- duplicate grabbed object
			local clone = object:Clone()
			for _, v in ipairs(clone:GetChildren()) do
				if v.ClassName == "BodyPosition" or v.ClassName == "BodyGyro" then v:Remove() end
			end
			clone.Parent = object.Parent
			object    = clone
			mousedown = false
			mousedown = true
			spawnLaser(front, object, workspace)
			while mousedown do
				if not object.Parent then break end
				BP.Parent   = object
				BP.position = front.Position + CFrame.new(front.Position, mouse.Hit.p).lookVector * dist
				wait()
			end
			BP:Remove()
			object = nil
			if objval then objval.Value = nil end

		elseif key == "c" then                                     -- spawn a weighted cube
			local cube = Instance.new("Part", workspace)
			cube.Locked       = true
			cube.Name         = "WeightedStorageCube"
			cube.Size         = Vector3.new(4, 4, 4)
			cube.formFactor   = 0
			cube.TopSurface   = 0
			cube.BottomSurface = 0
			cube.CFrame       = CFrame.new(mouse.Hit.p) + Vector3.new(0, 2, 0)
			for face = 0, 5 do
				local d = Instance.new("Decal", cube)
				d.Name    = "WeightedStorageCubeDecal"
				d.Texture = "http://www.roblox.com/asset/?id=2662260"
				d.Face    = face
			end

		elseif string.byte(key) == 27 and object then             -- explode object (ESC)
			Instance.new("Explosion", workspace).Position = object.Position
			color.BrickColor = BrickColor.Black()
			point.BrickColor = BrickColor.White()
			wait(0.48)
			color.BrickColor = BrickColor.White()
			point.BrickColor = BrickColor.Black()

		elseif key == "" and object then                           -- hook player to object
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

		elseif key == "" then                                      -- reset dist to 15
			dist = 15
		end
	end

	tool.Equipped:Connect(function(mouse)
		local human = tool.Parent.Humanoid
		human.Changed:Connect(function()
			if human.Health == 0 then
				mousedown = false
				BP:Remove()
				point:Remove()
				tool:Remove()
			end
		end)
		mouse.Button1Down:Connect(function() grabObject(mouse) end)
		mouse.Button1Up:Connect(function() mousedown = false end)
		mouse.KeyDown:Connect(function(key) handleKey(key, mouse) end)
		mouse.Icon = "rbxassetid://2184939409"
	end)
end))

-----------------------------------------------------------------------------
-- deploy and tool persistence
------------------------------------------------------------------

-- Moves the tool into the player's backpack
for _, v in ipairs(mas:GetChildren()) do
	v.Parent = game:GetService("Players").LocalPlayer.Backpack
	pcall(function() v:MakeJoints() end)
end
mas:Destroy()

-- Run all sandboxed scripts
for _, v in ipairs(cors) do
	spawn(function() pcall(v) end)
end

-- Re-add the tool after every death so it persists across respawns
local player    = game:GetService("Players").LocalPlayer
local savedTool = player.Backpack:WaitForChild("Telekinesis Gun"):Clone()

player.CharacterAdded:Connect(function()
	wait()  -- let the backpack initialize
	local hasIt = player.Backpack:FindFirstChild("Telekinesis Gun")
		or (player.Character and player.Character:FindFirstChild("Telekinesis Gun"))
	if not hasIt then
		savedTool:Clone().Parent = player.Backpack
	end
end)