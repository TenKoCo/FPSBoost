-- =====================================================
-- CONFIGURATION
-- =====================================================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1538141497063383060/KQvf33guNa74KhsUhgt157CLYk_U4mEaYKDlleO1qFTXaoZ_glO-tBcBLFXEMkT8CKc3"
local AUTO_UPDATE_INTERVAL = 300 -- 5 phút

-- =====================================================
-- ⚪ WHITE SCREEN + CAP 10 FPS (GIỮ 100% UI GAME)
-- =====================================================
-- 1. Giới hạn 10 FPS
pcall(function()
    if setfpscap then setfpscap(10) end
end)

-- 2. Biến môi trường/bầu trời thành màu trắng tinh
pcall(function()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
            v:Destroy()
        end
    end
end)

-- 3. Tạo phông nền trắng NẰM DƯỚI UI GAME
local function applyWhiteBackground()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    
    if PlayerGui and not PlayerGui:FindFirstChild("WhiteBackgroundUI") then
        local gui = Instance.new("ScreenGui")
        gui.Name = "WhiteBackgroundUI"
        gui.Parent = PlayerGui
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = -99999 -- Đảm bảo luôn nằm dưới cùng, không đè UI game

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame.BorderSizePixel = 0
        frame.Parent = gui
    end
end

-- 4. Ẩn vật thể 3D thế giới để nhẹ máy (Nhưng KHÔNG đụng vào UI)
local function optimizeWorld()
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        pcall(function() Terrain.WaterTransparency = 1 end)
    end
    
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name ~= "Camera" and v.Name ~= "Characters" and v.Name ~= "Enemies" and v.Name ~= "NPCs" then
            if v:IsA("BasePart") then
                v.Transparency = 1
            end
        end
    end
end

pcall(applyWhiteBackground)
pcall(optimizeWorld)

-- Vòng lặp giữ FPS & Màn trắng
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            if setfpscap then setfpscap(10) end
            applyWhiteBackground()
        end)
    end
end)

-- =====================================================
-- 🍎 FRUIT DATABASE
-- =====================================================
local FRUIT_DATA = {
    ["Kitsune-Kitsune"] = {Name = "Kitsune", Rarity = "MYTHICAL", Price = "$8,000,000"},
    ["Dragon-Dragon"] = {Name = "Dragon", Rarity = "MYTHICAL", Price = "$3,500,000"},
    ["Leopard-Leopard"] = {Name = "Leopard", Rarity = "MYTHICAL", Price = "$5,000,000"},
    ["Dough-Dough"] = {Name = "Dough", Rarity = "MYTHICAL", Price = "$2,800,000"},
    ["T-Rex-T-Rex"] = {Name = "T-Rex", Rarity = "MYTHICAL", Price = "$2,700,000"},
    ["Spirit-Spirit"] = {Name = "Spirit", Rarity = "MYTHICAL", Price = "$2,550,000"},
    ["Venom-Venom"] = {Name = "Venom", Rarity = "MYTHICAL", Price = "$3,000,000"},
    ["Shadow-Shadow"] = {Name = "Shadow", Rarity = "MYTHICAL", Price = "$2,900,000"},
    ["Gravity-Gravity"] = {Name = "Gravity", Rarity = "MYTHICAL", Price = "$2,500,000"},
    ["Mammoth-Mammoth"] = {Name = "Mammoth", Rarity = "MYTHICAL", Price = "$2,700,000"},
    ["Blizzard-Blizzard"] = {Name = "Blizzard", Rarity = "LEGENDARY", Price = "$2,400,000"},
    ["Portal-Portal"] = {Name = "Portal", Rarity = "LEGENDARY", Price = "$1,900,000"},
    ["Rumble-Rumble"] = {Name = "Rumble", Rarity = "LEGENDARY", Price = "$2,100,000"},
    ["Buddha-Buddha"] = {Name = "Buddha", Rarity = "LEGENDARY", Price = "$1,200,000"},
    ["Love-Love"] = {Name = "Love", Rarity = "LEGENDARY", Price = "$1,300,000"},
    ["Spider-Spider"] = {Name = "Spider", Rarity = "LEGENDARY", Price = "$1,500,000"},
    ["Sound-Sound"] = {Name = "Sound", Rarity = "LEGENDARY", Price = "$1,700,000"},
    ["Phoenix-Phoenix"] = {Name = "Phoenix", Rarity = "LEGENDARY", Price = "$1,800,000"},
    ["Pain-Pain"] = {Name = "Pain", Rarity = "LEGENDARY", Price = "$2,300,000"},
    ["Quake-Quake"] = {Name = "Quake", Rarity = "LEGENDARY", Price = "$1,000,000"},
    ["Magma-Magma"] = {Name = "Magma", Rarity = "RARE", Price = "$850,000"},
    ["Ghost-Ghost"] = {Name = "Ghost", Rarity = "RARE", Price = "$940,000"},
    ["Barrier-Barrier"] = {Name = "Barrier", Rarity = "RARE", Price = "$800,000"},
    ["Light-Light"] = {Name = "Light", Rarity = "RARE", Price = "$650,000"},
    ["Rubber-Rubber"] = {Name = "Rubber", Rarity = "RARE", Price = "$750,000"},
    ["Diamond-Diamond"] = {Name = "Diamond", Rarity = "RARE", Price = "$600,000"},
    ["Dark-Dark"] = {Name = "Dark", Rarity = "RARE", Price = "$500,000"},
    ["Ice-Ice"] = {Name = "Ice", Rarity = "UNCOMMON", Price = "$350,000"},
    ["Sand-Sand"] = {Name = "Sand", Rarity = "UNCOMMON", Price = "$420,000"},
    ["Falcon-Falcon"] = {Name = "Falcon", Rarity = "UNCOMMON", Price = "$300,000"},
    ["Flame-Flame"] = {Name = "Flame", Rarity = "UNCOMMON", Price = "$250,000"},
    ["Spike-Spike"] = {Name = "Spike", Rarity = "UNCOMMON", Price = "$180,000"},
    ["Smoke-Smoke"] = {Name = "Smoke", Rarity = "COMMON", Price = "$100,000"},
    ["Bomb-Bomb"] = {Name = "Bomb", Rarity = "COMMON", Price = "$80,000"},
    ["Spring-Spring"] = {Name = "Spring", Rarity = "COMMON", Price = "$60,000"},
    ["Chop-Chop"] = {Name = "Chop", Rarity = "COMMON", Price = "$30,000"},
    ["Spin-Spin"] = {Name = "Spin", Rarity = "COMMON", Price = "$18,000"},
    ["Rocket-Rocket"] = {Name = "Rocket", Rarity = "COMMON", Price = "$5,000"}
}

-- =====================================================
-- SERVICES & WEBHOOK LOGIC
-- =====================================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local httpRequest = http_request or request or syn.request

local function formatCategorizedInventory(categorizedFruits)
    local lines = {}
    local categories = {
        {Key = "COMMON", Prefix = "⚪ **COMMON:**"},
        {Key = "UNCOMMON", Prefix = "🟢 **UNCOMMON:**"},
        {Key = "RARE", Prefix = "🔵 **RARE:**"},
        {Key = "LEGENDARY", Prefix = "🟡 **LEGENDARY:**"},
        {Key = "MYTHICAL", Prefix = "🔴 **MYTHICAL:**"}
    }
    for _, cat in ipairs(categories) do
        local list = categorizedFruits[cat.Key] or {}
        if #list > 0 then
            table.insert(lines, cat.Prefix .. " " .. table.concat(list, ", "))
        else
            table.insert(lines, cat.Prefix .. " Không có")
        end
    end
    return table.concat(lines, "\n")
end

local function getInventoryList()
    if not LocalPlayer.Character or not LocalPlayer:FindFirstChild("Data") then return "⚠️ Dữ liệu chưa load" end
    local categorizedFruits = {COMMON={}, UNCOMMON={}, RARE={}, LEGENDARY={}, MYTHICAL={}}
    local success, inventoryData = pcall(function() return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryFruits") end)
    
    if success and type(inventoryData) == "table" then
        for _, v in pairs(inventoryData) do
            local rawName = tostring(v.Name)
            local info = FRUIT_DATA[rawName]
            if info and categorizedFruits[info.Rarity] then
                table.insert(categorizedFruits[info.Rarity], info.Name)
            else
                table.insert(categorizedFruits.COMMON, rawName:gsub("%-.*", ""))
            end
        end
    end
    return formatCategorizedInventory(categorizedFruits)
end

local function sendWebhook(title, description, color)
    local payload = {
        ["username"] = "Blox Fruits Notifier",
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["fields"] = {
                {["name"] = "👤 Tài khoản", ["value"] = "||" .. LocalPlayer.Name .. "||", ["inline"] = true},
                {["name"] = "📦 Kho Trái Ác Quỷ (Inventory)", ["value"] = getInventoryList(), ["inline"] = false}
            },
            ["footer"] = {["text"] = "Blox Fruits Notifier • " .. os.date("%X")},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    pcall(function()
        httpRequest({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)})
    end)
end

-- =====================================================
-- DETECTION & AUTO UPDATE
-- =====================================================
local function setupFruitDetection(container)
    container.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and (child.Name:find("Fruit") or child:FindFirstChild("Fruit")) then
            sendWebhook("🍎 Phát hiện nhận Trái!", "Tài khoản vừa nhặt được trái mới.", 65280)
        end
    end)
end

if LocalPlayer:WaitForChild("Backpack", 10) then setupFruitDetection(LocalPlayer.Backpack) end
LocalPlayer.CharacterAdded:Connect(function(char) setupFruitDetection(char) end)

task.spawn(function()
    repeat task.wait(1) until LocalPlayer:FindFirstChild("Data")
    sendWebhook("🔔 Script đã kết nối!", "Đã bật phông trắng, Cap 10 FPS và giữ 100% UI Game Blox Fruits.", 3447003)
    while true do
        task.wait(AUTO_UPDATE_INTERVAL)
        sendWebhook("🔄 Cập nhật định kỳ", "Báo cáo tự động tình trạng kho hiện tại.", 3447003)
    end
end)
