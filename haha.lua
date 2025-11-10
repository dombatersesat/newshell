-- =====================================================
-- _______  _______  _______  _______  _______ _________
-- (  ____ )(  ____ )(  ____ \(  ____ \(  ____ \\__   __/
-- | (    )|| (    )|| (    \/| (    \/| (    \/   ) (
-- | (____)|| (____)|| |      | (_____ | (_____    | |
-- |  _____)|     __)| |      | (_____ |  _____)   | |
-- | (      | (\ (   | |      | )      | (         | |
-- | )      | ) \ \__| (____/\| )      | )      ___) (___
-- |/       |/   \__/(_______/|/       |/       \_______/
--
-- Game: Fish It!
-- Credit: DOMBA TERSESAT
-- =====================================================

-- Inisialisasi Environment
getgenv().DombaTersatHub = {}
local Hub = getgenv().DombaTersatHub

-- Layanan Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

-- Variabel Pemain
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Tabel untuk menyimpan state fitur
Hub.Toggles = {
    AutoFarm = {
        Enabled = false,
        FishMode = "Stable", -- Stable, Blatant, Extreme, Instant
        Sell = false,
        Event = false,
        Favorite = false,
        Artifact = false,
        Quest = false
    },
    Player = {
        WalkSpeed = 16,
        JumpPower = 50,
        NoClip = false,
        Fly = false,
        AntiAFK = false,
        AntiDrown = false
    },
    Visuals = {
        PlayerESP = false,
        FishESP = false,
        TreasureESP = false,
        FPSBoost = false
    },
    Settings = {
        WebhookURL = "",
        NotifyRareFish = true,
        NotifyFullInventory = true,
        NotifyTrade = true
    }
}

-- Tabel untuk menyimpan koneksi (agar bisa dihentikan)
Hub.Connections = {}

-- Fungsi untuk membuat UI
local function createUI()
    -- Buat ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name = "DombaTersatHubUI"
    ScreenGui.IgnoreGuiInset = true

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- Shadow Effect
    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BorderSizePixel = 0
    Shadow.Position = UDim2.new(0, 5, 0, 5)
    Shadow.Size = UDim2.new(1, 0, 1, 0)
    Shadow.ZIndex = 0
    Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 8)
    MainFrame.ZIndex = 1

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "DOMBA TERSESAT HUB"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.TextSize = 18.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button (X)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseButton.TextSize = 20.000
    CloseButton.MouseEnter:Connect(function() CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50) end)
    CloseButton.MouseLeave:Connect(function() CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100) end)
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Tab Holder
    local TabHolder = Instance.new("Frame")
    TabHolder.Parent = MainFrame
    TabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 0, 0, 35)
    TabHolder.Size = UDim2.new(0, 150, 1, -35)
    Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 8)

    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 150, 0, 35)
    ContentFrame.Size = UDim2.new(1, -150, 1, -35)
    Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)
    
    local Padding = Instance.new("UIPadding", ContentFrame)
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.PaddingBottom = UDim.new(0, 10)

    -- Fungsi untuk membuat elemen UI
    local function createTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Position = UDim2.new(0, 0, 0, 40 * (#TabHolder:GetChildren() - 1))
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14.000
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        local Corner = Instance.new("UICorner", TabButton)
        Corner.CornerRadius = UDim.new(0, 5)

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentFrame
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0) -- Akan diatur nanti
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)

        TabButton.MouseButton1Click:Connect(function()
            -- Sembunyikan semua halaman
            for _, page in ipairs(ContentFrame:GetChildren()) do
                if page:IsA("ScrollingFrame") then page.Visible = false end
            end
            -- Reset warna semua tombol
            for _, btn in ipairs(TabHolder:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            -- Tampilkan halaman yang dipilih
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 120)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        return Page
    end

    local function createToggle(page, label, toggleTable, key)
        local ySize = 35
        local yPos = page.CanvasSize.Y.Offset + 5

        local Frame = Instance.new("Frame")
        Frame.Parent = page
        Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(1, 0, 0, ySize)
        Frame.Position = UDim2.new(0, 0, 0, yPos)
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)

        local Label = Instance.new("TextLabel")
        Label.Parent = Frame
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Size = UDim2.new(1, -80, 1, 0)
        Label.Font = Enum.Font.Gotham
        Label.Text = label
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 14.000
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Toggle = Instance.new("TextButton")
        Toggle.Parent = Frame
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        Toggle.BorderSizePixel = 0
        Toggle.Position = UDim2.new(1, -70, 0.5, -10)
        Toggle.Size = UDim2.new(0, 60, 0, 20)
        Toggle.Font = Enum.Font.GothamBold
        Toggle.Text = "OFF"
        Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.TextSize = 12.000
        Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)

        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        local tweenOn = TweenService:Create(Toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 255, 50)})
        local tweenOff = TweenService:Create(Toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 50, 50)})

        Toggle.MouseButton1Click:Connect(function()
            toggleTable[key] = not toggleTable[key]
            Toggle.Text = toggleTable[key] and "ON" or "OFF"
            if toggleTable[key] then tweenOn:Play() else tweenOff:Play() end
            -- Trigger event untuk menjalankan logika fitur
            if Hub.Functions[label] then
                Hub.Functions[label](toggleTable[key])
            end
        end)

        page.CanvasSize = UDim2.new(0, 0, 0, yPos + ySize)
    end
    
    -- Buat Tab dan Isinya
    local AutoFarmPage = createTab("Auto Farm")
    createToggle(AutoFarmPage, "Auto Fish", Hub.Toggles.AutoFarm, "Enabled")
    -- TODO: Tambahkan Dropdown untuk memilih mode
    createToggle(AutoFarmPage, "Auto Sell", Hub.Toggles.AutoFarm, "Sell")
    createToggle(AutoFarmPage, "Auto Event", Hub.Toggles.AutoFarm, "Event")
    createToggle(AutoFarmPage, "Auto Favorite", Hub.Toggles.AutoFarm, "Favorite")
    createToggle(AutoFarmPage, "Auto Artifact", Hub.Toggles.AutoFarm, "Artifact")
    createToggle(AutoFarmPage, "Auto Quest", Hub.Toggles.AutoFarm, "Quest")

    local PlayerPage = createTab("Player")
    createToggle(PlayerPage, "No Clip", Hub.Toggles.Player, "NoClip")
    createToggle(PlayerPage, "Fly", Hub.Toggles.Player, "Fly")
    createToggle(PlayerPage, "Anti AFK", Hub.Toggles.Player, "AntiAFK")
    createToggle(PlayerPage, "Anti Drown", Hub.Toggles.Player, "AntiDrown")
    -- TODO: Tambahkan Slider untuk WalkSpeed dan JumpPower

    local VisualsPage = createTab("Visuals")
    createToggle(VisualsPage, "Player ESP", Hub.Toggles.Visuals, "PlayerESP")
    createToggle(VisualsPage, "Fish ESP", Hub.Toggles.Visuals, "FishESP")
    createToggle(VisualsPage, "Treasure ESP", Hub.Toggles.Visuals, "TreasureESP")
    createToggle(VisualsPage, "FPS Boost", Hub.Toggles.Visuals, "FPSBoost")

    local SettingsPage = createTab("Settings")
    -- TODO: Tambahkan TextBox untuk Webhook URL
    -- TODO: Tambahkan Toggle untuk notifikasi
    -- TODO: Tambahkan Tombol Save/Load Config
    -- TODO: Tambahkan Tombol Server Hop

    -- Tampilkan tab pertama
    TabHolder:FindFirstChildWhichIsA("TextButton").MouseButton1Click()
end

-- =====================================================
-- LOGIKA FITUR (Template - Perlu Diisi)
-- =====================================================
Hub.Functions = {}

function Hub.Functions["Auto Fish"](state)
    if state then
        print("[Auto Fish] Started")
        Hub.Connections.AutoFish = RunService.Heartbeat:Connect(function()
            -- TODO: Implementasi Auto Fish
            -- 1. Cari RemoteEvent untuk melempar kail (misal: game.ReplicatedStorage.Remotes.Cast)
            -- 2. Cari cara mendeteksi ikan (misal: check UI, atau event dari client)
            -- 3. Contoh logika loop:
            --    if not isFishing then
            --        castRemote:FireServer()
            --    end
            --    if fishBiting then
            --        reelRemote:FireServer()
            --    end
        end)
    else
        print("[Auto Fish] Stopped")
        if Hub.Connections.AutoFish then
            Hub.Connections.AutoFish:Disconnect()
            Hub.Connections.AutoFish = nil
        end
    end
end

function Hub.Functions["No Clip"](state)
    if state then
        print("[No Clip] Enabled")
        Hub.Connections.NoClip = RunService.Stepped:Connect(function()
            if Character and Character:FindFirstChild("Humanoid") then
                for _, part in ipairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        print("[No Clip] Disabled")
        if Hub.Connections.NoClip then
            Hub.Connections.NoClip:Disconnect()
            Hub.Connections.NoClip = nil
            -- Kembalikan CanCollide
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

function Hub.Functions["Fly"](state)
    -- TODO: Implementasi Fly (lebih kompleks, butuh kontrol UserInputService)
    print("[Fly] State:", state)
    -- Logika dasar: ubah HumanoidRootPart.CFrame secara terus-menerus berdasarkan input
end

function Hub.Functions["Anti AFK"](state)
    if state then
        print("[Anti AFK] Enabled")
        Hub.Connections.AntiAFK = LocalPlayer.Idled:Connect(function()
            VirtualUser:Button1Down(Vector2.new())
            wait()
            VirtualUser:Button1Up(Vector2.new())
        end)
    else
        print("[Anti AFK] Disabled")
        if Hub.Connections.AntiAFK then
            Hub.Connections.AntiAFK:Disconnect()
            Hub.Connections.AntiAFK = nil
        end
    end
end

function Hub.Functions["FPS Boost"](state)
    if state then
        print("[FPS Boost] Enabled")
        -- Nonaktifkan partikel, api, jejak, dll.
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
        -- setfpscap(60) -- Jika exploit mendukung
    else
        print("[FPS Boost] Disabled")
        -- Kembalikan ke default (opsional, bisa memakan resource)
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = true
            end
        end
    end
end

-- ... Tambahkan fungsi untuk fitur lainnya di sini ...


-- =====================================================
-- INISIALISASI UTAMA
-- =====================================================
createUI()
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[DOMBA TERSESAT HUB] Script Loaded! Use at your own risk.";
    Color = Color3.fromRGB(0, 255, 255);
    Font = Enum.Font.GothamBold;
})
