local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Verificar se já existe um ScreenGui com o nome "ModMenuGui"
if playerGui:FindFirstChild("ModMenuGui") then
    return
end

-- URL da API do GitHub para listar os scripts
local GITHUB_USER = "SEU_USUARIO"
local GITHUB_REPO = "SEU_REPOSITORIO"
local SCRIPTS_FOLDER_URL = "https://api.github.com/repos/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/contents/scripts"

-- Função para carregar scripts dinamicamente
local function loadScripts()
    local success, response = pcall(function()
        return HttpService:GetAsync(SCRIPTS_FOLDER_URL, true)
    end)

    if not success then
        warn("Erro ao carregar scripts: " .. response)
        return
    end

    local scriptsData = HttpService:JSONDecode(response)
    for _, scriptData in ipairs(scriptsData) do
        if scriptData.type == "file" and string.sub(scriptData.name, -4) == ".lua" then
            local scriptName = string.sub(scriptData.name, 1, -5) -- Remove a extensão .lua
            local scriptUrl = scriptData.download_url

            createButton(scriptName, function()
                loadstring(game:HttpGet(scriptUrl))()
            end)
        end
    end
end

-- Criação do GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenuGui"
ScreenGui.Parent = playerGui

local ModMenu = Instance.new("Frame")
ModMenu.Name = "ModMenu"
ModMenu.Parent = ScreenGui
ModMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ModMenu.Size = UDim2.new(0, 250, 0, 400)
ModMenu.Position = UDim2.new(0.1, 0, 0.1, 0)
ModMenu.Active = true
ModMenu.Draggable = true
ModMenu.ClipsDescendants = true

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = ModMenu
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Text = "Maximum Explorer"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 40, 1, 0)
MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 18

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Parent = ModMenu
Content.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Content.Size = UDim2.new(1, -20, 1, -100)
Content.Position = UDim2.new(0, 10, 0, 90)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 8

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = Content
ListLayout.Padding = UDim.new(0, 5)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Buttons = {}

local function updateCanvasSize()
    local totalHeight = 0
    for _, button in pairs(Buttons) do
        totalHeight = totalHeight + button.Size.Y.Offset + ListLayout.Padding.Offset
    end
    Content.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

local function createButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = Content
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.MouseButton1Click:Connect(callback)
    table.insert(Buttons, Button)
    
    updateCanvasSize()
end

-- Carregar scripts dinamicamente
loadScripts()
