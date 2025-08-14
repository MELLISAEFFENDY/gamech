local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = PlayerService.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local ButtonColorPrimary = Color3.fromRGB(150,255,150)
local ButtonColorSecondary = Color3.fromRGB(255,150,150)

local FischS = Instance.new("ScreenGui")
local ExitButton = Instance.new("TextButton")
local SellButton = Instance.new("TextButton")
local AutoReelFrame = Instance.new("Frame")
local AutoShakeFrame = Instance.new("Frame")

do
	local Main = Instance.new("Frame")
	local Button = Instance.new("TextButton")
	local TextLabel = Instance.new("TextLabel")
	local Button_2 = Instance.new("TextButton")
	local TextLabel_2 = Instance.new("TextLabel")
	local TextLabel_3 = Instance.new("TextLabel")

	FischS.Name = "FischS"
	FischS.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Main.Name = "Main"
	Main.Parent = FischS
	Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	Main.BorderColor3 = Color3.fromRGB(255, 255, 255)
	Main.Position = UDim2.new(0.716049373, 0, 0.365705609, 0)
	Main.Size = UDim2.new(0, 200, 0, 140)
	Main.Active = true
	Main.Draggable = true

	ExitButton.Name = "ExitButton"
	ExitButton.Parent = Main
	ExitButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ExitButton.BackgroundTransparency = 1.000
	ExitButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExitButton.BorderSizePixel = 0
	ExitButton.Position = UDim2.new(0, 175, 0, 0)
	ExitButton.Size = UDim2.new(0, 25, 0, 25)
	ExitButton.Font = Enum.Font.SourceSans
	ExitButton.Text = "X"
	ExitButton.TextColor3 = Color3.fromRGB(255, 0, 0)
	ExitButton.TextSize = 14.000

	AutoShakeFrame.Name = "AutoShake"
	AutoShakeFrame.Parent = Main
	AutoShakeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	AutoShakeFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
	AutoShakeFrame.Position = UDim2.new(0, 5, 0, 50)
	AutoShakeFrame.Size = UDim2.new(0, 190, 0, 25)

	Button.Name = "Button"
	Button.Parent = AutoShakeFrame
	Button.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
	Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Button.BorderSizePixel = 0
	Button.Size = UDim2.new(0, 15, 0, 15)
	Button.Font = Enum.Font.SourceSans
	Button.Position = UDim2.new(0, 5, 0, 5)
	Button.Text = ""
	Button.TextColor3 = Color3.fromRGB(0, 0, 0)
	Button.TextSize = 14.000

	TextLabel.Parent = AutoShakeFrame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0, 30, 0, 0)
	TextLabel.Size = UDim2.new(0, 100, 0, 25)
	TextLabel.Font = Enum.Font.Ubuntu
	TextLabel.Text = "Auto Shake"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 14.000
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	AutoReelFrame.Name = "AutoReel"
	AutoReelFrame.Parent = Main
	AutoReelFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	AutoReelFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
	AutoReelFrame.Position = UDim2.new(0, 5, 0, 80)
	AutoReelFrame.Size = UDim2.new(0, 190, 0, 25)

	Button_2.Name = "Button"
	Button_2.Parent = AutoReelFrame
	Button_2.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
	Button_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Button_2.BorderSizePixel = 0
	Button_2.Position = UDim2.new(0, 5, 0, 5)
	Button_2.Size = UDim2.new(0, 15, 0, 15)
	Button_2.Font = Enum.Font.SourceSans
	Button_2.Text = ""
	Button_2.TextColor3 = Color3.fromRGB(0, 0, 0)
	Button_2.TextSize = 14.000

	TextLabel_2.Parent = AutoReelFrame
	TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.BackgroundTransparency = 1.000
	TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_2.BorderSizePixel = 0
	TextLabel_2.Position = UDim2.new(0, 30, 0, 0)
	TextLabel_2.Size = UDim2.new(0, 100, 0, 25)
	TextLabel_2.Font = Enum.Font.Ubuntu
	TextLabel_2.Text = "Auto Reel"
	TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextSize = 14.000
	TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

	SellButton.Name = "SellButton"
	SellButton.Parent = Main
	SellButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	SellButton.BorderColor3 = Color3.fromRGB(200, 200, 200)
	SellButton.Position = UDim2.new(0, 5, 0, 110)
	SellButton.Size = UDim2.new(0, 190, 0, 25)
	SellButton.Font = Enum.Font.Ubuntu
	SellButton.Text = "Sell Inventory"
	SellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	SellButton.TextSize = 14.000
	SellButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

	TextLabel_3.Parent = Main
	TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_3.BackgroundTransparency = 1.000
	TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel_3.BorderSizePixel = 0
	TextLabel_3.Position = UDim2.new(0, 5, 0, 0)
	TextLabel_3.Size = UDim2.new(0, 100, 0, 25)
	TextLabel_3.Font = Enum.Font.Ubuntu
	TextLabel_3.Text = "Fisch Script"
	TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_3.TextSize = 14.000
	TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
	
	FischS.Parent = PlayerGui
end

ExitButton.MouseButton1Click:Connect(function()
	FischS:Destroy()
	script:Destroy()
end)

SellButton.MouseButton1Click:Connect(function()
	game:GetService("Workspace").world.npcs["Marc Merchant"].merchant.sellall:InvokeServer()
end)

local AutoShakeEnabled = false
local AutoReelEnabled = false

local Connections = {
	AutoShake = nil,
	AutoReel = nil,
}

local function MessageBox(title, content)
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = content,
		Duration = 10
	})
end

local function UpdateButtonColor(button, enabled)
	if enabled then
		button.BackgroundColor3 = ButtonColorPrimary
	else
		button.BackgroundColor3 = ButtonColorSecondary
	end
end

local function UpdateShakeUi(shakeui)
	local safezone = shakeui:WaitForChild("safezone")
	safezone.ChildAdded:Connect(function(child)
		child.Position = UDim2.new(0.5, 0, 0.5, 0)
		child.Size = UDim2.new(0.5, 0, 0.5, 0)
	end)
end

local function StepReelUi()
	local reel = PlayerGui:FindFirstChild("reel")
	if not reel then return end
	local bar = reel:FindFirstChild("bar")
	if not bar then return end
	local playerbar = bar:FindFirstChild("playerbar")
	local fish = bar:FindFirstChild("fish")
	if not playerbar or not fish then return end
	playerbar.Position = fish.Position
end

AutoShakeFrame.Button.MouseButton1Click:Connect(function()
	AutoShakeEnabled = not AutoShakeEnabled
	UpdateButtonColor(AutoShakeFrame.Button, AutoShakeEnabled)
	if Connections.AutoShake then Connections.AutoShake:Disconnect() end
	if AutoShakeEnabled then
		Connections.AutoShake = PlayerGui.ChildAdded:Connect(function(child)
			if child.Name ~= "shakeui" then return end
			UpdateShakeUi(child)
		end)
		MessageBox("Auto Shake", "Auto Shake Enabled")
	else
		MessageBox("Auto Shake", "Auto Shake Disabled")
	end
end)

AutoReelFrame.Button.MouseButton1Click:Connect(function()
	AutoReelEnabled = not AutoReelEnabled
	UpdateButtonColor(AutoReelFrame.Button, AutoReelEnabled)
	if Connections.AutoReel then Connections.AutoReel:Disconnect() end
	if AutoReelEnabled then
		Connections.AutoReel = RunService.RenderStepped:Connect(StepReelUi)
		MessageBox("Auto Reel", "Auto Reel Enabled")
	else
		MessageBox("Auto Reel", "Auto Reel Disabled")
	end
end)
