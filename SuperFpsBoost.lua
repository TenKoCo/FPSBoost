-- [[ ULTRA FPS BOOSTER + RAM CLEANER - BLOX FRUITS ]]

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ContentProvider = game:GetService("ContentProvider")

-- =======================================================
-- 1. TỐI ƯU RAM & CẤU HÌNH FPS
-- =======================================================

-- Khóa FPS ở mức 15
if setfpscap then
    setfpscap(15)
end

-- Ép chất lượng đồ họa về mức thấp nhất để tiết kiệm RAM/GPU
UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1

-- Tắt Render 3D (Ngừng vẽ khung cảnh, tiết kiệm RAM/GPU tối đa)
RunService:Set3DRenderStepped(false)

-- Hàm dọn dẹp các Sound rác sinh ra khi dùng Skill để giải phóng RAM
local function clearSoundEffects()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Sound") and not v.Playing then
            v:Destroy()
        end
    end
end

-- Vòng lặp dọn dẹp bộ nhớ định kỳ mỗi 60 giây
task.spawn(function()
    while task.wait(60) do
        clearSoundEffects()
    end
end)

-- =======================================================
-- 2. TÀNG HÌNH MAP & CHUYỂN BẦU TRỜI XÁM PHẲNG
-- =======================================================

local function isCharacterOrNPC(v)
    local ancestor = v:FindFirstAncestorOfClass("Model")
    if ancestor and ancestor:FindFirstChildOfClass("Humanoid") then
        return true
    end
    return false
end

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.ClockTime = 12
Lighting.Brightness = 0
Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
Lighting.Ambient = Color3.fromRGB(150, 150, 150)

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("PostEffect") then
        v:Destroy()
    end
end

local solidSky = Instance.new("Sky")
solidSky.Name = "SolidGraySky"
local grayTexture = "rbxassetid://6039602330" 
solidSky.SkyboxBk = grayTexture
solidSky.SkyboxDn = grayTexture
solidSky.SkyboxFt = grayTexture
solidSky.SkyboxLf = grayTexture
solidSky.SkyboxRt = grayTexture
solidSky.SkyboxUp = grayTexture
solidSky.StarCount = 0
solidSky.Parent = Lighting

if workspace.Terrain then
    workspace.Terrain.WaterWaveSize = 0
end

-- =======================================================
-- 3. XÓA TOÀN BỘ HIỆU ỨNG VFX / DECAL BAN ĐẦU
-- =======================================================

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        if not isCharacterOrNPC(v) then
            v.Transparency = 1
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") 
        or v:IsA("Sparkles") or v:IsA("Beam") or v:IsA("Highlight") or v:IsA("Explosion") then
        if v:IsA("Explosion") then
            v.Visible = false
        else
            v.Enabled = false
        end
    end
end

-- =======================================================
-- 4. TỰ ĐỘNG TRIỆT TIÊU VFX MỚI PHÁT SINH KHI FARM
-- =======================================================

workspace.DescendantAdded:Connect(function(v)
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") 
        or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Highlight") then
        v.Enabled = false
    elseif v:IsA("Explosion") then
        v.Visible = false
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    elseif v:IsA("BasePart") and not isCharacterOrNPC(v) then
        v.Transparency = 1
    end
end)

Lighting.ChildAdded:Connect(function(child)
    if (child:IsA("Sky") and child.Name ~= "SolidGraySky") or child:IsA("Atmosphere") or child:IsA("PostEffect") then
        task.wait()
        child:Destroy()
    end
end)
