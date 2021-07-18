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

    createNewPlayer(Player):Notify(Messages.GameJoined)

    return nil
end

-- Function For Ordering -- TODO: Give Player Order
function Machines.Order(prompt : ProximityPrompt)
    
    table.insert(Events,prompt.Triggered:Connect(function(Player)

        --If player doesnt exist, then return
        if not PlayerExist(Player) then
            return
        end


        Player = PlayerManager:FindPlayer(Player)


        --If player doesnt have tray, then return
        if not Player:HasTray() then
            Player:Notify(Messages.NoTrayError)
            return
        end
    

        --If order is recieved, then return
        if Player:HasRecievedOrder() then
            Player:Notify(Messages.OrderExistingError)
            return
        end

        --//TODO: Give Player an order

        Player:GiveOrder(true)
        Player:Notify(Messages.OrderRecieved)

    end))

end

--Function For Trays
function Machines.Tray(prompt : ProximityPrompt)
    
    table.insert(Events,prompt.Triggered:Connect(function(Player)
      
        
        if not PlayerExist(Player) then
            return
        end


        Player = PlayerManager:FindPlayer(Player)


        --If Player Has Tray, then return
        if Player:HasTray() then
            Player:Notify(Messages.TrayExistingError)
            return
        end

        --Give Tray
        Player:GiveTray(Tray.new())
        Player:Notify(Messages.TrayRecieved)
        
    end))

end

--Function For Bases -- TODO: Apply Base Colour
function Machines.Bases(prompt : ProximityPrompt)

    table.insert(Events,prompt.Triggered:Connect(function(Player)
        
        if not PlayerExist(Player) then
            return
        end

        Player = PlayerManager:FindPlayer(Player)

        if not Player:HasTray() then
            Player:Notify(Messages.NoTrayError)
            return
        end

        if not Player:GetTray():IsEquipped() then
            Player:Notify(Messages.TrayUnequippedError)
            return
        end

        if Player:HasCake() and Player:GetCake():HasBase() then
            Player:Notify(Messages.BaseExistingError)
            return
        end

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

        Player:Notify(Messages.BaseAdded)


    end))

end

--Function For Oven
function Machines.Oven(prompt : ProximityPrompt)
    
    table.insert(Events,prompt.Triggered:Connect(function(Player)

        if not PlayerExist(Player) then
            return
        end

        Player = PlayerManager:FindPlayer(Player)

        if not Player:HasCake() then
            Player:Notify(Messages.NoCakeError)
            return
        end

        if not Player:GetCake():HasBase() then
            Player:Notify(Messages.NoCakeBaseError)
            return
        end

        if Player:HasBakedCake() then
            Player:Notify(Messages.CakeBakedError)
            return
        end

        if not Player:GetTray():IsEquipped() then
            Player:Notify(Messages.TrayUnequippedError)
            return
        end

        Player:BakeCake()
        Player:Notify(Messages.CakeBaked)

    end))

end

--Function For  Icing
function Machines.Icing(prompt : ProximityPrompt)

    table.insert(Events,prompt.Triggered:Connect(function(Player)
        
        if not PlayerExist(Player) then
            return
        end

        Player = PlayerManager:FindPlayer(Player)

        if not Player:HasCake() then
           Player:Notify(Messages.NoCakeError)
           return
        end

        if not Player:GetCake():HasBase() then
            Player:Notify(Messages.NoCakeBaseError)
            return
        end

        if not Player:HasBakedCake() then
            Player:Notify(Messages.CakeUnbakedError)
            return
        end

        if not Player:GetCake():CanApplyIcing() then
            Player:Notify(Messages.IcingExistingError)
            return
        end

        if not Player:GetTray():IsEquipped() then
            Player:Notify(Messages.TrayUnequippedError)
            return
        end

        Player:GetCake():ApplyIcing(CakeEnums.Icings[Player:GetCake()().Name])
        Player:GetCake():ApplyIcingColour(CakeEnums.IcingColour[Player.IcingColour])

        Player:Notify(Messages.IcingApplied)

    end))
    
end

--Function for IcingToppings
function Machines.IcingToppings(prompt : ProximityPrompt)

    table.insert(Events,prompt.Triggered:Connect(function(Player)
        
        if not PlayerExist(Player) then
            return
        end

        Player = PlayerManager:FindPlayer(Player)

        if not Player:HasCake() then
            Player:Notify(Messages.NoCakeError)
            return
        end

        if not Player:GetCake():HasBase() then
            Player:Notify(Messages.NoCakeBaseError)
            return
        end

        if Player:GetCake():CanApplyIcing() then
            Player:Notify(Messages.NoIcingError)
            return
        end

        if not Player:GetCake():CanApplyIcingToppings() then
            Player:Notify(Messages.IcingToppingsExistingError)
            return
        end

        if not Player:GetTray():IsEquipped() then
            Player:Notify(Messages.TrayUnequippedError)
            return
        end

        Player:GetCake():ApplyIcingToppings(CakeEnums.IcingToppings[Player:GetCake()().Name])
        Player:GetCake():ApplyIcingToppingsFlavour(CakeEnums.BaseFlavours[Player.IcingToppingsFlavour])

        Player:Notify(Messages.IcingToppingsAdded)
    end))

end

--Function For Sprinkles --TODO: Apply Sprinkles
function Machines.Sprinkles(prompt : ProximityPrompt)
    
    table.insert(Events,prompt.Triggered:Connect(function(Player)
        
        if not PlayerExist(Player) then
            return
        end

        Player = PlayerManager:FindPlayer(Player)

        if not Player:HasCake() then
            Player:Notify(Messages.NoCakeError)
            return
        end
 
        
        if not Player:GetCake():HasBase() then
            Player:Notify(Messages.NoCakeBaseError)
            return
        end

        if Player:GetCake():CanApplyIcing() then
            Player:Notify(Messages.NoIcingError)
            return
        end
        
        if not Player:GetCake():CanApplySprinkles() then
            Player:Notify(Messages.SprinklesExistingError)
        end
        
        if not Player:GetTray():IsEquipped() then
            Player:Notify(Messages.TrayUnequippedError)
            return
        end



        Player:GetCake():ApplySprinkles(CakeEnums.Sprinkles[Player:GetCake()().Name][string.split(prompt.Parent.Parent.Name,":")[2]])
        Player:Notify(Messages.SprinklesAdded)


    end))

end

--Function For Toppings
function Machines.Toppings(prompt : ProximityPrompt) 
        
    table.insert(Events,prompt.Triggered:Connect(function(Player)
        
        if not PlayerExist(Player) then
            return
        end

        Player = PlayerManager:FindPlayer(Player)

        if not Player:HasCake() then
            Player:Notify(Messages.NoCakeError)
            return
        end
 
        
        if not Player:GetCake():HasBase() then
            Player:Notify(Messages.NoCakeBaseError)
            return
        end

        if Player:GetCake():CanApplyIcing() then
            Player:Notify(Messages.NoIcingError)
            return
        end

        
        if not Player:GetTray():IsEquipped() then
            Player:Notify(Messages.TrayUnequippedError)
            return
        end

        if not Player:GetCake():CanApplyCakeToppings() then
            Player:Notify(Messages.ToppingsExistingError)
            return
        end

        Player:GetCake():ApplyCakeToppings(CakeEnums.CakeToppings[string.split(prompt.Parent.Parent.Name,":")[2]])
        Player:Notify(Messages.ToppingsAdded)

    end))

end

--Function for Flavour Selector -- TODO Make Selector Object
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

        Player:Notify(
            string.format(
                Messages[SelectorName.."Selected"],
                SelectorTable[SelectorName]:ChangeFlavour(Player)
            )
        )

        
    end))

end





return Machines