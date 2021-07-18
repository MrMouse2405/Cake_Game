--Class
local Selector = {}
Selector.__index = Selector

--Constructor
function Selector.new(Model,Flavours,SelectorName)
    
    local self = {}
    setmetatable(self,Selector)

    self.Model = Model
    self.Flavours = Flavours
    self.SelectorName = SelectorName

    return self
end

--Utils
local function findn(Table, number)
    local count = 1
    for _,x in pairs(Table) do
        if count == number then
            return x
        end
        count += 1;
    end
end


function Selector:ChangeFlavour(Player)
    
    local CurrentFlavourIndex

    for _,x in pairs(self.Model:GetChildren()) do
        
        if string.sub(x.Name,3) == Player[self.SelectorName]then
            CurrentFlavourIndex = tonumber(string.sub(x.Name,0,1))
            if CurrentFlavourIndex == 9 then
                CurrentFlavourIndex = 0
            end
            break
        end
    end

    for _,x in pairs(self.Model:GetChildren()) do
        if string.sub(x.Name,0,1) == tostring(CurrentFlavourIndex + 1) then
            Player[self.SelectorName] = string.sub(x.Name,3)
        end
    end

    return Player[self.SelectorName]
end

return Selector