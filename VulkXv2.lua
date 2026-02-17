-- VulkX V2.0.6
if not game:IsLoaded() then game.Loaded:Wait() end
pcall(function() getgenv().VulkX = nil end)

-- Services
local Plrs, RunS, RepS, WS, TS, SoundS, Debris, ContentP, UIS, HttpS, VIM, SGui, GuiS, TextS = game:GetService("Players"), game:GetService("RunService"), game:GetService("ReplicatedStorage"), game:GetService("Workspace"), game:GetService("TweenService"), game:GetService("SoundService"), game:GetService("Debris"), game:GetService("ContentProvider"), game:GetService("UserInputService"), game:GetService("HttpService"), game:GetService("VirtualInputManager"), game:GetService("StarterGui"), game:GetService("GuiService"), game:GetService("TextService")
local LPlr = Plrs.LocalPlayer
local Cam = WS.CurrentCamera
local Mouse = LPlr:GetMouse()

-- Wait for character and backpack
if not LPlr.Character then LPlr.CharacterAdded:Wait() end
repeat task.wait() until LPlr:FindFirstChild("Backpack")

-- Compatibility Checks
local hasNewCClosure = pcall(function() return newcclosure end)
local hasGetNamecallMethod = pcall(function() return getnamecallmethod ~= nil end)
local hasDebug = pcall(function() return debug.setupvalue ~= nil end)

-- Environment Setup
getgenv().VulkX = {
    Settings = {},
    Functions = {},
    Data = {},
    Rage = {},
    Tables = {}
}
local G = getgenv().VulkX

-- Script State
local silentAimActive = false
local silentAimToggled = false
local flying = false
local flyActive = false
local flyToggled = false
local connections = {}
local originalMetatables = {}

-- CFrame Synchronization (csync) System
local csync = {
    enabled = false,
    server_cframe = nil,
    client_cframe = nil,
    active = false
}
local primaryPart = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
local csyncHookSetup = false

local function setupCsync()
    local s, e = pcall(function()
        if not hasNewCClosure or not hasGetNamecallMethod then return end
        if csyncHookSetup then return end
        local mt = getrawmetatable(game)
        if not mt then return end
        originalMetatables.__index = mt.__index
        local setreadonly = setreadonly or make_writeable or function() end
        setreadonly(mt, false)
        local index = mt.__index
        mt.__index = function(self, property)
            if not checkcaller() and self == primaryPart and property == "CFrame" and csync.active and csync.client_cframe then
                return csync.client_cframe
            end
            return index(self, property)
        end
        setreadonly(mt, true)
        csyncHookSetup = true
    end)
    if not s then print("VulkX Csync Setup Error:", e) end
end

table.insert(connections, RunS.Heartbeat:Connect(function()
    local s, e = pcall(function()
        if csync.enabled and csync.server_cframe and primaryPart then
            csync.active = true
            csync.client_cframe = primaryPart.CFrame
            primaryPart.CFrame = csync.server_cframe
            RunS.RenderStepped:Wait()
            primaryPart.CFrame = csync.client_cframe
        else
            csync.active = false
        end
    end)
    if not s then print("VulkX Csync Heartbeat Error:", e) end
end))

table.insert(connections, LPlr.CharacterAdded:Connect(function(character)
    task.wait(0.01)
    primaryPart = character:WaitForChild("HumanoidRootPart", 1)
    csyncHookSetup = false
    setupCsync()
    csync.enabled = false
    csync.server_cframe = nil
    csync.client_cframe = nil
    csync.active = false
    G.Rage.State.MaskAppliedThisLife = false
    flying = false
    flyActive = false
    flyToggled = false
end))

local function enableCsync(serverCFrame)
    if not primaryPart then return end
    csync.enabled = true
    csync.server_cframe = serverCFrame
end

local function disableCsync()
    csync.enabled = false
    csync.server_cframe = nil
    csync.client_cframe = nil
    csync.active = false
end

local function csyncTeleport(destinationCFrame, duration)
    local s, e = pcall(function()
        if not primaryPart then return false end
        enableCsync(destinationCFrame)
        local startTime = tick()
        while tick() - startTime < duration do
            RunS.Heartbeat:Wait()
        end
        disableCsync()
        return true
    end)
    if not s then print("VulkX Csync Teleport Error:", e); return false end
    return s
end

-- Data Tables
G.Tables.Fonts = {
    "Gotham", "GothamBold", "GothamBlack", "GothamMedium",
    "SourceSans", "SourceSansBold", "SourceSansItalic",
    "Ubuntu", "UbuntuMono", "Arial", "Roboto", "RobotoMono",
    "FredokaOne", "Bangers", "Creepster", "LuckiestGuy",
    "HighwayGothic", "Arcade"
}

G.Tables.HitSoundTable = {
    ['Baimware'] = 'rbxassetid://3124331820',
    ['Bamboo'] = 'rbxassetid://3769434519',
    ['Bambi'] = 'rbxassetid://8437203821',
    ['Bat'] = 'rbxassetid://3333907347',
    ['Beep'] = 'rbxassetid://8177256015',
    ['Big'] = 'rbxassetid://5332005053',
    ['Bonk'] = 'rbxassetid://5766898159',
    ['Bruh'] = 'rbxassetid://4578740568',
    ['Bubble'] = 'rbxassetid://6534947588',
    ['Call of Duty'] = 'rbxassetid://5952120301',
    ['Click'] = 'rbxassetid://8053704437',
    ['Crowbar'] = 'rbxassetid://546410481',
    ['Ding'] = 'rbxassetid://7149516994',
    ['Fart'] = 'rbxassetid://130833677',
    ['Fatality'] = 'rbxassetid://6534947869',
    ['Gamesense'] = 'rbxassetid://4817809188',
    ['Laser'] = 'rbxassetid://7837461331',
    ['Lazer'] = 'rbxassetid://130791043',
    ['Mario'] = 'rbxassetid://2815207981',
    ['Minecraft'] = 'rbxassetid://5869422451',
    ['Neverlose'] = 'rbxassetid://6534948092',
    ['Old Fatality'] = 'rbxassetid://6607142036',
    ['Osu'] = 'rbxassetid://7149255551',
    ['Pick'] = 'rbxassetid://1347140027',
    ['Pop'] = 'rbxassetid://198598793',
    ['RIFK7'] = 'rbxassetid://9102080552',
    ['Rust'] = 'rbxassetid://1255040462',
    ['Saber'] = 'rbxassetid://8415678813',
    ['Sans'] = 'rbxassetid://3188795283',
    ['Skeet'] = 'rbxassetid://5633695679',
    ['Slime'] = 'rbxassetid://6916371803',
    ['Snow'] = 'rbxassetid://6455527632',
    ['Steve'] = 'rbxassetid://4965083997',
    ['Stone'] = 'rbxassetid://3581383408',
    ['TF2'] = 'rbxassetid://2868331684',
    ['TF2 Critical'] = 'rbxassetid://296102734',
    ['UwU'] = 'rbxassetid://8679659744',
    ['Vine'] = 'rbxassetid://5332680810',
    ['Weeb'] = 'rbxassetid://6442965016',
    ['Hoot (On Shoot)'] = 'rbxassetid://5153733934'
}
G.Tables.HitSoundNames = {}
for name in pairs(G.Tables.HitSoundTable) do
    table.insert(G.Tables.HitSoundNames, name)
end
table.sort(G.Tables.HitSoundNames)

G.Tables.TracerTextures = {
    Default = "Default",
    Blood = "rbxassetid://7574452472",
    Lightning = "rbxassetid://117245845390957",
    ["Double Tracer"] = "rbxassetid://11862660322",
    Wavy = "rbxassetid://6292361118",
    Vine = "rbxassetid://7226453660",
    Bubbles = "rbxassetid://15981282949",
    Fire = "rbxassetid://18654087326",
    Solar = "rbxassetid://7135001284"
}

G.Tables.CSyncIcons = {
    Default = "rbxassetid://12823489098",
    ["Anime Girl"] = "rbxassetid://7831428568",
    Robux = "rbxassetid://11560341132",
    Discord = "rbxassetid://101192191207677",
    ["Verified Checkmark"] = "rbxassetid://93631347041836"
}

G.Tables.PredefinedSkyboxes = {
    dahood = { Bk = 600830446, Dn = 600831635, Ft = 600832720, Lf = 600886090, Rt = 600833862, Up = 600835177 },
    rainy = { Bk = 1666456837, Dn = 1666455881, Ft = 1666457447, Lf = 1666455318, Rt = 1666456385, Up = 1666458034 },
    ["space v2"] = { Bk = 76948125119932, Dn = 117865148129754, Ft = 77181996912050, Lf = 130317898320211, Rt = 105669495538162, Up = 128363212769327 },
    cosmo = { Bk = 15753305495, Dn = 15753362674, Ft = 15753305823, Lf = 15753310707, Rt = 15753304774, Up = 15753304473 },
    neon = { Bk = 271042516, Dn = 271077243, Ft = 271042556, Lf = 271042310, Rt = 271042467, Up = 271077958 },
    minecraft = { Bk = 1876545003, Dn = 1876544331, Ft = 1876542941, Lf = 1876543392, Rt = 1876543764, Up = 1876544642 },
    ["old skybox"] = { Bk = 15436783, Dn = 15436796, Ft = 15436831, Lf = 15437157, Rt = 15437166, Up = 15437184 },
    nightless = { Bk = 48020371, Dn = 48020144, Ft = 48020234, Lf = 48020211, Rt = 48020254, Up = 48020383 }
}

-- Settings
G.Settings = {
    RapidFire = {Enabled = false},
    HitSounds = {Enabled = false, SoundID = "rbxassetid://3124331820", Volume = 5, LastPlayTime = 0},
    HitNotifications = {Enabled = false, Time = 3},
    BulletTracers = {Enabled = false, Color = Color3.new(155/255, 125/255, 175/255), Size = 0.1, Transparency = 0, TimeAlive = 3, Texture = "Default"},
    RageEnabled = false,
    ShowStatus = false,
    SwapInterval = 1,
    VoidSpamEnabled = false,
    VoidSpamTimeIn = 200,
    VoidSpamTimeOut = 200,
    SelectedGuns = {'rifle', 'aug', 'flintlock'},
    StrafeDistance = 30,
    StrafeSpeed = 1000,
    ReturnToPosition = true,
    SpectateEnabled = false,
    SpectateDistance = 10,
    SpectateHeight = 5,
    AutoGuns = {Mode = true},
    AutoAmmo = { Mode = true, Guns = {} },
    AutoArmor = {Mode = false, Threshold = 100},
    AntiStomp = {Enabled = false},
    ShootDelay = 0.0000000000000000000000000000000000000000000001,
    MiscAutoEquip = false,
    ESP = {
        Enabled = false,
        Boxes = false,
        Names = false,
        Distance = false,
        Tool = false,
        Tracers = false,
        Skeleton = false,
        HealthBar = false,
        ArmorBar = false,
        NameMode = "Both",
        TracerOrigin = "Top",
        Font = "Plex",  -- Drawing font: Plex, UI, System, Monospace
        MaxDistanceEnabled = false,  -- Toggle for max distance limit
        MaxDistance = 5000,          -- Max distance (studs)
        Colors = {
            Box = Color3.new(1, 1, 1),
            Name = Color3.new(1, 1, 1),
            Distance = Color3.fromRGB(200, 200, 200),
            Tool = Color3.fromRGB(255, 165, 0),
            Tracer = Color3.fromRGB(255, 255, 255),
            Skeleton = Color3.fromRGB(255, 255, 255),
            HealthHigh = Color3.fromRGB(0, 255, 0),
            HealthMid = Color3.fromRGB(255, 255, 0),
            HealthLow = Color3.fromRGB(255, 0, 0),
            ArmorHigh = Color3.fromRGB(0, 100, 255),
            ArmorLow = Color3.fromRGB(100, 200, 255)
        },
        Objects = {}
    },
    SilentAim = {
        Enabled = false,
        Keybind = Enum.UserInputType.MouseButton2,
        Activation = "Hold",
        HitPart = "HumanoidRootPart",
        HitChance = 100,
        Prediction = 0,
        FOVRadius = 200,
        FOVVisible = true,
        FOVTransparency = 0.5,
        FOVColor = Color3.fromRGB(255, 255, 255),
        WallCheck = true,
        VisualizeTarget = false,
        VisualizeColor = Color3.fromRGB(255, 0, 255)
    },
    Fly = {
        Enabled = false,
        Keybind = Enum.KeyCode.X,
        Activation = "Toggle",
        Speed = 1400,
        MoveSmoothRate = 240.0,
        RotSmoothRate = 200.0,
        HoverSmoothRate = 90.0
    },
    Ragebot = {
        Enabled = false,
        Keybind = Enum.KeyCode.C,
        Active = false
    },
    CSyncVisualizer = {
        Enabled = false,
        Color = Color3.fromRGB(255, 255, 0),
        Size = 20,
        Icon = "Default"
    },
    Skybox = {
        Enabled = false,
        Current = "dahood"
    },
    MenuKey = Enum.KeyCode.RightShift,
    MainColor = Color3.fromRGB(10, 10, 10),
    AccentColor = Color3.fromRGB(147, 112, 219),
    TextColor = Color3.fromRGB(240, 240, 240),
    ToggleOnColor = Color3.fromRGB(255, 255, 255),
    ToggleOffColor = Color3.fromRGB(30, 30, 30),
    SectionColor = Color3.fromRGB(20, 20, 20),
    ButtonColor = Color3.fromRGB(40, 40, 40),
    SliderColor = Color3.fromRGB(147, 112, 219),
    DropdownColor = Color3.fromRGB(30, 30, 30),
    VersionTextColor = Color3.fromRGB(255, 0, 0),
    KillMode = "Normal",
    Font = "Gotham",
    Positions = {
        KeybindList = UDim2.new(0.01, 0, 0.3, 0),
        NotificationList = UDim2.new(0.75, 0, 0.05, 0)
    }
}

for _, gun in ipairs({'rifle', 'aug', 'lmg', 'double', 'silencerar', 'ak47', 'p90', 'flintlock'}) do
    G.Settings.AutoAmmo.Guns[gun] = {low = 20, high = 150}
end

-- Data
G.Data = {
    menuVisible = true,
    notifications = {},
    UIReferences = {
        toggles = {},
        sliders = {},
        dropdowns = {},
        keybinds = {},
        colorPreviews = {},
        accentElements = {},
        groupBoxes = {},
        multiTargetListContainer = nil
    },
    KeybindList = {},
    ActiveFeatures = {Ragebot = false, ["SilentAim"] = false, Fly = false}
}

-- Helper: get Font enum
local function getFontEnum(fontName)
    local success, fontEnum = pcall(function() return Enum.Font[fontName] end)
    return success and fontEnum or Enum.Font.Gotham
end

-- Drawing font mapping for ESP
local drawingFonts = {
    Plex = Drawing.Fonts.Plex,
    UI = Drawing.Fonts.UI,
    System = Drawing.Fonts.System,
    Monospace = Drawing.Fonts.Monospace
}

setupCsync()

-- Keybind Display
local keybindDisplay = Instance.new("ScreenGui")
keybindDisplay.Name = "VulkX_Keybinds"
keybindDisplay.Parent = game.CoreGui
keybindDisplay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
keybindDisplay.IgnoreGuiInset = true

local keybindFrame = Instance.new("Frame")
keybindFrame.Name = "KeybindFrame"
keybindFrame.Size = UDim2.new(0, 200, 0, 200)
keybindFrame.Position = G.Settings.Positions.KeybindList
keybindFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keybindFrame.BackgroundTransparency = 0.5
keybindFrame.BorderSizePixel = 0
keybindFrame.Visible = true
keybindFrame.Parent = keybindDisplay

local keybindStroke = Instance.new("UIStroke", keybindFrame)
keybindStroke.Color = G.Settings.AccentColor
keybindStroke.Thickness = 1

local keybindTitle = Instance.new("TextLabel", keybindFrame)
keybindTitle.Size = UDim2.new(1, 0, 0, 25)
keybindTitle.BackgroundTransparency = 1
keybindTitle.Text = "Active Keybinds"
keybindTitle.TextColor3 = G.Settings.AccentColor
keybindTitle.Font = getFontEnum(G.Settings.Font)
keybindTitle.TextSize = 14
keybindTitle.TextXAlignment = Enum.TextXAlignment.Center

local keybindTitleOutline = Instance.new("UIStroke", keybindTitle)
keybindTitleOutline.Color = Color3.new(0, 0, 0)
keybindTitleOutline.Thickness = 1
keybindTitleOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

local keybindScrolling = Instance.new("ScrollingFrame", keybindFrame)
keybindScrolling.Size = UDim2.new(1, -10, 1, -35)
keybindScrolling.Position = UDim2.new(0, 5, 0, 30)
keybindScrolling.BackgroundTransparency = 1
keybindScrolling.ScrollBarThickness = 2
keybindScrolling.ScrollBarImageColor3 = G.Settings.AccentColor

local keybindList = Instance.new("UIListLayout", keybindScrolling)
keybindList.Padding = UDim.new(0, 5)

local function updateKeybindDisplay()
    local s, e = pcall(function()
        for _, v in ipairs(keybindScrolling:GetChildren()) do
            if v:IsA("TextLabel") then v:Destroy() end
        end
        local keybinds = {
            {name = "Menu", key = G.Settings.MenuKey},
            {name = "Ragebot", key = G.Settings.Ragebot.Keybind},
            {name = "SilentAim", key = G.Settings.SilentAim.Keybind},
            {name = "Fly", key = G.Settings.Fly.Keybind}
        }
        for _, kb in ipairs(keybinds) do
            local label = Instance.new("TextLabel", keybindScrolling)
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            local keyName = (type(kb.key) == "EnumItem" and kb.key.Name) or tostring(kb.key)
            label.Text = kb.name .. ": [" .. keyName .. "]"
            label.TextColor3 = (G.Data.ActiveFeatures[kb.name]) and G.Settings.AccentColor or G.Settings.TextColor
            label.Font = getFontEnum(G.Settings.Font)
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            local labelOutline = Instance.new("UIStroke", label)
            labelOutline.Color = Color3.new(0, 0, 0)
            labelOutline.Thickness = 1
            labelOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        end
        keybindScrolling.CanvasSize = UDim2.new(0, 0, 0, #keybinds * 25)
    end)
    if not s then print("VulkX Keybind Display Error:", e) end
end

table.insert(connections, task.spawn(function()
    while true do
        local s, e = pcall(function()
            G.Data.ActiveFeatures["Ragebot"] = G.Settings.Ragebot.Active
            G.Data.ActiveFeatures["SilentAim"] = silentAimToggled or silentAimActive
            G.Data.ActiveFeatures["Fly"] = flying
            if keybindFrame.Visible then
                updateKeybindDisplay()
            end
        end)
        if not s then print("VulkX Active Feature Update Error:", e) end
        task.wait(0)
    end
end))

-- Menu toggle
table.insert(connections, UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == G.Settings.MenuKey then
        G.Data.menuVisible = not G.Data.menuVisible
        local gui = game.CoreGui:FindFirstChild("VulkXGUI")
        if gui then
            gui.MainFrame.Visible = G.Data.menuVisible
        end
    end
end))

-- Player state tracking (for stomp detection)
local lastState = {}
local conns = {}
local function disconnectPlayerConns(plr)
    if not plr then return end
    local list = conns[plr]
    if list then
        for _, c in ipairs(list) do
            pcall(function()
                if c and c.Disconnect then c:Disconnect()
                elseif c and c.disconnect then c:disconnect() end
            end)
        end
    end
    conns[plr] = nil
end
local function addConn(plr, conn)
    if not plr then return end
    conns[plr] = conns[plr] or {}
    table.insert(conns[plr], conn)
end
local function announceStateChange(plr, isSDeath)
    if not plr then return end
    lastState[plr.Name] = isSDeath and true or false
end
local function attachToBodyEffects(plr, bodyFolder)
    if not plr or not bodyFolder then return end
    local function attachSDeath(sdeath)
        if sdeath and sdeath:IsA("BoolValue") then
            announceStateChange(plr, sdeath.Value)
            addConn(plr, sdeath:GetPropertyChangedSignal("Value"):Connect(function()
                announceStateChange(plr, sdeath.Value)
            end))
        end
    end
    local sdeath = bodyFolder:FindFirstChild("SDeath")
    attachSDeath(sdeath)
    addConn(plr, bodyFolder.ChildAdded:Connect(function(child)
        if child and child.Name == "SDeath" then attachSDeath(child) end
    end))
    addConn(plr, bodyFolder.ChildRemoved:Connect(function(child)
        if child and child.Name == "SDeath" then lastState[plr.Name] = false end
    end))
end
local function onCharacterAdded(plr, char)
    disconnectPlayerConns(plr)
    if not char then return end
    local body = char:FindFirstChild("BodyEffects")
    if body then
        attachToBodyEffects(plr, body)
    else
        spawn(function()
            local ok, bf = pcall(function() return char:WaitForChild("BodyEffects", 5) end)
            if ok and bf then attachToBodyEffects(plr, bf) end
        end)
    end
end
local function onPlayerAdded(plr)
    lastState[plr.Name] = false
    if plr.Character then onCharacterAdded(plr, plr.Character) end
    addConn(plr, plr.CharacterAdded:Connect(function(char) onCharacterAdded(plr, char) end))
    local leaveConn
    leaveConn = plr.AncestryChanged:Connect(function()
        if not plr.Parent then
            disconnectPlayerConns(plr)
            lastState[plr.Name] = nil
            if leaveConn and leaveConn.Disconnect then leaveConn:Disconnect() end
        end
    end)
    addConn(plr, leaveConn)
end
for _, p in ipairs(Plrs:GetPlayers()) do onPlayerAdded(p) end
table.insert(connections, Plrs.PlayerAdded:Connect(onPlayerAdded))
table.insert(connections, task.spawn(function()
    while true do
        local s, e = pcall(function()
            for _, p in ipairs(Plrs:GetPlayers()) do
                local char = p.Character
                if char then
                    local body = char:FindFirstChild("BodyEffects")
                    if body then
                        local s = body:FindFirstChild("SDeath")
                        if s and s:IsA("BoolValue") then
                            lastState[p.Name] = s.Value
                        end
                    end
                end
            end
        end)
        if not s then print("VulkX Stomp State Monitor Error:", e) end
        wait(0.1)
    end
end))

local function is_stomped(player)
    if not player then return false end
    return lastState[player.Name] == true
end

-- Rage System
G.Rage = {
    State = {
        ACTION = "IDLE",
        IS_BUYING = false,
        MaskAppliedThisLife = false,
        LAST_BUY_TIME = 0,
        SavedPosition = nil,
        auraTargets = {},
        CurrentTarget = nil,
        SearchFilter = "",
        LastTargetSwap = 0,
        CurrentTargetIndex = 1,
        CurrentStatus = "Idle",
        LACKING_CASH = false,
        LackingItem = nil,
        LackingPrice = nil,
        lastEquipTime = 0,
        EQUIP_COOLDOWN = 0.5,
        Spectating = false,
        LastSDeathCheck = {},
        BuyingInProgress = false,
        ShouldResumeAfterBuy = true,
        RageLoopRunning = false,
        LastReloadCheck = 0,
        ReloadCooldown = 1,
        IsStomping = false,
        KOedTargets = {},
        StompQueue = {},
        ricochetPos = nil,
        ricochetVel = nil,
        LastShootTime = 0
    },
    Settings = G.Settings,
    GunMapping = {
        ['rifle'] = '[Rifle]',
        ['aug'] = '[AUG]',
        ['lmg'] = '[LMG]',
        ['double'] = '[Double-Barrel SG]',
        ['silencerar'] = '[SilencerAR]',
        ['ak47'] = '[AK47]',
        ['p90'] = '[P90]',
        ['flintlock'] = '[Flintlock]'
    },
    AmmoMapping = {
        ['rifle'] = '5 [Rifle Ammo]',
        ['aug'] = '90 [AUG Ammo]',
        ['lmg'] = '200 [LMG Ammo]',
        ['double'] = '18 [Double-Barrel SG Ammo]',
        ['silencerar'] = '120 [SilencerAR Ammo]',
        ['ak47'] = '90 [AK47 Ammo]',
        ['p90'] = '120 [P90 Ammo]',
        ['flintlock'] = '6 [Flintlock Ammo]'
    },
    DisplayNames = {
        ['rifle'] = 'Rifle',
        ['aug'] = 'AUG',
        ['lmg'] = 'LMG',
        ['double'] = 'Double-Barrel',
        ['silencerar'] = 'SilencerAR',
        ['ak47'] = 'AK47',
        ['p90'] = 'P90',
        ['flintlock'] = 'Flintlock'
    },
    GunsAvailable = {'rifle', 'aug', 'lmg', 'double', 'silencerar', 'ak47', 'p90', 'flintlock'},
    VOID_Y = 676767,
    ARMOR_SHOP = "High-Medium Armor",
    Prices = {},
    lastShotTimes = {},
    ShopPrices = {}
}
local RS = G.Rage

-- CSYNC VISUALIZER (Fixed: ensure image is created and visible)
local csyncVisualizerDot = Drawing.new("Image")
csyncVisualizerDot.Visible = false
csyncVisualizerDot.Data = G.Tables.CSyncIcons[G.Settings.CSyncVisualizer.Icon] or G.Tables.CSyncIcons.Default
csyncVisualizerDot.Size = Vector2.new(G.Settings.CSyncVisualizer.Size, G.Settings.CSyncVisualizer.Size)
csyncVisualizerDot.Transparency = 0.5

local function updateCSyncVisualizer()
    local s, e = pcall(function()
        if not G.Settings.CSyncVisualizer.Enabled or not csync.active or not csync.server_cframe then
            csyncVisualizerDot.Visible = false
            return
        end
        local pos = csync.server_cframe.Position
        local screenPos, onScreen = Cam:WorldToViewportPoint(pos)
        if onScreen and screenPos.Z > 0 then
            csyncVisualizerDot.Position = Vector2.new(screenPos.X, screenPos.Y) - (csyncVisualizerDot.Size / 2)
            csyncVisualizerDot.Size = Vector2.new(G.Settings.CSyncVisualizer.Size, G.Settings.CSyncVisualizer.Size)
            csyncVisualizerDot.Data = G.Tables.CSyncIcons[G.Settings.CSyncVisualizer.Icon] or G.Tables.CSyncIcons.Default
            csyncVisualizerDot.Visible = true
        else
            csyncVisualizerDot.Visible = false
        end
    end)
    if not s then print("VulkX Csync Visualizer Error:", e) end
end

table.insert(connections, RunS.RenderStepped:Connect(updateCSyncVisualizer))

-- Silent Aim FOV Circle
local silentAimCircle = Drawing.new("Circle")
silentAimCircle.Color = G.Settings.SilentAim.FOVColor
silentAimCircle.Thickness = 2
silentAimCircle.Filled = false
silentAimCircle.Transparency = G.Settings.SilentAim.FOVTransparency
silentAimCircle.Radius = G.Settings.SilentAim.FOVRadius
silentAimCircle.Visible = G.Settings.SilentAim.FOVVisible

-- Silent Aim Target Highlight
local silentAimTargetHighlight = Instance.new("Highlight")
silentAimTargetHighlight.Adornee = nil
silentAimTargetHighlight.Enabled = false
silentAimTargetHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
silentAimTargetHighlight.Parent = game.CoreGui

local function updateSilentAimFOV()
    pcall(function()
        local guiInset = GuiS:GetGuiInset()
        silentAimCircle.Position = Vector2.new(Mouse.X, Mouse.Y + guiInset.Y)
        silentAimCircle.Radius = G.Settings.SilentAim.FOVRadius
        silentAimCircle.Transparency = G.Settings.SilentAim.FOVTransparency
        silentAimCircle.Color = G.Settings.SilentAim.FOVColor
        silentAimCircle.Visible = G.Settings.SilentAim.FOVVisible and G.Settings.SilentAim.Enabled
    end)
end

local function getClosestSilentAimTarget()
    local closestPlayer, closestPart, minDistance = nil, nil, G.Settings.SilentAim.FOVRadius
    for _, player in ipairs(Plrs:GetPlayers()) do
        if player ~= LPlr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetPart = nil
            if G.Settings.SilentAim.HitPart == "Random" then
                local parts = {"Head", "UpperTorso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "LeftLowerLeg", "RightLowerLeg"}
                local potentialPartName = parts[math.random(1, #parts)]
                targetPart = player.Character:FindFirstChild(potentialPartName)
            else
                targetPart = player.Character:FindFirstChild(G.Settings.SilentAim.HitPart)
            end
            if targetPart then
                if G.Settings.SilentAim.WallCheck then
                    local rayOrigin = Cam.CFrame.Position
                    local rayDirection = targetPart.Position - rayOrigin
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LPlr.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = WS:Raycast(rayOrigin, rayDirection, raycastParams)
                    if result and not result.Instance:IsDescendantOf(player.Character) then
                        continue
                    end
                end
                local pos, onScreen = Cam:WorldToScreenPoint(targetPart.Position)
                if onScreen then
                    local diff = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if diff < minDistance then
                        minDistance = diff
                        closestPlayer = player
                        closestPart = targetPart
                    end
                end
            end
        end
    end
    return closestPlayer, closestPart
end

local function isSilentAimOn()
    if not G.Settings.SilentAim.Enabled then return false end
    if G.Settings.SilentAim.Activation == "Hold" then
        return silentAimActive
    else
        return silentAimToggled
    end
end

-- Silent Aim Input
table.insert(connections, UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == G.Settings.SilentAim.Keybind or input.KeyCode == G.Settings.SilentAim.Keybind then
        if G.Settings.SilentAim.Activation == "Hold" then
            silentAimActive = true
        else
            silentAimToggled = not silentAimToggled
        end
    end
end))

table.insert(connections, UIS.InputEnded:Connect(function(input, processed)
    if processed then return end
    if (input.UserInputType == G.Settings.SilentAim.Keybind or input.KeyCode == G.Settings.SilentAim.Keybind) and G.Settings.SilentAim.Activation == "Hold" then
        silentAimActive = false
    end
end))

-- Silent Aim Visualization
table.insert(connections, RunS.RenderStepped:Connect(function()
    local s, e = pcall(function()
        updateSilentAimFOV()
        if G.Settings.SilentAim.VisualizeTarget and isSilentAimOn() then
            local _, targetPart = getClosestSilentAimTarget()
            if targetPart and targetPart.Parent then
                silentAimTargetHighlight.Adornee = targetPart
                silentAimTargetHighlight.FillColor = G.Settings.SilentAim.VisualizeColor
                silentAimTargetHighlight.OutlineColor = Color3.new(0, 0, 0)
                silentAimTargetHighlight.FillTransparency = 0.5
                silentAimTargetHighlight.OutlineTransparency = 0.2
                silentAimTargetHighlight.Enabled = true
            else
                silentAimTargetHighlight.Enabled = false
                silentAimTargetHighlight.Adornee = nil
            end
        else
            silentAimTargetHighlight.Enabled = false
            silentAimTargetHighlight.Adornee = nil
        end
    end)
    if not s then print("VulkX SA Vis Error:", e) end
end))

-- Silent Aim Hook
pcall(function()
    local silentAimMt = getrawmetatable(game)
    if silentAimMt then
        originalMetatables.__index_sa = silentAimMt.__index
        local __index = silentAimMt.__index
        local setreadonly = setreadonly or make_writeable or function() end
        setreadonly(silentAimMt, false)
        silentAimMt.__index = function(self, key)
            if isSilentAimOn() and self == Mouse and key == "Hit" then
                local targetPlayer, targetPart = getClosestSilentAimTarget()
                if targetPlayer and targetPart then
                    if math.random(1, 100) <= G.Settings.SilentAim.HitChance then
                        local velocity = targetPart.AssemblyLinearVelocity or Vector3.new()
                        return (targetPart.CFrame + (velocity * G.Settings.SilentAim.Prediction))
                    end
                end
            end
            return __index(self, key)
        end
        setreadonly(silentAimMt, true)
    end
end)

-- Flight System
local flyConnection = nil
local lockedY = nil
local smoothCFrame = nil
local function expAlpha(k, dt) return 1 - math.exp(-math.max(0, k) * dt) end

local function enableFlight()
    local s, e = pcall(function()
        local character = LPlr.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end
        flying = true
        humanoid.PlatformStand = true
        lockedY = root.Position.Y
        smoothCFrame = root.CFrame
    end)
    if not s then print("VulkX Enable Flight Error:", e) end
end

local function disableFlight()
    local s, e = pcall(function()
        local character = LPlr.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        flying = false
        lockedY = nil
        humanoid.PlatformStand = false
    end)
    if not s then print("VulkX Disable Flight Error:", e) end
end

table.insert(connections, UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == G.Settings.Fly.Keybind and G.Settings.Fly.Enabled then
        if G.Settings.Fly.Activation == "Hold" then
            flyActive = true
            enableFlight()
        else
            flyToggled = not flyToggled
            if flyToggled then enableFlight() else disableFlight() end
        end
    end
end))

table.insert(connections, UIS.InputEnded:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == G.Settings.Fly.Keybind and G.Settings.Fly.Activation == "Hold" then
        flyActive = false
        disableFlight()
    end
end))

local function startFlying()
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunS.Heartbeat:Connect(function(dt)
        local s, e = pcall(function()
            if not flying or not LPlr.Character then return end
            local root = LPlr.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local cam = Cam
            local pos = root.Position
            local moveVec = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.yAxis end
            local targetPos = pos
            local targetRotCFrame = CFrame.new(Vector3.zero, cam.CFrame.LookVector)
            if moveVec.Magnitude > 0 then
                local displacement = moveVec.Unit * G.Settings.Fly.Speed * dt
                targetPos = pos + displacement
                lockedY = targetPos.Y
            elseif lockedY then
                targetPos = Vector3.new(pos.X, lockedY, pos.Z)
            else
                targetPos = pos
            end
            local desiredCFrame = CFrame.new(targetPos) * targetRotCFrame
            local chosenMoveRate = G.Settings.Fly.MoveSmoothRate
            local chosenRotRate = G.Settings.Fly.RotSmoothRate
            if moveVec.Magnitude <= 0 then
                chosenMoveRate = G.Settings.Fly.HoverSmoothRate
                chosenRotRate = G.Settings.Fly.HoverSmoothRate
            end
            local alphaPos = expAlpha(chosenMoveRate, dt)
            local alphaRot = expAlpha(chosenRotRate, dt)
            if not smoothCFrame then smoothCFrame = root.CFrame end
            local smoothPos = smoothCFrame.Position:Lerp(desiredCFrame.Position, alphaPos)
            local smoothRot = smoothCFrame:Lerp(desiredCFrame, alphaRot)
            smoothCFrame = CFrame.new(smoothPos) * (smoothRot - smoothRot.Position)
            root.CFrame = smoothCFrame
        end)
        if not s then print("VulkX Flight Loop Error:", e) end
    end)
    table.insert(connections, flyConnection)
end
startFlying()

table.insert(connections, LPlr.CharacterAdded:Connect(function(character)
    task.wait(0.01)
    smoothCFrame = nil
    flying = false
    flyActive = false
    flyToggled = false
    startFlying()
end))

-- Auto Armor System
local isBuyingArmor = false
local function findArmorShop()
    local shop = WS:FindFirstChild("Ignored") and WS.Ignored:FindFirstChild("Shop")
    if not shop then return nil end
    for _, child in ipairs(shop:GetChildren()) do
        if child.Name:find("%[High%-Medium Armor%]") then
            return child
        end
    end
    return nil
end
local function canBuyArmor()
    local character = LPlr.Character
    if not character then return false end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 1 then return false end
    local bodyEffects = character:FindFirstChild("BodyEffects")
    local isKO = bodyEffects and bodyEffects:FindFirstChild("K.O") and bodyEffects["K.O"].Value
    if isKO then return false end
    return true
end
local function teleportAndBuy(shop, clickDetector)
    local s, e = pcall(function()
        if isBuyingArmor then return false end
        isBuyingArmor = true
        local character = LPlr.Character
        if not character or not character.PrimaryPart then isBuyingArmor = false; return false end
        local hrp = character.PrimaryPart
        local originalCFrame = hrp.CFrame
        local shopHead = shop:FindFirstChild("Head") or shop.PrimaryPart or shop:FindFirstChildWhichIsA("BasePart")
        if not shopHead then isBuyingArmor = false; return false end
        local buyPosition = shopHead.CFrame * CFrame.new(0, 5, 0)
        csyncTeleport(buyPosition, 0.3)
        fireclickdetector(clickDetector)
        task.wait(0.01)
        if character and character:FindFirstChild("HumanoidRootPart") then
            csyncTeleport(originalCFrame, 0.3)
        end
        task.wait(0.01)
        isBuyingArmor = false
        return true
    end)
    if not s then print("VulkX Teleport&Buy Error:", e); isBuyingArmor = false; return false end
    return s
end
local function buyArmor()
    local s, e = pcall(function()
        if isBuyingArmor then return end
        if not G.Settings.AutoArmor.Mode then return end
        local currentArmorShop = findArmorShop()
        if not currentArmorShop then return end
        local currentClickDetector = currentArmorShop:FindFirstChild("ClickDetector")
        if not currentClickDetector then return end
        local armorValue = RS.GetArmor() or 0
        local threshold = G.Settings.AutoArmor.Threshold or 100
        if armorValue < threshold and canBuyArmor() then
            RS.State.CurrentStatus = "Buying armor..."
            teleportAndBuy(currentArmorShop, currentClickDetector)
            RS.State.CurrentStatus = "Armor bought successfully"
            task.wait(0.01)
        end
    end)
    if not s then print("VulkX Buy Armor Error:", e) end
end
table.insert(connections, task.spawn(function()
    while true do
        local s, e = pcall(function()
            if not G.Settings.AutoArmor.Mode then task.wait(0.1); return end
            local char = LPlr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local be = char:FindFirstChild("BodyEffects")
            if not hrp or not hum or hum.Health <= 0 then return end
            if be and be:FindFirstChild("K.O") and be["K.O"].Value then return end
            local currentArmor = RS.GetArmor()
            if currentArmor >= G.Settings.AutoArmor.Threshold then return end
            if G.Settings.Ragebot.Active and #RS.State.auraTargets > 0 then
                local hasValidTargets = false
                for _, target in ipairs(RS.State.auraTargets) do
                    if RS.ValidTarget(target) then hasValidTargets = true; break end
                end
                if hasValidTargets then
                    RS.State.CurrentStatus = "Low armor but in combat, delaying..."
                    return
                end
            end
            buyArmor()
        end)
        if not s then print("VulkX Auto Armor Loop Error:", e) end
        task.wait(0.1)
    end
end))
table.insert(connections, LPlr.CharacterAdded:Connect(function() isBuyingArmor = false; task.wait(0.01) end))

-- Shop prices
local function fetchShopPrices()
    local s, e = pcall(function()
        local shop = WS:FindFirstChild("Ignored") and WS.Ignored:FindFirstChild("Shop")
        if not shop then return end
        RS.ShopPrices = {}
        for _, item in ipairs(shop:GetChildren()) do
            local itemName = item.Name
            local priceMatch = string.match(itemName, "%$(%d+)")
            if priceMatch then
                local price = tonumber(priceMatch)
                RS.ShopPrices[itemName] = price
                for gunKey, gunName in pairs(RS.GunMapping) do
                    if string.find(itemName, gunName, 1, true) then
                        RS.Prices[gunKey] = price
                    end
                end
                for gunKey, ammoName in pairs(RS.AmmoMapping) do
                    if string.find(itemName, ammoName, 1, true) then
                        RS.Prices['ammo_' .. gunKey] = price
                    end
                end
                if string.find(itemName, "High%-Medium Armor", 1, true) then
                    RS.Prices['armor'] = price
                end
            end
        end
    end)
    if not s then print("VulkX Fetch Prices Error:", e) end
end
table.insert(connections, task.spawn(function()
    fetchShopPrices()
    while true do task.wait(30); fetchShopPrices() end
end))

-- Notification System
local notificationGui = Instance.new("ScreenGui")
notificationGui.Name = "VulkX_Notifications"
notificationGui.Parent = game.CoreGui
notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
notificationGui.IgnoreGuiInset = true

local notificationContainer = Instance.new("Frame", notificationGui)
notificationContainer.Size = UDim2.new(0, 300, 1, -20)
notificationContainer.Position = G.Settings.Positions.NotificationList
notificationContainer.BackgroundTransparency = 1

local notificationListLayout = Instance.new("UIListLayout", notificationContainer)
notificationListLayout.Padding = UDim.new(0, 8)
notificationListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notificationListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notificationListLayout.SortOrder = Enum.SortOrder.LayoutOrder

function G.Functions.Notify(title, message, color)
    local s, e = pcall(function()
        local notificationFrame = Instance.new("Frame")
        notificationFrame.Name = "Notification"
        notificationFrame.Size = UDim2.new(1, 0, 0, 80)
        notificationFrame.BackgroundColor3 = G.Settings.MainColor
        notificationFrame.BackgroundTransparency = 1
        notificationFrame.BorderSizePixel = 0
        notificationFrame.ZIndex = 1000
        notificationFrame.LayoutOrder = -tick()
        notificationFrame.Parent = notificationContainer

        local UIStroke = Instance.new("UIStroke", notificationFrame)
        UIStroke.Color = color or G.Settings.AccentColor
        UIStroke.Thickness = 2

        local TitleLabel = Instance.new("TextLabel", notificationFrame)
        TitleLabel.Size = UDim2.new(1, -20, 0, 25)
        TitleLabel.Position = UDim2.new(0, 10, 0, 10)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = color or G.Settings.AccentColor
        TitleLabel.Font = getFontEnum(G.Settings.Font)
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local titleOutline = Instance.new("UIStroke", TitleLabel)
        titleOutline.Color = Color3.new(0, 0, 0)
        titleOutline.Thickness = 1
        titleOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

        local MessageLabel = Instance.new("TextLabel", notificationFrame)
        MessageLabel.Size = UDim2.new(1, -20, 0, 45)
        MessageLabel.Position = UDim2.new(0, 10, 0, 35)
        MessageLabel.BackgroundTransparency = 1
        MessageLabel.Text = message
        MessageLabel.TextColor3 = G.Settings.TextColor
        MessageLabel.Font = getFontEnum(G.Settings.Font)
        MessageLabel.TextSize = 12
        MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
        MessageLabel.TextWrapped = true

        local msgOutline = Instance.new("UIStroke", MessageLabel)
        msgOutline.Color = Color3.new(0, 0, 0)
        msgOutline.Thickness = 1
        msgOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

        if not color then
            table.insert(G.Data.UIReferences.accentElements, {element = UIStroke, property = "Color"})
            table.insert(G.Data.UIReferences.accentElements, {element = TitleLabel, property = "TextColor3"})
        end

        TS:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 0.1 }):Play()

        task.delay(G.Settings.HitNotifications.Time, function()
            if notificationFrame and notificationFrame.Parent then
                local tween = TS:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
                tween:Play()
                tween.Completed:Wait()
                notificationFrame:Destroy()
            end
        end)
    end)
    if not s then print("VulkX Notify Error:", e) end
end

-- Rage Status Display
local RageStatusText = Drawing.new("Text")
RageStatusText.Visible = false
RageStatusText.Color = Color3.fromRGB(255, 255, 255)
RageStatusText.Size = 24
RageStatusText.Center = true
RageStatusText.Outline = true
RageStatusText.Font = Drawing.Fonts.Plex
RageStatusText.OutlineColor = Color3.fromRGB(0, 0, 0)
RageStatusText.Position = Vector2.new(Cam.ViewportSize.X / 2, 50)

table.insert(connections, task.spawn(function()
    while task.wait(0.1) do
        local s, e = pcall(function()
            RageStatusText.Visible = G.Settings.Ragebot.Active and G.Settings.ShowStatus
            if G.Settings.Ragebot.Active then
                RageStatusText.Text = "Status: " .. RS.State.CurrentStatus
            else
                RageStatusText.Text = "Status: Idle"
            end
            RageStatusText.Position = Vector2.new(Cam.ViewportSize.X / 2, 50)
        end)
        if not s then print("VulkX Status Display Error:", e) end
    end
end))

-- Find MainEvent
local MainEvent = nil
local function findMainEvent()
    MainEvent = RepS:FindFirstChild("MainEvent")
    if not MainEvent then
        for _, child in ipairs(RepS:GetChildren()) do
            if child:IsA("RemoteEvent") and (child.Name:lower():find("main") or child.Name:lower():find("event")) then
                MainEvent = child; break
            end
        end
    end
    return MainEvent
end
findMainEvent()

-- Rage System Functions
RS.SavePosition = function()
    local char = LPlr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then RS.State.SavedPosition = hrp.CFrame end
end

RS.GoToVoid = function()
    local char = LPlr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local voidPos = CFrame.new(hrp.Position.X, RS.VOID_Y, hrp.Position.Z)
    csyncTeleport(voidPos, 0.03)
end

RS.ReturnToPosition = function()
    if not RS.State.SavedPosition then return end
    local char = LPlr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    csyncTeleport(RS.State.SavedPosition, 0.24)
    RS.State.SavedPosition = nil
end

RS.GetVoidPos = function()
    local random_x = math.random(1000, 676767) * (math.random(0, 1) * 2 - 1)
    local random_z = math.random(1000, 676767) * (math.random(0, 1) * 2 - 1)
    return CFrame.new(random_x, 676767, random_z)
end

RS.ShouldBeInVoid = function()
    if not G.Settings.VoidSpamEnabled then return false end
    local cycleTime = G.Settings.VoidSpamTimeIn + G.Settings.VoidSpamTimeOut
    if cycleTime <= 0 then return false end
    local currentCycle = (tick() * 1000) % cycleTime
    return currentCycle < G.Settings.VoidSpamTimeIn
end

RS.GetVoidCyclePosition = function()
    if RS.ShouldBeInVoid() then
        return RS.GetVoidPos()
    else
        local x = math.random(-10000, 10000)
        local z = math.random(-10000, 10000)
        local y = math.random(500, 5000)
        return CFrame.new(x, y, z)
    end
end

RS.HasGun = function(gunKey)
    if not LPlr then return false end
    gunKey = string.lower(string.gsub(gunKey, '%s+', ''))
    local exactName = RS.GunMapping[gunKey]
    local backpack = LPlr.Backpack
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if string.find(string.lower(item.Name), gunKey) or (exactName and item.Name == exactName) then
                return true
            end
        end
    end
    if LPlr.Character then
        for _, item in pairs(LPlr.Character:GetChildren()) do
            if item:IsA("Tool") and (string.find(string.lower(item.Name), gunKey) or (exactName and item.Name == exactName)) then
                return true
            end
        end
    end
    return false
end

RS.GetAmmo = function(gunName)
    local df = LPlr:FindFirstChild("DataFolder")
    if not df then return 999 end
    local inv = df:FindFirstChild("Inventory")
    if not inv then return 999 end
    local av = inv:FindFirstChild(gunName)
    return av and tonumber(av.Value) or 999
end

RS.GetCash = function()
    local df = LPlr:FindFirstChild("DataFolder")
    local cur = df and df:FindFirstChild("Currency")
    return cur and cur.Value or 0
end

RS.BuyItem = function(itemName, noReturn)
    local s, e = pcall(function()
        local gunKey = nil
        for k, v in pairs(RS.GunMapping) do
            if v == itemName then gunKey = k; break end
        end
        local price = nil
        for shopItemName, shopPrice in pairs(RS.ShopPrices) do
            if string.find(shopItemName, itemName, 1, true) then
                price = shopPrice; break
            end
        end
        if not price then price = RS.Prices[gunKey] or 1000 end
        if RS.GetCash() < price then
            G.Functions.Notify("Auto-Buy", "NOT ENOUGH DHC FOR " .. itemName:upper() .. " ($" .. price .. ")", Color3.fromRGB(255, 100, 100))
            return false
        end
        RS.State.CurrentStatus = "Buying " .. itemName
        local char = LPlr.Character; if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for i = 1, 3 do pcall(function() hum:UnequipTools() end); task.wait(0.02) end
        end
        local shop = WS:FindFirstChild("Ignored") and WS.Ignored:FindFirstChild("Shop"); if not shop then return false end
        local item;
        for _, c in ipairs(shop:GetChildren()) do
            if c.Name == itemName or string.find(string.lower(c.Name), string.lower(itemName), 1, true) then
                item = c; break
            end
        end
        if not item then return false end
        local cd = item:FindFirstChildOfClass("ClickDetector"); if not cd then return false end
        local tp = item:FindFirstChild("Head") or item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart"); if not tp then return false end
        local oldCF = hrp.CFrame
        local shopPos = tp.CFrame * CFrame.new(0, 5, 0)
        csyncTeleport(shopPos, 0.3)
        pcall(fireclickdetector, cd)
        task.wait(0.01)
        if not noReturn then csyncTeleport(oldCF, 0.3) end
        G.Functions.Notify("Auto-Buy", "Bought " .. itemName .. " ($" .. price .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end)
    if not s then print("VulkX Buy Item Error:", e); return false end
    return s
end

RS.BuyAmmo = function(gunKey, targetAmt, noReturn)
    local s, e = pcall(function()
        local ammoName = RS.AmmoMapping[gunKey]
        local gunName = RS.GunMapping[gunKey]
        if not ammoName or not gunName or not RS.HasGun(gunKey) then return false end
        RS.State.CurrentStatus = "Buying Ammo"
        local price = nil
        for shopItemName, shopPrice in pairs(RS.ShopPrices) do
            if string.find(shopItemName, ammoName, 1, true) then
                price = shopPrice; break
            end
        end
        if not price then price = RS.Prices['ammo_' .. gunKey] or 80 end
        if RS.GetCash() < price then
            G.Functions.Notify("Auto-Buy", "NOT ENOUGH DHC FOR AMMO ($" .. price .. ")", Color3.fromRGB(255, 100, 100))
            return false
        end
        local char = LPlr.Character; if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for i = 1, 3 do pcall(function() hum:UnequipTools() end); task.wait(0.02) end
        end
        local shop = WS:FindFirstChild("Ignored") and WS.Ignored:FindFirstChild("Shop"); if not shop then return false end
        local item;
        for _, c in ipairs(shop:GetChildren()) do
            if string.find(string.lower(c.Name), string.lower(ammoName), 1, true) then
                item = c; break
            end
        end
        if not item then item = shop:FindFirstChild(ammoName) end
        if not item then return false end
        local cd = item:FindFirstChildOfClass("ClickDetector"); if not cd then return false end
        local tp = item:FindFirstChild("Head") or item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart"); if not tp then return false end
        local oldCF = hrp.CFrame
        local shopPos = tp.CFrame * CFrame.new(0, 5, 0)
        for i = 1, 20 do
            if RS.GetAmmo(gunName) >= targetAmt or RS.GetCash() < price then break end
            csyncTeleport(shopPos, 0.2)
            pcall(fireclickdetector, cd)
            task.wait(0.01)
        end
        if not noReturn then csyncTeleport(oldCF, 0.3) end
        G.Functions.Notify("Auto-Buy", "Bought ammo for " .. gunName .. " ($" .. price .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end)
    if not s then print("VulkX Buy Ammo Error:", e); return false end
    return s
end

RS.GetArmor = function()
    local df = LPlr:FindFirstChild("DataFolder")
    if df then
        local info = df:FindFirstChild("Information")
        if info then
            local av = info:FindFirstChild("ArmorSave")
            if av then return tonumber(av.Value) or 0 end
        end
    end
    return 0
end

RS.BuyArmor = function(noReturn)
    local s, e = pcall(function()
        RS.State.CurrentStatus = "Buying Armor"
        local armorShop = nil
        local armorPrice = nil
        local shop = WS:FindFirstChild("Ignored") and WS.Ignored:FindFirstChild("Shop")
        if not shop then G.Functions.Notify("Auto-Buy", "Shop not found!", Color3.fromRGB(255, 165, 0)); return false end
        for _, item in ipairs(shop:GetChildren()) do
            if string.find(item.Name, "High%-Medium Armor", 1, true) then
                armorShop = item
                local priceMatch = string.match(item.Name, "%$(%d+)")
                if priceMatch then armorPrice = tonumber(priceMatch) end
                break
            end
        end
        if not armorShop then G.Functions.Notify("Auto-Buy", "Armor shop not found!", Color3.fromRGB(255, 165, 0)); return false end
        if not armorPrice then armorPrice = 2513 end
        if RS.GetCash() < armorPrice then
            G.Functions.Notify("Auto-Buy", "NOT ENOUGH DHC FOR ARMOR ($" .. armorPrice .. ")", Color3.fromRGB(255, 100, 100))
            return false
        end
        local char = LPlr.Character; if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return false end
        local be = char:FindFirstChild("BodyEffects")
        if be and be:FindFirstChild("K.O") and be["K.O"].Value then
            G.Functions.Notify("Auto-Buy", "Cannot buy armor while K.O.", Color3.fromRGB(255, 100, 100))
            return false
        end
        for i = 1, 3 do pcall(function() hum:UnequipTools() end) end
        local armorClickDetector = armorShop:FindFirstChildOfClass("ClickDetector")
        if not armorClickDetector then G.Functions.Notify("Auto-Buy", "No click detector on armor!", Color3.fromRGB(255, 165, 0)); return false end
        local tp = armorShop:FindFirstChild("Head") or armorShop.PrimaryPart or armorShop:FindFirstChildWhichIsA("BasePart"); if not tp then return false end
        local oldCF = hrp.CFrame
        local shopPos = tp.CFrame * CFrame.new(0, 5, 0)
        local startingArmor = RS.GetArmor()
        csyncTeleport(shopPos, 0.3)
        fireclickdetector(armorClickDetector)
        task.wait(0.01)
        local newArmor = RS.GetArmor()
        if newArmor > startingArmor then
            G.Functions.Notify("Auto-Buy", "Bought armor ($" .. armorPrice .. ")", Color3.fromRGB(100, 255, 100))
            if not noReturn then csyncTeleport(oldCF, 0.3) end
            return true
        else
            G.Functions.Notify("Auto-Buy", "Failed to buy armor!", Color3.fromRGB(255, 100, 100))
            return false
        end
    end)
    if not s then print("VulkX Buy Armor Error:", e); return false end
    return s
end

RS.ValidTarget = function(enemy)
    if not (enemy and enemy.Character) then return false end
    if enemy.Character:FindFirstChildOfClass("ForceField") then return false end
    local be = enemy.Character:FindFirstChild("BodyEffects")
    if be and (be:FindFirstChild("K.O") and be["K.O"].Value) then return false end
    if is_stomped(enemy) then return false end
    if not (enemy.Character:FindFirstChild("Head") and enemy.Character:FindFirstChild("HumanoidRootPart")) then return false end
    local hum = enemy.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return false end
    return true
end

RS.GetInvalidReason = function(target)
    if not target or not target.Character then return "No character" end
    local char = target.Character
    local be = char:FindFirstChild("BodyEffects")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if be and be:FindFirstChild("K.O") and be["K.O"].Value then return "K.O." end
    if is_stomped(target) then return "Dead" end
    if char:FindFirstChildOfClass("ForceField") then return "ForceField" end
    if not char:FindFirstChild("Head") then return "No head" end
    if not char:FindFirstChild("HumanoidRootPart") then return "No HRP" end
    if hum and hum.Health <= 0 then return "Health 0" end
    return "Unknown"
end

RS.GetAllInvalidReason = function()
    local reasons = {}
    for _, target in ipairs(RS.State.auraTargets) do
        local reason = RS.GetInvalidReason(target)
        if reason and not table.find(reasons, reason) then
            table.insert(reasons, reason)
        end
    end
    if #reasons == 0 then return "No targets in list" end
    if #reasons == 1 then return "All targets: " .. reasons[1] end
    return "Various reasons"
end

RS.CheckAndReload = function()
    if RS.State.IsStomping then return false end
    local now = tick()
    if now - RS.State.LastReloadCheck < RS.State.ReloadCooldown then return false end
    RS.State.LastReloadCheck = now
    local char = LPlr.Character
    if not char then return false end
    local needsReload = false
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local ammo = tool:FindFirstChild("Ammo")
            if ammo and ammo.Value <= 0 then
                needsReload = true
                if MainEvent then
                    pcall(function() MainEvent:FireServer("Reload", tool) end)
                end
            end
        end
    end
    return needsReload
end

RS.Shoot = function(tool, enemy)
    if not (tool and tool:FindFirstChild('Handle')) or not RS.ValidTarget(enemy) then return end
    local character = enemy.Character; if not character then return end
    local head = character:FindFirstChild('Head'); if not head then return end
    local now = tick()
    local isShotgun = string.find(string.lower(tool.Name), "shotgun") or string.find(string.lower(tool.Name), "double")
    local shotDelay = isShotgun and 0.08 or G.Settings.ShootDelay
    local shootFrom = head.Position + Vector3.new(0,3,0)
    if RS.lastShotTimes[tool] and now - RS.lastShotTimes[tool] < shotDelay then return end
    RS.lastShotTimes[tool] = now
    if MainEvent then
        pcall(function()
            MainEvent:FireServer("ShootGun", tool.Handle, shootFrom, head.Position, head, Vector3.new(0,0,0))
        end)
    end
    if G.Settings.BulletTracers.Enabled and csync.active and csync.server_cframe then
        G.Functions.CreateTracer(csync.server_cframe.Position, head.Position)
    end
end

-- ULTIMATE STRAFE PATTERN (Enhanced)
local strafeTime = 0
local lastTeleport = 0
local strafeNoiseOffset = Vector3.new()
RS.GetStrafePos = function(targetRoot)
    if not targetRoot then return nil end
    local dt = RunS.Heartbeat:Wait()
    strafeTime += dt * (G.Settings.StrafeSpeed / 100)

    local radiusBase = G.Settings.StrafeDistance
    local targetPos = targetRoot.Position
    local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.zero

    -- Advanced prediction with acceleration estimation
    local predictionTime = math.clamp(radiusBase / 180, 0.03, 0.2)
    local predictedPos = targetPos + targetVel * predictionTime

    local distance = (predictedPos - Cam.CFrame.Position).Magnitude
    local dynamicRadius = radiusBase * math.clamp(distance / 80, 0.5, 1.5)

    -- Multi-frequency orbital motion
    local orbitSpeed1 = G.Settings.StrafeSpeed * 0.008
    local orbitSpeed2 = G.Settings.StrafeSpeed * 0.015
    local angle1 = strafeTime * orbitSpeed1 * 4
    local angle2 = strafeTime * orbitSpeed2 * 3

    local orbitX = math.cos(angle1) * dynamicRadius * 0.7 + math.sin(angle2) * dynamicRadius * 0.3
    local orbitZ = math.sin(angle1) * dynamicRadius * 0.7 + math.cos(angle2) * dynamicRadius * 0.3

    -- Enhanced Perlin noise for organic movement
    local noiseX = math.noise(strafeTime * 0.8, 0) * dynamicRadius * 0.3
    local noiseZ = math.noise(0, strafeTime * 0.8) * dynamicRadius * 0.3
    local noiseY = math.noise(strafeTime, strafeTime) * 20

    -- Harmonic oscillations for vertical movement
    local verticalWave = math.sin(strafeTime * 2.5) * 10 + math.cos(strafeTime * 1.8) * 8

    -- Random teleport-like jumps
    local teleportOffset = Vector3.zero
    if tick() - lastTeleport > 1.0 then
        if math.random() < 0.12 then
            lastTeleport = tick()
            teleportOffset = Vector3.new(
                (math.random() - 0.5) * dynamicRadius * 0.8,
                (math.random() - 0.5) * 30,
                (math.random() - 0.5) * dynamicRadius * 0.8
            )
        end
    end

    -- Cumulative offset
    local offset = Vector3.new(
        orbitX + noiseX + teleportOffset.X,
        verticalWave + noiseY + teleportOffset.Y,
        orbitZ + noiseZ + teleportOffset.Z
    )

    -- Rotation based on movement direction and noise
    local rotX = math.noise(strafeTime * 2, 1) * math.rad(8)
    local rotY = math.atan2(offset.X, offset.Z) + math.noise(1, strafeTime * 2) * math.rad(5)
    local rotZ = math.noise(strafeTime * 2.5, 2) * math.rad(5)

    local finalPos = predictedPos + offset
    local lookAt = CFrame.new(finalPos, predictedPos)
    return lookAt * CFrame.Angles(rotX, rotY, rotZ)
end

RS.EquipGuns = function()
    local now = tick()
    if now - RS.State.lastEquipTime < RS.State.EQUIP_COOLDOWN then return end
    if RS.State.IS_BUYING then return end
    local char = LPlr.Character; if not char then return end
    local bp = LPlr:FindFirstChild("Backpack"); if not bp then return end
    local equippedCount = 0
    for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then equippedCount = equippedCount + 1 end end
    if equippedCount >= 2 then return end
    RS.State.lastEquipTime = now
    for _, gk in ipairs(G.Settings.SelectedGuns or {}) do
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                if string.find(string.lower(t.Name), string.lower(gk)) then
                    t.Parent = char
                    task.wait(0.05)
                    if equippedCount >= 1 then break end
                end
            end
        end
        if equippedCount >= 1 then break end
    end
end

RS.StopAll = function(options)
    options = options or {}
    local isTemporary = options.isTemporary or false
    RS.State.ACTION = "IDLE"
    RS.State.Spectating = false
    RS.State.RageLoopRunning = false
    RS.State.IsStomping = false
    RS.State.KOedTargets = {}
    RS.State.StompQueue = {}
    local localHumanoid = LPlr.Character and LPlr.Character:FindFirstChildOfClass('Humanoid')
    if localHumanoid then
        Cam.CameraSubject = localHumanoid
        Cam.CameraType = Enum.CameraType.Custom
    end
    if not isTemporary and RS.State.SavedPosition then
        RS.ReturnToPosition()
    end
end

RS.ShootAllGuns = function(target)
    if not target or not target.Character then return end
    local char = LPlr.Character; if not char then return end
    local tools = {}
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then table.insert(tools, t) end
    end
    for _, t in ipairs(tools) do
        RS.Shoot(t, target)
    end
end

-- Master kill loop
RS.MasterKillLoop = function()
    if RS.State.RageLoopRunning then return end
    RS.State.RageLoopRunning = true
    RS.State.ACTION = "ACTIVE_MAIN_LOOP"
    if not RS.State.ShouldResumeAfterKO then
        RS.SavePosition()
    end
    RS.State.ShouldResumeAfterKO = false
    task.spawn(function()
        while G.Settings.Ragebot.Active and RS.State.RageLoopRunning do
            local s, e = pcall(function()
                if not LPlr.Character or not LPlr.Character.Parent then
                    RS.State.CurrentStatus = "Waiting for character..."
                    LPlr.CharacterAdded:Wait()
                    task.wait(0.01)
                    RS.SavePosition()
                    return
                end
                local char = LPlr.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum or hum.Health <= 0 then
                    RS.State.CurrentStatus = "Waiting for respawn..."
                    local respawnTime = tick()
                    while tick() - respawnTime < 10 do
                        if LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") and LPlr.Character:FindFirstChildOfClass("Humanoid") and LPlr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                            break
                        end
                        task.wait(0.01)
                    end
                    if G.Settings.Ragebot.Active then
                        RS.State.CurrentStatus = "Respawned, continuing..."
                        RS.SavePosition()
                        task.wait(0.01)
                    end
                    return
                end
                local localBE = LPlr.Character and LPlr.Character:FindFirstChild("BodyEffects")
                local isLocalKO = localBE and localBE:FindFirstChild("K.O") and localBE["K.O"].Value
                if isLocalKO then
                    RS.State.CurrentStatus = "Local player K.O., pausing..."
                    RS.StopAll({isTemporary = true})
                    RS.State.ShouldResumeAfterKO = true
                    while isLocalKO and G.Settings.Ragebot.Active do
                        task.wait(0.01)
                        localBE = LPlr.Character and LPlr.Character:FindFirstChild("BodyEffects")
                        isLocalKO = localBE and localBE:FindFirstChild("K.O") and localBE["K.O"].Value
                    end
                    if not G.Settings.Ragebot.Active then
                        RS.StopAll(); RS.State.RageLoopRunning = false; return
                    end
                    RS.State.CurrentStatus = "Respawned, resuming..."
                    task.wait(0.01)
                    RS.SavePosition()
                    return
                end
                if not RS.State.IS_BUYING then
                    local needsBuying = false
                    local gunsToBuy, ammoToBuy = {}, {}
                    local needsArmor = false
                    if G.Settings.AutoGuns.Mode then
                        for _, gun in ipairs(G.Settings.SelectedGuns) do
                            if not RS.HasGun(gun) then
                                table.insert(gunsToBuy, gun); needsBuying = true
                            end
                        end
                    end
                    if G.Settings.AutoAmmo.Mode then
                        for _, gun in ipairs(G.Settings.SelectedGuns) do
                            local gn = RS.GunMapping[gun]
                            if gn and RS.HasGun(gun) then
                                local thresholds = G.Settings.AutoAmmo.Guns[gun] or {low = 20, high = 150}
                                if RS.GetAmmo(gn) <= thresholds.low then
                                    table.insert(ammoToBuy, gun); needsBuying = true
                                end
                            end
                        end
                    end
                    if G.Settings.AutoArmor.Mode and RS.GetArmor() < G.Settings.AutoArmor.Threshold then
                        needsArmor = true; needsBuying = true
                    end
                    if needsBuying then
                        RS.State.IS_BUYING = true
                        RS.State.CurrentStatus = "Need to buy items, stopping to purchase..."
                        RS.State.ShouldResumeAfterBuy = true
                        local myHRP = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            local oldCF = myHRP.CFrame
                            RS.GoToVoid()
                            task.wait(0.01)
                            for _, gk in ipairs(gunsToBuy) do
                                local gn = RS.GunMapping[gk]; if gn then RS.BuyItem(gn, true); task.wait(0.01) end
                            end
                            if needsArmor then
                                RS.BuyArmor(true); task.wait(0.01)
                            end
                            for _, gk in ipairs(ammoToBuy) do
                                local thresholds = G.Settings.AutoAmmo.Guns[gk] or {low = 20, high = 150}
                                RS.BuyAmmo(gk, thresholds.high, true); task.wait(0.01)
                            end
                            if oldCF then csyncTeleport(oldCF, 0.3) end
                        end
                        RS.State.IS_BUYING = false
                        RS.State.CurrentStatus = "Finished buying, resuming..."
                        task.wait(0)
                        RS.EquipGuns()
                    end
                end
                local myHRP = LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then
                    RS.State.ACTION = "IDLE"
                    RS.State.RageLoopRunning = false
                    return
                end
                if RS.State.IS_BUYING then
                    task.wait(0.01); return
                end
                for i = #RS.State.auraTargets, 1, -1 do
                    if not RS.State.auraTargets[i] or not RS.State.auraTargets[i].Parent then
                        table.remove(RS.State.auraTargets, i)
                    end
                end
                if #RS.State.auraTargets == 0 then
                    RS.State.CurrentStatus = "Waiting (No targets in list)"
                    RS.State.Spectating = false
                    local localHumanoid = LPlr.Character and LPlr.Character:FindFirstChildOfClass('Humanoid')
                    if localHumanoid then
                        Cam.CameraSubject = localHumanoid
                        Cam.CameraType = Enum.CameraType.Custom
                    end
                    local startTime = tick()
                    while tick() - startTime < 2 and #RS.State.auraTargets == 0 and G.Settings.Ragebot.Active do
                        if myHRP then enableCsync(RS.GetVoidCyclePosition()) end
                        RunS.Heartbeat:Wait()
                        disableCsync()
                    end
                    return
                end
                if RS.CheckAndReload() and not RS.State.IsStomping then
                    RS.State.CurrentStatus = "Reloading in void..."
                    local startTime = tick()
                    while tick() - startTime < 1.5 and G.Settings.Ragebot.Active do
                        if myHRP then enableCsync(RS.GetVoidCyclePosition()) end
                        RunS.Heartbeat:Wait()
                        disableCsync()
                    end
                    return
                end
                if G.Settings.KillMode == "Stomp" then
                    local allKO = true
                    local nonKOedTargets = {}
                    for _, target in ipairs(RS.State.auraTargets) do
                        if target and target.Character then
                            local tBE = target.Character:FindFirstChild("BodyEffects")
                            local isKO = tBE and tBE:FindFirstChild("K.O") and tBE["K.O"].Value
                            if isKO and not is_stomped(target) then
                                if not table.find(RS.State.KOedTargets, target) then
                                    table.insert(RS.State.KOedTargets, target)
                                end
                            elseif not isKO and RS.ValidTarget(target) then
                                allKO = false
                                table.insert(nonKOedTargets, target)
                            end
                        end
                    end
                    if allKO and #RS.State.KOedTargets > 0 then
                        for _, target in ipairs(RS.State.KOedTargets) do
                            if is_stomped(target) then continue end
                            RS.State.CurrentStatus = "Stomping " .. target.Name
                            RS.State.IsStomping = true
                            if RS.State.Spectating then
                                RS.State.Spectating = false
                                local lh = LPlr.Character and LPlr.Character:FindFirstChildOfClass('Humanoid')
                                if lh then
                                    Cam.CameraSubject = lh
                                    Cam.CameraType = Enum.CameraType.Custom
                                end
                            end
                            local tChar = target.Character
                            if tChar then
                                local torso = tChar:FindFirstChild("UpperTorso") or tChar:FindFirstChild("Torso") or tChar:FindFirstChild("HumanoidRootPart")
                                if torso then
                                    for i = 1, 20 do
                                        if not G.Settings.Ragebot.Active or is_stomped(target) then break end
                                        enableCsync(CFrame.new(torso.Position + Vector3.new(0, 3, 0)))
                                        if MainEvent then
                                            pcall(function() MainEvent:FireServer("Stomp") end)
                                        end
                                        task.wait(0.001)
                                        disableCsync()
                                    end
                                end
                            end
                            RS.State.IsStomping = false
                            if is_stomped(target) then
                                RS.State.CurrentStatus = "Stomped " .. target.Name
                                task.wait(0.001)
                            end
                        end
                        RS.State.KOedTargets = {}
                        return
                    elseif #nonKOedTargets > 0 then
                        if tick() - RS.State.LastTargetSwap >= G.Settings.SwapInterval then
                            local foundValid = false
                            for _, target in ipairs(nonKOedTargets) do
                                if RS.ValidTarget(target) then
                                    RS.State.CurrentTarget = target
                                    foundValid = true
                                    break
                                end
                            end
                            if not foundValid then
                                RS.State.CurrentStatus = "Waiting - " .. RS.GetAllInvalidReason()
                                local startTime = tick()
                                while tick() - startTime < 2 and G.Settings.Ragebot.Active do
                                    if myHRP then enableCsync(RS.GetVoidCyclePosition()) end
                                    RunS.Heartbeat:Wait()
                                    disableCsync()
                                end
                                return
                            end
                            RS.State.LastTargetSwap = tick()
                        end
                    else
                        RS.State.CurrentStatus = "All targets stomped, waiting..."
                        local startTime = tick()
                        while tick() - startTime < 2 and G.Settings.Ragebot.Active do
                            if myHRP then enableCsync(RS.GetVoidCyclePosition()) end
                            RunS.Heartbeat:Wait()
                            disableCsync()
                        end
                        return
                    end
                else -- Normal kill mode
                    if tick() - RS.State.LastTargetSwap >= G.Settings.SwapInterval then
                        local foundValid = false
                        local startIdx = RS.State.CurrentTargetIndex
                        local attempts = 0
                        while attempts < #RS.State.auraTargets do
                            local target = RS.State.auraTargets[RS.State.CurrentTargetIndex]
                            if target and RS.ValidTarget(target) then
                                foundValid = true
                                RS.State.CurrentTarget = target
                                break
                            end
                            RS.State.CurrentTargetIndex = (RS.State.CurrentTargetIndex % #RS.State.auraTargets) + 1
                            attempts = attempts + 1
                            if RS.State.CurrentTargetIndex == startIdx then break end
                        end
                        if not foundValid then
                            RS.State.CurrentStatus = "Waiting - " .. RS.GetAllInvalidReason()
                            local startTime = tick()
                            while tick() - startTime < 2 and G.Settings.Ragebot.Active do
                                if myHRP then enableCsync(RS.GetVoidCyclePosition()) end
                                RunS.Heartbeat:Wait()
                                disableCsync()
                            end
                            return
                        end
                        RS.State.LastTargetSwap = tick()
                    end
                end
                local currentTarget = RS.State.CurrentTarget or RS.State.auraTargets[RS.State.CurrentTargetIndex]
                if not currentTarget then
                    RS.State.CurrentTargetIndex = 1
                    task.wait(0.01)
                    return
                end
                local tChar = currentTarget.Character
                local tBE = tChar and tChar:FindFirstChild("BodyEffects")
                local isKO = tBE and tBE:FindFirstChild("K.O") and tBE["K.O"].Value
                local isSDeath = is_stomped(currentTarget)
                if isSDeath then
                    RS.State.CurrentStatus = "Target dead, waiting for respawn: " .. currentTarget.Name
                    local waitStart = tick()
                    while tick() - waitStart < 10 and is_stomped(currentTarget) and currentTarget.Parent do
                        if myHRP then enableCsync(RS.GetVoidCyclePosition()) end
                        if not is_stomped(currentTarget) then break end
                        RunS.Heartbeat:Wait()
                        disableCsync()
                    end
                    if not is_stomped(currentTarget) and currentTarget.Parent then
                        RS.State.CurrentStatus = "Target respawned, continuing: " .. currentTarget.Name
                        task.wait(0.001)
                    else
                        RS.State.CurrentStatus = "Target still dead or left, skipping: " .. currentTarget.Name
                        RS.State.CurrentTargetIndex = (RS.State.CurrentTargetIndex % #RS.State.auraTargets) + 1
                    end
                    return
                end
                if isKO and G.Settings.KillMode == "Normal" then
                    if #RS.State.auraTargets == 1 then
                        RS.State.CurrentStatus = "Target K.O., waiting: " .. currentTarget.Name
                        if RS.State.Spectating then
                            RS.State.Spectating = false
                            local lh = LPlr.Character and LPlr.Character:FindFirstChildOfClass('Humanoid')
                            if lh then
                                Cam.CameraSubject = lh
                                Cam.CameraType = Enum.CameraType.Custom
                            end
                        end
                        local startTime = tick()
                        while tick() - startTime < 2 and G.Settings.Ragebot.Active do
                            if myHRP then enableCsync(RS.GetVoidCyclePosition()) end
                            RunS.Heartbeat:Wait()
                            disableCsync()
                        end
                    else
                        RS.State.CurrentStatus = "Target K.O., moving to next: " .. currentTarget.Name
                        RS.State.CurrentTargetIndex = (RS.State.CurrentTargetIndex % #RS.State.auraTargets) + 1
                    end
                    return
                end
                RS.State.CurrentStatus = "Strafing " .. currentTarget.Name
                local tRoot = currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart")
                local cf = tRoot and RS.ValidTarget(currentTarget) and RS.GetStrafePos(tRoot) or RS.GetVoidCyclePosition()
                if RS.ShouldBeInVoid() then
                    cf = CFrame.new(cf.Position.X, RS.VOID_Y, cf.Position.Z)
                    RS.State.CurrentStatus = "Strafing (VOID)"
                end
                enableCsync(cf)
                RunS.Heartbeat:Wait()
                RS.EquipGuns()
                RS.ShootAllGuns(currentTarget)
                if G.Settings.SpectateEnabled and tChar and not isKO and not isSDeath and not RS.State.IsStomping then
                    local targetHumanoid = tChar:FindFirstChildOfClass("Humanoid")
                    local targetHead = tChar:FindFirstChild("Head")
                    if targetHumanoid and targetHead then
                        if not RS.State.Spectating then
                            RS.State.Spectating = true
                            Cam.CameraSubject = targetHumanoid
                            Cam.CameraType = Enum.CameraType.Custom
                        end
                        local offset = Vector3.new(0, G.Settings.SpectateHeight, G.Settings.SpectateDistance)
                        Cam.CFrame = CFrame.new(targetHead.Position + offset, targetHead.Position)
                    end
                elseif RS.State.Spectating then
                    RS.State.Spectating = false
                    local localHumanoid = LPlr.Character and LPlr.Character:FindFirstChildOfClass('Humanoid')
                    if localHumanoid then
                        Cam.CameraSubject = localHumanoid
                        Cam.CameraType = Enum.CameraType.Custom
                    end
                end
                RunS.Heartbeat:Wait()
            end)
            if not s then print("VulkX Master Kill Loop Error:", e) end
        end
        RS.State.ACTION = "IDLE"
        RS.State.RageLoopRunning = false
        RS.State.CurrentStatus = "Idle"
        RS.State.IsStomping = false
        RS.State.KOedTargets = {}
        RS.State.StompQueue = {}
        if RS.State.Spectating then RS.State.Spectating = false end
        local localHumanoid = LPlr.Character and LPlr.Character:FindFirstChildOfClass('Humanoid')
        if localHumanoid then
            Cam.CameraSubject = localHumanoid
            Cam.CameraType = Enum.CameraType.Custom
        end
        if RS.State.ShouldResumeAfterBuy and G.Settings.Ragebot.Active then
            task.wait(0.001)
            RS.MasterKillLoop()
        end
    end)
end

-- Auto reload when idle
table.insert(connections, task.spawn(function()
    while true do
        local s, e = pcall(function()
            if not G.Settings.Ragebot.Active and RS.State.ACTION == "IDLE" then
                if LPlr.Character and MainEvent then
                    for _, tool in ipairs(LPlr.Character:GetChildren()) do
                        if tool:IsA('Tool') then
                            local ammo = tool:FindFirstChild('Ammo')
                            if ammo and typeof(ammo.Value) == "number" and ammo.Value <= 0 then
                                pcall(function() MainEvent:FireServer('Reload', tool) end)
                                task.wait(0.25)
                            end
                        end
                    end
                end
            end
        end)
        if not s then print("VulkX Idle Reload Error:", e) end
        task.wait(0.2)
    end
end))

-- Remove players from target list on leave
table.insert(connections, Plrs.PlayerRemoving:Connect(function(player)
    for i = #RS.State.auraTargets, 1, -1 do
        if RS.State.auraTargets[i] == player then
            table.remove(RS.State.auraTargets, i)
        end
    end
end))

-- ESP System
local ESP = G.Settings.ESP
local R15_SKELETON_BONES = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}
local R6_SKELETON_BONES = {
    {"Head", "Torso"},
    {"Torso", "LeftArm"},
    {"Torso", "RightArm"},
    {"Torso", "LeftLeg"},
    {"Torso", "RightLeg"}
}

local function ClearESP()
    for player, objects in pairs(ESP.Objects) do
        for key, obj in pairs(objects) do
            pcall(function()
                if type(obj) == "table" then
                    for _, line in pairs(obj) do
                        line.Visible = false
                        line:Remove()
                    end
                else
                    obj.Visible = false
                    obj:Remove()
                end
            end)
        end
    end
    ESP.Objects = {}
end

local function CreateESP(player)
    if player == LPlr or ESP.Objects[player] then return end
    local objects = {
        BoxOutline = Drawing.new("Square"),
        Box = Drawing.new("Square"),
        NameText = Drawing.new("Text"),
        DistanceText = Drawing.new("Text"),
        ToolText = Drawing.new("Text"),
        TracerOutline = Drawing.new("Line"),
        Tracer = Drawing.new("Line"),
        HealthBarOutline = Drawing.new("Square"),
        HealthBarBackground = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        ArmorBarOutline = Drawing.new("Square"),
        ArmorBarBackground = Drawing.new("Square"),
        ArmorBar = Drawing.new("Square"),
        SkeletonLines = {},
        SkeletonOutlines = {}
    }
    objects.BoxOutline.Thickness, objects.BoxOutline.Filled, objects.BoxOutline.Color, objects.BoxOutline.Transparency, objects.BoxOutline.Visible = 3, false, Color3.new(0,0,0), 1, false
    objects.Box.Thickness, objects.Box.Filled, objects.Box.Transparency, objects.Box.Visible = 1, false, 1, false
    objects.NameText.Size, objects.NameText.Center, objects.NameText.Outline, objects.NameText.OutlineColor, objects.NameText.Visible, objects.NameText.Font = 14, true, true, Color3.new(0,0,0), false, drawingFonts[ESP.Font] or Drawing.Fonts.Plex
    objects.DistanceText.Size, objects.DistanceText.Center, objects.DistanceText.Outline, objects.DistanceText.OutlineColor, objects.DistanceText.Visible, objects.DistanceText.Font = 13, true, true, Color3.new(0,0,0), false, drawingFonts[ESP.Font] or Drawing.Fonts.Plex
    objects.ToolText.Size, objects.ToolText.Center, objects.ToolText.Outline, objects.ToolText.OutlineColor, objects.ToolText.Visible, objects.ToolText.Font = 13, true, true, Color3.new(0,0,0), false, drawingFonts[ESP.Font] or Drawing.Fonts.Plex
    objects.TracerOutline.Thickness, objects.TracerOutline.Color, objects.TracerOutline.Transparency, objects.TracerOutline.Visible = 3, Color3.new(0,0,0), 1, false
    objects.Tracer.Thickness, objects.Tracer.Transparency, objects.Tracer.Visible = 1, 1, false
    objects.HealthBarOutline.Thickness, objects.HealthBarOutline.Filled, objects.HealthBarOutline.Color, objects.HealthBarOutline.Transparency, objects.HealthBarOutline.Visible = 1, false, Color3.new(0,0,0), 1, false
    objects.HealthBarBackground.Filled, objects.HealthBarBackground.Color, objects.HealthBarBackground.Transparency, objects.HealthBarBackground.Visible = true, Color3.new(0.2,0.2,0.2), 0.5, false
    objects.HealthBar.Filled, objects.HealthBar.Transparency, objects.HealthBar.Visible = true, 1, false
    objects.ArmorBarOutline.Thickness, objects.ArmorBarOutline.Filled, objects.ArmorBarOutline.Color, objects.ArmorBarOutline.Transparency, objects.ArmorBarOutline.Visible = 1, false, Color3.new(0,0,0), 1, false
    objects.ArmorBarBackground.Filled, objects.ArmorBarBackground.Color, objects.ArmorBarBackground.Transparency, objects.ArmorBarBackground.Visible = true, Color3.new(0.2,0.2,0.4), 0.5, false
    objects.ArmorBar.Filled, objects.ArmorBar.Transparency, objects.ArmorBar.Visible = true, 1, false
    for i = 1, 15 do
        local outline = Drawing.new("Line"); outline.Thickness = 3; outline.Color = Color3.new(0,0,0); outline.Visible = false; table.insert(objects.SkeletonOutlines, outline)
        local line = Drawing.new("Line"); line.Thickness = 1; line.Visible = false; table.insert(objects.SkeletonLines, line)
    end
    ESP.Objects[player] = objects
end

local function GetPlayerArmor(player)
    local df = player:FindFirstChild("DataFolder")
    if df then
        local info = df:FindFirstChild("Information")
        if info then
            local av = info:FindFirstChild("ArmorSave")
            if av then return tonumber(av.Value) or 0 end
        end
    end
    return 0
end

local function UpdateESP()
    for player, objects in pairs(ESP.Objects) do
        pcall(function()
            if not player or not player.Parent then return end
            local char = player.Character
            local allVisible = false
            if char and char.Parent then
                local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChild("Humanoid")
                if hrp and head and hum and hum.Health > 0 then
                    local hrpPos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
                    local distance = (LPlr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    -- Max distance check
                    if onScreen and hrpPos.Z > 0 and (not ESP.MaxDistanceEnabled or distance < ESP.MaxDistance) then
                        allVisible = true
                        local headPos = Cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = Cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 2
                        local boxX = hrpPos.X - width / 2
                        local boxY = headPos.Y

                        objects.BoxOutline.Visible = ESP.Boxes
                        objects.Box.Visible = ESP.Boxes
                        if ESP.Boxes then
                            objects.BoxOutline.Size = Vector2.new(width, height)
                            objects.BoxOutline.Position = Vector2.new(boxX, boxY)
                            objects.Box.Size = Vector2.new(width, height)
                            objects.Box.Position = Vector2.new(boxX, boxY)
                            objects.Box.Color = ESP.Colors.Box
                        end

                        objects.NameText.Visible = ESP.Names
                        if ESP.Names then
                            local nameText = (ESP.NameMode == "Username") and player.Name or (ESP.NameMode == "DisplayName") and player.DisplayName or (player.DisplayName .. " (@" .. player.Name .. ")")
                            objects.NameText.Text = nameText
                            objects.NameText.Position = Vector2.new(hrpPos.X, boxY - 18)
                            objects.NameText.Color = ESP.Colors.Name
                        end

                        local distanceYPos = legPos.Y + 5
                        objects.DistanceText.Visible = ESP.Distance
                        if ESP.Distance then
                            objects.DistanceText.Text = tostring(math.floor(distance)) .. "m"
                            objects.DistanceText.Position = Vector2.new(hrpPos.X, distanceYPos)
                            objects.DistanceText.Color = ESP.Colors.Distance
                        end

                        objects.ToolText.Visible = ESP.Tool
                        if ESP.Tool then
                            local toolName = char:FindFirstChildOfClass("Tool") and char:FindFirstChildOfClass("Tool").Name or "[No Tool]"
                            local toolYPos = ESP.Distance and distanceYPos + 15 or distanceYPos
                            objects.ToolText.Text = toolName
                            objects.ToolText.Position = Vector2.new(hrpPos.X, toolYPos)
                            objects.ToolText.Color = ESP.Colors.Tool
                        end

                        objects.TracerOutline.Visible = ESP.Tracers
                        objects.Tracer.Visible = ESP.Tracers
                        if ESP.Tracers then
                            local tracerY = (ESP.TracerOrigin == "Top" and 0) or (ESP.TracerOrigin == "Middle" and Cam.ViewportSize.Y / 2) or Cam.ViewportSize.Y
                            local tracerFrom = Vector2.new(Cam.ViewportSize.X / 2, tracerY)
                            local tracerTo = Vector2.new(hrpPos.X, hrpPos.Y)
                            objects.TracerOutline.From, objects.TracerOutline.To = tracerFrom, tracerTo
                            objects.Tracer.From, objects.Tracer.To = tracerFrom, tracerTo
                            objects.Tracer.Color = ESP.Colors.Tracer
                        end

                        objects.HealthBarOutline.Visible = ESP.HealthBar
                        objects.HealthBarBackground.Visible = ESP.HealthBar
                        objects.HealthBar.Visible = ESP.HealthBar
                        if ESP.HealthBar then
                            local healthPercent = hum.Health / hum.MaxHealth
                            local barHeight = height
                            local barWidth = 4
                            local barX = boxX - barWidth - 2
                            objects.HealthBarOutline.Size = Vector2.new(barWidth + 2, barHeight + 2)
                            objects.HealthBarOutline.Position = Vector2.new(barX - 1, boxY - 1)
                            objects.HealthBarBackground.Size = Vector2.new(barWidth, barHeight)
                            objects.HealthBarBackground.Position = Vector2.new(barX, boxY)
                            objects.HealthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                            objects.HealthBar.Position = Vector2.new(barX, boxY + barHeight * (1 - healthPercent))
                            objects.HealthBar.Color = healthPercent > 0.6 and ESP.Colors.HealthHigh or healthPercent > 0.3 and ESP.Colors.HealthMid or ESP.Colors.HealthLow
                        end

                        objects.ArmorBarOutline.Visible = ESP.ArmorBar
                        objects.ArmorBarBackground.Visible = ESP.ArmorBar
                        objects.ArmorBar.Visible = ESP.ArmorBar
                        if ESP.ArmorBar then
                            local armor = GetPlayerArmor(player)
                            local armorPercent = math.min(armor / 200, 1)
                            local barHeight = height
                            local barWidth = 4
                            local barX = boxX - (barWidth * 2) - 6
                            objects.ArmorBarOutline.Size = Vector2.new(barWidth + 2, barHeight + 2)
                            objects.ArmorBarOutline.Position = Vector2.new(barX - 1, boxY - 1)
                            objects.ArmorBarBackground.Size = Vector2.new(barWidth, barHeight)
                            objects.ArmorBarBackground.Position = Vector2.new(barX, boxY)
                            objects.ArmorBar.Size = Vector2.new(barWidth, barHeight * armorPercent)
                            objects.ArmorBar.Position = Vector2.new(barX, boxY + barHeight * (1 - armorPercent))
                            objects.ArmorBar.Color = ESP.Colors.ArmorHigh:Lerp(ESP.Colors.ArmorLow, 1 - armorPercent)
                        end

                        local skeletonBones = char:FindFirstChild("UpperTorso") and R15_SKELETON_BONES or R6_SKELETON_BONES
                        local lineIndex = 1
                        if ESP.Skeleton then
                            for _, bonePair in ipairs(skeletonBones) do
                                if lineIndex > #objects.SkeletonLines then break end
                                local part1 = char:FindFirstChild(bonePair[1])
                                local part2 = char:FindFirstChild(bonePair[2])
                                if part1 and part2 then
                                    local pos1, onScreen1 = Cam:WorldToViewportPoint(part1.Position)
                                    local pos2, onScreen2 = Cam:WorldToViewportPoint(part2.Position)
                                    if onScreen1 and onScreen2 then
                                        local outline = objects.SkeletonOutlines[lineIndex]
                                        local line = objects.SkeletonLines[lineIndex]
                                        outline.From = Vector2.new(pos1.X, pos1.Y)
                                        outline.To = Vector2.new(pos2.X, pos2.Y)
                                        outline.Visible = true
                                        line.From = Vector2.new(pos1.X, pos1.Y)
                                        line.To = Vector2.new(pos2.X, pos2.Y)
                                        line.Color = ESP.Colors.Skeleton
                                        line.Visible = true
                                        lineIndex = lineIndex + 1
                                    end
                                end
                            end
                        end
                        for i = lineIndex, #objects.SkeletonLines do
                            objects.SkeletonOutlines[i].Visible = false
                            objects.SkeletonLines[i].Visible = false
                        end
                    end
                end
            end
            if not allVisible then
                for key, obj in pairs(objects) do
                    if type(obj) == "table" then
                        for _, line in pairs(obj) do line.Visible = false end
                    else
                        obj.Visible = false
                    end
                end
            end
        end)
    end
end

table.insert(connections, task.spawn(function()
    while true do
        local s, e = pcall(function()
            if ESP.Enabled then
                for _, player in ipairs(Plrs:GetPlayers()) do
                    CreateESP(player)
                end
                pcall(UpdateESP)
            else
                ClearESP()
            end
        end)
        if not s then print("VulkX ESP Loop Error:", e) end
        RunS.RenderStepped:Wait()
    end
end))

table.insert(connections, Plrs.PlayerAdded:Connect(function(player)
    task.wait(0.1)
    CreateESP(player)
    table.insert(connections, player.CharacterAdded:Connect(function()
        task.wait(0.1)
    end))
end))

table.insert(connections, Plrs.PlayerRemoving:Connect(function(player)
    if ESP.Objects[player] then
        for key, obj in pairs(ESP.Objects[player]) do
            pcall(function()
                if type(obj) == "table" then
                    for _, line in pairs(obj) do line:Remove() end
                else
                    obj:Remove()
                end
            end)
        end
        ESP.Objects[player] = nil
    end
end))

-- Bullet Tracers
function G.Functions.CreateTracer(startPos, endPos)
    pcall(function()
        if typeof(startPos) ~= "Vector3" or typeof(endPos) ~= "Vector3" then return end
        local startPart = Instance.new("Part", WS)
        startPart.Anchored = true
        startPart.CanCollide = false
        startPart.Size = Vector3.new(0.1,0.1,0.1)
        startPart.Transparency = 1
        startPart.Position = startPos

        local endPart = Instance.new("Part", WS)
        endPart.Anchored = true
        endPart.CanCollide = false
        endPart.Size = Vector3.new(0.1,0.1,0.1)
        endPart.Transparency = 1
        endPart.Position = endPos

        local attach0 = Instance.new("Attachment", startPart)
        local attach1 = Instance.new("Attachment", endPart)
        local beam = Instance.new("Beam", startPart)
        beam.Attachment0 = attach0
        beam.Attachment1 = attach1
        beam.Color = ColorSequence.new(G.Settings.BulletTracers.Color)
        beam.Width0 = G.Settings.BulletTracers.Size
        beam.Width1 = G.Settings.BulletTracers.Size
        beam.Transparency = NumberSequence.new(G.Settings.BulletTracers.Transparency)
        if G.Settings.BulletTracers.Texture ~= "Default" then
            beam.Texture = G.Tables.TracerTextures[G.Settings.BulletTracers.Texture]
        end

        task.spawn(function()
            task.wait(G.Settings.BulletTracers.TimeAlive or 3)
            pcall(function()
                if beam and beam.Parent then
                    local tween = TS:Create(beam, TweenInfo.new(0.3), {Width0 = 0, Width1 = 0})
                    tween:Play()
                    tween.Completed:Wait()
                end
                Debris:AddItem(startPart, 0)
                Debris:AddItem(endPart, 0)
            end)
        end)
    end)
end

if hasGetNamecallMethod and MainEvent ~= nil then
    pcall(function()
        local mt = getrawmetatable(MainEvent)
        originalMetatables.__namecall = mt.__namecall
        local setreadonly = setreadonly or make_writeable or function() end
        setreadonly(mt, false)
        local oldnamecall = mt.__namecall
        local hookFunc = function(self, ...)
            local args = {...}
            pcall(function()
                if getnamecallmethod() == "FireServer" and args[1] == "ShootGun" then
                    if G.Settings.BulletTracers.Enabled and args[3] and args[4] then
                        G.Functions.CreateTracer(args[3], args[4])
                    end
                end
            end)
            return oldnamecall(self, unpack(args))
        end
        if hasNewCClosure and newcclosure then
            mt.__namecall = newcclosure(hookFunc)
        else
            mt.__namecall = hookFunc
        end
        setreadonly(mt, true)
    end)
end

-- Hit Sounds
task.spawn(function()
    local s, e = pcall(function()
        local assets = {}
        for _, id in pairs(G.Tables.HitSoundTable) do
            table.insert(assets, id)
        end
        ContentP:PreloadAsync(assets)
    end)
    if not s then print("VulkX Preload Sounds Error:", e) end
end)

local function createHitSound()
    local now = tick()
    if now - G.Settings.HitSounds.LastPlayTime < 0.15 then return end
    G.Settings.HitSounds.LastPlayTime = now
    task.spawn(function()
        pcall(function()
            local sound = Instance.new("Sound", SoundS)
            sound.SoundId = G.Settings.HitSounds.SoundID
            sound.Volume = G.Settings.HitSounds.Volume / 10
            sound:Play()
            Debris:AddItem(sound, math.max(sound.TimeLength, 3))
        end)
    end)
end

-- Hit Detection (New)
getgenv().lastHealths = getgenv().lastHealths or {}
local function formatPlayer(player)
    if not player then return "Unknown" end
    return string.format("%s (@%s)", player.DisplayName, player.Name)
end
local function resolvePlayerFromValue(val)
    if typeof(val) == "Instance" then
        if val:IsA("Player") then return val end
        local fromChar = Plrs:GetPlayerFromCharacter(val)
        if fromChar then return fromChar end
        if val.Parent then
            fromChar = Plrs:GetPlayerFromCharacter(val.Parent)
            if fromChar then return fromChar end
        end
        if val.Value then return resolvePlayerFromValue(val.Value) end
    elseif typeof(val) == "string" then
        local p = Plrs:FindFirstChild(val)
        if p and p:IsA("Player") then return p end
    end
    return nil
end
local function monitorPlayer(player)
    local function setupCharacter(character)
        local s, e = pcall(function()
            local humanoid = character:WaitForChild("Humanoid")
            local bodyEffects = character:WaitForChild("BodyEffects")
            getgenv().lastHealths[player] = humanoid.Health
            humanoid.HealthChanged:Connect(function(newHealth)
                local oldHealth = getgenv().lastHealths[player] or newHealth
                if newHealth < oldHealth then
                    local damage = oldHealth - newHealth
                    task.wait(0.05)
                    local lastDamagerValue = bodyEffects:FindFirstChild("LastDamager")
                    local attacker = lastDamagerValue and resolvePlayerFromValue(lastDamagerValue.Value)
                    if attacker == LPlr and player ~= LPlr then
                        if G.Settings.HitSounds.Enabled and G.Settings.HitSounds.SoundID ~= "rbxassetid://5153733934" then
                            createHitSound()
                        end
                        if G.Settings.HitNotifications.Enabled then
                            G.Functions.Notify("Damage Dealt", string.format("Hit %s | Damage: %.1f | HP: %.1f", player.Name, damage, newHealth), G.Settings.AccentColor)
                        end
                    end
                end
                getgenv().lastHealths[player] = newHealth
            end)
        end)
        if not s then print("VulkX setupCharacter Error:", e) end
    end
    player.CharacterAdded:Connect(setupCharacter)
    if player.Character then
        task.spawn(function() setupCharacter(player.Character) end)
    end
end
for _, p in ipairs(Plrs:GetPlayers()) do monitorPlayer(p) end
Plrs.PlayerAdded:Connect(monitorPlayer)
Plrs.PlayerRemoving:Connect(function(player) getgenv().lastHealths[player] = nil end)

-- Rapid Fire
if hasDebug and hasGetNamecallMethod then
    table.insert(connections, RunS.Heartbeat:Connect(function()
        pcall(function()
            local tool = LPlr.Character and LPlr.Character:FindFirstChildOfClass("Tool")
            if G.Settings.RapidFire.Enabled and tool and tool:FindFirstChild("GunScript") then
                local toolConnections = getconnections(tool.Activated)
                if toolConnections then
                    for _, v in ipairs(toolConnections) do
                        pcall(function()
                            local funcinfo = debug.getinfo(v.Function)
                            if funcinfo then
                                for i = 1, funcinfo.nups do
                                    local c, n = debug.getupvalue(v.Function, i)
                                    if type(c) == "number" then
                                        debug.setupvalue(v.Function, i, 0.00000000000000000000000000000001)
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        end)
    end))
end

-- Skybox Changer
function G.Functions.ApplySkybox(skyboxName)
    local s, e = pcall(function()
        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") then child:Destroy() end
        end
        if skyboxName ~= "default" then
            local skyboxData = G.Tables.PredefinedSkyboxes[skyboxName]
            if skyboxData then
                local sky = Instance.new("Sky")
                sky.SkyboxBk = "rbxassetid://" .. skyboxData.Bk
                sky.SkyboxDn = "rbxassetid://" .. skyboxData.Dn
                sky.SkyboxFt = "rbxassetid://" .. skyboxData.Ft
                sky.SkyboxLf = "rbxassetid://" .. skyboxData.Lf
                sky.SkyboxRt = "rbxassetid://" .. skyboxData.Rt
                sky.SkyboxUp = "rbxassetid://" .. skyboxData.Up
                sky.Parent = game.Lighting
            end
        end
        game.Lighting.ClockTime = 12
    end)
    if not s then print("VulkX Apply Skybox Error:", e) end
end

-- UI and GUI Creation
local function getInputDisplayName(input)
    if typeof(input) == "EnumItem" then
        if input.EnumType == Enum.KeyCode then return input.Name
        elseif input.EnumType == Enum.UserInputType then return input.Name:gsub("MouseButton", "Mouse") end
    end
    return tostring(input)
end

local function updateAllColors()
    local gui = game.CoreGui:FindFirstChild("VulkXGUI")
    if not gui then return end
    local mainFrame = gui:FindFirstChild("MainFrame")
    if mainFrame then
        local uiStroke = mainFrame:FindFirstChild("UIStroke")
        if uiStroke then uiStroke.Color = G.Settings.AccentColor end
    end
    keybindStroke.Color = G.Settings.AccentColor
    keybindTitle.TextColor3 = G.Settings.AccentColor
    keybindScrolling.ScrollBarImageColor3 = G.Settings.AccentColor
    for i = #G.Data.UIReferences.accentElements, 1, -1 do
        local data = G.Data.UIReferences.accentElements[i]
        if not data.element or not data.element.Parent then
            table.remove(G.Data.UIReferences.accentElements, i)
        end
    end
    for _, data in ipairs(G.Data.UIReferences.accentElements) do
        if data.element and data.element.Parent then
            if data.isToggleTrack then
                if data.getState and data.getState() then
                    data.element[data.property] = G.Settings.AccentColor
                end
            else
                data.element[data.property] = G.Settings.AccentColor
            end
        end
    end
    updateKeybindDisplay()
end

local function updateAllFonts()
    local gui = game.CoreGui:FindFirstChild("VulkXGUI")
    if not gui then return end
    local function setFontRecursive(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj.Font = getFontEnum(G.Settings.Font)
        end
        for _, child in ipairs(obj:GetChildren()) do
            setFontRecursive(child)
        end
    end
    setFontRecursive(gui)
end

local function makeGui()
    if game.CoreGui:FindFirstChild("VulkXGUI") then
        game.CoreGui.VulkXGUI:Destroy()
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VulkXGUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -300)
    MainFrame.BackgroundColor3 = G.Settings.MainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = false
    MainFrame.Visible = G.Data.menuVisible
    MainFrame.Parent = ScreenGui

    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = G.Settings.AccentColor
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(G.Data.UIReferences.accentElements, {element = UIStroke, property = "Color"})

    local TitleBar = Instance.new("Frame", MainFrame)
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = G.Settings.SectionColor
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2

    local TitleText = Instance.new("TextLabel", TitleBar)
    TitleText.Size = UDim2.new(0.5, 0, 1, 0)
    TitleText.Position = UDim2.new(0.25, 0, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "VulkX"
    TitleText.TextColor3 = G.Settings.TextColor
    TitleText.Font = getFontEnum(G.Settings.Font)
    TitleText.TextSize = 18
    TitleText.TextXAlignment = Enum.TextXAlignment.Center
    TitleText.ZIndex = 3
    local titleOutline = Instance.new("UIStroke", TitleText)
    titleOutline.Color = Color3.new(0, 0, 0)
    titleOutline.Thickness = 1
    titleOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

    local VersionText = Instance.new("TextLabel", TitleBar)
    VersionText.Size = UDim2.new(0.2, 0, 1, 0)
    VersionText.Position = UDim2.new(0.8, -10, 0, 0)
    VersionText.BackgroundTransparency = 1
    VersionText.Text = "V2.0.6"
    VersionText.TextColor3 = G.Settings.VersionTextColor
    VersionText.Font = getFontEnum(G.Settings.Font)
    VersionText.TextSize = 14
    VersionText.TextXAlignment = Enum.TextXAlignment.Right
    VersionText.ZIndex = 3
    local versionOutline = Instance.new("UIStroke", VersionText)
    versionOutline.Color = Color3.new(0, 0, 0)
    versionOutline.Thickness = 1
    versionOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

    do
        local dragging, dragStart, frameStart = false, Vector2.new(), UDim2.new()
        table.insert(connections, TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if ScreenGui:FindFirstChild("ColorPickerPopup") then ScreenGui.ColorPickerPopup:Destroy() end
                for _, child in pairs(ScreenGui:GetChildren()) do
                    if child:IsA("Frame") and child.Name:find("DropdownList") then child.Visible = false end
                end
                dragging, dragStart, frameStart = true, UIS:GetMouseLocation(), MainFrame.Position
                local changedConn
                changedConn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        changedConn:Disconnect()
                    end
                end)
                table.insert(connections, changedConn)
            end
        end))
        table.insert(connections, UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = UIS:GetMouseLocation() - dragStart
                MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
            end
        end))
    end

    local TabContainer = Instance.new("Frame", MainFrame)
    TabContainer.Size = UDim2.new(0, 100, 1, -35)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundColor3 = G.Settings.SectionColor
    TabContainer.BorderSizePixel = 0
    TabContainer.ZIndex = 2

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Pages = Instance.new("Frame", MainFrame)
    Pages.Size = UDim2.new(1, -110, 1, -45)
    Pages.Position = UDim2.new(0, 105, 0, 40)
    Pages.BackgroundTransparency = 1
    Pages.ZIndex = 2

    local function addOutline(guiObject)
        if not guiObject:FindFirstChildOfClass("UIStroke") then
            local o = Instance.new("UIStroke", guiObject)
            o.Color = Color3.new(0, 0, 0)
            o.Thickness = 1
            o.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        end
    end

    local function createTab(name, isDefault)
        local btn = Instance.new("TextButton", TabContainer)
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.BackgroundColor3 = G.Settings.SectionColor
        btn.Text = name
        btn.TextColor3 = G.Settings.TextColor
        btn.Font = getFontEnum(G.Settings.Font)
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.ZIndex = 10
        addOutline(btn)

        local page = Instance.new("ScrollingFrame", Pages)
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = isDefault or false
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = G.Settings.AccentColor
        page.CanvasSize = UDim2.new(0, 0, 3, 0)
        page.ZIndex = 5
        table.insert(G.Data.UIReferences.accentElements, {element = page, property = "ScrollBarImageColor3"})

        local leftCol = Instance.new("Frame", page)
        leftCol.Size = UDim2.new(0.48, 0, 1, 0)
        leftCol.Position = UDim2.new(0.01, 0, 0, 10)
        leftCol.BackgroundTransparency = 1
        leftCol.ZIndex = 5

        local leftList = Instance.new("UIListLayout", leftCol)
        leftList.Padding = UDim.new(0, 10)
        leftList.SortOrder = Enum.SortOrder.LayoutOrder

        local rightCol = Instance.new("Frame", page)
        rightCol.Size = UDim2.new(0.48, 0, 1, 0)
        rightCol.Position = UDim2.new(0.51, 0, 0, 10)
        rightCol.BackgroundTransparency = 1
        rightCol.ZIndex = 5

        local rightList = Instance.new("UIListLayout", rightCol)
        rightList.Padding = UDim.new(0, 10)
        rightList.SortOrder = Enum.SortOrder.LayoutOrder

        table.insert(connections, btn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = G.Settings.SectionColor end end
            page.Visible = true
            btn.BackgroundColor3 = G.Settings.AccentColor
        end))

        if isDefault then btn.BackgroundColor3 = G.Settings.AccentColor end
        table.insert(G.Data.UIReferences.accentElements, { element = btn, property = "BackgroundColor3", isTabButton = true, page = page })

        return page, leftCol, rightCol
    end

    local function createGroupBox(parent, title)
        local box = Instance.new("Frame", parent)
        box.Size = UDim2.new(1, 0, 0, 40)
        box.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        box.BorderSizePixel = 0
        box.ZIndex = 6

        local stroke = Instance.new("UIStroke", box)
        stroke.Color = Color3.fromRGB(35, 35, 35)
        stroke.Thickness = 1

        local header = Instance.new("Frame", box)
        header.Size = UDim2.new(1, 0, 0, 22)
        header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        header.BorderSizePixel = 0
        header.ZIndex = 7

        local hLine = Instance.new("Frame", header)
        hLine.Size = UDim2.new(1, 0, 0, 1)
        hLine.Position = UDim2.new(0, 0, 1, -1)
        hLine.BackgroundColor3 = G.Settings.AccentColor
        hLine.BorderSizePixel = 0
        hLine.BackgroundTransparency = 0.5
        hLine.ZIndex = 8
        table.insert(G.Data.UIReferences.accentElements, {element = hLine, property = "BackgroundColor3"})

        local titleLabel = Instance.new("TextLabel", header)
        titleLabel.Size = UDim2.new(1, -10, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title:upper()
        titleLabel.TextColor3 = G.Settings.AccentColor
        titleLabel.Font = getFontEnum(G.Settings.Font)
        titleLabel.TextSize = 10
        titleLabel.ZIndex = 9
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        addOutline(titleLabel)
        table.insert(G.Data.UIReferences.accentElements, {element = titleLabel, property = "TextColor3"})

        local container = Instance.new("Frame", box)
        container.Size = UDim2.new(1, -20, 0, 0)
        container.Position = UDim2.new(0, 10, 0, 30)
        container.BackgroundTransparency = 1
        container.ZIndex = 7

        local list = Instance.new("UIListLayout", container)
        list.Padding = UDim.new(0, 5)
        list.SortOrder = Enum.SortOrder.LayoutOrder

        local updatingSize = false
        table.insert(connections, list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if not updatingSize then
                updatingSize = true
                task.wait()
                container.Size = UDim2.new(1, -20, 0, list.AbsoluteContentSize.Y)
                box.Size = UDim2.new(1, 0, 0, list.AbsoluteContentSize.Y + 40)
                task.wait()
                updatingSize = false
            end
        end))

        return container
    end

    local function createToggle(parent, text, state, callback, name)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 8

        local track = Instance.new("Frame", btn)
        track.Size = UDim2.new(0, 35, 0, 18)
        track.Position = UDim2.new(1, -35, 0.5, -9)
        track.BackgroundColor3 = state and G.Settings.AccentColor or G.Settings.ToggleOffColor
        track.ZIndex = 9
        table.insert(G.Data.UIReferences.accentElements, { element = track, property = "BackgroundColor3", isToggleTrack = true, getState = function() return state end })

        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new(state and 1 or 0, state and -16 or 2, 0.5, -7)
        knob.BackgroundColor3 = state and G.Settings.ToggleOnColor or Color3.fromRGB(240, 240, 240)
        knob.ZIndex = 10

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, -45, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = G.Settings.TextColor
        label.Font = getFontEnum(G.Settings.Font)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 9
        addOutline(label)

        if name then
            G.Data.UIReferences.toggles[name] = {
                button = btn, track = track, knob = knob, label = label,
                update = function(newState)
                    state = newState
                    track.BackgroundColor3 = newState and G.Settings.AccentColor or G.Settings.ToggleOffColor
                    knob.Position = UDim2.new(newState and 1 or 0, newState and -16 or 2, 0.5, -7)
                    knob.BackgroundColor3 = newState and G.Settings.ToggleOnColor or Color3.fromRGB(240, 240, 240)
                end
            }
        end

        table.insert(connections, btn.MouseButton1Click:Connect(function()
            state = not state
            TS:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = state and G.Settings.AccentColor or G.Settings.ToggleOffColor }):Play()
            TS:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(state and 1 or 0, state and -16 or 2, 0.5, -7), BackgroundColor3 = state and G.Settings.ToggleOnColor or Color3.fromRGB(240, 240, 240) }):Play()
            callback(state)
        end))

        return btn
    end

    local function createSlider(parent, text, min, max, current, rounding, callback, name)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, 0, 0, 45)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.TextColor3 = G.Settings.TextColor
        label.Font = getFontEnum(G.Settings.Font)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 9
        addOutline(label)

        local sliderBg = Instance.new("Frame", container)
        sliderBg.Size = UDim2.new(1, 0, 0, 8)
        sliderBg.Position = UDim2.new(0, 0, 0, 25)
        sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderBg.ZIndex = 9

        local fill = Instance.new("Frame", sliderBg)
        fill.BackgroundColor3 = G.Settings.SliderColor
        fill.ZIndex = 10
        table.insert(G.Data.UIReferences.accentElements, {element = fill, property = "BackgroundColor3"})

        local function updateLabel(val) label.Text = text .. ": " .. string.format("%." .. (rounding or 0) .. "f", val) end
        local function updateFill(val) local rel = (val - min) / (max - min); fill.Size = UDim2.new(rel, 0, 1, 0) end
        updateLabel(current)
        updateFill(current)

        if name then
            G.Data.UIReferences.sliders[name] = { label = label, fill = fill, min = min, max = max, update = function(newVal) updateLabel(newVal); updateFill(newVal) end }
        end

        local dragging = false
        local function update(input)
            local rel = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local val = min + (max - min) * rel
            local roundedVal = tonumber(string.format("%." .. (rounding or 0) .. "f", val))
            updateLabel(roundedVal)
            updateFill(roundedVal)
            callback(roundedVal)
        end

        table.insert(connections, sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update(input)
            end
        end))

        table.insert(connections, sliderBg.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end))

        table.insert(connections, UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end))

        return container
    end

    local function createDropdown(parent, text, options, current, callback, name)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, 0, 0, 45)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = G.Settings.TextColor
        label.Font = getFontEnum(G.Settings.Font)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 9
        addOutline(label)

        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(1, 0, 0, 20)
        btn.Position = UDim2.new(0, 0, 0, 22)
        btn.BackgroundColor3 = G.Settings.DropdownColor
        btn.Text = current
        btn.TextColor3 = G.Settings.TextColor
        btn.Font = getFontEnum(G.Settings.Font)
        btn.TextSize = 13
        btn.ZIndex = 10
        btn.AutoButtonColor = true
        addOutline(btn)

        if name then
            G.Data.UIReferences.dropdowns[name] = { btn = btn, update = function(newVal) btn.Text = newVal end }
        end

        local list = Instance.new("Frame")
        list.Name = "DropdownList" .. text
        list.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        list.Visible = false
        list.ZIndex = 10000
        list.BorderSizePixel = 0
        list.Parent = ScreenGui

        local listStroke = Instance.new("UIStroke", list)
        listStroke.Color = G.Settings.AccentColor
        listStroke.Thickness = 1
        table.insert(G.Data.UIReferences.accentElements, {element = listStroke, property = "Color"})

        local layout = Instance.new("UIListLayout", list)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local padding = Instance.new("UIPadding", list)
        padding.PaddingTop = UDim.new(0,5)
        padding.PaddingBottom = UDim.new(0,5)
        padding.PaddingLeft = UDim.new(0,5)
        padding.PaddingRight = UDim.new(0,5)

        local scrollFrame = Instance.new("ScrollingFrame", list)
        scrollFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollFrame.Position = UDim2.new(0,5,0,5)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 5
        scrollFrame.ScrollBarImageColor3 = G.Settings.AccentColor
        scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
        scrollFrame.ZIndex = 10001

        local scrollLayout = Instance.new("UIListLayout", scrollFrame)
        scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
        scrollLayout.Padding = UDim.new(0,2)

        table.insert(G.Data.UIReferences.accentElements, {element = scrollFrame, property = "ScrollBarImageColor3"})

        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton", scrollFrame)
            optBtn.Size = UDim2.new(1, 0, 0, 25)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = opt
            optBtn.TextColor3 = G.Settings.TextColor
            optBtn.Font = getFontEnum(G.Settings.Font)
            optBtn.TextSize = 14
            optBtn.ZIndex = 10002
            optBtn.AutoButtonColor = true
            addOutline(optBtn)

            local hoverFrame = Instance.new("Frame", optBtn)
            hoverFrame.Size = UDim2.new(1,0,1,0)
            hoverFrame.BackgroundColor3 = G.Settings.AccentColor
            hoverFrame.BackgroundTransparency = 1
            hoverFrame.ZIndex = optBtn.ZIndex - 1
            table.insert(G.Data.UIReferences.accentElements, {element = hoverFrame, property = "BackgroundColor3"})

            table.insert(connections, optBtn.MouseEnter:Connect(function() hoverFrame.BackgroundTransparency = 0.7 end))
            table.insert(connections, optBtn.MouseLeave:Connect(function() hoverFrame.BackgroundTransparency = 1 end))
            table.insert(connections, optBtn.MouseButton1Down:Connect(function()
                btn.Text = opt
                list.Visible = false
                callback(opt)
            end))
        end

        table.insert(connections, scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0,0,0, scrollLayout.AbsoluteContentSize.Y)
        end))

        table.insert(connections, btn.MouseButton1Down:Connect(function()
            if list.Visible then
                list.Visible = false
            else
                for _, child in pairs(ScreenGui:GetChildren()) do
                    if child:IsA("Frame") and child.Name:find("DropdownList") then
                        child.Visible = false
                    end
                end
                local absolutePos = btn.AbsolutePosition
                local listHeight = math.min(#options * 27 + 10, 150)
                list.Position = UDim2.new(0, absolutePos.X, 0, absolutePos.Y + 22)
                list.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, listHeight)
                scrollFrame.CanvasSize = UDim2.new(0,0,0, #options * 27)
                list.Visible = true
            end
        end))

        table.insert(connections, MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and list.Visible then
                local mouse = UIS:GetMouseLocation()
                local pos, size = list.AbsolutePosition, list.AbsoluteSize
                if not (mouse.X > pos.X and mouse.X < pos.X + size.X and mouse.Y > pos.Y and mouse.Y < pos.Y + size.Y) then
                    local bPos, bSize = btn.AbsolutePosition, btn.AbsoluteSize
                    if not (mouse.X > bPos.X and mouse.X < bPos.X + bSize.X and mouse.Y > bPos.Y and mouse.Y < bPos.Y + bSize.Y) then
                        list.Visible = false
                    end
                end
            end
        end))

        return container
    end

    local function createButton(parent, text, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = G.Settings.ButtonColor
        btn.Text = text
        btn.TextColor3 = G.Settings.TextColor
        btn.Font = getFontEnum(G.Settings.Font)
        btn.TextSize = 14
        btn.AutoButtonColor = true
        btn.ZIndex = 9
        addOutline(btn)
        table.insert(connections, btn.MouseButton1Click:Connect(callback))
        return btn
    end

    local function createKeybind(parent, text, currentKey, callback, name)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, 0, 0, 25)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(1, -60, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = G.Settings.TextColor
        label.Font = getFontEnum(G.Settings.Font)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 9
        addOutline(label)

        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(0, 60, 0, 20)
        btn.Position = UDim2.new(1, -60, 0.5, -10)
        btn.BackgroundColor3 = G.Settings.ButtonColor
        btn.Text = getInputDisplayName(currentKey)
        btn.TextColor3 = G.Settings.TextColor
        btn.Font = getFontEnum(G.Settings.Font)
        btn.TextSize = 10
        btn.ZIndex = 9
        addOutline(btn)

        if name then
            G.Data.UIReferences.keybinds[name] = { btn = btn, update = function(newKey) btn.Text = getInputDisplayName(newKey) end }
        end

        local waiting = false
        table.insert(connections, btn.MouseButton1Click:Connect(function()
            if waiting then return end
            waiting = true
            btn.Text = "..."
            local keybindConn
            keybindConn = UIS.InputBegan:Connect(function(input)
                local uitype = input.UserInputType
                if uitype == Enum.UserInputType.Keyboard or uitype == Enum.UserInputType.MouseButton1 or uitype == Enum.UserInputType.MouseButton2 or uitype == Enum.UserInputType.MouseButton3 then
                    local bind = uitype == Enum.UserInputType.Keyboard and input.KeyCode or uitype
                    btn.Text = getInputDisplayName(bind)
                    callback(bind)
                    task.wait(0.01)
                    waiting = false
                    keybindConn:Disconnect()
                end
            end)
            table.insert(connections, keybindConn)
        end))
    end

    local function createColorPicker(parent, text, defaultColor, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, 0, 0, 30)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(1, -40, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = G.Settings.TextColor
        label.Font = getFontEnum(G.Settings.Font)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 9
        addOutline(label)

        local previewButton = Instance.new("TextButton", container)
        previewButton.Size = UDim2.new(0, 30, 0, 20)
        previewButton.Position = UDim2.new(1, -30, 0.5, -10)
        previewButton.BackgroundColor3 = defaultColor
        previewButton.Text = ""
        previewButton.ZIndex = 9

        local previewStroke = Instance.new("UIStroke", previewButton)
        previewStroke.Color = Color3.new(0,0,0)
        previewStroke.Thickness = 1

        local function generateColorPickerPopup(initialColor, position)
            if ScreenGui:FindFirstChild("ColorPickerPopup") then ScreenGui.ColorPickerPopup:Destroy() end
            local H, S, V = Color3.toHSV(initialColor)
            local frame = Instance.new("Frame", ScreenGui)
            frame.Name = "ColorPickerPopup"
            frame.Size = UDim2.new(0, 280, 0, 280)
            frame.Position = UDim2.new(0, position.X, 0, position.Y)
            frame.BackgroundColor3 = G.Settings.SectionColor
            frame.BorderSizePixel = 0
            frame.ZIndex = 20000
            frame.Active = true
            frame.Draggable = false

            local stroke = Instance.new("UIStroke", frame)
            stroke.Color = G.Settings.AccentColor
            stroke.Thickness = 1.5
            table.insert(G.Data.UIReferences.accentElements, {element = stroke, property = "Color"})

            local titleBar = Instance.new("Frame", frame)
            titleBar.Size = UDim2.new(1, 0, 0, 25)
            titleBar.BackgroundColor3 = G.Settings.MainColor
            titleBar.BorderSizePixel = 0
            titleBar.ZIndex = 20001
            titleBar.Active = true
            titleBar.Draggable = false

            local titleLabel = Instance.new("TextLabel", titleBar)
            titleLabel.Size = UDim2.new(1, 0, 1, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = "Color Picker"
            titleLabel.TextColor3 = G.Settings.TextColor
            titleLabel.Font = getFontEnum(G.Settings.Font)
            titleLabel.TextSize = 14

            local closeButton = Instance.new("TextButton", titleBar)
            closeButton.Size = UDim2.new(0, 20, 0, 20)
            closeButton.Position = UDim2.new(1, -25, 0.5, -10)
            closeButton.BackgroundColor3 = G.Settings.ButtonColor
            closeButton.Text = "X"
            closeButton.TextColor3 = G.Settings.TextColor
            closeButton.Font = getFontEnum(G.Settings.Font)
            closeButton.TextSize = 14
            closeButton.Parent = titleBar
            table.insert(connections, closeButton.MouseButton1Click:Connect(function() frame:Destroy() end))

            do
                local dragging, dragStart, frameStart = false, Vector2.new(), UDim2.new()
                table.insert(connections, titleBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging, dragStart, frameStart = true, UIS:GetMouseLocation(), frame.Position
                        local c
                        c = input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                                c:Disconnect()
                            end
                        end)
                        table.insert(connections, c)
                    end
                end))
                table.insert(connections, UIS.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local delta = UIS:GetMouseLocation() - dragStart
                        frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
                    end
                end))
            end

            local svSize = 200
            local svPicker = Instance.new("Frame", frame)
            svPicker.Name = "SVPicker"
            svPicker.Size = UDim2.new(0, svSize, 0, svSize)
            svPicker.Position = UDim2.new(0, 12, 0, 35)
            svPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
            svPicker.BorderSizePixel = 0

            local whiteGradient = Instance.new("UIGradient", svPicker)
            whiteGradient.Rotation = 0
            whiteGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))})
            whiteGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})

            local blackGradient = Instance.new("UIGradient", svPicker)
            blackGradient.Rotation = 90
            blackGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color3.new(0,0,0))})
            blackGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})

            local svHandle = Instance.new("Frame", svPicker)
            svHandle.Size = UDim2.new(0, 16, 0, 16)
            svHandle.AnchorPoint = Vector2.new(0.5, 0.5)
            svHandle.BackgroundColor3 = Color3.new(1,1,1)
            svHandle.BorderSizePixel = 1
            svHandle.BorderColor3 = Color3.new(0,0,0)
            svHandle.ZIndex = 2
            Instance.new("UICorner", svHandle).CornerRadius = UDim.new(1, 0)

            local hueBar = Instance.new("Frame", frame)
            hueBar.Size = UDim2.new(0, 28, 0, svSize)
            hueBar.Position = UDim2.new(0, svSize + 24, 0, 35)
            hueBar.BorderSizePixel = 0

            local hueGradient = Instance.new("UIGradient", hueBar)
            hueGradient.Rotation = 90
            hueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
                ColorSequenceKeypoint.new(1/6, Color3.fromHSV(1/6,1,1)),
                ColorSequenceKeypoint.new(2/6, Color3.fromHSV(2/6,1,1)),
                ColorSequenceKeypoint.new(3/6, Color3.fromHSV(3/6,1,1)),
                ColorSequenceKeypoint.new(4/6, Color3.fromHSV(4/6,1,1)),
                ColorSequenceKeypoint.new(5/6, Color3.fromHSV(5/6,1,1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
            })

            local hueHandle = Instance.new("Frame", hueBar)
            hueHandle.Size = UDim2.new(1, 4, 0, 10)
            hueHandle.AnchorPoint = Vector2.new(0.5, 0.5)
            hueHandle.BackgroundColor3 = Color3.new(1,1,1)
            hueHandle.BorderSizePixel = 1
            hueHandle.BorderColor3 = Color3.new(0,0,0)
            hueHandle.ZIndex = 2

            local colourDisplay = Instance.new("Frame", frame)
            colourDisplay.Size = UDim2.new(0, 240, 0, 28)
            colourDisplay.Position = UDim2.new(0, 12, 0, svSize + 45)
            colourDisplay.BorderSizePixel = 0

            local hexLabel = Instance.new("TextLabel", colourDisplay)
            hexLabel.Size = UDim2.new(1, -12, 1, 0)
            hexLabel.Position = UDim2.new(0, 6, 0, 0)
            hexLabel.BackgroundTransparency = 1
            hexLabel.Font = getFontEnum(G.Settings.Font)
            hexLabel.TextSize = 16
            hexLabel.TextXAlignment = Enum.TextXAlignment.Left

            local function toHex(c) return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)) end
            local function mouseToLocal(f, m) return Vector2.new(m.X - f.AbsolutePosition.X, m.Y - f.AbsolutePosition.Y) end

            local function updateColor()
                H = math.clamp(H, 0, 1)
                S = math.clamp(S, 0, 1)
                V = math.clamp(V, 0, 1)
                local finalColor = Color3.fromHSV(H, S, V)
                svPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                svHandle.Position = UDim2.new(S, 0, 1 - V, 0)
                hueHandle.Position = UDim2.new(0.5, 0, H, 0)
                colourDisplay.BackgroundColor3 = finalColor
                hexLabel.Text = toHex(finalColor)
                hexLabel.TextColor3 = (finalColor.R*0.299 + finalColor.G*0.587 + finalColor.B*0.114) > 0.5 and Color3.new(0,0,0) or Color3.new(1,1,1)
                previewButton.BackgroundColor3 = finalColor
                callback(finalColor)
            end

            local draggingSV, draggingHue = false, false
            table.insert(connections, svPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSV = true
                    local m = UIS:GetMouseLocation() - Vector2.new(0, GuiS:GetGuiInset().Y)
                    local localPos = mouseToLocal(svPicker, m)
                    S = math.clamp(localPos.X / svPicker.AbsoluteSize.X, 0, 1)
                    V = 1 - math.clamp(localPos.Y / svPicker.AbsoluteSize.Y, 0, 1)
                    updateColor()
                end
            end))

            table.insert(connections, hueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = true
                    local m = UIS:GetMouseLocation() - Vector2.new(0, GuiS:GetGuiInset().Y)
                    local localPos = mouseToLocal(hueBar, m)
                    H = math.clamp(localPos.Y / hueBar.AbsoluteSize.Y, 0, 1)
                    updateColor()
                end
            end))

            table.insert(connections, UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSV, draggingHue = false, false
                end
            end))

            table.insert(connections, UIS.InputChanged:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                local mouse = UIS:GetMouseLocation() - Vector2.new(0, GuiS:GetGuiInset().Y)
                if draggingSV then
                    local localPos = mouseToLocal(svPicker, mouse)
                    S = math.clamp(localPos.X / svPicker.AbsoluteSize.X, 0, 1)
                    V = 1 - math.clamp(localPos.Y / svPicker.AbsoluteSize.Y, 0, 1)
                    updateColor()
                elseif draggingHue then
                    local localPos = mouseToLocal(hueBar, mouse)
                    H = math.clamp(localPos.Y / hueBar.AbsoluteSize.Y, 0, 1)
                    updateColor()
                end
            end))

            updateColor()
        end

        table.insert(connections, previewButton.MouseButton1Click:Connect(function()
            local pos = previewButton.AbsolutePosition
            generateColorPickerPopup(previewButton.BackgroundColor3, pos)
        end))
    end

    G.Data.UIReferences = {toggles = {}, sliders = {}, dropdowns = {}, keybinds = {}, accentElements = {}}

    local mainPage, mLeft, mRight = createTab("Main", true)
    local ragePage, rLeft, rRight = createTab("Ragebot")
    local visualsPage, vLeft, vRight = createTab("Visuals")
    local settingsPage, sLeft, sRight = createTab("Settings")
    local miscPage, msLeft, msRight = createTab("Misc")
    local characterPage, cLeft, cRight = createTab("Character")

    local function rebuildMultiTargetList()
        local container = G.Data.UIReferences.multiTargetListContainer
        if not container then return end
        container.CanvasPosition = Vector2.zero
        for _, v in ipairs(container:GetChildren()) do
            if v:IsA("UIListLayout") then else v:Destroy() end
        end
        local selectedNames = {}
        for _, p in ipairs(RS.State.auraTargets) do selectedNames[p.Name] = true end
        local players = Plrs:GetPlayers()
        table.sort(players, function(a,b) return a.Name:lower() < b.Name:lower() end)
        for _, player in ipairs(players) do
            if player ~= LPlr then
                local item = Instance.new("Frame", container)
                item.Size = UDim2.new(1, 0, 0, 30)
                item.BackgroundTransparency = 1

                local btn = Instance.new("TextButton", item)
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                btn.Font = getFontEnum(G.Settings.Font)
                btn.TextSize = 14
                addOutline(btn)

                local function updateVisual(isSelected)
                    btn.BackgroundColor3 = isSelected and G.Settings.AccentColor or G.Settings.ButtonColor
                    btn.TextColor3 = isSelected and Color3.new(0,0,0) or G.Settings.TextColor
                end
                updateVisual(selectedNames[player.Name])

                table.insert(connections, btn.MouseButton1Click:Connect(function()
                    local foundIdx = -1
                    for i, p in ipairs(RS.State.auraTargets) do
                        if p == player then foundIdx = i; break end
                    end
                    if foundIdx > -1 then
                        table.remove(RS.State.auraTargets, foundIdx)
                        updateVisual(false)
                    else
                        table.insert(RS.State.auraTargets, player)
                        updateVisual(true)
                    end
                end))
            end
        end
        container.CanvasSize = UDim2.new(0,0,0, container.UIListLayout.AbsoluteContentSize.Y)
    end

    local function updatePlayerLists()
        if G.Data.UIReferences.multiTargetListContainer then rebuildMultiTargetList() end
    end

    table.insert(connections, Plrs.PlayerAdded:Connect(updatePlayerLists))
    table.insert(connections, Plrs.PlayerRemoving:Connect(updatePlayerLists))

    -- Silent Aim
    local silentAimGroup = createGroupBox(mLeft, "Silent Aim")
    createToggle(silentAimGroup, "Master Toggle", G.Settings.SilentAim.Enabled, function(v) G.Settings.SilentAim.Enabled = v; silentAimCircle.Visible = v and G.Settings.SilentAim.FOVVisible end, "SilentAimToggle")
    createKeybind(silentAimGroup, "Aim Key", G.Settings.SilentAim.Keybind, function(k) G.Settings.SilentAim.Keybind = k; updateKeybindDisplay() end, "SilentAimKeybind")
    createDropdown(silentAimGroup, "Activation", {"Hold", "Toggle"}, G.Settings.SilentAim.Activation, function(v) G.Settings.SilentAim.Activation = v end, "SilentAimActivation")
    createDropdown(silentAimGroup, "Hit Part", {"Head", "UpperTorso", "HumanoidRootPart", "Random"}, G.Settings.SilentAim.HitPart, function(v) G.Settings.SilentAim.HitPart = v end, "SilentAimHitPart")
    createSlider(silentAimGroup, "Hit Chance", 0, 100, G.Settings.SilentAim.HitChance, 0, function(v) G.Settings.SilentAim.HitChance = v end, "SilentAimHitChance")
    createSlider(silentAimGroup, "Prediction", 0, 0.5, G.Settings.SilentAim.Prediction, 2, function(v) G.Settings.SilentAim.Prediction = v end, "SilentAimPrediction")

    local silentAimVisualsGroup = createGroupBox(mRight, "Silent Aim Visuals")
    createSlider(silentAimVisualsGroup, "FOV Radius", 0, 500, G.Settings.SilentAim.FOVRadius, 0, function(v) G.Settings.SilentAim.FOVRadius = v end, "SilentAimFOVRadius")
    createToggle(silentAimVisualsGroup, "Show FOV", G.Settings.SilentAim.FOVVisible, function(v) G.Settings.SilentAim.FOVVisible = v; silentAimCircle.Visible = v and G.Settings.SilentAim.Enabled end, "SilentAimFOVVisible")
    createColorPicker(silentAimVisualsGroup, "FOV Color", G.Settings.SilentAim.FOVColor, function(c) G.Settings.SilentAim.FOVColor = c end)
    createToggle(silentAimVisualsGroup, "Wall Check", G.Settings.SilentAim.WallCheck, function(v) G.Settings.SilentAim.WallCheck = v end)
    createToggle(silentAimVisualsGroup, "Visualize Target", G.Settings.SilentAim.VisualizeTarget, function(v) G.Settings.SilentAim.VisualizeTarget = v end)
    createColorPicker(silentAimVisualsGroup, "Visualize Color", G.Settings.SilentAim.VisualizeColor, function(c) G.Settings.SilentAim.VisualizeColor = c end)

    -- Ragebot
    local rageGroup = createGroupBox(rLeft, "Ragebot")
    createToggle(rageGroup, "RAGE ENABLED (Master)", G.Settings.Ragebot.Enabled, function(v) G.Settings.Ragebot.Enabled = v; G.Data.ActiveFeatures["Ragebot"] = v and G.Settings.Ragebot.Active; if not v then G.Settings.Ragebot.Active = false; RS.StopAll() end; updateKeybindDisplay() end, "RageEnabledToggle")
    createKeybind(rageGroup, "Activation Key", G.Settings.Ragebot.Keybind, function(k) G.Settings.Ragebot.Keybind = k; updateKeybindDisplay() end, "RagebotKeybind")
    createToggle(rageGroup, "Show Status HUD", G.Settings.ShowStatus, function(v) G.Settings.ShowStatus = v end, "ShowStatusToggle")
    createToggle(rageGroup, "View While Strafing", G.Settings.SpectateEnabled, function(v) G.Settings.SpectateEnabled = v; if not v and RS.State.Spectating then RS.State.Spectating = false; local lh = LPlr.Character and LPlr.Character:FindFirstChildOfClass('Humanoid'); if lh then Cam.CameraSubject = lh; Cam.CameraType = Enum.CameraType.Custom end end end, "SpectateToggle")
    createDropdown(rageGroup, "Kill Mode", {'Normal', 'Stomp'}, G.Settings.KillMode, function(v) G.Settings.KillMode = v; G.Functions.Notify("Ragebot", "Mode changed to: " .. v, G.Settings.AccentColor) end, "KillModeDropdown")
    createSlider(rageGroup, "Swap Target Time (s)", 0.1, 10, G.Settings.SwapInterval, 1, function(v) G.Settings.SwapInterval = v end, "SwapIntervalSlider")
    createToggle(rageGroup, "Void Spam", G.Settings.VoidSpamEnabled, function(v) G.Settings.VoidSpamEnabled = v end, "VoidSpamToggle")
    createSlider(rageGroup, "Time in Void (ms)", 0.1, 1000, G.Settings.VoidSpamTimeIn, 1, function(v) G.Settings.VoidSpamTimeIn = v end, "VoidTimeInSlider")
    createSlider(rageGroup, "Time out of Void (ms)", 0.1, 1000, G.Settings.VoidSpamTimeOut, 1, function(v) G.Settings.VoidSpamTimeOut = v end, "VoidTimeOutSlider")

    local movementGroup = createGroupBox(rLeft, "Movement")
    createSlider(movementGroup, "Strafe Distance", 10, 100, G.Settings.StrafeDistance, 0, function(v) G.Settings.StrafeDistance = v end, "StrafeDistance")
    createSlider(movementGroup, "Strafe Speed", 100, 5000, G.Settings.StrafeSpeed, 0, function(v) G.Settings.StrafeSpeed = v end, "StrafeSpeed")

    local equipmentGroup = createGroupBox(rRight, "Equipment")
    createToggle(equipmentGroup, "Auto Buy Guns", G.Settings.AutoGuns.Mode, function(v) G.Settings.AutoGuns.Mode = v end)
    createToggle(equipmentGroup, "Auto Buy Ammo", G.Settings.AutoAmmo.Mode, function(v) G.Settings.AutoAmmo.Mode = v end)

    local ammoThresholdsGroup = createGroupBox(rRight, "Ammo Thresholds")
    for _, gk in ipairs(RS.GunsAvailable) do
        local disp = RS.DisplayNames[gk] or gk
        local th = G.Settings.AutoAmmo.Guns[gk] or {low = 20, high = 150}
        local subContainer = Instance.new("Frame", ammoThresholdsGroup)
        subContainer.Size = UDim2.new(1, 0, 0, 130)
        subContainer.BackgroundTransparency = 1
        subContainer.ZIndex = 8
        local list = Instance.new("UIListLayout", subContainer)
        list.Padding = UDim.new(0, 2)
        local gunLabel = Instance.new("TextLabel", subContainer)
        gunLabel.Size = UDim2.new(1, 0, 0, 20)
        gunLabel.BackgroundTransparency = 1
        gunLabel.Text = disp
        gunLabel.TextColor3 = G.Settings.AccentColor
        gunLabel.Font = getFontEnum(G.Settings.Font)
        gunLabel.TextSize = 14
        gunLabel.TextXAlignment = Enum.TextXAlignment.Left
        addOutline(gunLabel)
        table.insert(G.Data.UIReferences.accentElements, {element = gunLabel, property = "TextColor3"})
        createSlider(subContainer, "When ammo is lower than", 5, 150, th.low, 0, function(v) G.Settings.AutoAmmo.Guns[gk].low = v end)
        createSlider(subContainer, "Buy until ammo is", 5, 150, th.high, 0, function(v) G.Settings.AutoAmmo.Guns[gk].high = v end)
    end

    local targetGroup = createGroupBox(rRight, "Target Selection")
    local playerListContainer = Instance.new("ScrollingFrame", targetGroup)
    playerListContainer.Name = "PlayerListContainer"
    playerListContainer.Size = UDim2.new(1, 0, 0, 150)
    playerListContainer.BackgroundTransparency = 1
    playerListContainer.ScrollBarThickness = 2
    playerListContainer.ScrollBarImageColor3 = G.Settings.AccentColor
    playerListContainer.CanvasSize = UDim2.new(0,0,0,0)
    local playerListLayout = Instance.new("UIListLayout", playerListContainer)
    playerListLayout.Name = "UIListLayout"
    playerListLayout.Padding = UDim.new(0, 5)
    G.Data.UIReferences.multiTargetListContainer = playerListContainer
    table.insert(G.Data.UIReferences.accentElements, {element = playerListContainer, property = "ScrollBarImageColor3"})

    local rageEquipGroup = createGroupBox(rRight, "Weapons")
    for _, gk in ipairs(RS.GunsAvailable) do
        local isSelected = table.find(G.Settings.SelectedGuns, gk) ~= nil
        createToggle(rageEquipGroup, RS.DisplayNames[gk] or gk, isSelected, function(state)
            local currentIdx = table.find(G.Settings.SelectedGuns, gk)
            if state and not currentIdx then
                table.insert(G.Settings.SelectedGuns, gk)
            elseif not state and currentIdx then
                table.remove(G.Settings.SelectedGuns, currentIdx)
            end
        end)
    end

    -- Visuals
    local espGroup = createGroupBox(vLeft, "ESP")
    createToggle(espGroup, "Master ESP Toggle", ESP.Enabled, function(v) ESP.Enabled = v; if not v then ClearESP() end end)
    createToggle(espGroup, "Boxes", ESP.Boxes, function(v) ESP.Boxes = v end)
    createToggle(espGroup, "Names", ESP.Names, function(v) ESP.Names = v end)
    createToggle(espGroup, "Distance", ESP.Distance, function(v) ESP.Distance = v end)
    createToggle(espGroup, "Tool", ESP.Tool, function(v) ESP.Tool = v end)
    createToggle(espGroup, "Tracers", ESP.Tracers, function(v) ESP.Tracers = v end)
    createToggle(espGroup, "Skeleton", ESP.Skeleton, function(v) ESP.Skeleton = v end)
    createToggle(espGroup, "Health Bar", ESP.HealthBar, function(v) ESP.HealthBar = v end)
    createToggle(espGroup, "Armor Bar", ESP.ArmorBar, function(v) ESP.ArmorBar = v end)

    local espSettingsGroup = createGroupBox(vRight, "ESP Settings")
    createDropdown(espSettingsGroup, "Name Mode", {'Username', 'DisplayName', 'Both'}, ESP.NameMode, function(v) ESP.NameMode = v end)
    createDropdown(espSettingsGroup, "Tracer Origin", {'Top', 'Middle', 'Bottom'}, ESP.TracerOrigin, function(v) ESP.TracerOrigin = v end)
    -- ESP Font dropdown
    local espFontOptions = {"Plex", "UI", "System", "Monospace"}
    createDropdown(espSettingsGroup, "Font", espFontOptions, ESP.Font, function(v) ESP.Font = v; -- update existing ESP objects font
        for player, objects in pairs(ESP.Objects) do
            if objects.NameText then objects.NameText.Font = drawingFonts[v] or Drawing.Fonts.Plex end
            if objects.DistanceText then objects.DistanceText.Font = drawingFonts[v] or Drawing.Fonts.Plex end
            if objects.ToolText then objects.ToolText.Font = drawingFonts[v] or Drawing.Fonts.Plex end
        end
    end)
    -- Max distance toggle and slider
    local maxDistToggle = createToggle(espSettingsGroup, "Limit Max Distance", ESP.MaxDistanceEnabled, function(v) ESP.MaxDistanceEnabled = v; if maxDistSlider then maxDistSlider.Visible = v end end)
    local maxDistSlider = createSlider(espSettingsGroup, "Max Distance", 200, 10000, ESP.MaxDistance, 0, function(v) ESP.MaxDistance = v end)
    maxDistSlider.Visible = ESP.MaxDistanceEnabled

    local espColorsGroup = createGroupBox(vRight, "ESP Colors")
    createColorPicker(espColorsGroup, "Box Color", ESP.Colors.Box, function(v) ESP.Colors.Box = v end)
    createColorPicker(espColorsGroup, "Name Color", ESP.Colors.Name, function(v) ESP.Colors.Name = v end)
    createColorPicker(espColorsGroup, "Distance Color", ESP.Colors.Distance, function(v) ESP.Colors.Distance = v end)
    createColorPicker(espColorsGroup, "Tool Color", ESP.Colors.Tool, function(v) ESP.Colors.Tool = v end)
    createColorPicker(espColorsGroup, "Tracer Color", ESP.Colors.Tracer, function(v) ESP.Colors.Tracer = v end)
    createColorPicker(espColorsGroup, "Skeleton Color", ESP.Colors.Skeleton, function(v) ESP.Colors.Skeleton = v end)
    createColorPicker(espColorsGroup, "Health High Color", ESP.Colors.HealthHigh, function(v) ESP.Colors.HealthHigh = v end)
    createColorPicker(espColorsGroup, "Health Mid Color", ESP.Colors.HealthMid, function(v) ESP.Colors.HealthMid = v end)
    createColorPicker(espColorsGroup, "Health Low Color", ESP.Colors.HealthLow, function(v) ESP.Colors.HealthLow = v end)
    createColorPicker(espColorsGroup, "Armor High Color", ESP.Colors.ArmorHigh, function(v) ESP.Colors.ArmorHigh = v end)
    createColorPicker(espColorsGroup, "Armor Low Color", ESP.Colors.ArmorLow, function(v) ESP.Colors.ArmorLow = v end)

    local bulletTracersGroup = createGroupBox(vLeft, "Bullet Tracers")
    createToggle(bulletTracersGroup, "Bullet Tracers", G.Settings.BulletTracers.Enabled, function(v) G.Settings.BulletTracers.Enabled = v end, "BulletTracersToggle")
    createColorPicker(bulletTracersGroup, "Tracer Color", G.Settings.BulletTracers.Color, function(v) G.Settings.BulletTracers.Color = v end)
    createSlider(bulletTracersGroup, "Tracer Size", 0.1, 2, G.Settings.BulletTracers.Size, 1, function(v) G.Settings.BulletTracers.Size = v end, "TracerSize")
    createSlider(bulletTracersGroup, "Time Alive", 1, 10, G.Settings.BulletTracers.TimeAlive, 0, function(v) G.Settings.BulletTracers.TimeAlive = v end, "TracerTime")
    local tracerTextureNames = {}
    for name in pairs(G.Tables.TracerTextures) do table.insert(tracerTextureNames, name) end
    createDropdown(bulletTracersGroup, "Texture", tracerTextureNames, G.Settings.BulletTracers.Texture, function(v) G.Settings.BulletTracers.Texture = v end)

    local skyboxGroup = createGroupBox(vRight, "Skybox")
    local skyboxNames = {"default"}
    for name in pairs(G.Tables.PredefinedSkyboxes) do table.insert(skyboxNames, name) end
    createDropdown(skyboxGroup, "Sky", skyboxNames, G.Settings.Skybox.Current, function(v) G.Settings.Skybox.Current = v; G.Functions.ApplySkybox(v) end)

    -- Settings
    local uiGroup = createGroupBox(sLeft, "UI Settings")
    createKeybind(uiGroup, "Toggle GUI Key", G.Settings.MenuKey, function(k) G.Settings.MenuKey = k; updateKeybindDisplay() end, "MenuKey")
    createColorPicker(uiGroup, "Accent Color", G.Settings.AccentColor, function(v) G.Settings.AccentColor = v; updateAllColors() end)
    createColorPicker(uiGroup, "Version Text Color", G.Settings.VersionTextColor, function(v) G.Settings.VersionTextColor = v; VersionText.TextColor3 = v end)
    createDropdown(uiGroup, "Font", G.Tables.Fonts, G.Settings.Font, function(v) G.Settings.Font = v; updateAllFonts() end, "FontDropdown")
    createButton(uiGroup, "Test Notification", function() G.Functions.Notify("Test Notification", "This is a sample notification.", G.Settings.AccentColor) end)
    createToggle(uiGroup, "Show Keybind List", keybindFrame.Visible, function(v) keybindFrame.Visible = v end, "ShowKeybindList")
    createSlider(uiGroup, "Keybind List X Pos", 0, 1, G.Settings.Positions.KeybindList.X.Scale, 2, function(v) G.Settings.Positions.KeybindList = UDim2.new(v, G.Settings.Positions.KeybindList.X.Offset, G.Settings.Positions.KeybindList.Y.Scale, G.Settings.Positions.KeybindList.Y.Offset); keybindFrame.Position = G.Settings.Positions.KeybindList end)
    createSlider(uiGroup, "Keybind List Y Pos", 0, 1, G.Settings.Positions.KeybindList.Y.Scale, 2, function(v) G.Settings.Positions.KeybindList = UDim2.new(G.Settings.Positions.KeybindList.X.Scale, G.Settings.Positions.KeybindList.X.Offset, v, G.Settings.Positions.KeybindList.Y.Offset); keybindFrame.Position = G.Settings.Positions.KeybindList end)
    createSlider(uiGroup, "Notification X Pos", 0, 1, G.Settings.Positions.NotificationList.X.Scale, 2, function(v) G.Settings.Positions.NotificationList = UDim2.new(v, G.Settings.Positions.NotificationList.X.Offset, G.Settings.Positions.NotificationList.Y.Scale, G.Settings.Positions.NotificationList.Y.Offset); notificationContainer.Position = G.Settings.Positions.NotificationList end)
    createSlider(uiGroup, "Notification Y Pos", 0, 1, G.Settings.Positions.NotificationList.Y.Scale, 2, function(v) G.Settings.Positions.NotificationList = UDim2.new(G.Settings.Positions.NotificationList.X.Scale, G.Settings.Positions.NotificationList.X.Offset, v, G.Settings.Positions.NotificationList.Y.Offset); notificationContainer.Position = G.Settings.Positions.NotificationList end)

    local miscGroup = createGroupBox(msLeft, "Combat")
    createToggle(miscGroup, "Rapid Fire", G.Settings.RapidFire.Enabled, function(v) G.Settings.RapidFire.Enabled = v end, "RapidFireToggle")

    local hitEffectsGroup = createGroupBox(msLeft, "Hit Effects")
    createToggle(hitEffectsGroup, "Hit Sounds", G.Settings.HitSounds.Enabled, function(v) G.Settings.HitSounds.Enabled = v end, "HitSoundsToggle")
    createDropdown(hitEffectsGroup, "Hit Sound", G.Tables.HitSoundNames, 'Baimware', function(v) G.Settings.HitSounds.SoundID = G.Tables.HitSoundTable[v] or 'rbxassetid://3124331820' end, "HitSoundDropdown")
    createSlider(hitEffectsGroup, "Hit Sound Volume", 1, 10, G.Settings.HitSounds.Volume, 0, function(v) G.Settings.HitSounds.Volume = v end, "HitSoundVolume")
    createButton(hitEffectsGroup, "Test Hit Sound", function() createHitSound() end)
    createToggle(hitEffectsGroup, "Damage Notifications", G.Settings.HitNotifications.Enabled, function(v) G.Settings.HitNotifications.Enabled = v end, "HitNotificationsToggle")
    createSlider(hitEffectsGroup, "Notification Time", 1, 10, G.Settings.HitNotifications.Time, 0, function(v) G.Settings.HitNotifications.Time = v end, "HitNotificationTime")

    local csyncVisGroup = createGroupBox(msRight, "CSync Visualizer")
    createToggle(csyncVisGroup, "Enabled", G.Settings.CSyncVisualizer.Enabled, function(v) G.Settings.CSyncVisualizer.Enabled = v end, "CSyncVisToggle")
    local csyncIconNames = {}
    for name in pairs(G.Tables.CSyncIcons) do table.insert(csyncIconNames, name) end
    createDropdown(csyncVisGroup, "Icon", csyncIconNames, G.Settings.CSyncVisualizer.Icon, function(v) G.Settings.CSyncVisualizer.Icon = v end)
    createSlider(csyncVisGroup, "Icon Size", 1, 50, G.Settings.CSyncVisualizer.Size, 0, function(v) G.Settings.CSyncVisualizer.Size = v end, "CSyncVisSize")

    local armorGroup = createGroupBox(msRight, "Auto Armor")
    createToggle(armorGroup, "Auto Armor", G.Settings.AutoArmor.Mode, function(v) G.Settings.AutoArmor.Mode = v; G.Functions.Notify("Auto Armor", v and "Auto Armor enabled" or "Auto Armor disabled", v and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)) end, "AutoArmorToggle")
    createSlider(armorGroup, "Armor Threshold", 1, 200, G.Settings.AutoArmor.Threshold, 0, function(v) G.Settings.AutoArmor.Threshold = v end, "ArmorThresholdSlider")

    local flyGroup = createGroupBox(cLeft, "Flight")
    createToggle(flyGroup, "Master Toggle", G.Settings.Fly.Enabled, function(v) G.Settings.Fly.Enabled = v; if not v and flying then disableFlight() end; updateKeybindDisplay() end, "FlyToggle")
    createKeybind(flyGroup, "Fly Key", G.Settings.Fly.Keybind, function(k) G.Settings.Fly.Keybind = k; updateKeybindDisplay() end, "FlyKeybind")
    createDropdown(flyGroup, "Activation", {"Hold", "Toggle"}, G.Settings.Fly.Activation, function(v) G.Settings.Fly.Activation = v end, "FlyActivation")
    createSlider(flyGroup, "Fly Speed", 100, 5000, G.Settings.Fly.Speed, 0, function(v) G.Settings.Fly.Speed = v end, "FlySpeed")

    local antiStompGroup = createGroupBox(cRight, "Anti Stomp")
    createToggle(antiStompGroup, "Anti Stomp", G.Settings.AntiStomp.Enabled, function(v) G.Settings.AntiStomp.Enabled = v; G.Functions.Notify("Misc", v and "Anti Stomp enabled" or "Anti Stomp disabled", v and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)) end, "AntiStompToggle")

    table.insert(connections, ragePage:GetPropertyChangedSignal("Visible"):Connect(function() if ragePage.Visible then updatePlayerLists() end end))

    updateAllColors()
    updateAllFonts()
    updatePlayerLists()
    G.Functions.ApplySkybox(G.Settings.Skybox.Current)

    return ScreenGui
end

-- Anti-stomp
table.insert(connections, task.spawn(function()
    while true do
        local s, e = pcall(function()
            if G.Settings.AntiStomp.Enabled then
                local char = LPlr.Character
                if not char then return end
                local be = char:FindFirstChild("BodyEffects")
                local koValue = be and be:FindFirstChild("K.O")
                if koValue and koValue.Value then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        hum.Health = 0
                        G.Functions.Notify("Anti Stomp", "Prevented stomp by KOing", Color3.fromRGB(255, 165, 0))
                    end
                    task.wait(1.5)
                end
            end
        end)
        if not s then print("VulkX Anti-Stomp Error:", e) end
        task.wait(0.01)
    end
end))

-- Ragebot activation key
table.insert(connections, UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == G.Settings.Ragebot.Keybind and G.Settings.Ragebot.Enabled then
        G.Settings.Ragebot.Active = not G.Settings.Ragebot.Active
        if G.Settings.Ragebot.Active then
            RS.MasterKillLoop()
        else
            RS.StopAll()
        end
    end
end))

-- Anti-fall damage
local originalHeight = WS.FallenPartsDestroyHeight
WS.FallenPartsDestroyHeight = -math.huge

-- Remove seats to prevent vehicle exploits
local function removeSeats()
    for _, seat in pairs(WS:GetDescendants()) do
        if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
            pcall(function() seat:Destroy() end)
        end
    end
end
removeSeats()
table.insert(connections, WS.DescendantAdded:Connect(function(desc)
    if desc:IsA("Seat") or desc:IsA("VehicleSeat") then
        task.wait()
        pcall(function() desc:Destroy() end)
    end
end))

-- Initialize GUI
makeGui()

-- Unload function
G.Functions.Unload = function()
    RS.StopAll()
    ClearESP()
    if silentAimCircle then silentAimCircle:Remove() end
    if RageStatusText then RageStatusText:Remove() end
    if csyncVisualizerDot then csyncVisualizerDot:Remove() end
    WS.FallenPartsDestroyHeight = originalHeight
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
    pcall(function()
        local mt = getrawmetatable(game)
        if mt and originalMetatables.__namecall then
            local sr = setreadonly or make_writeable or function() end
            sr(mt, false)
            mt.__namecall = originalMetatables.__namecall
            sr(mt, true)
        end
        local saMt = getrawmetatable(game)
        if saMt and originalMetatables.__index_sa then
            local sr = setreadonly or make_writeable or function() end
            sr(saMt, false)
            saMt.__index = originalMetatables.__index_sa
            sr(saMt, true)
        end
        if csyncHookSetup and originalMetatables.__index then
            local sr = setreadonly or make_writeable or function() end
            sr(getrawmetatable(game), false)
            getrawmetatable(game).__index = originalMetatables.__index
            sr(getrawmetatable(game), true)
        end
    end)
    if game.CoreGui:FindFirstChild("VulkXGUI") then game.CoreGui.VulkXGUI:Destroy() end
    if game.CoreGui:FindFirstChild("VulkX_Keybinds") then game.CoreGui.VulkX_Keybinds:Destroy() end
    if game.CoreGui:FindFirstChild("VulkX_Notifications") then game.CoreGui.VulkX_Notifications:Destroy() end
    G.Functions.ApplySkybox("default") -- Revert skybox
    getgenv().VulkX = nil
    print('VulkX Unloaded. :(')
end

print('VulkX V2.0.6 Loaded! | Meow!, From Ximmy')
