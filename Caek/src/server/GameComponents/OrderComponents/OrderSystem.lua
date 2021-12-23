--[[

    function OrderSystem.new()
    function OrderSystem:GetOrder()

]]


--Modules
local OrderSystem       = require(script.Parent:FindFirstChild("Order")).new()

-- Order Folder
local DisplayerFolder = Instance.new("Folder")
DisplayerFolder.Name = "DisplayerFolder"
DisplayerFolder.Parent = game:GetService("ReplicatedStorage")

--Vars
local OrderList = {}
local Orders = 0

local Processing = false

--Functions
local function AddNewOrder(order)
    repeat
        task.wait(1)
    until not Processing
    
    Processing = true

    Orders = Orders + 1
    table.insert(OrderList,order)
    local DisplayCake = OrderSystem:GetCakeFromOrderSheet(order)
    DisplayCake.Name = tostring(Orders)
    DisplayCake.Parent = DisplayerFolder

    Processing = false
end

local function RemoveOrder()
    local order = OrderList[Orders]
    table.remove(OrderList,Orders)
    local Data = OrderSystem:GetClientEncodedData(order)
    Orders = Orders - 1
    print(Orders)
    return Data,Orders+1
end

local function ReconcileOrderList()
    while task.wait(math.random(0,10)) do
        
        if Orders == 8 then
            continue
        end
        math.randomseed(tick())
        AddNewOrder(OrderSystem:CreateNewOrder())
        task.wait(5)
    end
end

--Class
local OrderSystem = {}
OrderSystem.__index = OrderSystem

--Constructor
function OrderSystem.new(displayer)

    local self = {}
    setmetatable(self,OrderSystem)


    coroutine.wrap(ReconcileOrderList)()

    return self
end

--Methods
function OrderSystem:GetOrder()
    return RemoveOrder()
end

return OrderSystem