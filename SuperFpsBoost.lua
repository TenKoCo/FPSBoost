-- [[ ULTRA FPS BOOSTER - GRAY SKY & REMOVE ALL BLOX FRUITS VFX ]]

local Lighting = game:GetService("Lighting")

-- Hàm kiểm tra xem có phải Model Nhân vật / NPC / Quái vật không
local function isCharacterOrNPC(v)
    local ancestor = v:FindFirstAncestorOfClass("Model")
    if ancestor and ancestor:FindFirstChildOfClass("Humanoid") then
        return true
    end
    return false
end

-- 1. CHUYỂN BẦU TRỜI THÀNH MÀU XÁM PHẲNG TRƠN (KHÔNG CÓ SAO)
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.ClockTime = 12
Lighting.Brightness = 0
Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
Lighting.Ambient = Color3.fromRGB(150, 150, 150)

-- Triệt tiêu các hiệu ứng ánh sáng ống kính & Skybox cũ
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("PostEffect") then
        v:Destroy()
    end
end

-- Tạo Skybox màu xám phẳng chuẩn đè bầu trời mặc định
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

-- 2. TÀNG HÌNH MAP (GIỮ VA CHẠM) & XÓA TẤT CẢ HIỆU ỨNG TỒN TẠI Ban ĐẦU
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        if not isCharacterOrNPC(v) then
            v.Transparency = 1 -- Tàng hình vật thể cảnh vật
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    -- Xóa/Chặn toàn bộ các loại hiệu ứng hình ảnh (VFX)
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") 
        or v:IsA("Sparkles") or v:IsA("Beam") or v:IsA("Highlight") or v:IsA("Explosion") then
        if v:IsA("Explosion") then
            v.Visible = false
        else
            v.Enabled = false
        end
    end
end

-- 3. BẮT SỰ KIỆN XÓA LẬP TỨC MỌI HIỆU ỨNG SKILL / CHIÊU THỨC BLOX FRUITS TỰ ĐỘNG PHÁT SINH
workspace.DescendantAdded:Connect(function(v)
    -- Tắt triệt để mọi loại Particle/VFX khi tung chiêu
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

-- Chặn Blox Fruits tự thêm lại Skybox hay hiệu ứng khí quyển
Lighting.ChildAdded:Connect(function(child)
    if (child:IsA("Sky") and child.Name ~= "SolidGraySky") or child:IsA("Atmosphere") or child:IsA("PostEffect") then
        task.wait()
        child:Destroy()
    end
end)
