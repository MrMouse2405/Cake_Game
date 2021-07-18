--Class
local OrderDisplayer = {}
OrderDisplayer.__index = OrderDisplayer

--Constructor
function OrderDisplayer.new(Model)
    
    local self = {}
    setmetatable(self,OrderDisplayer)

    return OrderDisplayer
end

return OrderDisplayer