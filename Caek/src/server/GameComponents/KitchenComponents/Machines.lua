--Class
local Machines = {}
Machines.__index = Machines

--Vars
local PlayerManager = nil
local Events        = {}
local Messages      = nil
local OrderSystem   = nil
local CakeEnums     = nil
local Cake          = nil

--Modules
local Tray      = require(script.Parent:FindFirstChild("Tray"))
local Selector = require(script.Parent:FindFirstChild("Selector"))

--Setup
function Machines.new(playerManager,messages,orderSystem,cakeEnums,cake)
	PlayerManager = playerManager
	Messages      = messages
	OrderSystem   = orderSystem
	CakeEnums     = cakeEnums
	Cake          = cake
	return Machines
end

--Utils

--creates new player
local function createNewPlayer(Player)
	PlayerManager:AddPlayer(Player)
	return PlayerManager:FindPlayer(Player)
end

--returns true if player exists else returns nil and creates new player
local function PlayerExist(Player)
	if PlayerManager:FindPlayer(Player) then 
		return true
	end

	createNewPlayer(Player):Notify("Notify",Messages.GameJoined)

	return nil
end

--[[

    Order

]]

local function OrderCheck(Player : Player)
	--If player doesnt exist, then return
	PlayerExist(Player)

	Player = PlayerManager:FindPlayer(Player)

	--If player doesnt have tray, then return
	if not Player:HasTray() then
		Player:Notify("Notify",Messages.NoTrayError)
		return false
	end


	--If order is recieved, then return
	if Player:HasRecievedOrder() then
		Player:Notify("Notify",Messages.OrderExistingError)
		return false
	end

	return true
end

function Machines.Order(prompt : ProximityPrompt)

	table.insert(Events,prompt.PromptButtonHoldBegan:Connect(OrderCheck))

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not OrderCheck(Player) then
			return
		end

		Player = PlayerManager:FindPlayer(Player)

		--//TODO: Give Player an order
		local OrderData,OrderNumber = OrderSystem:GetOrder()
		Player:GiveOrder(OrderData)
		Player:Notify("Notify",Messages.OrderRecieved)
		-- Remove From the UIs
		PlayerManager:NotfiyAll("Remove",OrderNumber)
	end))

end

--[[

    Tray

]]

local function TrayCheck(Player : Player)

	PlayerExist(Player)


	Player = PlayerManager:FindPlayer(Player)

	--If Player Has Tray, then return
	if Player:HasTray() then
		Player:Notify("Notify",Messages.TrayExistingError)
		return false
	end

	return true
end

function Machines.Tray(prompt : ProximityPrompt)

	table.insert(Events,prompt.PromptButtonHoldBegan:Connect(TrayCheck))

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not TrayCheck(Player) then
			return
		end

		Player = PlayerManager:FindPlayer(Player)

		--Give Tray
		Player:GiveTray(Tray.new())
		Player:Notify("Notify",Messages.TrayRecieved)

	end))

end

--[[

    Bases

]]

local function BaseCheck(Player : Player)

	if not PlayerExist(Player) then
		return false
	end

	Player = PlayerManager:FindPlayer(Player)

	if not Player:HasTray() then
		Player:Notify("Notify",Messages.NoTrayError)
		return false
	end

	if not Player:GetTray():IsEquipped() then
		Player:Notify("Notify",Messages.TrayUnequippedError)
		return false
	end

	if Player:HasCake() and Player:GetCake():HasBase() then
		Player:Notify("Notify",Messages.BaseExistingError)
		return false
	end

	return true
end

function Machines.Bases(prompt : ProximityPrompt)

	table.insert(Events,prompt.PromptButtonHoldBegan:Connect(BaseCheck))

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not BaseCheck(Player) then
			return
		end

		Player = PlayerManager:FindPlayer(Player)

		if not Player:HasCake() then
			Player:AddCake(Cake.new())
		end

        --[[

            prompt.Parent.Parent.Name = "Bases:(BaseName)"

            string.split("Bases:(BaseName)") = {"Bases","(BaseName)")

        ]]

		--//Adding Base
		Player:GetCake():ApplyBase(CakeEnums.Bases[string.split(prompt.Parent.Parent.Name,":")[2]])
		Player:GetCake():ApplyBaseFlavour(CakeEnums.BaseFlavours[Player.BaseFlavour  ])

		--//Visualising Base
		Player:GetCake():GetModel():SetPrimaryPartCFrame(
		Player:GetTray()().CFrame +
			Vector3.new(
				0,
				(Player:GetTray()().Size.Y/2) + (Player:GetCake()().Size.Y/2),
				0
			)
		)

		--//Welding to Crate
		local w = Instance.new("WeldConstraint",Player:GetTray()())
		w.Part0 = Player:GetTray()()
		w.Part1 = Player:GetCake()()

		--//Parenting Cake
		Player:GetCake():GetModel().Parent = Player:GetTray():GetTool()

		Player:Notify("Notify",Messages.BaseAdded)

		-- Base
		if Player:GetCake().Base.Name == Player.Order[1] then
			Player:Notify("Base",true)
		else
			Player:DecrementScore()
			Player:Notify("Base",false)
		end

		-- BaseFlavour
		if Player.BaseFlavour == Player.Order[2] then
			Player:Notify("BaseFlavour",true)
		else
			Player:DecrementScore()
			Player:Notify("BaseFlavour",false)
		end


	end))

end

--[[
    
    Oven

]]

local function OvenCheck(Player : Player)

	if not PlayerExist(Player) then
		return false
	end

	Player = PlayerManager:FindPlayer(Player)

	if not Player:HasCake() then
		Player:Notify("Notify",Messages.NoCakeError)
		return false
	end

	if not Player:GetCake():HasBase() then
		Player:Notify("Notify",Messages.NoCakeBaseError)
		return false
	end

	if Player:HasBakedCake() then
		Player:Notify("Notify",Messages.CakeBakedError)
		return false
	end

	if not Player:GetTray():IsEquipped() then
		Player:Notify("Notify",Messages.TrayUnequippedError)
		return false
	end

	return true
end


function Machines.Oven(prompt : ProximityPrompt)

	table.insert(Events,prompt.PromptButtonHoldBegan:Connect(OvenCheck))

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not OvenCheck(Player) then
			return
		end

		Player = PlayerManager:FindPlayer(Player)

		Player:BakeCake()
		Player:Notify("Notify",Messages.CakeBaked)

	end))

end

--[[

    Icing

]]

local function IcingCheck(Player : Player)


	if not PlayerExist(Player) then
		return false
	end

	Player = PlayerManager:FindPlayer(Player)

	if not Player:HasCake() then
		Player:Notify("Notify",Messages.NoCakeError)
		return false
	end

	if not Player:GetCake():HasBase() then
		Player:Notify("Notify",Messages.NoCakeBaseError)
		return false
	end

	if not Player:HasBakedCake() then
		Player:Notify("Notify",Messages.CakeUnbakedError)
		return false
	end

	if not Player:GetCake():CanApplyIcing() then
		Player:Notify("Notify",Messages.IcingExistingError)
		return false
	end

	if not Player:GetTray():IsEquipped() then
		Player:Notify("Notify",Messages.TrayUnequippedError)
		return false
	end

	return true
end

function Machines.Icing(prompt : ProximityPrompt)

	table.insert(Events,prompt.PromptButtonHoldBegan:Connect(IcingCheck))

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not IcingCheck(Player) then return end

		Player = PlayerManager:FindPlayer(Player)

		Player:GetCake():ApplyIcing(CakeEnums.Icings[Player:GetCake()().Name])
		Player:GetCake():ApplyIcingColour(CakeEnums.IcingColour[Player.IcingColour])

		Player:Notify("Notify",Messages.IcingApplied)

		-- Icing Colour
		if Player.IcingColour == Player.Order[3] then
			Player:Notify("Icing",true)
		else
			Player:DecrementScore()
			Player:Notify("Icing",false)
		end


	end))

end

--[[

    Icing Toppings

]]

local function IcingToppingsCheck(Player : Player)

	if not PlayerExist(Player) then
		return false
	end

	Player = PlayerManager:FindPlayer(Player)

	if not Player:HasCake() then
		Player:Notify("Notify",Messages.NoCakeError)
		return false
	end

	if not Player:GetCake():HasBase() then
		Player:Notify("Notify",Messages.NoCakeBaseError)
		return false
	end

	if Player:GetCake():CanApplyIcing() then
		Player:Notify("Notify",Messages.NoIcingError)
		return false
	end

	if not Player:GetCake():CanApplyIcingToppings() then
		Player:Notify("Notify",Messages.IcingToppingsExistingError)
		return false
	end

	if not Player:GetTray():IsEquipped() then
		Player:Notify("Notify",Messages.TrayUnequippedError)
		return false
	end

	return true
end


function Machines.IcingToppings(prompt : ProximityPrompt)

	table.insert(Events,prompt.Triggered:Connect(IcingToppingsCheck))

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not IcingToppingsCheck(Player) then
			return
		end

		Player = PlayerManager:FindPlayer(Player)

		Player:GetCake():ApplyIcingToppings(CakeEnums.IcingToppings[Player:GetCake()().Name])
		Player:GetCake():ApplyIcingToppingsFlavour(CakeEnums.BaseFlavours[Player.IcingToppingsFlavour])

		Player:Notify("Notify",Messages.IcingToppingsAdded)


		-- Icing Topping
		if Player.IcingToppingsFlavour == Player.Order[5] then
			Player:Notify("IcingTopping",true)
		else
			Player:DecrementScore()
			Player:Notify("IcingTopping",false)
		end

	end))

end

--[[

    Sprinkles

]]

local function SprinklesCheck(Player)
	if not PlayerExist(Player) then
		return false
	end

	Player = PlayerManager:FindPlayer(Player)

	if not Player:HasCake() then
		Player:Notify("Notify",Messages.NoCakeError)
		return false
	end


	if not Player:GetCake():HasBase() then
		Player:Notify("Notify",Messages.NoCakeBaseError)
		return false
	end

	if Player:GetCake():CanApplyIcing() then
		Player:Notify("Notify",Messages.NoIcingError)
		return false
	end

	if not Player:GetCake():CanApplySprinkles() then
		Player:Notify("Notify",Messages.SprinklesExistingError)
		return false
	end

	if not Player:GetTray():IsEquipped() then
		Player:Notify("Notify",Messages.TrayUnequippedError)
		return false
	end

	return true
end


function Machines.Sprinkles(prompt : ProximityPrompt)

	table.insert(Events,prompt.PromptButtonHoldBegan:Connect(SprinklesCheck))

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not SprinklesCheck(Player) then
			return
		end

		Player = PlayerManager:FindPlayer(Player)

		Player:GetCake():ApplySprinkles(CakeEnums.Sprinkles[Player:GetCake()().Name][string.split(prompt.Parent.Parent.Name,":")[2]])
		Player:Notify("Notify",Messages.SprinklesAdded)


		-- Sprinkles
		if Player:GetCake().Sprinkles.Name == Player.Order[4] then
			Player:Notify("Sprinkles",true)
		else
			Player:DecrementScore()
			Player:Notify("Sprinkles",false)
		end


	end))

end

--[[

    Toppings

]]

local function ToppingsCheck(Player: Player)

	if not PlayerExist(Player) then
		return false
	end

	Player = PlayerManager:FindPlayer(Player)

	if not Player:HasCake() then
		Player:Notify("Notify",Messages.NoCakeError)
		return false
	end

	if not Player:GetCake():HasBase() then
		Player:Notify("Notify",Messages.NoCakeBaseError)
		return false
	end

	if Player:GetCake():CanApplyIcing() then
		Player:Notify("Notify",Messages.NoIcingError)
		return false
	end

	if not Player:GetTray():IsEquipped() then
		Player:Notify("Notify",Messages.TrayUnequippedError)
		return false
	end

	if not Player:GetCake():CanApplyCakeToppings() then
		Player:Notify("Notify",Messages.ToppingsExistingError)
		return false
	end

	return true
end


function Machines.Toppings(prompt : ProximityPrompt)

	table.insert(Events,prompt.PromptButtonHoldBegan:Connect(ToppingsCheck))

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not ToppingsCheck(Player) then
			return
		end

		Player = PlayerManager:FindPlayer(Player)

		Player:GetCake():ApplyCakeToppings(CakeEnums.CakeToppings[string.split(prompt.Parent.Parent.Name,":")[2]])
		Player:Notify("Notify",Messages.ToppingsAdded)


		-- Toppings
		if Player:GetCake().CakeToppings.Name == Player.Order[6] then
			Player:Notify("Topping",true)
		else
			Player:DecrementScore()
			Player:Notify("Topping",false)
		end


	end))

end

--[[

    Flavour Selector

]]

local SelectorTable = {}


function Machines.Selector(prompt : ProximityPrompt)

	SelectorTable[string.split(prompt.Parent.Parent.Name,":")[2]] = Selector.new(
	prompt.Parent.Parent.Parent,
	(function()
		if string.split(prompt.Parent.Parent.Name,":")[2] == "IcingColour" then
			return CakeEnums.IcingColour
		end
		return CakeEnums.BaseFlavours
	end)(),
	string.split(prompt.Parent.Parent.Name,":")[2]
	)

	table.insert(Events,prompt.Triggered:Connect(function(Player)

		if not PlayerExist(Player) then
			return
		end

		Player = PlayerManager:FindPlayer(Player)
		local SelectorName = string.split(prompt.Parent.Parent.Name,":")[2]
		local SelectorIndex = prompt.Parent.Parent.Parent.Name:split(":")[1]

		local FlavourIndex, ChosenFlavour = SelectorTable[SelectorName]:ChangeFlavour(Player)

		Player:Notify(
			"Notify", -- Key
			string.format(
				Messages[SelectorName.."Selected"],
				ChosenFlavour
			)
		)

		Player:Notify(
			"Selector", -- Key
			""..tostring(SelectorIndex)..tostring(FlavourIndex+1)
		)


	end))

end

--[[

    Delivery

]]

local function DeliveryCheck(Player)

	if not PlayerExist(Player) then
		return false
	end

	Player = PlayerManager:FindPlayer(Player)

	if not Player:HasCake() then
		Player:Notify("Notify",Messages.NoCakeError)
		return false
	end

	if not Player:GetTray():IsEquipped() then
		Player:Notify("Notify",Messages.TrayUnequippedError)
		return false
	end

	if not Player:GetCake():HasBase() then
		Player:Notify("Notify",Messages.NoCakeBaseError)
		return false
	end

	if not Player:GetTray():IsEquipped() then
		Player:Notify("Notify",Messages.TrayUnequippedError)
		return false
	end

	if Player:GetCake():CanApplyIcing() then
		Player:Notify("Notify",Messages.NoIcingError)
		return false
	end

	if Player:GetCake():CanApplyCakeToppings() then
		Player:Notify("Notify",Messages.NoToppingsError)
		return false
	end

	return true
end

local Leaderboard = require(game:GetService("ReplicatedStorage"):FindFirstChild("DataManager"))

function Machines.Delivery(prompt : ProximityPrompt)

	-- Do a quick check when the player starts holding.
	table.insert(Events,prompt.PromptButtonHoldBegan:Connect(DeliveryCheck))

	-- When player finishes holding the button.
	table.insert(Events,prompt.Triggered:Connect(function(Player)

		-- Quick Check
		if not DeliveryCheck(Player) then
			return
		end

		-- Functionality
		Player = PlayerManager:FindPlayer(Player)


		-- Delivery Score
		if prompt.Name == Player.Order[7] then
			Player:Notify("DropOff",true)
			Player:Notify("Notify",Messages.Delivered)
		else
			Player:DecrementScore()
			Player:Notify("DropOff",false)
			Player:Notify("Notify",Messages.WrongDeliveryError)
		end

		Leaderboard.giveCoins(Player(),Player.Score)

        Player:Notify("Reset","")
		Player:Notify("ShowScore",tostring(Player.Score))
		Player:Reset()

	end))

end

return Machines