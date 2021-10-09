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


function Selector:ChangeFlavour(Player)
    
    local CurrentFlavourIndex
    local Children = self.Model:GetChildren()

    for _,x in pairs(Children) do
        if string.sub(x.Name,3) == Player[self.SelectorName]then
            CurrentFlavourIndex = tonumber(x.Name:sub(1,1))
            if CurrentFlavourIndex == 9 then
                CurrentFlavourIndex = 0
            end
            break
        end
    end

    for _,x in pairs(Children) do
        if string.sub(x.Name,0,1) == tostring(CurrentFlavourIndex + 1) then
            Player[self.SelectorName] = string.sub(x.Name,3)
        end
    end

    return CurrentFlavourIndex,Player[self.SelectorName]
end

return Selector