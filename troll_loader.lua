--[[
    Proje: Sentinel V5.0 (Tam Sürüm: İsim, Can Barı, Aimbot ve Menü Entegreli)
]]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Ayar Tablosu
local Config = {
    ESPEnabled = true,
    AimbotEnabled = false,
    FOV = 100
}

--------------------------------------------------------------------------------
-- 1. BÖLÜM: İsim ve Can Barı Destekli Gelişmiş ESP Fonksiyonu
--------------------------------------------------------------------------------
local function createAdvancedESP(player)
    if player == LocalPlayer then return end
    
    local function setupCharacter(char)
        if not char then return end
        
        if char:FindFirstChild("SentinelESP_Folder") then
            char.SentinelESP_Folder:Destroy()
        end
        
        local folder = Instance.new("Folder")
        folder.Name = "SentinelESP_Folder"
        folder.Parent = char
        
        -- Kutu (Highlight)
        local highlight = Instance.new("Highlight")
        highlight.Name = "Box"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.6
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = folder
        
        -- İsim ve Can Barı (Kafanın üstünde)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "InfoTag"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 150, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = folder
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.Code
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = billboard
        
        local healthBarBg = Instance.new("Frame")
        healthBarBg.Size = UDim2.new(0, 100, 0, 6)
        healthBarBg.Position = UDim2.new(0.5, -50, 0, 22)
        healthBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        healthBarBg.BorderSizePixel = 0
        healthBarBg.Parent = billboard
        
        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(1, 0)
        bgCorner.Parent = healthBarBg
        
        local healthBar = Instance.new("Frame")
        healthBar.Name = "HealthFill"
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        healthBar.BorderSizePixel = 0
        healthBar.Parent = healthBarBg
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = healthBar
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.HealthChanged:Connect(function(health)
                local healthPercent = math.clamp(health / humanoid.MaxHealth, 0, 1)
                healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
            end)
        end
    end

    player.CharacterAdded:Connect(setupCharacter)
    if player.Character then
        task.spawn(function()
            setupCharacter(player.Character)
        end)
    end
end

-- ESP'yi aç/kapat kontrol fonksiyonu
local function toggleESP(state)
    Config.ESPEnabled = state
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local folder = p.Character:FindFirstChild("SentinelESP_Folder")
            if folder then
                folder.Enabled = state
            elseif state then
                createAdvancedESP(p)
            end
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createAdvancedESP(p)
end
Players.PlayerAdded:Connect(createAdvancedESP)


--------------------------------------------------------------------------------
-- 2. BÖLÜM: Aimbot ve Diğer Yetenekler
--------------------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if Config.AimbotEnabled then
        local closestTarget = nil
        local shortestDist = Config.FOV
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local screenPoint, onScreen = Camera:WorldToScreenPoint(player.Character.Head.Position)
                if onScreen then
                    local magnitude = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    if magnitude < shortestDist then
                        shortestDist = magnitude
                        closestTarget = player.Character.Head
                    end
                end
            end
        end
        
        if closestTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
        end
    end
end)


--------------------------------------------------------------------------------
-- 3. BÖLÜM: Arayüz (GUI - Menü Paneli)
--------------------------------------------------------------------------------
if CoreGui:FindFirstChild("SentinelGUI") then
    CoreGui.SentinelGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SentinelGUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Başlık
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.Text = "  S E N T I N E L  //  Troll Suite"
TitleBar.TextColor3 = Color3.fromRGB(0, 255, 128)
TitleBar.TextSize = 14
TitleBar.Font = Enum.Font.Code
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Buton Oluşturucu Fonksiyon
local function createButton(name, positionY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 35)
    btn.Position = UDim2.new(0.5, -140, 0, positionY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.Code
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- Menü Tuşları ve Fonksiyon Bağlantıları
createButton("ESP Aç / Kapat", 55, function()
    Config.ESPEnabled = not Config.ESPEnabled
    toggleESP(Config.ESPEnabled)
end)

createButton("Aimbot Aç / Kapat", 100, function()
    Config.AimbotEnabled = not Config.AimbotEnabled
end)

createButton("Menüyü Gizle / Göster", 145, function()
    MainFrame.Visible = not MainFrame.Visible
end)