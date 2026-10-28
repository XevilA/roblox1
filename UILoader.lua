-- วางไฟล์นี้ใน ServerScriptService (กดสร้างเป็น Script ปกติ ไม่ใช่ LocalScript)
-- ชื่อไฟล์: UnitSpawnerService.lua

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- สร้าง RemoteEvent สำหรับให้ Client สั่งเสกของ (ต้องสร้างใน ReplicatedStorage ก่อน หรือสร้างผ่านสคริปต์)
local spawnEvent = ReplicatedStorage:FindFirstChild("RequestSpawnUnit")
if not spawnEvent then
    spawnEvent = Instance.new("RemoteEvent")
    spawnEvent.Name = "RequestSpawnUnit"
    spawnEvent.Parent = ReplicatedStorage
end

-- ฟังก์ชันหลักสำหรับการเสกยูนิต
local function SpawnUnitForPlayer(player, unitName, spawnCFrame)
    -- 1. ค้นหาโมเดลยูนิตจาก ServerStorage (ต้องมี Folder ชื่อ UnitTemplates)
    local templateFolder = ServerStorage:FindFirstChild("UnitTemplates")
    if not templateFolder then
        warn("ไม่พบ Folder 'UnitTemplates' ใน ServerStorage")
        return false
    end

    local unitTemplate = templateFolder:FindFirstChild(unitName)
    if not unitTemplate then
        warn("ไม่พบโมเดลยูนิตชื่อ: " .. unitName)
        return false
    end

    -- 2. Clone โมเดลออกมา
    local newUnit = unitTemplate:Clone()
    
    -- 3. กำหนดตำแหน่งการเกิด (ถ้ามี)
    if spawnCFrame then
        if newUnit.PrimaryPart then
            newUnit:SetPrimaryPartCFrame(spawnCFrame)
        else
            newUnit:MoveTo(spawnCFrame.Position)
        end
    end

    -- 4. ตั้งค่าความเป็นเจ้าของ (Owner) เพื่อให้รู้ว่ายูนิตนี้เป็นของใคร
    newUnit:SetAttribute("OwnerId", player.UserId)
    newUnit.Name = player.Name .. "_" .. unitName

    -- 5. นำยูนิตไปวางใน Workspace
    newUnit.Parent = workspace
    print("[Server] " .. player.Name .. " ได้เสกยูนิต: " .. unitName)
    return true
end

-- รับคำสั่งจาก Client ผ่าน RemoteEvent
spawnEvent.OnServerEvent:Connect(function(player, unitName, spawnPosition)
    -- ⚠️ สำคัญมาก: ต้องมีระบบตรวจสอบ (Validation) เสมอเพื่อป้องกันการโกง
    -- เช่น เช็กว่า player มีเงินพอไหม? คูลดาวน์ครบหรือยัง? 
    
    -- ตัวอย่างการตรวจสอบเบื้องต้น (ป้องกันการส่งค่าผิดประเภทมา)
    if type(unitName) ~= "string" then return end
    if typeof(spawnPosition) ~= "Vector3" then
        spawnPosition = Vector3.new(0, 10, 0) -- ตำแหน่งเริ่มต้น
    end

    local success = SpawnUnitForPlayer(player, unitName, CFrame.new(spawnPosition))
    
    if not success then
        -- แจ้งเตือนผู้เล่นหากเสกไม่สำเร็จ
        print("เกิดข้อผิดพลาดในการเสกให้ " .. player.Name)
    end
end)
