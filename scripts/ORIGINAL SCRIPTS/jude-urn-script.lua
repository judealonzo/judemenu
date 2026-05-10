-- Target models list
local targets = { "Afton", "BB", "Ballora", "Bidybab", "Bloodworm", "Bonnie", "Buff Helpy", "COMM-A267", "Chica", "Circus Baby", "Crybaby", "DOOM HEAD", "Dee Dee", "Doctor Squidward", "El Chip", "Elizabeth", "Endo 02", "Endo 03", "Ennard", "Foxy", "Freddy", "Funtime Chica", "Funtime Foxy", "Funtime Freddy", "Golden Freddy", "Helpy", "Huggestables", "JJ", "Jack O' Bonnie", "Jack O' Chica", "Lefty", "Mangle", "Marionette", "Minireenas", "Molten Freddy", "Mr Hippo", "Mr Horse", "Music Man", "Nightmare", "Nightmare BB", "Nightmare Bonnie", "Nightmare Chica", "Nightmare Foxy", "Nightmare Fredbear", "Nightmare Freddy", "Nightmare Mangle", "Nightmare Rockstar Chica", "Nightmarionne", "OMC", "Phantom BB", "Phantom Chica", "Phantom Foxy", "Phantom Freddy", "Phantom Mangle", "Phantom Marionette", "Phone Guy", "Plushtrap", "RWQFSASXC", "Rockstar Bonnie", "Rockstar Chica", "Rockstar Foxy", "Rockstar Freddy", "Shadow Freddy", "Slendypants", "Springtrap", "Toy Bonnie", "Toy Chica", "Toy Foxy", "Toy Freddy", "Withered Bonnie", "Withered Chica", "Withered Foxy", "Withered Freddy" }

-- Flags
local settings = {
    ESPEnabled = false,
    NameTagsEnabled = false,
    AutoRemovePlayerNames = true,
    Speed = 16,
    SpeedEnabled = false
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 450)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Jude's U.R.N ESP"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 24
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Function to create checkboxes
local function createCheckbox(text, defaultState, position, settingKey)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0, 20, 0, 20)
    btn.Position = UDim2.new(0, 10, 0, position)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    btn.Text = ""

    local lbl = Instance.new("TextLabel", Frame)
    lbl.Size = UDim2.new(0, 160, 0, 20)
    lbl.Position = UDim2.new(0, 40, 0, position)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)

    btn.MouseButton1Click:Connect(function()
        settings[settingKey] = not settings[settingKey]
        btn.BackgroundColor3 = settings[settingKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
end

-- Create the setting checkboxes
createCheckbox("ESP", settings.ESPEnabled, 40, "ESPEnabled")
createCheckbox("nametags visible", settings.NameTagsEnabled, 70, "NameTagsEnabled")
createCheckbox("remove player names", settings.AutoRemovePlayerNames, 100, "AutoRemovePlayerNames")
createCheckbox("speed", settings.SpeedEnabled, 130, "SpeedEnabled")

-- Speed setting
local SpeedLabel = Instance.new("TextLabel", Frame)
SpeedLabel.Size = UDim2.new(0, 50, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 160)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "speed:"
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 16
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedBox = Instance.new("TextBox", Frame)
SpeedBox.Size = UDim2.new(0, 100, 0, 20)
SpeedBox.Position = UDim2.new(0, 70, 0, 160)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 16
SpeedBox.Text = tostring(settings.Speed)

SpeedBox.FocusLost:Connect(function()
    local num = tonumber(SpeedBox.Text)
    if num then
        settings.Speed = num
    else
        SpeedBox.Text = tostring(settings.Speed)
    end
end)

-- Teleport Button
local TeleportButton = Instance.new("TextButton", Frame)
TeleportButton.Size = UDim2.new(0, 200, 0, 30)
TeleportButton.Position = UDim2.new(0, 10, 0, 190)
TeleportButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
TeleportButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.TextSize = 16
TeleportButton.Text = "teleport to night guard"

TeleportButton.MouseButton1Click:Connect(function()
    local nightGuard = workspace:FindFirstChild("Night Guard")
    local character = game.Players.LocalPlayer.Character
    if nightGuard and character then
        local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
        if humanoidRoot then
            if nightGuard.PrimaryPart then
                humanoidRoot.CFrame = nightGuard.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            else
                humanoidRoot.CFrame = nightGuard:GetModelCFrame() + Vector3.new(0, 5, 0)
            end
        end
    end
end)

-- Separator Line
local Line = Instance.new("Frame", Frame)
Line.Size = UDim2.new(1, -20, 0, 1)
Line.Position = UDim2.new(0, 10, 0, 230)
Line.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Line.BorderSizePixel = 0

-- Ingame Label
local IngameLabel = Instance.new("TextLabel", Frame)
IngameLabel.Size = UDim2.new(1, -20, 0, 20)
IngameLabel.Position = UDim2.new(0, 10, 0, 235) 
IngameLabel.BackgroundTransparency = 1
IngameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IngameLabel.Font = Enum.Font.SourceSans
IngameLabel.TextSize = 16
IngameLabel.TextXAlignment = Enum.TextXAlignment.Left
IngameLabel.Text = "ingame: 0"

-- Scrolling list of models
local List = Instance.new("ScrollingFrame", Frame)
List.Size = UDim2.new(1, -20, 1, -270)
List.Position = UDim2.new(0, 10, 0, 260)
List.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
List.ScrollBarThickness = 6
List.BorderSizePixel = 0
List.CanvasSize = UDim2.new(0, 0, 0, 0)

-- ESP functions
local function createESP(part)
    if not part:FindFirstChild("ESPBox") then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Adornee = part
        box.Size = part.Size
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Transparency = 0.5
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Parent = part
    end
end

local function removeESP(part)
    local box = part:FindFirstChild("ESPBox")
    if box then box:Destroy() end
end

local function refreshESP()
    for _, model in ipairs(workspace:GetChildren()) do
        if table.find(targets, model.Name) then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    if settings.ESPEnabled then
                        createESP(part)
                    else
                        removeESP(part)
                    end
                end
            end
        end
    end
end

local function refreshList()
    for _, child in ipairs(List:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    local y = 0
    local count = 0
    for _, model in ipairs(workspace:GetChildren()) do
        if table.find(targets, model.Name) then
            local lbl = Instance.new("TextLabel", List)
            lbl.Size = UDim2.new(1, 0, 0, 20)
            lbl.Position = UDim2.new(0, 0, 0, y)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 14
            lbl.Text = model.Name
            y = y + 20
            count = count + 1
        end
    end
    List.CanvasSize = UDim2.new(0, 0, 0, y)
    IngameLabel.Text = "ingame: "..count
end

-- Minimize/expand the window
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Frame.Size = minimized and UDim2.new(0, 220, 0, 30) or UDim2.new(0, 220, 0, 450)
    for _, child in ipairs(Frame:GetChildren()) do
        if child ~= TitleBar then
            child.Visible = not minimized
        end
    end
end)

-- Main loop
spawn(function()
    while task.wait(0.1) do
        refreshESP()
        refreshList()

        if settings.SpeedEnabled then
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.WalkSpeed = settings.Speed
            end
        end

        local tagFolder = workspace:FindFirstChild("FolderNameTags")
        if tagFolder then
            for _, obj in ipairs(tagFolder:GetDescendants()) do
                if obj:IsA("BillboardGui") then
                    obj.Enabled = settings.NameTagsEnabled
                elseif obj:IsA("BasePart") then
                    obj.Transparency = settings.NameTagsEnabled and 0 or 1
                end
                if settings.AutoRemovePlayerNames and obj.Name == "PlayerName" then
                    obj:Destroy()
                end
            end
        end
    end
end)