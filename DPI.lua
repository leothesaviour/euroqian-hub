-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local name = game:GetService("Players").LocalPlayer.Character
local isActive = false
local virtualUser = game:GetService("VirtualUser")

-- Function to send a notification
local function sendNotification(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 5;
        })
    end)
end

-- Create the ScreenGui named "Valindra's Fortitude"
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Valindra's Fortitude"
screenGui.Parent = playerGui

-- Create the main frame to hold all features
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Create a container for the buttons
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 0.6, 0)
buttonContainer.Position = UDim2.new(0, 10, 0.3, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local timeframe = Instance.new("TextLabel")
timeframe.Parent = screenGui
timeframe.Visible = false
timeframe.Size = UDim2.new(0.8, 0, 0.1, 0) -- Adjusted size for better visibility
timeframe.Position = UDim2.new(0.5, -30, 0, 10) -- Centered with a bit of padding
timeframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Match the background color of the title label
timeframe.TextScaled = true -- Automatic text scaling
timeframe.TextWrapped = true -- Allow text to wrap
timeframe.TextColor3 = Color3.fromRGB(255, 255, 255) -- Set text color for better contrast
timeframe.BorderSizePixel = 0 -- No border for a cleaner look
timeframe.BackgroundTransparency = 0.5
timeframe.Font = Enum.Font.SourceSans -- Choose a font that matches the title label

-- Minimize and Close Functionality
local isMinimized = false
local function toggleMinimize()
    isMinimized = not isMinimized
    buttonContainer.Visible = not isMinimized
    mainFrame.Size = isMinimized and UDim2.new(0.3, 0, 0.1, 0) or UDim2.new(0.3, 0, 0.4, 0)
end

local function closeGUI()
    screenGui:Destroy()
end

-- Create the title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.Text = "Valindra's Fortitude"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Parent = mainFrame

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeButton.Parent = mainFrame
minimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(closeGUI)

-- Toggle Button Functionality
local function createToggleButton(text, position, initialState, toggleCallback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0.2, 0)
    button.Position = UDim2.new(0, 0, position, 0)
    button.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    button.Text = text .. (initialState and " ON" or " OFF")
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.TextScaled = true
    button.Parent = buttonContainer
    button.MouseButton1Click:Connect(function()
        local newState = not initialState
        initialState = newState
        button.BackgroundColor3 = newState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        button.Text = text .. (newState and " ON" or " OFF")
        toggleCallback(newState)
    end)
    return button
end

local fishingConnection

local function startAutoFishing()
    local fishingFrame = playerGui:WaitForChild("ScreenGui"):WaitForChild("Fishing"):WaitForChild("Frame"):WaitForChild("FishFrame")
    local target = fishingFrame:WaitForChild("Target")
    local slider = fishingFrame:WaitForChild("Slider")
    local function updateSliderPosition()
        local targetPosition = target.Position.Y.Offset
        local newSliderPosition = targetPosition + math.random(40, 50)
        slider.Position = UDim2.new(slider.Position.X.Scale, slider.Position.X.Offset, 0, newSliderPosition)
    end
    -- Connect the RenderStepped to updateSliderPosition
	sendNotification("Euroqian's DPI Script", "Auto-fishing has now started.")
    fishingConnection = game:GetService("RunService").RenderStepped:Connect(updateSliderPosition)
end

local function stopAutoFishing()
    -- Disconnect the RenderStepped connection if it exists
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
		sendNotification("Euroqian's DPI Script", "Auto-fishing has now stopped.")
    end
end
local function dostats()
    name:SetAttribute("MaxStamina", 99999999)
    name:SetAttribute("MaxHunger", 99999999)
    name:SetAttribute("Stamina", 99999999)
    name:SetAttribute("Hunger", 99999999)
end

local function undostats()
	name:SetAttribute("MaxStamina", 100)
    name:SetAttribute("MaxHunger", 100)
    name:SetAttribute("Stamina", 100)
    name:SetAttribute("Hunger", 100)
end

-- Function to start the hygiene coroutine
local function startHygieneCoroutine()
    hygieneRunning = true
    hygieneCoroutine = coroutine.wrap(function()
        while hygieneRunning do
            name:SetAttribute("Hygiene", 100)
            wait(2) -- Adjust wait time as needed
        end
    end)
    hygieneCoroutine()
    sendNotification("Euroqian's DPI Script", "Infinite hygiene has now turned on.") -- Notification when starting
end

-- Function to stop the hygiene coroutine
local function stopHygieneCoroutine()
    hygieneRunning = false
    sendNotification("Euroqian's DPI Script", "Infinite hygiene has now stopped.") -- Notification when stopping
end

-- Function to start the time coroutine
local function startTimeCoroutine()
    timeRunning = true
	timeframe.Visible = true
    timeframe.Text = "Stop"
    timeCoroutine = coroutine.wrap(function()
        while timeRunning do
            local blurs = game:GetService("Players").LocalPlayer:GetAttribute("Insanity")
            local time = game:GetService("Lighting").TimeOfDay
            timeframe.Text = "Current Time: " .. time .. "\nBlurs: " .. blurs
            wait(1) -- Adjust wait time as needed
        end
    end)
    timeCoroutine()
    sendNotification("Euroqian's DPI Script", "Time tracking has now turned on.") -- Notification when starting
end

-- Function to stop the time coroutine
local function stopTimeCoroutine()
    timeRunning = false
	timeframe.Visible = false
    timeframe.Text = "Click here to start showing the current time, alongside with Insanity."
    sendNotification("Euroqian's DPI Script", "Time tracking has now turned off.") -- Notification when stopping
end

local function antiAFKStart()
    sendNotification("Euroqian's DPI Script", "ANTI-AFK is now on.")
    isActive = true
    game.Players.LocalPlayer.Idled:Connect(function()
        virtualUser:CaptureController()
        virtualUser:ClickButton2(Vector2.new())
        sendNotification("Euroqian's DPI Script", "ANTI-AFK: Roblox tried to kick you but has been prevented!")
    end)
end

local function antiAFKStop()
    isActive = false
	sendNotification("Euroqian's DPI Script", "ANTI-AFK is now off.")
end

local function toggleAntiAFK(state)
    if state and not isActive then
        antiAFKStart()
    elseif not state and isActive then
        antiAFKStop()
    end
end
-- Toggle button handlers
local function toggleAutoFish(state)
    if state then
        startAutoFishing()
    else
        stopAutoFishing()
    end
end

local function toggleHygiene(state)
    if state then
        startHygieneCoroutine()
    else
        stopHygieneCoroutine()
    end
end

local function toggleTime(state)
    if state then
        startTimeCoroutine()
    else
        stopTimeCoroutine()
    end
end

local function toggleStats(state)
    if state then
	    dostats()
        sendNotification("Infinite Stats", "Infinite Stats Refreshed")
    else
	    undostats()
        sendNotification("Infinite Stats", "Infinite Stats Reverted to Default")
    end
end

-- Create toggle buttons
local autoFishButton = createToggleButton("Auto fish", 0, false, toggleAutoFish)
local showTimeButton = createToggleButton("Show time/blur", 0.25, false, toggleTime)
local refreshStatsButton = createToggleButton("Infinite Stats", 0.5, false, toggleStats)
local infiniteHygieneButton = createToggleButton("Infinite Hygiene", 0.75, false, toggleHygiene)
local afkButton = createToggleButton("Anti-AFK", 1, false, toggleAntiAFK)

-- Footer label
local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, 0, 0.1, 0)
footerLabel.Position = UDim2.new(0, 0, 1.01, 0)
footerLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
footerLabel.Text = "By Euroqian | leothesaviour"
footerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
footerLabel.TextScaled = true
footerLabel.Parent = mainFrame



