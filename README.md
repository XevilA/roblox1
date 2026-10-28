🛠️ วิธีการติดตั้ง (Installation Guide)

ส่วนที่ 1: การตั้งค่า Unit Spawner (ฝั่ง Server)

ระบบนี้ใช้สำหรับให้เซิร์ฟเวอร์สร้างโมเดล (เช่น สัตว์เลี้ยง, มอนสเตอร์, หอคอย) ตามคำสั่งของผู้เล่น

ขั้นตอน:

เปิด Roblox Studio และเปิดโปรเจกต์เกมของคุณ ไปที่ Explorer >> คลิกขวาที่ ServerStorage >> เลือก Insert Object >> เลือก Folder ตั้งชื่อ Folder ว่า UnitTemplates (ต้องสะกดให้ตรงเป๊ะ) นำโมเดลที่คุณต้องการให้เสกได้ (เช่น โมเดลมังกร) ลากใส่ไว้ใน Folder UnitTemplates นี้ ไปที่ ServerScriptService >> คลิกขวา >> Insert Object >> Script เปลี่ยนชื่อ Script เป็น UnitSpawnerService คัดลอกโค้ดจากไฟล์ src/server/UnitSpawnerService.lua ไปวางใน Script นี้ วิธีใช้งาน (จากฝั่ง Client):

lua local ReplicatedStorage = game:GetService(*ReplicatedStorage*) local spawnEvent = ReplicatedStorage:WaitForChild(*RequestSpawnUnit*)

-- สั่งเสกโมเดลชื่อ *Dragon* ที่พิกัด X=0, Y=10, Z=0 spawnEvent:FireServer(*Dragon*, Vector3.new(0, 10, 0)) ส่วนที่ 2: การตั้งค่า Universal UI Loader (ฝั่ง Client)

ระบบนี้ใช้สำหรับดึงโค้ด UI (หน้าต่าง, ปุ่มกด) จาก GitHub มาทำงานในเกม

ขั้นตอน:

อัปโหลดไฟล์ UI ของคุณ (เช่น MainMenu.lua) ขึ้น GitHub ของคุณ (ต้องเป็น Public Repository) กดปุ่ม *Raw* บน GitHub เพื่อดูลิงก์ตรงของไฟล์ (ลิงก์จะขึ้นต้นด้วย [https://raw.githubusercontent.com/...](https://raw.githubusercontent.com/...)) สำคัญมาก: ใน Roblox Studio ไปที่เมนู Home >> Game Settings >> แท็บ Security >> เปิดใช้งาน *Allow **HTTP** Requests* (อนุญาต **HTTP** Request) ไปที่ StarterPlayer >> StarterPlayerScripts >> คลิกขวา >> Insert Object >> LocalScript เปลี่ยนชื่อเป็น UILoader คัดลอกโค้ดจากไฟล์ src/client/UILoader.lua ไปวาง แก้ไขตัวแปร BASE_URL ในโค้ด ให้ชี้ไปที่ Repository ของคุณ: lua -- ตัวอย่างการแก้ไข (ห้ามลืมเครื่องหมาย / ปิดท้าย) local BASE_URL = "[https://raw.githubusercontent.com/ชื่อยูสเซอร์/ชื่อเรโป/main/src/client/"](https://raw.githubusercontent.com/ชื่อยูสเซอร์/ชื่อเรโป/main/src/client/") ❓ การแก้ไขปัญหาเบื้องต้น (Troubleshooting)

โหลด UI ไม่ขึ้น (Error: Http requests are not enabled):

วิธีแก้: คุณลืมเปิด Allow **HTTP** Requests ใน Game Settings >> Security โหลด UI ไม่ขึ้น (Error: **404** Not Found):

วิธีแก้: ลิงก์ BASE_URL หรือชื่อไฟล์ในตาราง UIModules ของคุณพิมพ์ผิด หรือไฟล์ยังไม่ได้อัปโหลดขึ้น GitHub เสกตัวไม่ได้ (ไม่เกิดอะไรขึ้น):

วิธีแก้: ตรวจสอบว่า Folder ใน ServerStorage ชื่อ UnitTemplates สะกดถูกต้องหรือไม่ และข้างในมีโมเดลที่ชื่อตรงกับที่ Client สั่งเสกหรือเปล่า เสกตัวแล้วเห็นแค่คนเดียว:

วิธีแก้: คุณต้องใช้โค้ด UnitSpawnerService (ฝั่ง Server) ไม่ใช่การสั่ง Instance.new ใน LocalScript ธรรมดา
