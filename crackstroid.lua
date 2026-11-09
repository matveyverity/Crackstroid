--[[
 ▄▄▄▄▄ ▄▄▄▄▄   ▄▄▄▄▄  ▄▄▄▄▄ ▄▄▄▄▄▄  ▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄   ▄▄▄▄▄ ▄▄▄▄▄ ▄▄▄▄▄ 
▒▄▀▀▀░ ░█▀▀▄░ ░▄▀▀█░ ▒▄▀▀▀░ ░█░░█░ ░▄▀▀▀░ ░▀▀█▀▀░ ░█▀▀▄░ ░▄▀▀█░  ▀█▀░ ░█▀▀▄░
▓█▓    ▒█▀▀▄▄ ▒█▄▄█▒ ▓█▓    ▒█▀▀▄▄ ▒▀▀▀█▒   ▒█▒   ▒█▀▀▄▄ ▒█░▒█▒  ░█░  ▒█░▒█▒
██▄▄▄▓ ▓█▓▓█▓ ▓█▒▓█▓ ██▄▄▄▓ ▓█▒▓█▓ ▓█▄▄▀▓   ▓█▓   ▓█▓▓█▓ ▓█▄▄▀▓ ▒▄█▄▒ ▓█▄▄▀▓
▀▀▀▀▀▀ ▀▀▀▀▀▀ ▀▀▀▀▀▀ ▀▀▀▀▀▀ ▀▀▀▀▀▀ ▀▀▀▀▀    ▀▀▀   ▀▀▀▀▀▀ ▀▀▀▀▀  ▀▀▀▀▀ ▀▀▀▀▀                                               

new lol i vibecoded
]]


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    pcall(function() Players:GetPropertyChangedSignal("LocalPlayer"):Wait() end)
    LocalPlayer = Players.LocalPlayer
end
if not LocalPlayer then return warn("[Crackstroid] No LocalPlayer") end

local EXECUTOR = "Unknown"
pcall(function() if identifyexecutor then EXECUTOR = tostring(identifyexecutor()) end end)

local GENV
pcall(function() if getgenv then GENV = getgenv() end end)
if not GENV then pcall(function() GENV = getfenv(0).getgenv and getfenv(0).getgenv() end) end
if not GENV then GENV = _G end

-- ═══════════════ IDENTITY ═══════════════
local CurrentIdentity = 2
pcall(function()
    for _, lvl in ipairs({8, 7, 6, 5, 4, 3}) do
        local ok = pcall(function()
            if setthreadidentity then setthreadidentity(lvl)
            elseif setidentity then setidentity(lvl)
            elseif setthreadcontext then setthreadcontext(lvl) end
        end)
        if ok then CurrentIdentity = lvl; break end
    end
end)

-- ═══════════════ REQUIRE ═══════════════
local RequireSources = {}
do
    local seen = {}
    local function add(srcName, fn)
        if type(fn) ~= "function" or seen[fn] then return end
        seen[fn] = true
        RequireSources[#RequireSources + 1] = {Name = srcName, Fn = fn}
    end
    add("direct", require)
    pcall(function()
        if getfenv then
            local env = getfenv(0)
            if env and type(env.require) == "function" then add("getfenv0", env.require) end
        end
    end)
    pcall(function()
        if getrenv then
            local env = getrenv()
            if env and type(env.require) == "function" then add("getrenv", env.require) end
        end
    end)
end

local RealRequire = require
local function safeRequire(module)
    if not module then return nil end
    local okType, isModule = pcall(function() return module:IsA("ModuleScript") end)
    if not okType or not isModule then return nil end
    for _, src in ipairs(RequireSources) do
        local ok, res = pcall(src.Fn, module)
        if ok and res ~= nil then
            RealRequire = src.Fn
            return res
        end
    end
    return nil
end

do
    for _, name in ipairs({"CrackstroidActive", "CheatMenuActive"}) do
        if GENV[name] then
            pcall(GENV[name])
            GENV[name] = nil
        end
    end
end
print("[Crackstroid v1.1] Loading on " .. EXECUTOR .. "...")

local VERSION = "1.1-Crackstroid"
local TOGGLE_KEY = Enum.KeyCode.RightShift
local EMOTE_COOLDOWN = 0.45

local function findChild(parent, name, timeout)
    if not parent then return nil end
    local ok, child = pcall(function() return parent:FindFirstChild(name) end)
    if ok and child then return child end
    ok, child = pcall(function() return parent:WaitForChild(name, timeout or 3) end)
    if not ok then return nil end
    return child
end
local function fastFind(parent, ...)
    local cur = parent
    for _, name in ipairs({...}) do
        if not cur then return nil end
        local ok, c = pcall(function() return cur:FindFirstChild(name) end)
        if not ok then return nil end
        cur = c
    end
    return cur
end

local Modules, Systems, Assets
pcall(function() Modules = ReplicatedStorage:FindFirstChild("Modules") end)
pcall(function() Systems = ReplicatedStorage:FindFirstChild("Systems") end)
pcall(function() Assets = ReplicatedStorage:FindFirstChild("Assets") end)

local Network, Util, Actors, Sounds, Device, LightingMod, BluePuzzle, FlowGame
local SprintingMod, EmoteMod, HeartbeatSys, ChaseSys, Initializer

local COMPAT = {}
local function loadAllModules()
    local okLoad, errLoad = pcall(function()
        Network = safeRequire(fastFind(Modules, "Network"))
        Util = safeRequire(fastFind(Modules, "Util"))
        Actors = safeRequire(fastFind(Modules, "Actors"))
        Sounds = safeRequire(fastFind(Modules, "Sounds"))
        Device = safeRequire(fastFind(Modules, "Device"))
        LightingMod = safeRequire(fastFind(Modules, "Schematics", "Lighting"))
        BluePuzzle = safeRequire(fastFind(Modules, "Misc", "BluePuzzleController"))
        FlowGame = safeRequire(fastFind(Modules, "Misc", "FlowGameManager"))
        SprintingMod = safeRequire(fastFind(Systems, "Character", "Game", "Sprinting"))
        EmoteMod = safeRequire(fastFind(Systems, "Character", "Game", "Emotes"))
        HeartbeatSys = safeRequire(fastFind(Systems, "Player", "Game", "Hearbeat"))
        ChaseSys = safeRequire(fastFind(Systems, "Character", "Game", "ChaseThemes"))
        Initializer = safeRequire(findChild(ReplicatedStorage, "Initializer", 5))
    end)
    if not okLoad then
        warn("[Crackstroid] loadAllModules error: " .. tostring(errLoad))
    end
    COMPAT = {
        Network = Network ~= nil, Util = Util ~= nil, Actors = Actors ~= nil,
        Sounds = Sounds ~= nil, Device = Device ~= nil, Lighting = LightingMod ~= nil,
        BluePuzzle = BluePuzzle ~= nil, FlowGame = FlowGame ~= nil, Sprinting = SprintingMod ~= nil,
        Emotes = EmoteMod ~= nil, Heartbeat = HeartbeatSys ~= nil, Chase = ChaseSys ~= nil,
        Initializer = Initializer ~= nil,
    }
    local loaded, total = 0, 0
    for _, v in pairs(COMPAT) do total = total + 1; if v then loaded = loaded + 1 end end
    print(("[Crackstroid] Modules loaded: %d/%d"):format(loaded, total))
    local reqSrc = "unknown"
    for _, src in ipairs(RequireSources) do
        if src.Fn == RealRequire then reqSrc = src.Name; break end
    end
    print(("[Crackstroid] Require source: %s"):format(reqSrc))
end

task.spawn(function()
    local t0 = os.clock()
    while os.clock() - t0 < 12 do
        pcall(function()
            if LocalPlayer:FindFirstChild("PlayerData") and ReplicatedStorage:FindFirstChild("Modules") then
                return
            end
        end)
        if LocalPlayer:FindFirstChild("PlayerData") and ReplicatedStorage:FindFirstChild("Modules") then break end
        task.wait(0.5)
    end
    task.wait(0.5)
    pcall(loadAllModules)
    if not SprintingMod then
        task.wait(2)
        pcall(loadAllModules)
    end
    print("[Crackstroid] Module load phase finished.")
    -- Если SprintingMod всё равно nil — включаем fallback спринт немедленно
    if not SprintingMod then
        pcall(setupFallbackSprint)
    end
end)

local Settings = {
    Language = "ru", Theme = "dark", UIScale = 1,
    ClickSounds = true, ShowMobileButton = true,
    ESPDistance = 500, ESPStyle = "highlight",
    ShowWelcomeScreen = true,
    StreamerMode = false, AnonymizeHUD = false, AnonymizePlayerList = false,
    AutoSaveSettings = false,
}
pcall(function()
    if GENV.CrackstroidSettings then
        for k, v in pairs(GENV.CrackstroidSettings) do Settings[k] = v end
    end
end)

local State = {
    GodMode = false, InfStamina = false, NoClip = false, Fullbright = false,
    Speed = 1, Jump = 50, Fly = false, AutoJump = false,
    FreezeCamera = false, FirstPerson = false, Freecam = false,
    ESPPlayers = false, ESPKillers = false, ESPItems = false, ESPGenerators = false,
    AutoRandomEmote = false, ShowAllNames = false,
    Killaura = false, AntiAFK = false,
}

local L = {
    ON = {ru = "ВКЛ", en = "ON"}, OFF = {ru = "ВЫКЛ", en = "OFF"},
    NA = {ru = "н/д", en = "n/a"},
    TAB_PLAYER = {ru = "Игрок", en = "Player"}, TAB_GRAPHICS = {ru = "Графика", en = "Graphics"},
    TAB_ESP = {ru = "ESP", en = "ESP"}, TAB_TELEPORTS = {ru = "Телепорты", en = "Teleports"},
    TAB_CHARS = {ru = "Персонажи", en = "Chars"}, TAB_ABILITIES = {ru = "Способности", en = "Abilities"},
    TAB_EMOTES = {ru = "Эмоции", en = "Emotes"}, TAB_PUZZLES = {ru = "Пазлы", en = "Puzzles"},
    TAB_MENUS = {ru = "Меню", en = "Menus"}, TAB_WORLD = {ru = "Мир", en = "World"},
    TAB_TOOLS = {ru = "Инстр.", en = "Tools"}, TAB_EXPORT = {ru = "Экспорт", en = "Export"},
    TAB_SETTINGS = {ru = "Настройки", en = "Settings"}, TAB_COMPAT = {ru = "Совм.", en = "Compat"},
    TAB_CHEATS = {ru = "Читы", en = "Cheats"},
    SEC_HEALTH = {ru = "Здоровье", en = "Health"}, SEC_SPEED = {ru = "Скорость", en = "Speed"},
    SEC_ACTIONS = {ru = "Действия", en = "Actions"}, SEC_DEVICE = {ru = "Устройство", en = "Device"},
    SEC_CAM = {ru = "Камера", en = "Camera"}, SEC_LIGHT = {ru = "Освещение", en = "Lighting"},
    SEC_OVERLAY = {ru = "Оверлеи", en = "Overlays"}, SEC_ATMO = {ru = "Атмосфера", en = "Atmosphere"},
    SEC_ESP_PLAYERS = {ru = "ESP: Игроки", en = "ESP: Players"}, SEC_ESP_WORLD = {ru = "ESP: Мир", en = "ESP: World"},
    SEC_ESP_DIST = {ru = "Дистанция", en = "Distance"}, SEC_ESP_STYLE = {ru = "Стиль", en = "Style"},
    SEC_KILLERS = {ru = "Киллеры", en = "Killers"}, SEC_SURVIVORS = {ru = "Выжившие", en = "Survivors"},
    SEC_PLAY_AS = {ru = "Играть за", en = "Play as"}, SEC_FORCE = {ru = "Способность", en = "Ability"},
    SEC_SHARED = {ru = "Общие", en = "Shared"}, SEC_ACTOR = {ru = "Актёр", en = "Actor"},
    SEC_BLUE = {ru = "Синий", en = "Blue"}, SEC_FLOW = {ru = "Поток", en = "Flow"},
    SEC_SIDEBAR = {ru = "Меню", en = "Menus"},
    SEC_OTHER = {ru = "Другое", en = "Other"}, SEC_AURAS = {ru = "Ауры", en = "Auras"},
    SEC_HEART = {ru = "Сердцебиение", en = "Heartbeat"}, SEC_CHASE = {ru = "Погоня", en = "Chase"},
    SEC_SOUNDS = {ru = "Звуки", en = "Sounds"}, SEC_OVERLAY_UI = {ru = "Оверлеи", en = "Overlays"},
    SEC_FREECAM = {ru = "Своб. камера", en = "Freecam"}, SEC_SERVER = {ru = "Сервер", en = "Server"},
    SEC_DUMP = {ru = "Дамп", en = "Dump"}, SEC_LANG = {ru = "Язык", en = "Language"},
    SEC_THEME = {ru = "Тема", en = "Theme"}, SEC_SCALE = {ru = "Масштаб UI", en = "UI Scale"},
    SEC_WELCOME = {ru = "Приветствие", en = "Welcome"}, SEC_STREAMER = {ru = "Стример", en = "Streamer"},
    SEC_FILEIO = {ru = "Файлы", en = "Files"}, SEC_OPTIONS = {ru = "Опции", en = "Options"},
    SEC_RESET = {ru = "Сброс", en = "Reset"}, SEC_XENO = {ru = "Проверка", en = "Check"},
    SEC_TP_TO_PLAYER = {ru = "TP к игроку", en = "TP to Player"}, SEC_TP_TO_SPAWN = {ru = "TP на спавн", en = "TP to Spawn"},
    SEC_EXTRA = {ru = "Экстра", en = "Extra"}, SEC_GRAVITY = {ru = "Гравитация", en = "Gravity"},
    SEC_SPRINT = {ru = "Спринт", en = "Sprint"},
    BTN_GOD = {ru = "Режим бога", en = "God Mode"}, BTN_STAM = {ru = "Беск. стамина", en = "Infinite Stamina"},
    BTN_NOCLIP = {ru = "NoClip", en = "NoClip"}, BTN_AUTOJUMP = {ru = "Авто-прыжок", en = "Auto Jump"},
    BTN_FLY = {ru = "Полёт", en = "Fly"}, BTN_SPEED = {ru = "Скорость", en = "Speed"},
    BTN_JUMP = {ru = "Прыжок", en = "Jump"}, BTN_SPRINT = {ru = "Спринт (переключить)", en = "Sprint (toggle)"},
    BTN_RESPAWN = {ru = "Респавн", en = "Respawn"}, BTN_INSTANT_RESPAWN = {ru = "Мгнов. респавн", en = "Instant Respawn"},
    BTN_KILL_SELF = {ru = "Убить себя", en = "Kill Self"}, BTN_TP_RANDOM = {ru = "TP → игрок", en = "TP → Player"},
    BTN_SET_PC = {ru = "PC", en = "PC"}, BTN_SET_MOB = {ru = "Mobile", en = "Mobile"},
    BTN_SET_CON = {ru = "Console", en = "Console"}, BTN_FULLBRIGHT = {ru = "Fullbright", en = "Fullbright"},
    BTN_REMOVE_FX = {ru = "Убрать FX", en = "Remove FX"}, BTN_ADD_ATMO = {ru = "Атмосфера", en = "Atmosphere"},
    BTN_CLOSE_MENUS = {ru = "Закрыть все", en = "Close All"}, BTN_EMOTE_MENU = {ru = "Меню эмоций", en = "Emote Menu"},
    BTN_PLAYER_LIST = {ru = "Список игроков", en = "Player List"}, BTN_CLOSE_PUZZLE = {ru = "Закрыть пазл", en = "Close Puzzle"},
    BTN_STOP_EMOTE = {ru = "Остановить", en = "Stop"}, BTN_RESCAN = {ru = "Скан", en = "Rescan"},
    BTN_REFRESH_AB = {ru = "Обновить", en = "Refresh"}, BTN_REVEAL_SURV = {ru = "Показать выживших", en = "Reveal Survivors"},
    BTN_REVEAL_KILL = {ru = "Показать киллеров", en = "Reveal Killers"}, BTN_CLEAR_AURAS = {ru = "Убрать ауры", en = "Clear Auras"},
    BTN_HB_ON = {ru = "Вкл HB", en = "Enable HB"}, BTN_HB_OFF = {ru = "Выкл HB", en = "Disable HB"},
    BTN_FORCE_CHASE = {ru = "Погоня", en = "Force Chase"}, BTN_FREEZE_CAM = {ru = "Замороз. камеру", en = "Freeze Camera"},
    BTN_FIRST_PERSON = {ru = "1-е лицо", en = "First Person"}, BTN_FREECAM = {ru = "Своб. камера", en = "Freecam"},
    BTN_SHOW_PING = {ru = "Пинг/FPS", en = "Ping/FPS"}, BTN_SHOW_COORDS = {ru = "Координаты", en = "Coordinates"},
    BTN_SHOW_PLIST = {ru = "Панель", en = "Panel"}, BTN_SHOW_SERVER = {ru = "Инфо", en = "Info"},
    BTN_OPEN_SHOP_K = {ru = "Магазин киллеров", en = "Killers Shop"}, BTN_OPEN_SHOP_S = {ru = "Магазин выживших", en = "Survivors Shop"},
    BTN_EQUIP_RANDOM = {ru = "Случайный", en = "Random"}, BTN_ACTOR_INFO = {ru = "Инфо", en = "Info"},
    BTN_AUTO_EMOTE = {ru = "Авто-спам (10x)", en = "Auto-spam (10x)"}, BTN_AUTO_RANDOM = {ru = "Авто-рандом", en = "Auto-Random"},
    BTN_SHOW_NAMES = {ru = "Показать имена", en = "Show Names"}, BTN_REJOIN = {ru = "Перезайти", en = "Rejoin"},
    BTN_LANG_RU = {ru = "Русский", en = "Russian"}, BTN_LANG_EN = {ru = "Английский", en = "English"},
    BTN_THEME_DARK = {ru = "Тёмная", en = "Dark"}, BTN_THEME_LIGHT = {ru = "Светлая", en = "Light"},
    BTN_RESET_ALL = {ru = "Сброс", en = "Reset"}, BTN_WELCOME_SHOW_NOW = {ru = "Показать", en = "Show"},
    BTN_DUMP_SETTINGS = {ru = "Дамп настроек", en = "Dump Settings"}, BTN_DUMP_STATE = {ru = "Дамп состояния", en = "Dump State"},
    BTN_DUMP_FULL = {ru = "Полный дамп", en = "Full Dump"}, BTN_COPY = {ru = "Копировать", en = "Copy"},
    BTN_CLEAR = {ru = "Очистить", en = "Clear"}, BTN_SAVE_FILE = {ru = "💾 Сохранить", en = "💾 Save"},
    BTN_LOAD_FILE = {ru = "📂 Загрузить", en = "📂 Load"}, BTN_TEST_REQUIRE = {ru = "Тест require", en = "Test require"},
    BTN_TEST_EVENT = {ru = "Тест RemoteEvent", en = "Test RemoteEvent"}, BTN_TEST_TWEEN = {ru = "Тест Tween", en = "Test Tween"},
    BTN_TEST_CLICK = {ru = "Тест Click", en = "Test Click"}, BTN_FULL_COMPAT = {ru = "Полная проверка", en = "Full Check"},
    BTN_TP_KILLERS = {ru = "TP → Киллеры", en = "TP → Killers"}, BTN_TP_SURVIVORS = {ru = "TP → Выжившие", en = "TP → Survivors"},
    BTN_TP_LOBBY = {ru = "TP → Лобби", en = "TP → Lobby"}, BTN_TP_REFRESH = {ru = "Обновить", en = "Refresh"},
    BTN_STREAMER = {ru = "Стример-режим", en = "Streamer Mode"}, BTN_ANON_HUD = {ru = "Анон HUD", en = "Anon HUD"},
    BTN_ANON_LIST = {ru = "Анон PlayerList", en = "Anon PlayerList"},
    BTN_ANTI_AFK = {ru = "Анти-АФК", en = "Anti-AFK"}, BTN_SPAM_CHAT = {ru = "Спам чата", en = "Chat Spam"},
    BTN_UNLOCK_ACH = {ru = "Разблок. ачивки", en = "Unlock Achievements"},
    BTN_AUTO_PUZZLE = {ru = "Авто-пазлы", en = "Auto-Puzzles"},
    BTN_KILLAURA = {ru = "Killaura", en = "Killaura"},
    MSG_GOD = {ru = "Режим бога", en = "God"}, MSG_STAM = {ru = "Стамина", en = "Stamina"},
    MSG_NOCLIP = {ru = "NoClip", en = "NoClip"}, MSG_FLY = {ru = "Полёт", en = "Fly"},
    MSG_FULLBRIGHT = {ru = "Fullbright", en = "Fullbright"}, MSG_LIGHT_RESET = {ru = "Свет сброшен", en = "Lighting reset"},
    MSG_EMOTE = {ru = "Эмоция", en = "Emote"}, MSG_EMOTE_STOP = {ru = "Стоп", en = "Stop"},
    MSG_PUZZLE_CLOSED = {ru = "Пазл закрыт", en = "Puzzle closed"}, MSG_MENU_OPEN = {ru = "Открыто", en = "Opened"},
    MSG_MENU_CLOSED = {ru = "Все закрыты", en = "All closed"}, MSG_TP = {ru = "TP", en = "TP"},
    MSG_ABILITY = {ru = "Способность", en = "Ability"}, MSG_EQUIPPED = {ru = "Экип.", en = "Equipped"},
    MSG_NOT_OWNED = {ru = "Не куплено", en = "Not owned"}, MSG_AUTO_EMOTE = {ru = "Авто", en = "Auto"},
    MSG_NO_ACTOR = {ru = "Нет актёра", en = "No actor"}, MSG_CAM_FROZEN = {ru = "Камера заморожена", en = "Camera frozen"},
    MSG_CAM_UNFROZEN = {ru = "Камера разморожена", en = "Camera unfrozen"}, MSG_KILLED = {ru = "Убит", en = "Killed"},
    MSG_LANG = {ru = "Язык", en = "Lang"}, MSG_THEME = {ru = "Тема", en = "Theme"},
    MSG_RESET = {ru = "Сброшено", en = "Reset"}, MSG_REJOIN = {ru = "Переподкл...", en = "Rejoining..."},
    MSG_NAMES_ON = {ru = "Имена ВКЛ", en = "Names ON"}, MSG_NAMES_OFF = {ru = "Имена ВЫКЛ", en = "Names OFF"},
    MSG_EVENT_FAIL = {ru = "RemoteEvent н/д", en = "RemoteEvent n/a"}, MSG_DUMP_CREATED = {ru = "Дамп создан", en = "Dump created"},
    MSG_COPIED = {ru = "Скопировано", en = "Copied"}, MSG_COPY_FAIL = {ru = "Копир. н/д", en = "Copy n/a"},
    MSG_WELCOME_HIDDEN = {ru = "Скрыто", en = "Hidden"}, MSG_WELCOME_SHOWN = {ru = "Показано", en = "Shown"},
    MSG_TP_PLAYER_LEFT = {ru = "Игрок вышел", en = "Left"}, MSG_TP_NO_SPAWN = {ru = "Спавны н/д", en = "No spawns"},
    MSG_STREAMER_ON = {ru = "Стример ВКЛ", en = "Streamer ON"}, MSG_STREAMER_OFF = {ru = "Стример ВЫКЛ", en = "Streamer OFF"},
    MSG_HUD_ANON_ON = {ru = "HUD анон", en = "HUD anon"}, MSG_HUD_ANON_OFF = {ru = "HUD восст", en = "HUD restored"},
    MSG_LIST_ANON_ON = {ru = "List анон", en = "List anon"}, MSG_LIST_ANON_OFF = {ru = "List восст", en = "List restored"},
    MSG_FILE_SAVED = {ru = "Сохранено %s", en = "Saved %s"}, MSG_FILE_LOADED = {ru = "Загружено %s", en = "Loaded %s"},
    MSG_FILE_NOT_FOUND = {ru = "Файл н/д", en = "File not found"}, MSG_NO_WRITEFILE = {ru = "writefile н/д", en = "writefile n/a"},
    MSG_NO_READFILE = {ru = "readfile н/д", en = "readfile n/a"}, MSG_MODULES_RELOAD = {ru = "Модули перезагружены", en = "Modules reloaded"},
    MSG_ANTI_AFK_ON = {ru = "Анти-АФК ВКЛ", en = "Anti-AFK ON"},
    MSG_KILLAURA_ON = {ru = "Killaura ВКЛ", en = "Killaura ON"}, MSG_KILLAURA_OFF = {ru = "Killaura ВЫКЛ", en = "Killaura OFF"},
    MSG_ACH_UNLOCKED = {ru = "Ачивки отправлены", en = "Achievements sent"},
    MSG_PUZZLE_AUTO = {ru = "Авто-пазлы запущены", en = "Auto-puzzles started"},
    MSG_FALLBACK_ON = {ru = "Fallback-спринт активирован", en = "Fallback sprint activated"},
    MSG_FALLBACK_WARN = {ru = "SprintingMod не загружен → включён fallback", en = "SprintingMod not loaded → fallback enabled"},
    PING_LABEL = {ru = "Пинг", en = "Ping"}, FPS_LABEL = {ru = "FPS", en = "FPS"},
    COMPAT_OK = {ru = "OK", en = "OK"}, COMPAT_FAIL = {ru = "FAIL", en = "FAIL"},
    WELCOME_GREET = {ru = "Привет, %s!", en = "Hello, %s!"},
    WELCOME_MSG = {ru = "Добро пожаловать в Crackstroid!", en = "Welcome to Crackstroid!"},
    WELCOME_CONTINUE = {ru = "Продолжить →", en = "Continue →"},
    WELCOME_DONT_SHOW = {ru = "Не показывать снова", en = "Don't show again"},
    WELCOME_VERSION = {ru = "Версия: %s", en = "Version: %s"},
    PH_EMOTE_SEARCH = {ru = "Поиск эмоции...", en = "Search emotes..."},
    PH_PLAYER_SEARCH = {ru = "Имя игрока...", en = "Player name..."},
    DUMP_HINT = {ru = "Сгенерируй дамп.", en = "Generate a dump."},
    TP_NO_MATCHES = {ru = "Ничего не найдено", en = "No matches"},
    TP_TYPE_TO_SEARCH = {ru = "Вводи имя", en = "Type a name"},
}

local function T(key, ...)
    -- Добавили ... в аргументы функции, а также передаем ... в pcall
    local ok, result = pcall(function(...) 
        local entry = L[key]
        if not entry then return tostring(key) end
        local str = entry[Settings.Language] or entry.ru or key
        local n = select("#", ...) -- Теперь это работает
        if n > 0 then
            local okF, res = pcall(string.format, str, ...)
            if okF then return res end
        end
        return str
    end, ...) -- <-- Передаем ... из T() в нашу функцию внутри pcall
    
    if ok then return result end
    return tostring(key)
end
local function onoff(b) return b and T("ON") or T("OFF") end

local ThemeDark = {
    BG = Color3.fromRGB(16, 18, 24), PANEL = Color3.fromRGB(26, 30, 40),
    PANEL_HOVER = Color3.fromRGB(36, 42, 55), TAB_IDLE = Color3.fromRGB(34, 38, 50),
    ACCENT = Color3.fromRGB(70, 140, 255), ACCENT_DARK = Color3.fromRGB(45, 100, 200),
    SUCCESS = Color3.fromRGB(70, 200, 100), DANGER = Color3.fromRGB(220, 70, 70),
    WARN = Color3.fromRGB(255, 180, 60), TEXT = Color3.fromRGB(230, 235, 245),
    TEXT_DIM = Color3.fromRGB(150, 160, 180), STROKE = Color3.fromRGB(60, 90, 140),
}
local ThemeLight = {
    BG = Color3.fromRGB(245, 247, 250), PANEL = Color3.fromRGB(230, 234, 240),
    PANEL_HOVER = Color3.fromRGB(215, 222, 232), TAB_IDLE = Color3.fromRGB(220, 226, 235),
    ACCENT = Color3.fromRGB(45, 110, 220), ACCENT_DARK = Color3.fromRGB(30, 80, 170),
    SUCCESS = Color3.fromRGB(45, 160, 80), DANGER = Color3.fromRGB(200, 55, 55),
    WARN = Color3.fromRGB(220, 150, 30), TEXT = Color3.fromRGB(30, 35, 45),
    TEXT_DIM = Color3.fromRGB(100, 110, 130), STROKE = Color3.fromRGB(150, 165, 190),
}
local THEME = ThemeDark
local function refreshTheme() THEME = Settings.Theme == "light" and ThemeLight or ThemeDark end
refreshTheme()

local function getChar()
    local ok, c = pcall(function() return LocalPlayer.Character end)
    return ok and c or nil
end
local function getHum()
    local c = getChar(); if not c then return nil end
    local ok, h = pcall(function() return c:FindFirstChildOfClass("Humanoid") end)
    return ok and h or nil
end
local function getRoot()
    local c = getChar(); if not c then return nil end
    local ok, r = pcall(function() return c:FindFirstChild("HumanoidRootPart") end)
    return ok and r or nil
end
local function getCamera()
    local ok, c = pcall(function() return workspace.CurrentCamera end)
    return ok and c or nil
end

local Connections = {}
local UIConnections = {}
local function setConn(key, conn)
    if Connections[key] then pcall(function() Connections[key]:Disconnect() end) end
    Connections[key] = conn
end
local function setUIConn(key, conn)
    if UIConnections[key] then pcall(function() UIConnections[key]:Disconnect() end) end
    UIConnections[key] = conn
end

local function isMobile()
    if Device then
        local ok, d = pcall(function() return Device:GetPlayerDevice() end)
        if ok and d == "Mobile" then return true end
    end
    local cam = getCamera()
    return cam ~= nil and cam.ViewportSize.X < 900
end

local ToastContainer = nil
local function toast(text, kind)
    if not ToastContainer or not ToastContainer.Parent then return end
    local ok = pcall(function()
        local color = THEME.ACCENT
        if kind == "success" then color = THEME.SUCCESS
        elseif kind == "error" then color = THEME.DANGER
        elseif kind == "warn" then color = THEME.WARN end
        local box = Instance.new("Frame")
        box.Size = UDim2.fromOffset(300, 38)
        box.BackgroundColor3 = THEME.PANEL
        box.BackgroundTransparency = 0.05
        box.BorderSizePixel = 0
        box.Parent = ToastContainer
        local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = box
        local cs = Instance.new("UIStroke"); cs.Color = color; cs.Thickness = 1.5; cs.Parent = box
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -16, 1, 0); lbl.Position = UDim2.fromOffset(8, 0)
        lbl.BackgroundTransparency = 1; lbl.Text = tostring(text)
        lbl.TextColor3 = THEME.TEXT; lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextWrapped = true; lbl.Parent = box
        box.Position = UDim2.fromOffset(320, 0)
        pcall(function()
            TweenService:Create(box, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Position = UDim2.fromOffset(0, 0)}):Play()
        end)
        task.delay(2.8, function()
            if not box.Parent then return end
            pcall(function()
                local t = TweenService:Create(box, TweenInfo.new(0.3),
                    {Position = UDim2.fromOffset(320, 0), BackgroundTransparency = 1})
                t:Play(); t.Completed:Once(function() if box and box.Parent then box:Destroy() end end)
            end)
        end)
    end)
    if not ok then
        print("[Crackstroid/toast] " .. tostring(text))
    end
end

local InitJump = nil

-- ═══════════════ FALLBACK SPRINT (всегда работает) ═══════════════
local FallbackSprint = {
    Active = false,
    Multiplier = nil,
    BaseSpeed = 16,
    SprintSpeed = 26,
    SprintKey = Enum.KeyCode.LeftShift,
    IsSprinting = false,
    KeyHeld = false,
    Connections = {},
    LastLoggedError = 0,
}

local function destroyFallbackSprint()
    for _, conn in pairs(FallbackSprint.Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    FallbackSprint.Connections = {}
    if FallbackSprint.Multiplier then
        pcall(function() FallbackSprint.Multiplier:Destroy() end)
        FallbackSprint.Multiplier = nil
    end
    FallbackSprint.IsSprinting = false
    FallbackSprint.KeyHeld = false
    FallbackSprint.Active = false
end

function setupFallbackSprint()
    destroyFallbackSprint()

    local char = getChar()
    if not char then
        print("[Crackstroid/fallback] No character yet")
        return false
    end
    local folder = char:FindFirstChild("SpeedMultipliers")
    if not folder then
        print("[Crackstroid/fallback] No SpeedMultipliers folder")
        return false
    end

    local hum = getHum()
    if not hum then
        print("[Crackstroid/fallback] No Humanoid")
        return false
    end

    FallbackSprint.BaseSpeed = hum:GetAttribute("BaseSpeed") or 16
    local actor = Actors and Actors.CurrentActors and Actors.CurrentActors[LocalPlayer]
    if actor and actor.Config and actor.Config.SprintSpeed then
        FallbackSprint.SprintSpeed = actor.Config.SprintSpeed
    else
        FallbackSprint.SprintSpeed = 26
    end

    pcall(function()
        local pd = LocalPlayer:FindFirstChild("PlayerData")
        if pd then
            local settings = pd:FindFirstChild("Settings")
            local keybinds = settings and settings:FindFirstChild("Keybinds")
            if keybinds then
                local bind = keybinds:FindFirstChild("Sprinting")
                if bind and type(bind.Value) == "string" then
                    local ok, key = pcall(function() return Enum.KeyCode[bind.Value] end)
                    if ok and key then
                        FallbackSprint.SprintKey = key
                    end
                end
            end
        end
    end)

    local mult = Instance.new("NumberValue")
    mult.Name = "CrackstroidSprint"
    mult.Value = 1
    mult.Parent = folder
    FallbackSprint.Multiplier = mult
    FallbackSprint.Active = true

    -- InputBegan/Ended — как страховка
    FallbackSprint.Connections.Begin = UserInputService.InputBegan:Connect(function(input, _)
        if input.KeyCode == FallbackSprint.SprintKey
            or input.KeyCode == Enum.KeyCode.ButtonL3
            or input.KeyCode == Enum.KeyCode.LeftShift then
            FallbackSprint.KeyHeld = true
        end
    end)
    FallbackSprint.Connections.End = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == FallbackSprint.SprintKey
            or input.KeyCode == Enum.KeyCode.ButtonL3
            or input.KeyCode == Enum.KeyCode.LeftShift then
            FallbackSprint.KeyHeld = false
        end
    end)

    -- Heartbeat — главный механизм (игнорирует gameProcessed)
    local multiplier = FallbackSprint.SprintSpeed / math.max(FallbackSprint.BaseSpeed, 1)

    FallbackSprint.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        if not FallbackSprint.Active then return end
        local h = getHum()
        if not h or h.Health <= 0 then return end

        local shouldSprint = FallbackSprint.KeyHeld
            or UserInputService:IsKeyDown(FallbackSprint.SprintKey)
            or UserInputService:IsKeyDown(Enum.KeyCode.ButtonL3)
            or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)

        if FallbackSprint.Multiplier and FallbackSprint.Multiplier.Parent then
            local target = shouldSprint and multiplier or 1
            if FallbackSprint.Multiplier.Value ~= target then
                FallbackSprint.Multiplier.Value = target
            end
        end

        FallbackSprint.IsSprinting = shouldSprint

        -- Дубль: если Multipliers-модуль не работает, WalkSpeed не растёт.
        -- Проверяем ожидаемое значение и, если оно не совпадает, ставим сами.
        local base = FallbackSprint.BaseSpeed
        local expected = shouldSprint and (base * multiplier) or base
        if math.abs(h.WalkSpeed - expected) > 0.5 then
            h.WalkSpeed = expected
        end
    end)

    print(("[Crackstroid/fallback] Active | key=%s | base=%.1f | sprint=%.1f | mult=%.2f")
        :format(tostring(FallbackSprint.SprintKey), FallbackSprint.BaseSpeed, FallbackSprint.SprintSpeed, multiplier))
    return true
end

-- ═══════════════ GOD MODE ═══════════════
local function setGodMode(on)
    State.GodMode = on
    setConn("God", nil)
    local char = getChar()
    local h = getHum()
    if on then
        if char and Util then pcall(function() Util:GiveInvincible(char, "CheatGod") end) end
        if h then
            h.MaxHealth = 9999999
            h.Health = 9999999
        end
        setConn("God", RunService.Heartbeat:Connect(function()
            local c = getChar()
            local hh = getHum()
            if c and hh then
                if Util then pcall(function() Util:GiveInvincible(c, "CheatGod") end) end
                hh.MaxHealth = 9999999
                if hh.Health < 9000000 then hh.Health = 9999999 end
            end
        end))
    else
        if char and Util then pcall(function() Util:RemoveInvincible(char, "CheatGod") end) end
        if h then
            h.MaxHealth = 100
            if h.Health > 100 then h.Health = 100 end
        end
    end
    toast(T("MSG_GOD") .. ": " .. onoff(on), on and "success" or nil)
end

-- ═══════════════ INFINITE STAMINA ═══════════════
local function setInfStamina(on)
    State.InfStamina = on
    setConn("Stam", nil)
    if SprintingMod then
        if on then
            pcall(function()
                SprintingMod.StaminaLossDisabled = true
                SprintingMod.Stamina = SprintingMod.MaxStamina
                if SprintingMod.__staminaChangedEvent then
                    SprintingMod.__staminaChangedEvent:Fire(SprintingMod.MaxStamina)
                end
            end)
            setConn("Stam", RunService.Heartbeat:Connect(function()
                if SprintingMod then
                    pcall(function()
                        SprintingMod.Stamina = SprintingMod.MaxStamina
                        SprintingMod.StaminaLossDisabled = true
                        if SprintingMod.__staminaChangedEvent then
                            SprintingMod.__staminaChangedEvent:Fire(SprintingMod.MaxStamina)
                        end
                    end)
                end
            end))
            toast(T("MSG_STAM") .. ": " .. T("ON"), "success")
        else
            pcall(function() SprintingMod.StaminaLossDisabled = false end)
            toast(T("MSG_STAM") .. ": " .. T("OFF"), nil)
        end
    else
        -- Fallback: наша система стамину не тратит
        toast(T("MSG_STAM") .. ": " .. onoff(on) .. " (fallback)", on and "success" or nil)
    end
end

-- ═══════════════ SPEED ═══════════════
local function setSpeed(m)
    State.Speed = m
    local c = getChar()
    if not c then return end
    local folder = c:FindFirstChild("SpeedMultipliers")
    if not folder then return end
    local old = folder:FindFirstChild("CheatSpeed")
    if old then old:Destroy() end
    if Util and type(Util.CreateSpeedMultiplier) == "function" then
        local ok = pcall(function() Util:CreateSpeedMultiplier(c, m, "CheatSpeed") end)
        if ok then return end
    end
    local nv = Instance.new("NumberValue")
    nv.Name = "CheatSpeed"
    nv.Value = m
    nv.Parent = folder
end

local function setJump(p)
    State.Jump = p
    local h = getHum()
    if h then
        if InitJump == nil then InitJump = h.JumpPower end
        h.JumpPower = p
    end
end

local function setNoClip(on)
    State.NoClip = on
    setConn("NoClip", nil)
    if on then
        setConn("NoClip", RunService.Stepped:Connect(function()
            local c = getChar()
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end
        end))
    end
    toast(T("MSG_NOCLIP") .. ": " .. onoff(on), on and "success" or nil)
end

local function setAutoJump(on)
    State.AutoJump = on
    setConn("AutoJump", nil)
    if on then
        setConn("AutoJump", RunService.Heartbeat:Connect(function()
            local h = getHum(); if h then h.Jump = true end
        end))
    end
end

local FlyBV, FlyBG, FlyConn = nil, nil, nil
local function setFly(on)
    State.Fly = on
    if FlyConn then FlyConn:Disconnect(); FlyConn = nil end
    if FlyBV then FlyBV:Destroy(); FlyBV = nil end
    if FlyBG then FlyBG:Destroy(); FlyBG = nil end
    if not on then return end
    local root = getRoot(); local hum = getHum()
    if not root or not hum then return end
    local ok = pcall(function()
        FlyBV = Instance.new("BodyVelocity")
        FlyBV.Name = "CheatFly"; FlyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5); FlyBV.Velocity = Vector3.zero
        FlyBV.Parent = root
        FlyBG = Instance.new("BodyGyro")
        FlyBG.Name = "CheatFlyGyro"; FlyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5); FlyBG.P = 1000
        FlyBG.Parent = root
    end)
    if not ok then toast("BodyMover failed", "error"); return end
    FlyConn = RunService.RenderStepped:Connect(function()
        local r = getRoot(); local h = getHum()
        if not r or not h or not FlyBV or not FlyBG then return end
        local cam = getCamera(); if not cam then return end
        local camCF = cam.CFrame
        local move = Vector3.zero
        local v = h.MoveDirection
        if v.Magnitude > 0 then move = move + camCF:VectorToWorldSpace(Vector3.new(v.X, 0, v.Z)) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0, -1, 0) end
        FlyBV.Velocity = move * 60
        FlyBG.CFrame = camCF
    end)
    toast(T("MSG_FLY") .. ": " .. T("ON"), "success")
end
local function killSelf()
    local h = getHum(); if h then h.Health = 0; toast(T("MSG_KILLED"), "warn") end
end
local function instantRespawn()
    pcall(function() LocalPlayer:LoadCharacter() end)
end
local function setFreezeCamera(on)
    State.FreezeCamera = on
    local cam = getCamera(); if not cam then return end
    if on then
        cam.CameraType = Enum.CameraType.Scriptable
        toast(T("MSG_CAM_FROZEN"), "success")
    else
        cam.CameraType = Enum.CameraType.Custom
        local h = getHum(); if h then cam.CameraSubject = h end
        toast(T("MSG_CAM_UNFROZEN"), "success")
    end
end
local function setFirstPerson(on)
    State.FirstPerson = on
    pcall(function()
        LocalPlayer.CameraMode = on and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
    end)
end

local FreecamConn = nil
local FreecamCF = CFrame.new()
local function setFreecam(on)
    State.Freecam = on
    local cam = getCamera(); if not cam then return end
    if FreecamConn then FreecamConn:Disconnect(); FreecamConn = nil end
    if on then
        FreecamCF = cam.CFrame
        cam.CameraType = Enum.CameraType.Scriptable
        FreecamConn = RunService.RenderStepped:Connect(function(dt)
            if not State.Freecam then return end
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + FreecamCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - FreecamCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - FreecamCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + FreecamCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
            if move.Magnitude > 0 then FreecamCF = FreecamCF + move.Unit * 40 * dt end
            local md
            local ok = pcall(function() md = UserInputService:GetMouseDelta() end)
            if ok and md then
                FreecamCF = FreecamCF * CFrame.Angles(0, math.rad(-md.X * 0.15), 0) * CFrame.Angles(math.rad(-md.Y * 0.15), 0, 0)
            end
            cam.CFrame = FreecamCF
        end)
        toast("Freecam ON", "success")
    else
        cam.CameraType = Enum.CameraType.Custom
        local h = getHum(); if h then cam.CameraSubject = h end
    end
end

-- ═══════════════ ЭКСТРА ═══════════════
local AntiAFKConn = nil
local function toggleAntiAFK(on)
    State.AntiAFK = on
    if AntiAFKConn then AntiAFKConn:Disconnect(); AntiAFKConn = nil end
    if not on then toast("Anti-AFK: OFF", "warn"); return end
    local VirtualUser = game:GetService("VirtualUser")
    AntiAFKConn = LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
    toast(T("MSG_ANTI_AFK_ON"), "success")
end

local function spamChat(text, count, delay)
    if not Network then toast(T("MSG_EVENT_FAIL"), "error"); return end
    count = count or 10
    delay = delay or 0.1
    task.spawn(function()
        for _ = 1, count do
            pcall(function() Network:FireServerConnection("SendChatMessage", "REMOTE_FUNCTION", text) end)
            task.wait(delay)
        end
        toast(("Chat x%d"):format(count), "success")
    end)
end

local function setGravity(g)
    workspace.Gravity = math.clamp(g, 0, 500)
    toast(("Gravity: %d"):format(math.floor(g)), "success")
end

local function unlockAllAchievements()
    local Achievements = safeRequire(fastFind(Modules, "Schematics", "Achievements"))
    if not Achievements then toast("Achievements not loaded", "warn"); return end
    if not Network then toast(T("MSG_EVENT_FAIL"), "error"); return end
    local sent = 0
    for _, data in pairs(Achievements) do
        if type(data) == "table" and data.Achievements then
            for id, info in pairs(data.Achievements) do
                if type(info) == "table" and info.Clientsided then
                    pcall(function() Network:FireServerConnection("UnlockAchievement", "REMOTE_EVENT", id) end)
                    sent = sent + 1
                end
            end
        end
    end
    toast(("%s (%d)"):format(T("MSG_ACH_UNLOCKED"), sent), "success")
end

local function autoPuzzle()
    local map = workspace:FindFirstChild("Map")
    local ingame = map and map:FindFirstChild("Ingame")
    local mapModel = ingame and ingame:FindFirstChild("Map")
    if not mapModel then toast("No map", "warn"); return end
    task.spawn(function()
        for _, gen in ipairs(mapModel:GetChildren()) do
            if gen.Name == "Generator" or gen.Name == "FakeGenerator" then
                local remotes = gen:FindFirstChild("Remotes")
                local RE = remotes and remotes:FindFirstChild("RE")
                if RE and RE:IsA("RemoteEvent") then
                    pcall(function() RE:FireServer() end)
                    task.wait(0.15)
                end
            end
        end
        toast(T("MSG_PUZZLE_AUTO"), "success")
    end)
end

local KillauraConn = nil
local function toggleKillaura(on)
    State.Killaura = on
    if KillauraConn then KillauraConn:Disconnect(); KillauraConn = nil end
    if not on then toast(T("MSG_KILLAURA_OFF"), "warn"); return end
    if not Network then toast(T("MSG_EVENT_FAIL"), "error"); return end
    KillauraConn = RunService.Heartbeat:Connect(function()
        local actor = Actors and Actors.CurrentActors and Actors.CurrentActors[LocalPlayer]
        if not actor then return end
        local targetList = {}
        if actor.Behavior and actor.Behavior.Abilities then
            for name in pairs(actor.Behavior.Abilities) do
                if name == "Stab" or name == "Slash" or name == "Lacerate" or name:lower():find("attack") then
                    table.insert(targetList, name)
                end
            end
        end
        if actor.CustomBehavior and actor.CustomBehavior.Abilities then
            for name in pairs(actor.CustomBehavior.Abilities) do
                if name == "Stab" or name == "Slash" or name == "Lacerate" or name:lower():find("attack") then
                    if not table.find(targetList, name) then table.insert(targetList, name) end
                end
            end
        end
        for _, name in ipairs(targetList) do
            pcall(function() Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", name) end)
        end
    end)
    toast(T("MSG_KILLAURA_ON"), "success")
end

-- ═══════════════ ТЕЛЕПОРТЫ ═══════════════
local function getSpawnParts(teamName)
    local result = {}
    local map = workspace:FindFirstChild("Map"); if not map then return result end
    local ingame = map:FindFirstChild("Ingame"); if not ingame then return result end
    local mapModel = ingame:FindFirstChild("Map"); if not mapModel then return result end
    local sp = mapModel:FindFirstChild("SpawnPoints"); if not sp then return result end
    local folder = sp:FindFirstChild(teamName); if not folder then return result end
    for _, p in ipairs(folder:GetChildren()) do
        if p:IsA("BasePart") then table.insert(result, p) end
    end
    return result
end
local function getLobbySpawnParts()
    local result = {}
    local map = workspace:FindFirstChild("Map"); if not map then return result end
    local lobby = map:FindFirstChild("Lobby"); if not lobby then return result end
    local sp = lobby:FindFirstChild("SpawnPoints")
    if sp then
        for _, folder in ipairs(sp:GetChildren()) do
            for _, p in ipairs(folder:GetChildren()) do
                if p:IsA("BasePart") then table.insert(result, p) end
            end
        end
    else
        for _, p in ipairs(lobby:GetChildren()) do
            if p:IsA("SpawnLocation") then table.insert(result, p) end
        end
    end
    return result
end
local function tpToSpawn(teamName)
    local spawns = (teamName == "Lobby") and getLobbySpawnParts() or getSpawnParts(teamName)
    if #spawns == 0 then toast(T("MSG_TP_NO_SPAWN"), "warn"); return end
    local char = getChar()
    if not char or not char.PrimaryPart then return end
    local target = spawns[math.random(1, #spawns)]
    pcall(function() char:PivotTo(target.CFrame + Vector3.new(0, 4, 0)) end)
    toast(T("MSG_TP") .. " → " .. teamName, "success")
end
local function getPlayerTeam(plr)
    local char = plr.Character
    if not char or not char.Parent then return "?" end
    return char.Parent.Name
end
local function tpToPlayerByName(name)
    if not name or name == "" then return end
    name = name:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if plr.Name:lower():find(name, 1, true) or (plr.DisplayName or ""):lower():find(name, 1, true) then
            local char = getChar()
            local target = plr.Character
            if not char or not char.PrimaryPart then return end
            if not target or not target.PrimaryPart then toast(T("MSG_TP_PLAYER_LEFT"), "warn"); return end
            pcall(function() char:PivotTo(target.PrimaryPart.CFrame * CFrame.new(0, 0, 5)) end)
            toast(T("MSG_TP") .. " → " .. plr.Name, "success")
            return
        end
    end
    toast(T("MSG_TP_PLAYER_LEFT"), "warn")
end
local function tpToRandomFromTeam(teamName)
    local folder = workspace:FindFirstChild("Players"); if not folder then return end
    local team = folder:FindFirstChild(teamName); if not team then toast(T("MSG_TP_NO_SPAWN"), "warn"); return end
    local list = {}
    for _, c in ipairs(team:GetChildren()) do
        if c:IsA("Model") and c.PrimaryPart then table.insert(list, c) end
    end
    if #list == 0 then toast(T("MSG_TP_NO_SPAWN"), "warn"); return end
    local target = list[math.random(1, #list)]
    local char = getChar()
    if char and char.PrimaryPart then
        pcall(function() char:PivotTo(target.PrimaryPart.CFrame * CFrame.new(0, 0, 5)) end)
        toast(T("MSG_TP") .. " → " .. target.Name, "success")
    end
end

-- ═══════════════ СТРИМЕР ═══════════════
local function getPlayerHUDModule()
    if not Initializer or not Initializer.Loaded then return nil end
    local cs = Initializer.CharacterSystems
    if cs and cs.PlayerHUD then return cs.PlayerHUD end
    local ps = Initializer.PlayerSystems
    if ps and ps.PlayerHUD then return ps.PlayerHUD end
    return nil
end
local function getPlayerListModule()
    if not Initializer or not Initializer.Loaded then return nil end
    return Initializer.Modules and Initializer.Modules.PlayerList
end
local function applyHUDAnonymize()
    local hud = getPlayerHUDModule()
    if not hud then return end
    local rigToFrame = hud._rigToFrame
    if not rigToFrame or type(rigToFrame) ~= "table" then return end
    local n = 0
    for _, frame in pairs(rigToFrame) do
        if frame and frame.Parent then
            n = n + 1
            local sn = frame:FindFirstChild("SurvivorName")
            local un = frame:FindFirstChild("Username")
            if sn and sn:IsA("TextLabel") then sn.Text = "Player " .. n end
            if un and un:IsA("TextLabel") then un.Text = "***" end
        end
    end
end
local function applyHUDHide()
    local hud = getPlayerHUDModule()
    if not hud then return end
    local ui = hud.UI
    if not ui then return end
    local cs = ui:FindFirstChild("CurrentSurvivors")
    if cs then cs.Visible = false end
end
local function applyListAnonymize()
    local plm = getPlayerListModule()
    if not plm then return end
    local list = plm.PlayerList
    if not list then return end
    local contents = list:FindFirstChild("Contents")
    if not contents then return end
    local players = contents:FindFirstChild("Players")
    if not players then return end
    local n = 0
    for _, container in ipairs(players:GetChildren()) do
        if container:IsA("Frame") and container.Name ~= "UIListLayout" then
            n = n + 1
            local info = container:FindFirstChild("PlayerInfo")
            if info then
                local un = info:FindFirstChild("Username")
                if un and un:IsA("TextLabel") then un.Text = "Player " .. n end
            end
        end
    end
end
local function applyListHide()
    local plm = getPlayerListModule()
    if not plm then return end
    if type(plm.TogglePlayerList) == "function" then
        pcall(function() plm:TogglePlayerList(false, true) end)
    end
end
setConn("AnonLoop", RunService.Heartbeat:Connect(function()
    if Settings.StreamerMode then applyHUDHide(); applyListHide() end
    if Settings.AnonymizeHUD then applyHUDAnonymize() end
    if Settings.AnonymizePlayerList then applyListAnonymize() end
end))

setConn("AllNamesLoop", RunService.Heartbeat:Connect(function()
    if not State.ShowAllNames then return end
    local folder = workspace:FindFirstChild("Players"); if not folder then return end
    for _, sub in ipairs(folder:GetChildren()) do
        for _, c in ipairs(sub:GetChildren()) do
            if c:IsA("Model") then
                local head = c:FindFirstChild("Head") or c.PrimaryPart
                if head and not head:FindFirstChild("CheatName") then
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "CheatName"; bb.Size = UDim2.fromOffset(120, 24)
                    bb.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = true; bb.Adornee = head; bb.Parent = head
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.fromScale(1, 1); lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = Color3.new(1, 1, 1); lbl.TextStrokeTransparency = 0
                    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
                    lbl.Text = c.Name; lbl.Parent = bb
                end
            end
        end
    end
end))

-- ═══════════════ ОСВЕЩЕНИЕ ═══════════════
local ActiveLightingAnim = nil
local function stopLightingAnim()
    if ActiveLightingAnim then ActiveLightingAnim:Disconnect(); ActiveLightingAnim = nil end
end
local function removePostFX()
    for _, c in ipairs(Lighting:GetChildren()) do
        if c.Name:sub(1, 7) == "CheatFX" then c:Destroy() end
    end
end
local function applyLightingPreset(preset)
    stopLightingAnim(); removePostFX()
    pcall(function()
        Lighting.Ambient = Color3.fromRGB(132, 42, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 102, 0)
        Lighting.Brightness = 0.4; Lighting.ClockTime = 6
        Lighting.ExposureCompensation = 0
        Lighting.FogColor = Color3.fromRGB(192, 192, 192)
        Lighting.FogEnd = 5000; Lighting.FogStart = 0
        Lighting.GlobalShadows = true
    end)
    local function makeCC(name, props)
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "CheatFX" .. name
        for k, v in pairs(props) do cc[k] = v end
        cc.Parent = Lighting; return cc
    end
    if preset == "default" then
        if LightingMod and type(LightingMod.SetDefaultLighting) == "function" then
            pcall(function() LightingMod:SetDefaultLighting() end)
        end
        toast(T("MSG_LIGHT_RESET"), "success")
    elseif preset == "day" then
        Lighting.Ambient = Color3.fromRGB(180, 200, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2.5; Lighting.ClockTime = 12
        Lighting.ExposureCompensation = 0.2
        Lighting.FogColor = Color3.fromRGB(220, 230, 255); Lighting.FogEnd = 8000
        makeCC("Day", {Brightness = 0.1, Contrast = 0.05, Saturation = 0.1})
    elseif preset == "night" then
        Lighting.Ambient = Color3.fromRGB(30, 40, 80)
        Lighting.OutdoorAmbient = Color3.fromRGB(50, 60, 120)
        Lighting.Brightness = 0.3; Lighting.ClockTime = 0
        Lighting.ExposureCompensation = -0.3
        Lighting.FogColor = Color3.fromRGB(20, 25, 50); Lighting.FogEnd = 2000
        makeCC("Night", {TintColor = Color3.fromRGB(150, 170, 255), Brightness = -0.1, Contrast = 0.15, Saturation = -0.2})
    elseif preset == "neon" then
        Lighting.Ambient = Color3.fromRGB(80, 20, 120)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 50, 200)
        Lighting.Brightness = 1.5; Lighting.ClockTime = 22
        Lighting.ExposureCompensation = 0.5
        Lighting.FogColor = Color3.fromRGB(255, 100, 255); Lighting.FogEnd = 1500
        makeCC("Neon", {TintColor = Color3.fromRGB(255, 150, 255), Brightness = 0.3, Contrast = 0.5, Saturation = 0.8})
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "CheatFXNeonBloom"; bloom.Intensity = 1.5; bloom.Size = 40; bloom.Threshold = 0.5
        bloom.Parent = Lighting
    elseif preset == "horror" then
        Lighting.Ambient = Color3.fromRGB(50, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(100, 0, 0)
        Lighting.Brightness = 0.2; Lighting.ClockTime = 0
        Lighting.ExposureCompensation = -0.7
        Lighting.FogColor = Color3.fromRGB(80, 0, 0); Lighting.FogEnd = 800
        makeCC("Horror", {TintColor = Color3.fromRGB(255, 100, 100), Brightness = -0.2, Contrast = 0.4, Saturation = -0.5})
        local blur = Instance.new("BlurEffect")
        blur.Name = "CheatFXHorrorBlur"; blur.Size = 4; blur.Parent = Lighting
    elseif preset == "cinematic" then
        Lighting.Ambient = Color3.fromRGB(100, 100, 120)
        Lighting.Brightness = 1; Lighting.ClockTime = 18
        Lighting.ExposureCompensation = -0.15
        makeCC("Cine", {TintColor = Color3.fromRGB(200, 210, 230), Contrast = 0.3, Saturation = -0.15})
        local dof = Instance.new("DepthOfFieldEffect")
        dof.Name = "CheatFXCineDof"; dof.FarIntensity = 0.7; dof.FocusDistance = 15; dof.InFocusRadius = 20
        dof.Parent = Lighting
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "CheatFXCineBloom"; bloom.Intensity = 0.3; bloom.Size = 24; bloom.Threshold = 1.1
        bloom.Parent = Lighting
    elseif preset == "foggy" then
        Lighting.Ambient = Color3.fromRGB(160, 170, 190)
        Lighting.Brightness = 0.7; Lighting.ClockTime = 7
        Lighting.FogColor = Color3.fromRGB(220, 225, 235)
        Lighting.FogEnd = 300; Lighting.FogStart = 0
        makeCC("Fog", {TintColor = Color3.fromRGB(220, 220, 220), Contrast = 0.1})
    elseif preset == "disco" then
        Lighting.Brightness = 1.5; Lighting.Ambient = Color3.fromRGB(100, 100, 255)
        local cc = makeCC("Disco", {Brightness = 0.2, Contrast = 0.3, Saturation = 0.6})
        local t = 0
        ActiveLightingAnim = RunService.Heartbeat:Connect(function(dt)
            t = t + dt
            cc.TintColor = Color3.fromHSV((t * 0.5) % 1, 0.8, 1)
            Lighting.Ambient = Color3.fromHSV((t * 0.3 + 0.5) % 1, 0.5, 0.6)
        end)
    end
    toast(preset, "success")
end
local function setFullbright(on)
    State.Fullbright = on
    local e = Lighting:FindFirstChild("CheatFXFullbright"); if e then e:Destroy() end
    if on then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "CheatFXFullbright"
        cc.Brightness = 2; cc.Contrast = 0.3; cc.Saturation = 0.4
        cc.TintColor = Color3.new(1, 1, 1); cc.Parent = Lighting
    end
    toast(T("MSG_FULLBRIGHT") .. ": " .. onoff(on), on and "success" or nil)
end
local function addAtmosphere()
    removePostFX()
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "CheatFXAtmo"
    atmo.Density = 0.5; atmo.Offset = 0.2
    atmo.Color = Color3.fromRGB(255, 255, 255)
    atmo.Decay = Color3.fromRGB(106, 112, 125)
    atmo.Glare = 0.5; atmo.Haze = 2
    atmo.Parent = Lighting
    toast("Atmosphere", "success")
end

-- ═══════════════ МЕНЮ ═══════════════
local function openMenuByName(name)
    if not Initializer or not Initializer.Loaded then toast(T("NA"), "warn"); return end
    local ps = Initializer.PlayerSystems
    local sb = ps and ps.SidebarHandler
    local menus = sb and sb.SidebarMenus
    if not menus then toast(T("NA"), "warn"); return end
    local menu = menus[name]
    if menu and type(menu.ToggleMenu) == "function" then
        pcall(function() menu:ToggleMenu(true) end)
        toast(T("MSG_MENU_OPEN") .. ": " .. name, "success")
    else
        toast(T("NA") .. ": " .. name, "warn")
    end
end
local function closeAllMenus()
    if not Initializer or not Initializer.Loaded then return end
    local menus = Initializer.PlayerSystems and Initializer.PlayerSystems.SidebarHandler
        and Initializer.PlayerSystems.SidebarHandler.SidebarMenus
    if not menus then return end
    for _, m in pairs(menus) do
        if type(m.ToggleMenu) == "function" then pcall(function() m:ToggleMenu(false) end) end
    end
    toast(T("MSG_MENU_CLOSED"), "success")
end
local function openEmoteMenu()
    if EmoteMod and type(EmoteMod.ToggleEmoteMenu) == "function" then
        pcall(function() EmoteMod:ToggleEmoteMenu() end)
    end
end
local function togglePlayerList()
    local pl = Initializer and Initializer.Modules and Initializer.Modules.PlayerList
    if pl and type(pl.TogglePlayerList) == "function" then
        pcall(function() pl:TogglePlayerList(not pl.ListEnabled) end)
    end
end
local function openShopTab(tab)
    if not Initializer or not Initializer.Loaded then return end
    local shop = Initializer.PlayerSystems and Initializer.PlayerSystems.Shop
    if shop and type(shop.SwitchTab) == "function" then
        pcall(function() shop:SwitchTab(tab) end)
    end
    openMenuByName("Shop")
end
local function openPuzzle(kind, size)
    local ctrl = (kind == "Blue" and BluePuzzle) or (kind == "Flow" and FlowGame) or nil
    if not ctrl then toast(T("NA"), "warn"); return end
    if kind == "Blue" and type(ctrl.startGame) == "function" then
        pcall(function() ctrl:startGame({rows = size, cols = size}) end)
    elseif kind == "Flow" and type(ctrl.startGame) == "function" then
        pcall(function() ctrl:startGame(size) end)
    end
    toast(kind .. " " .. size, "success")
end
local function closePuzzle()
    if BluePuzzle and type(BluePuzzle.endGame) == "function" then pcall(function() BluePuzzle:endGame() end) end
    if FlowGame then
        if type(FlowGame.endGame) == "function" then pcall(function() FlowGame:endGame() end)
        elseif type(FlowGame.EndGame) == "function" then pcall(function() FlowGame:EndGame() end)
        elseif type(FlowGame.Stop) == "function" then pcall(function() FlowGame:Stop() end) end
    end
    toast(T("MSG_PUZZLE_CLOSED"), "success")
end

-- ═══════════════ ЭМОЦИИ ═══════════════
local EmoteCache = {Shared = {}, Actor = {}}
local LastEmoteFire = 0
local function scanEmotes()
    EmoteCache.Shared = {}; EmoteCache.Actor = {}
    local folder = Assets and Assets:FindFirstChild("Emotes")
    if folder then
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("ModuleScript") then
                local ok, data = pcall(RealRequire, child)
                if ok and type(data) == "table" then
                    table.insert(EmoteCache.Shared, {
                        Name = child.Name, DisplayName = data.DisplayName or child.Name,
                        Price = tonumber(data.Price) or 0, Exclusive = data.Exclusive == true,
                    })
                end
            end
        end
    end
    table.sort(EmoteCache.Shared, function(a, b)
        if a.Exclusive ~= b.Exclusive then return a.Exclusive end
        if a.Price ~= b.Price then return a.Price > b.Price end
        return a.Name < b.Name
    end)
    local actor = Actors and Actors.CurrentActors and Actors.CurrentActors[LocalPlayer]
    if actor and actor.Config and actor.Config.Emotes then
        for etype, list in pairs(actor.Config.Emotes) do
            if type(list) == "table" then
                for name, data in pairs(list) do
                    if type(data) == "table" then
                        table.insert(EmoteCache.Actor, {Name = name, Type = etype, DisplayName = data.DisplayName or name})
                    end
                end
            end
        end
    end
end
local function playEmote(cat, name)
    local now = os.clock()
    if now - LastEmoteFire < EMOTE_COOLDOWN then return end
    LastEmoteFire = now
    if not Network then toast(T("MSG_EVENT_FAIL"), "error"); return end
    pcall(function() Network:FireServerConnection("PlayEmote", "REMOTE_EVENT", cat, name) end)
    toast(T("MSG_EMOTE") .. ": " .. name, "success")
end
local function stopEmote()
    if Network then
        pcall(function() Network:FireServerConnection("StopEmote", "REMOTE_EVENT") end)
        toast(T("MSG_EMOTE_STOP"), "success")
    end
end
local function autoEmoteSpam(name, count)
    task.spawn(function()
        for _ = 1, count do playEmote("Animations", name); task.wait(0.5) end
    end)
    toast(T("MSG_AUTO_EMOTE"), "success")
end
local function setAutoRandomEmote(on)
    State.AutoRandomEmote = on
    setConn("AutoRandEmote", nil)
    if on then
        setConn("AutoRandEmote", task.spawn(function()
            while State.AutoRandomEmote do
                if #EmoteCache.Shared > 0 then
                    local e = EmoteCache.Shared[math.random(1, #EmoteCache.Shared)]
                    playEmote("Animations", e.Name)
                end
                task.wait(math.random(3, 7))
            end
        end))
    end
    toast("Auto-random: " .. onoff(on), on and "success" or nil)
end

-- ═══════════════ СПОСОБНОСТИ ═══════════════
local function listAbilities()
    local result = {}
    local actor = Actors and Actors.CurrentActors and Actors.CurrentActors[LocalPlayer]
    if not actor then return result end
    local function collect(t)
        if type(t) ~= "table" then return end
        for name in pairs(t) do
            if not table.find(result, name) then table.insert(result, name) end
        end
    end
    if actor.Behavior and actor.Behavior.Abilities then collect(actor.Behavior.Abilities) end
    if actor.CustomBehavior and actor.CustomBehavior.Abilities then collect(actor.CustomBehavior.Abilities) end
    table.sort(result); return result
end
local function fireAbility(name)
    if Network then
        pcall(function() Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", name) end)
        toast(T("MSG_ABILITY") .. ": " .. name, "success")
    end
end

-- ═══════════════ АУРЫ ═══════════════
local function revealAuras(team)
    if not Util then return end
    local folder = workspace:FindFirstChild("Players")
    local t = folder and folder:FindFirstChild(team)
    if not t then return end
    for _, c in ipairs(t:GetChildren()) do
        if c:IsA("Model") then pcall(function() Util:RevealPlayerAura(c, 15) end) end
    end
    toast(team, "success")
end
local function clearAuras()
    if not Util then return end
    local folder = workspace:FindFirstChild("Players"); if not folder then return end
    for _, sub in ipairs(folder:GetChildren()) do
        for _, c in ipairs(sub:GetChildren()) do
            if c:IsA("Model") then pcall(function() Util:RemovePlayerAuraFrom(c) end) end
        end
    end
    toast("Cleared", "success")
end

-- ═══════════════ ПЕРСОНАЖИ ═══════════════
local function getPurchased()
    local pd = LocalPlayer:FindFirstChild("PlayerData")
    if not pd then
        local ok, r = pcall(function() return LocalPlayer:WaitForChild("PlayerData", 2) end)
        if ok then pd = r end
    end
    return pd and pd:FindFirstChild("Purchased")
end
local function isOwned(kind, name)
    local p = getPurchased(); if not p then return false end
    local folder = p:FindFirstChild(kind)
    return folder ~= nil and folder:FindFirstChild(name) ~= nil
end
local function equipCharacter(kind, name)
    local assetsFolder = Assets and Assets:FindFirstChild(kind)
    local asset = assetsFolder and assetsFolder:FindFirstChild(name)
    if not asset then toast(T("NA"), "warn"); return end
    if not Network then return end
    pcall(function() Network:FireServerConnection("EquipState", "REMOTE_EVENT", asset, nil) end)
    toast(T("MSG_EQUIPPED") .. ": " .. name, "success")
end
local function equipRandom()
    for _, kind in ipairs({"Killers", "Survivors"}) do
        local p = getPurchased()
        if p then
            local folder = p:FindFirstChild(kind)
            if folder then
                local list = {}
                for _, c in ipairs(folder:GetChildren()) do table.insert(list, c.Name) end
                if #list > 0 then equipCharacter(kind, list[math.random(1, #list)]); return end
            end
        end
    end
end
local function showActorInfo()
    local actor = Actors and Actors.CurrentActors and Actors.CurrentActors[LocalPlayer]
    if not actor then toast(T("MSG_NO_ACTOR"), "warn"); return end
    toast("Actor: " .. tostring(actor.ActorName or "?") .. " | " .. tostring(actor.ActorType or "?"), "success")
end

-- ═══════════════ ESP ═══════════════
local ESPActive = {}
local ESP_COLORS = {
    Survivors = Color3.fromRGB(80, 255, 100), Killers = Color3.fromRGB(255, 60, 60),
    Items = Color3.fromRGB(255, 210, 40), Generators = Color3.fromRGB(80, 180, 255),
}
local function removeESPEntry(inst)
    local data = ESPActive[inst]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
        ESPActive[inst] = nil
    end
end
local function addESPEntry(inst, kind, displayName)
    if ESPActive[inst] then return end
    local color = ESP_COLORS[kind] or Color3.new(1, 1, 1)
    local highlight, bb = nil, nil
    if Settings.ESPStyle == "highlight" or Settings.ESPStyle == "both" then
        highlight = Instance.new("Highlight")
        highlight.Name = "CheatESP"
        highlight.Adornee = inst
        highlight.FillColor = color; highlight.OutlineColor = color
        highlight.FillTransparency = 0.55; highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = inst
    end
    if Settings.ESPStyle == "billboard" or Settings.ESPStyle == "both" then
        local adornPart = nil
        if inst:IsA("Model") then adornPart = inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
        elseif inst:IsA("BasePart") then adornPart = inst end
        if adornPart then
            bb = Instance.new("BillboardGui")
            bb.Name = "CheatESPBB"; bb.Size = UDim2.fromOffset(160, 36)
            bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true
            bb.MaxDistance = Settings.ESPDistance; bb.Adornee = adornPart; bb.Parent = adornPart
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.fromScale(1, 1); lbl.BackgroundTransparency = 1
            lbl.TextColor3 = color; lbl.TextStrokeTransparency = 0
            lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.Text = displayName
            lbl.Parent = bb
        end
    end
    ESPActive[inst] = {highlight = highlight, billboard = bb, kind = kind}
end
local function clearESP()
    for inst in pairs(ESPActive) do removeESPEntry(inst) end
end
local function refreshESP()
    if not (State.ESPPlayers or State.ESPKillers or State.ESPItems or State.ESPGenerators) then
        clearESP(); return
    end
    local folder = workspace:FindFirstChild("Players")
    local ingame = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
    local survF = folder and folder:FindFirstChild("Survivors")
    local killF = folder and folder:FindFirstChild("Killers")
    local seen = {}
    if State.ESPPlayers and survF then
        for _, c in ipairs(survF:GetChildren()) do
            if c:IsA("Model") then
                seen[c] = true
                local disp = c:GetAttribute("ActorDisplayName") or c:GetAttribute("Username") or c.Name
                addESPEntry(c, "Survivors", tostring(disp))
            end
        end
    end
    if State.ESPKillers and killF then
        for _, c in ipairs(killF:GetChildren()) do
            if c:IsA("Model") then
                seen[c] = true
                local disp = c:GetAttribute("ActorDisplayName") or c:GetAttribute("Username") or c.Name
                addESPEntry(c, "Killers", tostring(disp))
            end
        end
    end
    if State.ESPItems and ingame then
        for _, c in ipairs(ingame:GetChildren()) do
            if c:IsA("Tool") and c:FindFirstChild("ItemRoot") then
                seen[c] = true; addESPEntry(c, "Items", c.Name)
            end
        end
    end
    if State.ESPGenerators and ingame then
        local map = ingame:FindFirstChild("Map")
        if map then
            for _, c in ipairs(map:GetChildren()) do
                if c:IsA("Model") and (c.Name == "Generator" or c.Name == "FakeGenerator") then
                    seen[c] = true
                    local prog = c:FindFirstChild("Progress")
                    local val = ""
                    if prog and prog:IsA("NumberValue") then val = string.format(" [%d%%]", math.floor(prog.Value)) end
                    addESPEntry(c, "Generators", c.Name .. val)
                end
            end
        end
    end
    for inst in pairs(ESPActive) do
        if not seen[inst] or not inst.Parent then removeESPEntry(inst) end
    end
end
setConn("ESPRefresh", RunService.Heartbeat:Connect(refreshESP))
local function setESPDistance(d)
    Settings.ESPDistance = d
    for _, data in pairs(ESPActive) do
        if data.billboard then data.billboard.MaxDistance = d end
    end
end

-- ═══════════════ ОВЕРЛЕИ ═══════════════
local GuiRoot = nil
local PingFrame = nil
local function togglePingFPS()
    if PingFrame and PingFrame.Parent then PingFrame:Destroy(); PingFrame = nil; return end
    if not GuiRoot then return end
    local f = Instance.new("TextLabel")
    f.Name = "CrackstroidPing"
    f.Size = UDim2.fromOffset(200, 28); f.Position = UDim2.new(0, 8, 0, 8)
    f.BackgroundColor3 = THEME.PANEL; f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0; f.TextColor3 = THEME.TEXT
    f.Font = Enum.Font.GothamMedium; f.TextSize = 11; f.Parent = GuiRoot
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 5); c.Parent = f
    PingFrame = f
    task.spawn(function()
        while f.Parent do
            local ping = 0
            pcall(function()
                if LocalPlayer.GetNetworkPing then ping = math.floor((LocalPlayer:GetNetworkPing() * 1000) + 0.5) end
            end)
            local dt = RunService.RenderStepped:Wait()
            local fps = math.floor(1 / math.max(dt, 0.001))
            f.Text = string.format("%s: %dms | %s: %d", T("PING_LABEL"), ping, T("FPS_LABEL"), fps)
            task.wait(0.5)
        end
    end)
end
local CoordFrame = nil
local function toggleCoords()
    if CoordFrame and CoordFrame.Parent then CoordFrame:Destroy(); CoordFrame = nil; return end
    if not GuiRoot then return end
    local f = Instance.new("TextLabel")
    f.Name = "CrackstroidCoords"
    f.Size = UDim2.fromOffset(220, 24); f.Position = UDim2.new(0, 8, 0, 42)
    f.BackgroundColor3 = THEME.PANEL; f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0; f.TextColor3 = THEME.TEXT
    f.Font = Enum.Font.GothamMedium; f.TextSize = 11; f.Parent = GuiRoot
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 5); c.Parent = f
    CoordFrame = f
    task.spawn(function()
        while f.Parent do
            local root = getRoot()
            if root then
                local p = root.Position
                f.Text = string.format("X: %d Y: %d Z: %d", math.floor(p.X), math.floor(p.Y), math.floor(p.Z))
            else
                f.Text = "X: - Y: - Z: -"
            end
            task.wait(0.2)
        end
    end)
end

local function addCorner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end
local function addStroke(p, color, thickness)
    local s = Instance.new("UIStroke"); s.Color = color; s.Thickness = thickness or 1; s.Parent = p; return s
end

local ServerInfoPanel = nil
local function toggleServerInfo()
    if ServerInfoPanel and ServerInfoPanel.Parent then ServerInfoPanel:Destroy(); ServerInfoPanel = nil; return end
    if not GuiRoot then return end
    local p = Instance.new("Frame")
    p.Name = "CrackstroidServerInfo"
    p.Size = UDim2.fromOffset(280, 220); p.Position = UDim2.new(0, 8, 0, 70)
    p.BackgroundColor3 = THEME.BG; p.BackgroundTransparency = 0.05
    p.BorderSizePixel = 0; p.Parent = GuiRoot
    addCorner(p, 8); addStroke(p, THEME.ACCENT, 1.5)
    ServerInfoPanel = p
    local reqSrc = "?"
    for _, src in ipairs(RequireSources) do
        if src.Fn == RealRequire then reqSrc = src.Name; break end
    end
    local sprintStatus = (SprintingMod and "native") or (FallbackSprint.Active and "fallback") or "none"
    local lines = {
        "Place ID: " .. game.PlaceId,
        "Job ID: " .. tostring(game.JobId ~= "" and game.JobId or "Studio"),
        "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
        "ServerType: " .. tostring(workspace:GetAttribute("ServerType") or "?"),
        "Executor: " .. EXECUTOR,
        "Version: " .. VERSION,
        "Sprint: " .. sprintStatus,
        "Require: " .. reqSrc,
        "PlayerGui: " .. (LocalPlayer:FindFirstChildOfClass("PlayerGui") and "OK" or "MISSING"),
    }
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -8, 0, 24); title.Position = UDim2.fromOffset(4, 4)
    title.BackgroundTransparency = 1; title.Text = "ℹ " .. T("SEC_SERVER")
    title.TextColor3 = THEME.ACCENT; title.Font = Enum.Font.GothamBold
    title.TextSize = 12; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = p
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(22, 22); closeBtn.Position = UDim2.new(1, -26, 0, 5)
    closeBtn.BackgroundColor3 = THEME.DANGER; closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1); closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11; closeBtn.Parent = p; addCorner(closeBtn, 4)
    closeBtn.MouseButton1Click:Connect(function() p:Destroy(); ServerInfoPanel = nil end)
    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -12, 1, -34); body.Position = UDim2.fromOffset(6, 30)
    body.BackgroundTransparency = 1; body.Text = table.concat(lines, "\n")
    body.TextColor3 = THEME.TEXT; body.Font = Enum.Font.Code
    body.TextSize = 10; body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top; body.Parent = p
end

local PlayerListPanel = nil
local function togglePlayerListPanel()
    if PlayerListPanel and PlayerListPanel.Parent then PlayerListPanel:Destroy(); PlayerListPanel = nil; return end
    if not GuiRoot then return end
    local p = Instance.new("Frame")
    p.Name = "CrackstroidPlayerList"
    p.Size = UDim2.fromOffset(300, 400); p.Position = UDim2.new(0, 8, 0.5, -200)
    p.BackgroundColor3 = THEME.BG; p.BackgroundTransparency = 0.05
    p.BorderSizePixel = 0; p.Parent = GuiRoot
    addCorner(p, 8); addStroke(p, THEME.ACCENT, 1.5)
    PlayerListPanel = p
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -8, 0, 26); title.Position = UDim2.fromOffset(4, 4)
    title.BackgroundTransparency = 1; title.Text = "👥 " .. T("BTN_PLAYER_LIST")
    title.TextColor3 = THEME.ACCENT; title.Font = Enum.Font.GothamBold
    title.TextSize = 12; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = p
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(22, 22); closeBtn.Position = UDim2.new(1, -26, 0, 5)
    closeBtn.BackgroundColor3 = THEME.DANGER; closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1); closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11; closeBtn.Parent = p; addCorner(closeBtn, 4)
    closeBtn.MouseButton1Click:Connect(function() p:Destroy(); PlayerListPanel = nil end)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -8, 1, -38); scroll.Position = UDim2.fromOffset(4, 34)
    scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4; scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.Parent = p
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 4); layout.Parent = scroll
    task.spawn(function()
        while p.Parent do
            for _, c in ipairs(scroll:GetChildren()) do
                if c:IsA("Frame") then c:Destroy() end
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, -4, 0, 30); row.BackgroundColor3 = THEME.PANEL_HOVER
                row.Parent = scroll; addCorner(row, 4)
                local team = getPlayerTeam(plr)
                local teamColor = Color3.fromRGB(150, 150, 150)
                if team == "Survivors" then teamColor = Color3.fromRGB(80, 200, 100)
                elseif team == "Killers" then teamColor = Color3.fromRGB(220, 60, 60) end
                local nameL = Instance.new("TextLabel")
                nameL.Size = UDim2.new(0.55, -4, 1, 0); nameL.Position = UDim2.fromOffset(4, 0)
                nameL.BackgroundTransparency = 1; nameL.Text = plr.Name
                nameL.TextColor3 = teamColor; nameL.Font = Enum.Font.GothamMedium
                nameL.TextSize = 10; nameL.TextXAlignment = Enum.TextXAlignment.Left; nameL.Parent = row
                local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                local hp = hum and math.floor(hum.Health) or 0
                local hpL = Instance.new("TextLabel")
                hpL.Size = UDim2.new(0.42, -4, 1, 0); hpL.Position = UDim2.new(0.56, 0, 0, 0)
                hpL.BackgroundTransparency = 1; hpL.Text = team .. " | " .. hp
                hpL.TextColor3 = THEME.TEXT_DIM; hpL.Font = Enum.Font.Gotham
                hpL.TextSize = 9; hpL.TextXAlignment = Enum.TextXAlignment.Right; hpL.Parent = row
            end
            task.wait(1)
        end
    end)
end

local function setShowAllNames(on)
    State.ShowAllNames = on
    if not on then
        local folder = workspace:FindFirstChild("Players"); if not folder then return end
        for _, sub in ipairs(folder:GetChildren()) do
            for _, c in ipairs(sub:GetChildren()) do
                if c:IsA("Model") then
                    local head = c:FindFirstChild("Head") or c.PrimaryPart
                    if head then
                        local existing = head:FindFirstChild("CheatName")
                        if existing then existing:Destroy() end
                    end
                end
            end
        end
    end
    toast(on and T("MSG_NAMES_ON") or T("MSG_NAMES_OFF"), "success")
end
local function rejoin()
    toast(T("MSG_REJOIN"), "warn")
    task.wait(0.5)
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end

-- ═══════════════ ДАМПЫ ═══════════════
local function buildSettingsDump()
    local lines = {
        "-- Crackstroid v" .. VERSION, "-- Player: " .. LocalPlayer.Name, "-- Executor: " .. EXECUTOR,
        "", "local CrackstroidSettings = {",
    }
    for k, v in pairs(Settings) do
        if type(v) == "string" then table.insert(lines, string.format('    ["%s"] = %q,', tostring(k), v))
        elseif type(v) == "boolean" or type(v) == "number" then
            table.insert(lines, string.format('    ["%s"] = %s,', tostring(k), tostring(v))) end
    end
    table.insert(lines, "}")
    table.insert(lines, "for k, v in pairs(CrackstroidSettings) do _G.CrackstroidSettings[k] = v end")
    return table.concat(lines, "\n")
end
local function buildStateDump()
    local lines = {"-- Crackstroid State", "", "local CrackstroidState = {"}
    for k, v in pairs(State) do
        if type(v) == "boolean" or type(v) == "number" then
            table.insert(lines, string.format('    ["%s"] = %s,', tostring(k), tostring(v))) end
    end
    table.insert(lines, "}")
    return table.concat(lines, "\n")
end
local function buildFullDump() return buildSettingsDump() .. "\n\n" .. buildStateDump() end
local function copyToClipboard(text)
    if setclipboard then
        local ok = pcall(setclipboard, text)
        if ok then toast(T("MSG_COPIED"), "success"); return true end
    end
    if toclipboard then
        local ok = pcall(toclipboard, text)
        if ok then toast(T("MSG_COPIED"), "success"); return true end
    end
    toast(T("MSG_COPY_FAIL"), "warn")
    return false
end
local function saveSettings()
    pcall(function() if GENV then GENV.CrackstroidSettings = Settings end end)
    if Settings.AutoSaveSettings then saveSettingsToFile() end
end
local function saveSettingsToFile()
    if not writefile then toast(T("MSG_NO_WRITEFILE"), "warn"); return false end
    local lines = {}
    for k, v in pairs(Settings) do
        if type(v) == "string" then table.insert(lines, k .. "=" .. v)
        else table.insert(lines, k .. "=" .. tostring(v)) end
    end
    local ok, err = pcall(writefile, "crackstroid.txt", table.concat(lines, "\n"))
    if ok then toast(T("MSG_FILE_SAVED", "crackstroid.txt"), "success"); return true
    else toast("Error: " .. tostring(err), "error"); return false end
end
local function loadSettingsFromFile()
    if not readfile then toast(T("MSG_NO_READFILE"), "warn"); return false end
    local ok, content = pcall(readfile, "crackstroid.txt")
    if not ok or not content then toast(T("MSG_FILE_NOT_FOUND"), "warn"); return false end
    for line in content:gmatch("[^\r\n]+") do
        local key, val = line:match("^([^=]+)=(.+)$")
        if key and val then
            if val == "true" then Settings[key] = true
            elseif val == "false" then Settings[key] = false
            elseif tonumber(val) then Settings[key] = tonumber(val)
            else Settings[key] = val end
        end
    end
    toast(T("MSG_FILE_LOADED", "crackstroid.txt"), "success")
    return true
end

-- ═══════════════ UI HELPERS ═══════════════
local function makeButton(parent, text, onClick, available)
    if available == nil then available = true end
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 32)
    b.BackgroundColor3 = available and THEME.PANEL_HOVER or Color3.fromRGB(35, 38, 48)
    b.TextColor3 = available and THEME.TEXT or THEME.TEXT_DIM
    b.Font = Enum.Font.GothamMedium; b.TextSize = 12
    b.Text = available and text or (text .. " (" .. T("NA") .. ")")
    b.AutoButtonColor = false; b.Active = available; b.Parent = parent
    addCorner(b, 5)
    if available then
        local orig = b.BackgroundColor3
        b.MouseEnter:Connect(function()
            pcall(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ACCENT}):Play() end)
        end)
        b.MouseLeave:Connect(function()
            pcall(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = orig}):Play() end)
        end)
        b.MouseButton1Click:Connect(function()
            local ok, err = pcall(onClick)
            if not ok then warn("[Crackstroid/button] " .. tostring(err)) end
        end)
    end
    return b
end
local function makeToggle(parent, text, initial, onChange, available)
    if available == nil then available = true end
    local state = initial
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 32)
    b.BackgroundColor3 = not available and Color3.fromRGB(35, 38, 48) or (state and THEME.SUCCESS or THEME.PANEL_HOVER)
    b.TextColor3 = available and THEME.TEXT or THEME.TEXT_DIM
    b.Font = Enum.Font.GothamMedium; b.TextSize = 12
    b.Text = text .. " [" .. (state and T("ON") or T("OFF")) .. "]" .. (available and "" or (" (" .. T("NA") .. ")"))
    b.AutoButtonColor = false; b.Active = available; b.Parent = parent
    addCorner(b, 5)
    if available then
        b.MouseButton1Click:Connect(function()
            state = not state
            b.Text = text .. " [" .. (state and T("ON") or T("OFF")) .. "]"
            pcall(function()
                TweenService:Create(b, TweenInfo.new(0.2),
                    {BackgroundColor3 = state and THEME.SUCCESS or THEME.PANEL_HOVER}):Play()
            end)
            local ok, err = pcall(onChange, state)
            if not ok then warn("[Crackstroid/toggle] " .. tostring(err)) end
        end)
    end
    return b
end
local function makeSlider(parent, text, min, max, init, onChange)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 50)
    frame.BackgroundColor3 = THEME.PANEL_HOVER; frame.Parent = parent
    addCorner(frame, 5)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 20); lbl.Position = UDim2.fromOffset(6, 2)
    lbl.BackgroundTransparency = 1; lbl.Text = text .. ": " .. string.format("%.1f", init)
    lbl.TextColor3 = THEME.TEXT; lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 8); track.Position = UDim2.fromOffset(8, 32)
    track.BackgroundColor3 = Color3.fromRGB(50, 55, 70); track.Parent = frame
    addCorner(track, 4)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(math.clamp((init - min) / math.max(max - min, 0.001), 0, 1), 1)
    fill.BackgroundColor3 = THEME.ACCENT; fill.Parent = track; addCorner(fill, 4)
    local dragging = false
    local function setVal(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        local val = min + (max - min) * rel
        val = math.floor(val * 10 + 0.5) / 10
        fill.Size = UDim2.fromScale(rel, 1)
        lbl.Text = text .. ": " .. string.format("%.1f", val)
        local ok, err = pcall(onChange, val)
        if not ok then warn("[Crackstroid/slider] " .. tostring(err)) end
    end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1); btn.BackgroundTransparency = 1
    btn.Text = ""; btn.Parent = frame
    btn.MouseButton1Down:Connect(function() dragging = true; setVal(UserInputService:GetMouseLocation().X) end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then setVal(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    return frame
end
local function makeSection(parent, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -8, 0, 24); f.BackgroundTransparency = 1; f.Parent = parent
    local l = Instance.new("TextLabel")
    l.Size = UDim2.fromScale(1, 1); l.BackgroundTransparency = 1
    l.Text = text:upper(); l.TextColor3 = THEME.ACCENT
    l.Font = Enum.Font.GothamBold; l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    return f
end
local function makeScroll(parent)
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.fromScale(1, 1); s.BackgroundTransparency = 1; s.BorderSizePixel = 0
    s.ScrollBarThickness = 5; s.ScrollBarImageColor3 = THEME.ACCENT
    s.CanvasSize = UDim2.new(); s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    s.Parent = parent
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 5); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Parent = s
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 4); p.PaddingRight = UDim.new(0, 4)
    p.PaddingTop = UDim.new(0, 4); p.PaddingBottom = UDim.new(0, 4); p.Parent = s
    return s
end

-- ═══════════════ UI STATE ═══════════════
local MainFrame = nil
local MobileToggle = nil
local SplashGui = nil
local CurrentTabName = ""
local baseSize = UDim2.fromOffset(760, 560)

local function destroyUI()
    for k, conn in pairs(UIConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
        UIConnections[k] = nil
    end
    if GuiRoot then GuiRoot:Destroy(); GuiRoot = nil end
    MainFrame = nil; MobileToggle = nil; ToastContainer = nil
    SplashGui = nil; CurrentTabName = ""
end
local function openMain()
    if not MainFrame then return end
    MainFrame.Visible = true
    MainFrame.Size = baseSize - UDim2.fromOffset(40, 40)
    MainFrame.BackgroundTransparency = 0.5
    if MobileToggle then MobileToggle.Visible = false end
    pcall(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = baseSize, BackgroundTransparency = 0.02}):Play()
    end)
end
local function closeMain()
    if MobileToggle then MobileToggle.Visible = Settings.ShowMobileButton end
    if not MainFrame then return end
    pcall(function()
        local t = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Size = baseSize - UDim2.fromOffset(40, 40), BackgroundTransparency = 0.5})
        t:Play()
        t.Completed:Once(function() if MainFrame then MainFrame.Visible = false end end)
    end)
end

local function buildSplash()
    if SplashGui then pcall(function() SplashGui:Destroy() end); SplashGui = nil end
    if not GuiRoot then return end
    local splash = Instance.new("Frame")
    splash.Name = "Splash"
    splash.Size = UDim2.fromScale(1, 1)
    splash.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    splash.BackgroundTransparency = 0.4
    splash.BorderSizePixel = 0; splash.ZIndex = 100; splash.Parent = GuiRoot
    SplashGui = splash
    local panel = Instance.new("Frame")
    panel.Size = UDim2.fromOffset(500, 360)
    panel.Position = UDim2.fromScale(0.5, 0.5); panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = THEME.BG; panel.BackgroundTransparency = 0.05
    panel.BorderSizePixel = 0; panel.ZIndex = 101; panel.Parent = splash
    addCorner(panel, 12); addStroke(panel, THEME.ACCENT, 2)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 46); title.Position = UDim2.fromOffset(0, 30)
    title.BackgroundTransparency = 1; title.Text = "⚡ CRACKSTROID"
    title.TextColor3 = THEME.ACCENT; title.Font = Enum.Font.GothamBold
    title.TextSize = 28; title.ZIndex = 102; title.Parent = panel
    local greet = Instance.new("TextLabel")
    greet.Size = UDim2.new(1, -60, 0, 32); greet.Position = UDim2.fromOffset(30, 100)
    greet.BackgroundTransparency = 1
    greet.Text = T("WELCOME_GREET", LocalPlayer.Name)
    greet.TextColor3 = THEME.TEXT; greet.Font = Enum.Font.GothamBold
    greet.TextSize = 22; greet.TextXAlignment = Enum.TextXAlignment.Left
    greet.ZIndex = 102; greet.Parent = panel
    local welcome = Instance.new("TextLabel")
    welcome.Size = UDim2.new(1, -60, 0, 60); welcome.Position = UDim2.fromOffset(30, 140)
    welcome.BackgroundTransparency = 1; welcome.Text = T("WELCOME_MSG")
    welcome.TextColor3 = THEME.TEXT_DIM; welcome.Font = Enum.Font.GothamMedium
    welcome.TextSize = 16; welcome.TextXAlignment = Enum.TextXAlignment.Left
    welcome.TextWrapped = true; welcome.ZIndex = 102; welcome.Parent = panel
    local continueBtn = Instance.new("TextButton")
    continueBtn.Size = UDim2.fromOffset(240, 44)
    continueBtn.Position = UDim2.new(0.5, 0, 0, 220); continueBtn.AnchorPoint = Vector2.new(0.5, 0)
    continueBtn.BackgroundColor3 = THEME.ACCENT; continueBtn.TextColor3 = Color3.new(1, 1, 1)
    continueBtn.Font = Enum.Font.GothamBold; continueBtn.TextSize = 16
    continueBtn.Text = T("WELCOME_CONTINUE"); continueBtn.AutoButtonColor = false
    continueBtn.ZIndex = 102; continueBtn.Parent = panel; addCorner(continueBtn, 8)
    local noShow = Instance.new("TextButton")
    noShow.Size = UDim2.fromOffset(260, 24)
    noShow.Position = UDim2.new(0.5, 0, 0, 276); noShow.AnchorPoint = Vector2.new(0.5, 0)
    noShow.BackgroundTransparency = 1; noShow.TextColor3 = THEME.TEXT_DIM
    noShow.Font = Enum.Font.Gotham; noShow.TextSize = 12
    noShow.Text = (Settings.ShowWelcomeScreen and "☑" or "☐") .. " " .. T("WELCOME_DONT_SHOW")
    noShow.ZIndex = 102; noShow.Parent = panel
    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(1, 0, 0, 20); ver.Position = UDim2.new(0, 0, 1, -28)
    ver.BackgroundTransparency = 1
    ver.Text = T("WELCOME_VERSION", VERSION) .. "  ·  " .. EXECUTOR
    ver.TextColor3 = THEME.TEXT_DIM; ver.Font = Enum.Font.Gotham
    ver.TextSize = 11; ver.ZIndex = 102; ver.Parent = panel
    continueBtn.MouseEnter:Connect(function()
        pcall(function() TweenService:Create(continueBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ACCENT_DARK}):Play() end)
    end)
    continueBtn.MouseLeave:Connect(function()
        pcall(function() TweenService:Create(continueBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ACCENT}):Play() end)
    end)
    local willShowAgain = Settings.ShowWelcomeScreen
    noShow.MouseButton1Click:Connect(function()
        willShowAgain = not willShowAgain
        noShow.Text = (willShowAgain and "☑" or "☐") .. " " .. T("WELCOME_DONT_SHOW")
    end)
    local function closeSplash()
        if SplashGui then
            pcall(function() SplashGui:Destroy() end)
            SplashGui = nil
        end
        Settings.ShowWelcomeScreen = willShowAgain
        pcall(saveSettings)
        pcall(openMain)
    end
    continueBtn.MouseButton1Click:Connect(closeSplash)
    splash.InputBegan:Connect(function(input, _)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            -- Клик по фону splash — тоже закрывает
        end
    end)
end

-- ═══════════════ BUILD UI ═══════════════
local function buildUI()
    local playerGui = nil
    pcall(function()
        playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then playerGui = LocalPlayer:WaitForChild("PlayerGui") end
    end)
    if not playerGui then
        warn("[Crackstroid] PlayerGui missing — cannot build UI")
        return false
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "CrackstroidGui"
    gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui
    GuiRoot = gui

    local mobile = false
    pcall(function() mobile = isMobile() end)
    baseSize = mobile and UDim2.fromScale(0.95, 0.85) or UDim2.fromOffset(760, 560)

    local main = Instance.new("Frame")
    main.Name = "Main"; main.Size = baseSize
    main.Position = UDim2.fromScale(0.5, 0.5); main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = THEME.BG; main.BackgroundTransparency = 0.02
    main.BorderSizePixel = 0; main.Visible = false; main.Active = true; main.Parent = gui
    MainFrame = main; addCorner(main, 10); addStroke(main, THEME.STROKE, 1.5)
    if not mobile then main.Draggable = true end
    local uiScale = Instance.new("UIScale"); uiScale.Scale = Settings.UIScale; uiScale.Parent = main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 44); header.BackgroundColor3 = THEME.PANEL
    header.BorderSizePixel = 0; header.Parent = main
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 10); hc.Parent = header
    local cover = Instance.new("Frame")
    cover.Size = UDim2.new(1, 0, 0, 10); cover.Position = UDim2.new(0, 0, 1, -10)
    cover.BackgroundColor3 = THEME.PANEL; cover.BorderSizePixel = 0; cover.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -120, 1, 0); title.Position = UDim2.fromOffset(16, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ CRACKSTROID v" .. VERSION
    title.TextColor3 = THEME.ACCENT; title.Font = Enum.Font.GothamBold
    title.TextSize = 14; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = header
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(32, 32); closeBtn.Position = UDim2.new(1, -42, 0, 6)
    closeBtn.BackgroundColor3 = THEME.DANGER; closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1); closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16; closeBtn.Parent = header; addCorner(closeBtn, 6)

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -16, 0, 34); tabBar.Position = UDim2.fromOffset(8, 50)
    tabBar.BackgroundColor3 = THEME.PANEL_HOVER; tabBar.BorderSizePixel = 0; tabBar.Parent = main
    addCorner(tabBar, 6)
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size = UDim2.new(1, -8, 1, 0); tabScroll.Position = UDim2.fromOffset(4, 0)
    tabScroll.BackgroundTransparency = 1; tabScroll.BorderSizePixel = 0
    tabScroll.ScrollBarThickness = 0
    tabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    tabScroll.CanvasSize = UDim2.new()
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabScroll.Parent = tabBar
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal; tl.Padding = UDim.new(0, 3)
    tl.VerticalAlignment = Enum.VerticalAlignment.Center; tl.Parent = tabScroll

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -16, 1, -140); content.Position = UDim2.fromOffset(8, 90)
    content.BackgroundColor3 = THEME.PANEL; content.BorderSizePixel = 0; content.Parent = main
    addCorner(content, 8)

    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, -16, 0, 22); footer.Position = UDim2.new(0, 8, 1, -28)
    footer.BackgroundTransparency = 1; footer.Parent = main
    local footText = Instance.new("TextLabel")
    footText.Size = UDim2.fromScale(1, 1); footText.BackgroundTransparency = 1
    footText.Text = "Crackstroid v" .. VERSION .. "  ·  " .. EXECUTOR .. "  ·  RShift | Sprint: " .. (SprintingMod and "native" or (FallbackSprint.Active and "fallback" or "none"))
    footText.TextColor3 = THEME.TEXT_DIM; footText.Font = Enum.Font.Gotham
    footText.TextSize = 10; footText.Parent = footer

    local Tabs = {}
    local TabButtons = {}
    local function switchTab(name)
        if CurrentTabName == name then return end
        for n, f in pairs(Tabs) do
            pcall(function() f.Visible = (n == name) end)
        end
        for n, b in pairs(TabButtons) do
            local on = (n == name)
            pcall(function()
                TweenService:Create(b, TweenInfo.new(0.15), {
                    BackgroundColor3 = on and THEME.ACCENT or THEME.TAB_IDLE,
                    TextColor3 = on and Color3.new(1, 1, 1) or THEME.TEXT_DIM,
                }):Play()
            end)
        end
        CurrentTabName = name
    end
    local function addTab(key, icon, displayName)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(mobile and 72 or 92, 28)
        btn.BackgroundColor3 = THEME.TAB_IDLE; btn.TextColor3 = THEME.TEXT_DIM
        btn.Font = Enum.Font.GothamMedium; btn.TextSize = 10
        btn.Text = icon .. " " .. displayName; btn.AutoButtonColor = false
        btn.Parent = tabScroll; addCorner(btn, 5)
        btn.MouseButton1Click:Connect(function() pcall(switchTab, key) end)
        TabButtons[key] = btn
        local frame = Instance.new("Frame")
        frame.Size = UDim2.fromScale(1, 1); frame.BackgroundTransparency = 1
        frame.Visible = false; frame.Parent = content
        Tabs[key] = frame
        if CurrentTabName == "" then switchTab(key) end
        return makeScroll(frame)
    end

    -- ═══ ЧИТЫ ═══
    do
        local s = addTab("cheats", "💀", T("TAB_CHEATS"))
        makeSection(s, T("SEC_EXTRA"))
        makeToggle(s, T("BTN_ANTI_AFK"), State.AntiAFK, toggleAntiAFK)
        makeButton(s, "💬 " .. T("BTN_SPAM_CHAT") .. " (10x)", function() spamChat("Crackstroid v" .. VERSION, 10, 0.1) end, Network ~= nil)
        makeButton(s, "🏆 " .. T("BTN_UNLOCK_ACH"), unlockAllAchievements)
        makeButton(s, "🧩 " .. T("BTN_AUTO_PUZZLE"), autoPuzzle)
        makeToggle(s, T("BTN_KILLAURA"), State.Killaura, toggleKillaura, Network ~= nil)
        makeSection(s, T("SEC_GRAVITY"))
        makeSlider(s, T("SEC_GRAVITY"), 0, 500, workspace.Gravity, setGravity)
        makeButton(s, "🌍 Gravity = 196.2 (default)", function() setGravity(196.2) end)
        makeSection(s, "Байпасы")
        makeButton(s, "Проверить require", function()
            local test = safeRequire(fastFind(Modules, "Network"))
            toast("require: " .. (test and "OK" or "FAIL"), test and "success" or "error")
        end)
        makeButton(s, "Принудительно включить fallback-спринт", function()
            if setupFallbackSprint() then
                toast(T("MSG_FALLBACK_ON"), "success")
            else
                toast("Не удалось (нет персонажа/SpeedMultipliers)", "warn")
            end
        end)
        makeButton(s, "Перезагрузить модули", function()
            pcall(loadAllModules)
            toast(T("MSG_MODULES_RELOAD"), "success")
            if not SprintingMod then pcall(setupFallbackSprint) end
            destroyUI(); pcall(buildUI); pcall(openMain)
        end)
    end

    -- ═══ ИГРОК ═══
    do
        local s = addTab("player", "👤", T("TAB_PLAYER"))
        makeSection(s, T("SEC_HEALTH"))
        makeToggle(s, T("BTN_GOD"), State.GodMode, setGodMode)
        makeToggle(s, T("BTN_STAM"), State.InfStamina, setInfStamina, true)
        makeToggle(s, T("BTN_NOCLIP"), State.NoClip, setNoClip)
        makeToggle(s, T("BTN_AUTOJUMP"), State.AutoJump, setAutoJump)
        makeToggle(s, T("BTN_FLY"), State.Fly, setFly)
        makeSection(s, T("SEC_SPEED"))
        makeSlider(s, T("BTN_SPEED"), 0.5, 5, State.Speed, setSpeed)
        makeSlider(s, T("BTN_JUMP"), 25, 250, State.Jump, setJump)
        makeSection(s, T("SEC_SPRINT"))
        local sprintStatus = (SprintingMod and "native") or (FallbackSprint.Active and "fallback") or "none"
        local statusLbl = Instance.new("TextLabel")
        statusLbl.Size = UDim2.new(1, -8, 0, 24); statusLbl.BackgroundTransparency = 1
        statusLbl.Text = "  Sprint: " .. sprintStatus
        statusLbl.TextColor3 = SprintingMod and THEME.SUCCESS or (FallbackSprint.Active and THEME.WARN or THEME.DANGER)
        statusLbl.Font = Enum.Font.GothamBold; statusLbl.TextSize = 11
        statusLbl.TextXAlignment = Enum.TextXAlignment.Left; statusLbl.Parent = s
        makeButton(s, T("BTN_SPRINT"), function()
            if SprintingMod then
                pcall(function()
                    SprintingMod.IsSprinting = not SprintingMod.IsSprinting
                    if SprintingMod.__sprintedEvent then SprintingMod.__sprintedEvent:Fire(SprintingMod.IsSprinting) end
                end)
            elseif FallbackSprint.Active then
                FallbackSprint.KeyHeld = not FallbackSprint.KeyHeld
            else
                pcall(setupFallbackSprint)
            end
        end)
        makeButton(s, "🔄 Пересоздать fallback-спринт", function()
            if setupFallbackSprint() then
                toast(T("MSG_FALLBACK_ON"), "success")
            else
                toast("Не удалось", "warn")
            end
        end)
        makeSection(s, T("SEC_ACTIONS"))
        makeButton(s, T("BTN_RESPAWN"), function() pcall(function() LocalPlayer:LoadCharacter() end) end)
        makeButton(s, T("BTN_INSTANT_RESPAWN"), instantRespawn)
        makeButton(s, T("BTN_KILL_SELF"), killSelf)
        makeButton(s, T("BTN_REJOIN"), rejoin)
        makeSection(s, T("SEC_DEVICE"))
        makeButton(s, T("BTN_SET_PC"), function()
            if Network then Network:FireServerConnection("SetDevice", "REMOTE_EVENT", "PC") end
        end, Network ~= nil)
        makeButton(s, T("BTN_SET_MOB"), function()
            if Network then Network:FireServerConnection("SetDevice", "REMOTE_EVENT", "Mobile") end
        end, Network ~= nil)
        makeButton(s, T("BTN_SET_CON"), function()
            if Network then Network:FireServerConnection("SetDevice", "REMOTE_EVENT", "Console") end
        end, Network ~= nil)
        makeSection(s, T("SEC_CAM"))
        makeToggle(s, T("BTN_FREEZE_CAM"), State.FreezeCamera, setFreezeCamera)
        makeToggle(s, T("BTN_FIRST_PERSON"), State.FirstPerson, setFirstPerson)
    end

    do
        local s = addTab("graphics", "🎨", T("TAB_GRAPHICS"))
        makeSection(s, T("SEC_LIGHT"))
        makeButton(s, "☀ Day", function() applyLightingPreset("day") end)
        makeButton(s, "🌙 Night", function() applyLightingPreset("night") end)
        makeButton(s, "💜 Neon", function() applyLightingPreset("neon") end)
        makeButton(s, "🩸 Horror", function() applyLightingPreset("horror") end)
        makeButton(s, "🎬 Cinematic", function() applyLightingPreset("cinematic") end)
        makeButton(s, "🌫 Foggy", function() applyLightingPreset("foggy") end)
        makeButton(s, "🕺 Disco", function() applyLightingPreset("disco") end)
        makeButton(s, "↺ Default", function() applyLightingPreset("default") end)
        makeSection(s, T("SEC_OVERLAY"))
        makeToggle(s, T("BTN_FULLBRIGHT"), State.Fullbright, setFullbright)
        makeButton(s, T("BTN_REMOVE_FX"), function() removePostFX(); stopLightingAnim() end)
        makeSection(s, T("SEC_ATMO"))
        makeButton(s, T("BTN_ADD_ATMO"), addAtmosphere)
    end

    do
        local s = addTab("esp", "🎯", T("TAB_ESP"))
        makeSection(s, T("SEC_ESP_PLAYERS"))
        makeToggle(s, "ESP Survivors", State.ESPPlayers, function(v) State.ESPPlayers = v end)
        makeToggle(s, "ESP Killers", State.ESPKillers, function(v) State.ESPKillers = v end)
        makeSection(s, T("SEC_ESP_WORLD"))
        makeToggle(s, "ESP Items", State.ESPItems, function(v) State.ESPItems = v end)
        makeToggle(s, "ESP Generators", State.ESPGenerators, function(v) State.ESPGenerators = v end)
        makeSection(s, T("SEC_ESP_DIST"))
        makeSlider(s, T("SEC_ESP_DIST"), 50, 2000, Settings.ESPDistance, setESPDistance)
        makeSection(s, T("SEC_ESP_STYLE"))
        makeButton(s, "Highlight", function() Settings.ESPStyle = "highlight"; clearESP() end)
        makeButton(s, "Billboard", function() Settings.ESPStyle = "billboard"; clearESP() end)
        makeButton(s, "Both", function() Settings.ESPStyle = "both"; clearESP() end)
        makeButton(s, "❌ Clear ESP", clearESP)
        makeToggle(s, T("BTN_SHOW_NAMES"), State.ShowAllNames, setShowAllNames)
    end

    do
        local s = addTab("teleports", "📡", T("TAB_TELEPORTS"))
        makeSection(s, T("SEC_TP_TO_PLAYER"))
        local searchFrame = Instance.new("Frame")
        searchFrame.Size = UDim2.new(1, -8, 0, 34)
        searchFrame.BackgroundColor3 = THEME.PANEL_HOVER
        searchFrame.Parent = s; addCorner(searchFrame, 5)
        local searchBox = Instance.new("TextBox")
        searchBox.Size = UDim2.new(1, -16, 1, -4); searchBox.Position = UDim2.fromOffset(8, 2)
        searchBox.BackgroundTransparency = 1
        searchBox.PlaceholderText = T("PH_PLAYER_SEARCH")
        searchBox.Text = ""; searchBox.TextColor3 = THEME.TEXT
        searchBox.PlaceholderColor3 = THEME.TEXT_DIM
        searchBox.Font = Enum.Font.Gotham; searchBox.TextSize = 12
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.ClearTextOnFocus = false; searchBox.Parent = searchFrame
        local matchesFrame = Instance.new("Frame")
        matchesFrame.Size = UDim2.new(1, 0, 0, 0)
        matchesFrame.BackgroundTransparency = 1
        matchesFrame.AutomaticSize = Enum.AutomaticSize.Y
        matchesFrame.Parent = s
        local mfl = Instance.new("UIListLayout")
        mfl.Padding = UDim.new(0, 4); mfl.Parent = matchesFrame
        local function rebuildMatches()
            for _, c in ipairs(matchesFrame:GetChildren()) do
                if c:IsA("GuiObject") then c:Destroy() end
            end
            local query = searchBox.Text:lower()
            if query == "" then
                local hint = Instance.new("TextLabel")
                hint.Size = UDim2.new(1, -8, 0, 24); hint.BackgroundTransparency = 1
                hint.Text = "  " .. T("TP_TYPE_TO_SEARCH")
                hint.TextColor3 = THEME.TEXT_DIM; hint.Font = Enum.Font.Gotham
                hint.TextSize = 10; hint.TextXAlignment = Enum.TextXAlignment.Left
                hint.Parent = matchesFrame
                return
            end
            local shown = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                if plr.Name:lower():find(query, 1, true) or (plr.DisplayName or ""):lower():find(query, 1, true) then
                    shown = shown + 1
                    local team = getPlayerTeam(plr)
                    local teamColor = Color3.fromRGB(150, 150, 150)
                    if team == "Survivors" then teamColor = Color3.fromRGB(80, 200, 100)
                    elseif team == "Killers" then teamColor = Color3.fromRGB(220, 60, 60) end
                    local btn = makeButton(matchesFrame, "🎯 " .. plr.Name .. "  (" .. team .. ")", function()
                        tpToPlayerByName(plr.Name)
                    end)
                    btn.TextColor3 = teamColor
                end
            end
            if shown == 0 then
                local hint = Instance.new("TextLabel")
                hint.Size = UDim2.new(1, -8, 0, 24); hint.BackgroundTransparency = 1
                hint.Text = "  " .. T("TP_NO_MATCHES")
                hint.TextColor3 = THEME.WARN; hint.Font = Enum.Font.Gotham
                hint.TextSize = 10; hint.TextXAlignment = Enum.TextXAlignment.Left
                hint.Parent = matchesFrame
            end
        end
        searchBox:GetPropertyChangedSignal("Text"):Connect(function() task.defer(rebuildMatches) end)
        rebuildMatches()
        makeSection(s, T("SEC_TP_TO_SPAWN"))
        makeButton(s, T("BTN_TP_KILLERS"), function() tpToSpawn("Killers") end)
        makeButton(s, T("BTN_TP_SURVIVORS"), function() tpToSpawn("Survivors") end)
        makeButton(s, T("BTN_TP_LOBBY"), function() tpToSpawn("Lobby") end)
        makeSection(s, T("SEC_OTHER"))
        makeButton(s, T("BTN_TP_RANDOM"), function() tpToRandomFromTeam("Survivors") end)
        makeButton(s, "TP → Random Killer", function() tpToRandomFromTeam("Killers") end)
        makeButton(s, T("BTN_TP_REFRESH"), function() destroyUI(); pcall(buildUI); pcall(openMain) end)
    end

    do
        local s = addTab("chars", "🎭", T("TAB_CHARS"))
        makeSection(s, T("SEC_PLAY_AS"))
        makeButton(s, "🛒 " .. T("BTN_OPEN_SHOP_K"), function() openShopTab("Killers") end, Initializer ~= nil)
        makeButton(s, "🛒 " .. T("BTN_OPEN_SHOP_S"), function() openShopTab("Survivors") end, Initializer ~= nil)
        makeButton(s, "🎲 " .. T("BTN_EQUIP_RANDOM"), equipRandom, Network ~= nil)
        makeButton(s, "ℹ " .. T("BTN_ACTOR_INFO"), showActorInfo, Actors ~= nil)
        makeSection(s, T("SEC_KILLERS"))
        local killAssets = Assets and Assets:FindFirstChild("Killers")
        if killAssets then
            for _, char in ipairs(killAssets:GetChildren()) do
                if char:IsA("Folder") then
                    local owned = isOwned("Killers", char.Name)
                    local tag = owned and " ✔" or " 🔒"
                    makeButton(s, "💀 " .. char.Name .. tag, function()
                        if isOwned("Killers", char.Name) then equipCharacter("Killers", char.Name)
                        else toast(T("MSG_NOT_OWNED"), "warn"); openShopTab("Killers") end
                    end, Network ~= nil)
                end
            end
        end
        makeSection(s, T("SEC_SURVIVORS"))
        local survAssets = Assets and Assets:FindFirstChild("Survivors")
        if survAssets then
            for _, char in ipairs(survAssets:GetChildren()) do
                if char:IsA("Folder") then
                    local owned = isOwned("Survivors", char.Name)
                    local tag = owned and " ✔" or " 🔒"
                    makeButton(s, "🏃 " .. char.Name .. tag, function()
                        if isOwned("Survivors", char.Name) then equipCharacter("Survivors", char.Name)
                        else toast(T("MSG_NOT_OWNED"), "warn"); openShopTab("Survivors") end
                    end, Network ~= nil)
                end
            end
        end
    end

    do
        local s = addTab("abilities", "⚔", T("TAB_ABILITIES"))
        makeSection(s, T("SEC_FORCE"))
        local abilities = listAbilities()
        if #abilities == 0 then
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -16, 0, 44); l.BackgroundTransparency = 1
            l.Text = T("MSG_NO_ACTOR"); l.TextWrapped = true
            l.TextColor3 = THEME.WARN; l.Font = Enum.Font.Gotham; l.TextSize = 12; l.Parent = s
        else
            for _, name in ipairs(abilities) do
                makeButton(s, "▶ " .. name, function() fireAbility(name) end, Network ~= nil)
            end
        end
        makeButton(s, "🔄 " .. T("BTN_REFRESH_AB"), function() destroyUI(); pcall(buildUI); pcall(openMain) end)
    end

    do
        local s = addTab("emotes", "😀", T("TAB_EMOTES"))
        makeSection(s, T("SEC_ACTIONS"))
        makeButton(s, "⏹ " .. T("BTN_STOP_EMOTE"), stopEmote, Network ~= nil)
        makeButton(s, "💬 " .. T("BTN_EMOTE_MENU"), openEmoteMenu, EmoteMod ~= nil)
        makeButton(s, "🔄 " .. T("BTN_RESCAN"), function()
            pcall(scanEmotes)
            toast(T("BTN_RESCAN") .. ": " .. #EmoteCache.Shared, "success")
            destroyUI(); pcall(buildUI); pcall(openMain)
        end)
        makeSection(s, "Авто")
        makeToggle(s, T("BTN_AUTO_RANDOM"), State.AutoRandomEmote, setAutoRandomEmote, Network ~= nil)
        local firstEmote = EmoteCache.Shared[1] and EmoteCache.Shared[1].Name
        makeButton(s, "▶ " .. T("BTN_AUTO_EMOTE"), function()
            if firstEmote then autoEmoteSpam(firstEmote, 10) end
        end, Network ~= nil and firstEmote ~= nil)
        local searchFrame = Instance.new("Frame")
        searchFrame.Size = UDim2.new(1, -8, 0, 34); searchFrame.BackgroundColor3 = THEME.PANEL_HOVER
        searchFrame.Parent = s; addCorner(searchFrame, 5)
        local searchBox = Instance.new("TextBox")
        searchBox.Size = UDim2.new(1, -16, 1, -4); searchBox.Position = UDim2.fromOffset(8, 2)
        searchBox.BackgroundTransparency = 1; searchBox.PlaceholderText = T("PH_EMOTE_SEARCH")
        searchBox.Text = ""; searchBox.TextColor3 = THEME.TEXT
        searchBox.PlaceholderColor3 = THEME.TEXT_DIM
        searchBox.Font = Enum.Font.Gotham; searchBox.TextSize = 12
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.ClearTextOnFocus = false; searchBox.Parent = searchFrame
        local emoteListFrame = Instance.new("Frame")
        emoteListFrame.Size = UDim2.new(1, 0, 0, 0)
        emoteListFrame.BackgroundTransparency = 1
        emoteListFrame.AutomaticSize = Enum.AutomaticSize.Y
        emoteListFrame.Parent = s
        local el = Instance.new("UIListLayout"); el.Padding = UDim.new(0, 4); el.Parent = emoteListFrame
        local function rebuild()
            for _, c in ipairs(emoteListFrame:GetChildren()) do
                if c:IsA("GuiObject") then c:Destroy() end
            end
            local query = searchBox.Text:lower()
            local function matches(e)
                if query == "" then return true end
                if e.Name:lower():find(query, 1, true) then return true end
                return (e.DisplayName or ""):lower():find(query, 1, true) ~= nil
            end
            if #EmoteCache.Shared > 0 then
                local h = Instance.new("TextLabel")
                h.Size = UDim2.new(1, -8, 0, 20); h.BackgroundTransparency = 1
                h.Text = T("SEC_SHARED") .. " (" .. #EmoteCache.Shared .. ")"
                h.TextColor3 = THEME.ACCENT; h.Font = Enum.Font.GothamBold
                h.TextSize = 11; h.TextXAlignment = Enum.TextXAlignment.Left; h.Parent = emoteListFrame
                for _, e in ipairs(EmoteCache.Shared) do
                    if matches(e) then
                        local tag = e.Exclusive and " ⭐" or ""
                        local pt = e.Price > 0 and (" [" .. e.Price .. "$]") or ""
                        makeButton(emoteListFrame, "▶ " .. e.DisplayName .. pt .. tag, function()
                            playEmote("Animations", e.Name)
                        end, Network ~= nil)
                    end
                end
            end
            if #EmoteCache.Actor > 0 then
                local h = Instance.new("TextLabel")
                h.Size = UDim2.new(1, -8, 0, 20); h.BackgroundTransparency = 1
                h.Text = T("SEC_ACTOR") .. " (" .. #EmoteCache.Actor .. ")"
                h.TextColor3 = THEME.ACCENT; h.Font = Enum.Font.GothamBold
                h.TextSize = 11; h.TextXAlignment = Enum.TextXAlignment.Left; h.Parent = emoteListFrame
                for _, e in ipairs(EmoteCache.Actor) do
                    if matches(e) then
                        makeButton(emoteListFrame, "★ " .. e.DisplayName .. " [" .. e.Type .. "]", function()
                            playEmote(e.Type, e.Name)
                        end, Network ~= nil)
                    end
                end
            end
        end
        searchBox:GetPropertyChangedSignal("Text"):Connect(function() task.defer(rebuild) end)
        pcall(scanEmotes); rebuild()
    end

    do
        local s = addTab("puzzles", "🧩", T("TAB_PUZZLES"))
        makeSection(s, T("SEC_BLUE"))
        for _, n in ipairs({4, 5, 6, 7, 8}) do
            makeButton(s, "Blue " .. n .. "×" .. n, function() openPuzzle("Blue", n) end, BluePuzzle ~= nil)
        end
        makeSection(s, T("SEC_FLOW"))
        for _, n in ipairs({4, 5, 6, 7, 8}) do
            makeButton(s, "Flow " .. n .. "×" .. n, function() openPuzzle("Flow", n) end, FlowGame ~= nil)
        end
        makeButton(s, "❌ " .. T("BTN_CLOSE_PUZZLE"), closePuzzle, (BluePuzzle ~= nil or FlowGame ~= nil))
    end

    do
        local s = addTab("menus", "📋", T("TAB_MENUS"))
        makeSection(s, T("SEC_SIDEBAR"))
        for _, m in ipairs({"Shop", "Settings", "Inventory", "Achievements", "Stats", "Codes", "Quests", "UpdateLog", "Rules", "PassBuyer"}) do
            makeButton(s, "📂 " .. m, function() openMenuByName(m) end, Initializer ~= nil)
        end
        makeButton(s, "❌ " .. T("BTN_CLOSE_MENUS"), closeAllMenus, Initializer ~= nil)
        makeSection(s, T("SEC_OTHER"))
        makeButton(s, "💬 " .. T("BTN_EMOTE_MENU"), openEmoteMenu, EmoteMod ~= nil)
        makeButton(s, "👥 " .. T("BTN_PLAYER_LIST"), togglePlayerList, Initializer ~= nil)
    end

    do
        local s = addTab("world", "🌍", T("TAB_WORLD"))
        makeSection(s, T("SEC_AURAS"))
        makeButton(s, "👁 " .. T("BTN_REVEAL_SURV"), function() revealAuras("Survivors") end, Util ~= nil)
        makeButton(s, "👁 " .. T("BTN_REVEAL_KILL"), function() revealAuras("Killers") end, Util ~= nil)
        makeButton(s, "❌ " .. T("BTN_CLEAR_AURAS"), clearAuras, Util ~= nil)
        makeSection(s, T("SEC_HEART"))
        makeButton(s, "💓 " .. T("BTN_HB_ON"), function()
            if HeartbeatSys then pcall(function() HeartbeatSys:EnableHearbeat() end) end
        end, HeartbeatSys ~= nil)
        makeButton(s, "💔 " .. T("BTN_HB_OFF"), function()
            if HeartbeatSys then pcall(function() HeartbeatSys:DisableHeartbeat() end) end
        end, HeartbeatSys ~= nil)
        makeSection(s, T("SEC_CHASE"))
        makeButton(s, "🎵 " .. T("BTN_FORCE_CHASE"), function()
            if ChaseSys and type(ChaseSys.Start) == "function" then
                pcall(function() ChaseSys.Start(ChaseSys) end)
            end
        end, ChaseSys ~= nil)
        makeSection(s, T("SEC_SOUNDS"))
        makeButton(s, "▶ notification", function() if Sounds then pcall(function() Sounds:Play("notification") end) end end, Sounds ~= nil)
        makeButton(s, "▶ hover", function() if Sounds then pcall(function() Sounds:Play("hover") end) end end, Sounds ~= nil)
        makeButton(s, "▶ select", function() if Sounds then pcall(function() Sounds:Play("select") end) end end, Sounds ~= nil)
    end

    do
        local s = addTab("tools", "🛠", T("TAB_TOOLS"))
        makeSection(s, T("SEC_FREECAM"))
        makeToggle(s, T("BTN_FREECAM"), State.Freecam, setFreecam)
        makeSection(s, T("SEC_OVERLAY_UI"))
        makeButton(s, "📊 " .. T("BTN_SHOW_PING"), togglePingFPS)
        makeButton(s, "📍 " .. T("BTN_SHOW_COORDS"), toggleCoords)
        makeButton(s, "👥 " .. T("BTN_SHOW_PLIST"), togglePlayerListPanel)
        makeButton(s, "ℹ " .. T("BTN_SHOW_SERVER"), toggleServerInfo)
    end

    do
        local s = addTab("export", "📤", T("TAB_EXPORT"))
        makeSection(s, T("SEC_DUMP"))
        local hint = Instance.new("TextLabel")
        hint.Size = UDim2.new(1, -8, 0, 30); hint.BackgroundTransparency = 1
        hint.Text = T("DUMP_HINT"); hint.TextWrapped = true
        hint.TextColor3 = THEME.TEXT_DIM; hint.Font = Enum.Font.Gotham
        hint.TextSize = 10; hint.TextXAlignment = Enum.TextXAlignment.Left; hint.Parent = s
        local dumpBox = Instance.new("TextBox")
        dumpBox.Size = UDim2.new(1, -8, 0, 180)
        dumpBox.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
        dumpBox.TextColor3 = THEME.TEXT; dumpBox.Font = Enum.Font.Code
        dumpBox.TextSize = 10; dumpBox.TextXAlignment = Enum.TextXAlignment.Left
        dumpBox.TextYAlignment = Enum.TextYAlignment.Top
        dumpBox.TextWrapped = false; dumpBox.MultiLine = true
        dumpBox.ClearTextOnFocus = false; dumpBox.Parent = s; addCorner(dumpBox, 5)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 36); row.BackgroundTransparency = 1; row.Parent = s
        local cpBtn = Instance.new("TextButton")
        cpBtn.Size = UDim2.new(0.5, -3, 1, 0); cpBtn.BackgroundColor3 = THEME.SUCCESS
        cpBtn.TextColor3 = Color3.new(1, 1, 1); cpBtn.Font = Enum.Font.GothamBold
        cpBtn.TextSize = 11; cpBtn.Text = "📋 " .. T("BTN_COPY")
        cpBtn.Parent = row; addCorner(cpBtn, 5)
        cpBtn.MouseButton1Click:Connect(function() copyToClipboard(dumpBox.Text) end)
        local clrBtn = Instance.new("TextButton")
        clrBtn.Size = UDim2.new(0.5, -3, 1, 0); clrBtn.Position = UDim2.new(0.5, 3, 0, 0)
        clrBtn.BackgroundColor3 = THEME.DANGER; clrBtn.TextColor3 = Color3.new(1, 1, 1)
        clrBtn.Font = Enum.Font.GothamBold; clrBtn.TextSize = 11
        clrBtn.Text = "🗑 " .. T("BTN_CLEAR"); clrBtn.Parent = row; addCorner(clrBtn, 5)
        clrBtn.MouseButton1Click:Connect(function() dumpBox.Text = "" end)
        makeButton(s, "⚙ " .. T("BTN_DUMP_SETTINGS"), function()
            dumpBox.Text = buildSettingsDump(); toast(T("MSG_DUMP_CREATED"), "success")
        end)
        makeButton(s, "📊 " .. T("BTN_DUMP_STATE"), function()
            dumpBox.Text = buildStateDump(); toast(T("MSG_DUMP_CREATED"), "success")
        end)
        makeButton(s, "📦 " .. T("BTN_DUMP_FULL"), function()
            dumpBox.Text = buildFullDump(); toast(T("MSG_DUMP_CREATED"), "success")
        end)
        makeSection(s, T("SEC_FILEIO"))
        local hasWrite = writefile ~= nil
        local hasRead = readfile ~= nil
        makeButton(s, "💾 " .. T("BTN_SAVE_FILE"), function()
            if not hasWrite then toast(T("MSG_NO_WRITEFILE"), "warn"); return end
            local text = dumpBox.Text
            if text == "" then text = buildFullDump() end
            local ok, err = pcall(writefile, "crackstroid_dump.lua", text)
            if ok then toast(T("MSG_FILE_SAVED", "crackstroid_dump.lua"), "success")
            else toast("Error: " .. tostring(err), "error") end
        end, hasWrite)
        makeButton(s, "📂 " .. T("BTN_LOAD_FILE"), function()
            if not hasRead then toast(T("MSG_NO_READFILE"), "warn"); return end
            local ok, content = pcall(readfile, "crackstroid_dump.lua")
            if ok and content then
                dumpBox.Text = content
                toast(T("MSG_FILE_LOADED", "crackstroid_dump.lua"), "success")
            else
                toast(T("MSG_FILE_NOT_FOUND"), "warn")
            end
        end, hasRead)
    end

    do
        local s = addTab("settings", "⚙", T("TAB_SETTINGS"))
        makeSection(s, T("SEC_LANG"))
        makeButton(s, "🇷🇺 " .. T("BTN_LANG_RU"), function()
            Settings.Language = "ru"; pcall(saveSettings); toast(T("MSG_LANG"), "success")
            destroyUI(); pcall(buildUI); pcall(openMain)
        end)
        makeButton(s, "🇬🇧 " .. T("BTN_LANG_EN"), function()
            Settings.Language = "en"; pcall(saveSettings); toast(T("MSG_LANG"), "success")
            destroyUI(); pcall(buildUI); pcall(openMain)
        end)
        makeSection(s, T("SEC_THEME"))
        makeButton(s, "🌙 " .. T("BTN_THEME_DARK"), function()
            Settings.Theme = "dark"; refreshTheme(); pcall(saveSettings)
            destroyUI(); pcall(buildUI); pcall(openMain)
        end)
        makeButton(s, "☀ " .. T("BTN_THEME_LIGHT"), function()
            Settings.Theme = "light"; refreshTheme(); pcall(saveSettings)
            destroyUI(); pcall(buildUI); pcall(openMain)
        end)
        makeSection(s, T("SEC_SCALE"))
        makeSlider(s, T("SEC_SCALE"), 0.7, 1.6, Settings.UIScale, function(v)
            Settings.UIScale = v; pcall(saveSettings)
            if MainFrame then
                local sc = MainFrame:FindFirstChildOfClass("UIScale")
                if sc then sc.Scale = v end
            end
        end)
        makeSection(s, T("SEC_WELCOME"))
        makeToggle(s, "Показывать приветствие", Settings.ShowWelcomeScreen, function(v)
            Settings.ShowWelcomeScreen = v; pcall(saveSettings)
            toast(v and T("MSG_WELCOME_SHOWN") or T("MSG_WELCOME_HIDDEN"), "success")
        end)
        makeButton(s, "🎬 " .. T("BTN_WELCOME_SHOW_NOW"), function()
            closeMain(); task.delay(0.3, function() pcall(buildSplash) end)
        end)
        makeSection(s, T("SEC_STREAMER"))
        makeToggle(s, T("BTN_STREAMER"), Settings.StreamerMode, function(v)
            Settings.StreamerMode = v; pcall(saveSettings)
            if not v then
                local hud = getPlayerHUDModule()
                if hud and hud.UI then
                    local cs = hud.UI:FindFirstChild("CurrentSurvivors")
                    if cs then cs.Visible = true end
                end
            end
            toast(v and T("MSG_STREAMER_ON") or T("MSG_STREAMER_OFF"), v and "warn" or "success")
        end)
        makeToggle(s, T("BTN_ANON_HUD"), Settings.AnonymizeHUD, function(v)
            Settings.AnonymizeHUD = v; pcall(saveSettings)
            toast(v and T("MSG_HUD_ANON_ON") or T("MSG_HUD_ANON_OFF"), v and "warn" or "success")
        end)
        makeToggle(s, T("BTN_ANON_LIST"), Settings.AnonymizePlayerList, function(v)
            Settings.AnonymizePlayerList = v; pcall(saveSettings)
            toast(v and T("MSG_LIST_ANON_ON") or T("MSG_LIST_ANON_OFF"), v and "warn" or "success")
        end)
        makeSection(s, T("SEC_FILEIO"))
        local hasWrite = writefile ~= nil
        local hasRead = readfile ~= nil
        makeToggle(s, "Auto-save settings", Settings.AutoSaveSettings, function(v) Settings.AutoSaveSettings = v end)
        makeButton(s, "💾 Save to file", function() pcall(saveSettingsToFile) end, hasWrite)
        makeButton(s, "📂 Load from file", function()
            if loadSettingsFromFile() then
                refreshTheme(); destroyUI(); pcall(buildUI); pcall(openMain)
            end
        end, hasRead)
        makeSection(s, T("SEC_OPTIONS"))
        makeToggle(s, "Click sounds", Settings.ClickSounds, function(v) Settings.ClickSounds = v; pcall(saveSettings) end)
        makeToggle(s, "Show mobile button", Settings.ShowMobileButton, function(v)
            Settings.ShowMobileButton = v; pcall(saveSettings)
            if MobileToggle then MobileToggle.Visible = v and not (MainFrame and MainFrame.Visible) end
        end)
        makeSection(s, T("SEC_RESET"))
        makeButton(s, "♻ " .. T("BTN_RESET_ALL"), function()
            Settings.Language = "ru"; Settings.Theme = "dark"; Settings.UIScale = 1
            Settings.ClickSounds = true; Settings.ShowMobileButton = true
            Settings.ESPDistance = 500; Settings.ESPStyle = "highlight"
            Settings.ShowWelcomeScreen = true
            Settings.StreamerMode = false; Settings.AnonymizeHUD = false; Settings.AnonymizePlayerList = false
            Settings.AutoSaveSettings = false
            refreshTheme(); pcall(saveSettings); toast(T("MSG_RESET"), "success")
            destroyUI(); pcall(buildUI); pcall(openMain)
        end)
    end

    do
        local s = addTab("compat", "🔬", T("TAB_COMPAT"))
        makeSection(s, T("SEC_XENO"))
        local infoLbl = Instance.new("TextLabel")
        infoLbl.Size = UDim2.new(1, -16, 0, 22); infoLbl.BackgroundTransparency = 1
        infoLbl.Text = "executor: " .. EXECUTOR .. " | Identity: " .. CurrentIdentity
        infoLbl.TextColor3 = THEME.ACCENT; infoLbl.Font = Enum.Font.GothamBold
        infoLbl.TextSize = 12; infoLbl.TextXAlignment = Enum.TextXAlignment.Left; infoLbl.Parent = s
        local reqSrcName = "unknown"
        for _, src in ipairs(RequireSources) do
            if src.Fn == RealRequire then reqSrcName = src.Name; break end
        end
        local sprintStatus = (SprintingMod and "native") or (FallbackSprint.Active and "fallback") or "none"
        local fioLbl = Instance.new("TextLabel")
        fioLbl.Size = UDim2.new(1, -16, 0, 18); fioLbl.BackgroundTransparency = 1
        fioLbl.Text = "writefile: " .. (writefile and "yes" or "no") .. "  |  readfile: " .. (readfile and "yes" or "no") .. "  |  require: " .. reqSrcName .. "  |  sprint: " .. sprintStatus
        fioLbl.TextColor3 = THEME.TEXT_DIM; fioLbl.Font = Enum.Font.Gotham
        fioLbl.TextSize = 10; fioLbl.TextXAlignment = Enum.TextXAlignment.Left; fioLbl.Parent = s
        for k, v in pairs(COMPAT) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -8, 0, 22)
            row.BackgroundColor3 = v and THEME.PANEL_HOVER or Color3.fromRGB(50, 30, 30)
            row.Parent = s; addCorner(row, 4)
            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, -8, 1, 0); txt.Position = UDim2.fromOffset(8, 0)
            txt.BackgroundTransparency = 1
            txt.Text = k .. "  →  " .. (v and T("COMPAT_OK") or T("COMPAT_FAIL"))
            txt.TextColor3 = v and THEME.SUCCESS or THEME.DANGER
            txt.Font = Enum.Font.GothamMedium; txt.TextSize = 11
            txt.TextXAlignment = Enum.TextXAlignment.Left; txt.Parent = row
        end
        makeSection(s, "Тесты")
        makeButton(s, "🔧 " .. T("BTN_TEST_REQUIRE"), function()
            local testModule = fastFind(Modules, "Network")
            local ok = safeRequire(testModule) ~= nil
            toast("require: " .. (ok and "OK" or "FAIL"), ok and "success" or "error")
        end)
        makeButton(s, "📡 " .. T("BTN_TEST_EVENT"), function()
            local ok = pcall(function()
                local ev = Instance.new("RemoteEvent")
                ev.Name = "CrackstroidTest"; ev.Parent = ReplicatedStorage
                task.delay(1, function() if ev and ev.Parent then ev:Destroy() end end)
            end)
            toast("RemoteEvent: " .. (ok and "OK" or "FAIL"), ok and "success" or "error")
        end)
        makeButton(s, "🎬 " .. T("BTN_TEST_TWEEN"), function()
            local ok = pcall(function()
                local f = Instance.new("Frame"); f.Parent = GuiRoot
                TweenService:Create(f, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
                task.delay(0.2, function() f:Destroy() end)
            end)
            toast("Tween: " .. (ok and "OK" or "FAIL"), ok and "success" or "error")
        end)
        makeButton(s, "🖱 " .. T("BTN_TEST_CLICK"), function()
            toast("Clicks: OK", "success")
        end)
        makeButton(s, "📋 " .. T("BTN_FULL_COMPAT"), function()
            local lines = {"executor: " .. EXECUTOR, "identity: " .. CurrentIdentity, "sprint: " .. sprintStatus}
            for k, v in pairs(COMPAT) do table.insert(lines, k .. "=" .. (v and "OK" or "FAIL")) end
            toast(table.concat(lines, " | "), "success")
        end)
    end

    local tc = Instance.new("Frame")
    tc.Name = "ToastContainer"
    tc.Size = UDim2.fromOffset(310, 440); tc.Position = UDim2.new(1, -320, 0, 60)
    tc.BackgroundTransparency = 1; tc.Parent = gui
    local tcl = Instance.new("UIListLayout")
    tcl.Padding = UDim.new(0, 6); tcl.SortOrder = Enum.SortOrder.LayoutOrder; tcl.Parent = tc
    ToastContainer = tc

    if mobile then
        local mt = Instance.new("ImageButton")
        mt.Name = "MobileToggle"
        mt.Size = UDim2.fromOffset(58, 58); mt.Position = UDim2.new(1, -78, 0, 20)
        mt.BackgroundColor3 = THEME.ACCENT
        mt.Image = "rbxassetid://10724129940"
        mt.ImageColor3 = Color3.new(1, 1, 1); mt.ScaleType = Enum.ScaleType.Fit
        mt.Visible = Settings.ShowMobileButton
        mt.Parent = gui; addCorner(mt, 29); addStroke(mt, THEME.ACCENT_DARK, 2)
        MobileToggle = mt
        mt.MouseButton1Click:Connect(function()
            if MainFrame then
                MainFrame.Visible = not MainFrame.Visible
                if MainFrame.Visible then mt.Visible = false end
            end
        end)
    end

    closeBtn.MouseButton1Click:Connect(function() pcall(closeMain) end)

    setUIConn("InputBegan", UserInputService.InputBegan:Connect(function(input, _)
        if input.KeyCode == TOGGLE_KEY then
            if MainFrame and MainFrame.Visible then
                pcall(closeMain)
            else
                pcall(openMain)
            end
        elseif input.KeyCode == Enum.KeyCode.Delete then
            pcall(closeMain)
        end
    end))

    pcall(function()
        local cam = getCamera()
        if cam then
            setUIConn("ViewportChanged", cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                local m = isMobile()
                baseSize = m and UDim2.fromScale(0.95, 0.85) or UDim2.fromOffset(760, 560)
                if MainFrame and MainFrame.Visible then MainFrame.Size = baseSize end
            end))
        end
    end)

    return true
end

-- ═══════════════ CLEANUP ═══════════════
GENV.CrackstroidActive = function()
    for k, conn in pairs(UIConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
        UIConnections[k] = nil
    end
    for k, conn in pairs(Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
        Connections[k] = nil
    end
    if GuiRoot then pcall(function() GuiRoot:Destroy() end); GuiRoot = nil end
    MainFrame = nil; MobileToggle = nil; ToastContainer = nil; SplashGui = nil
    if FlyConn then pcall(function() FlyConn:Disconnect() end); FlyConn = nil end
    if FreecamConn then pcall(function() FreecamConn:Disconnect() end); FreecamConn = nil end
    if FlyBV then pcall(function() FlyBV:Destroy() end); FlyBV = nil end
    if FlyBG then pcall(function() FlyBG:Destroy() end); FlyBG = nil end
    if KillauraConn then pcall(function() KillauraConn:Disconnect() end); KillauraConn = nil end
    if AntiAFKConn then pcall(function() AntiAFKConn:Disconnect() end); AntiAFKConn = nil end
    destroyFallbackSprint()
    removePostFX(); stopLightingAnim()
    print("[Crackstroid] Unloaded.")
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    pcall(setGodMode, State.GodMode)
    pcall(setNoClip, State.NoClip)
    pcall(setInfStamina, State.InfStamina)
    pcall(setSpeed, State.Speed)
    pcall(setJump, State.Jump)
    InitJump = nil
    if State.Fly then
        pcall(setFly, false)
        task.wait(0.1)
        pcall(setFly, true)
    end
    if not SprintingMod then
        pcall(setupFallbackSprint)
    end
end)

-- ═══════════════ ИНИЦИАЛИЗАЦИЯ ═══════════════
task.spawn(function()
    if not LocalPlayer.Character then
        pcall(function() LocalPlayer.CharacterAdded:Wait() end)
    end
    task.wait(0.5)

    -- Сначала fallback-спринт (не зависит от UI и модулей)
    if not SprintingMod then
        pcall(setupFallbackSprint)
    end

    -- Попытка 1: buildUI
    local ok, err = pcall(buildUI)
    if not ok then
        warn("[Crackstroid] buildUI failed: " .. tostring(err))
        task.wait(1)
        local ok2, err2 = pcall(buildUI)
        if not ok2 then
            warn("[Crackstroid] buildUI second attempt failed: " .. tostring(err2))
        end
    end

    task.wait(0.1)

    -- Открытие меню (splash или сразу)
    if Settings.ShowWelcomeScreen and SplashGui then
        -- welcome уже создан в buildUI через MainFrame? Нет, buildSplash отдельно
        local okSplash = pcall(buildSplash)
        if not okSplash then
            pcall(openMain)
        end
    else
        pcall(openMain)
    end

    pcall(scanEmotes)
    pcall(setSpeed, 1)

    -- Повторная попытка спринта (на случай если при старте не было персонажа)
    if not SprintingMod then
        task.wait(2)
        if not FallbackSprint.Active then
            pcall(setupFallbackSprint)
        end
    end

    print("[Crackstroid v" .. VERSION .. "] Loaded on " .. EXECUTOR)
    print("[Crackstroid v" .. VERSION .. "] RShift toggle | Delete close")
    print("[Crackstroid] Sprint: " .. ((SprintingMod and "native") or (FallbackSprint.Active and "fallback") or "NONE"))
end)
