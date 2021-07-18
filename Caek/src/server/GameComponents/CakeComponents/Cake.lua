--[[
    __call

    function Cake:GetModel()

    function Cake:HasBase()
    function Cake:ApplyBase(base)

    function Cake:CanApplyBaseFlavour()
    function Cake:ApplyBaseFlavour(flavour)

    function Cake:CanApplyIcing()
    function Cake:ApplyIcing(Icing)
   
    function Cake:CanApplyIcingColour()
    function Cake:ApplyIcingColour(Colour)
    
    function Cake:CanApplyIcingToppings()
    function Cake:ApplyIcingToppings(IcingToppings)
    
    function Cake:CanApplyIcingToppingFlavour()
    function Cake:ApplyIcingToppingsFlavour(Flavour)
    
    function Cake:CanApplySprinkles()
    function Cake:ApplySprinkles(Sprinkles)
    
    function Cake:CanApplyCakeToppings()
    function Cake:ApplyCakeToppings(Toppings)
]]

--//Misc
local Storage = {} --//Our Enums

--//Private Functions

--//Adding Base
local function AddBase(self,base)
    self.Base = base:Clone()
    self.Base.Parent = self.Cake
    self.Cake.PrimaryPart = self.Base

    return self.Base
end

--//Applying Base Flavour
local function ApplyBaseFlavour(self,flavour)
    self.Base.Color  = flavour

    return flavour
end

--//Applying Icing
local function ApplyIcing(self,icing)
    icing = icing:Clone()

    --//Sizing
    icing.Size = Vector3.new(
        self().Size.X + 0.1,
        icing.Size.Y,
        self().Size.Z + 0.1
    )

    --//Positioning
    icing.CFrame = self().CFrame + Vector3.new(
        0,
        (icing.Size.Y / 4) + 0.05,
        0
    )

    --//Connecting
    local w = Instance.new("WeldConstraint")
    w.Part0 = self()
    w.Part1 = icing
    w.Parent = self()

    --//Visualising and Referencing
    icing.Parent = self.Cake

    return icing
end

--//Applying Icing Colour
local function ApplyIcingColour(self,Colour)
    self.Icing.Color = Colour

    return Colour
end

--//Applying IcingToppings
local function ApplyIcingToppings(self,Toppings)
    Toppings = Toppings:Clone()

    --//Sizing
    Toppings.Size = Vector3.new(
        self().Size.X,
        Toppings.Size.Y,
        self().Size.Z
    )

    --//Positioning
    Toppings.CFrame = self().CFrame + Vector3.new(
        0,
        (self().Size.Y/2 ),
        0
    )

    --//Connecting
    local w = Instance.new("WeldConstraint")
    w.Part0 = self()
    w.Part1 = Toppings
    w.Parent = self()

    --//Visualising and Referencing
    Toppings.Parent = self.Cake

    return Toppings
end

--//Applying Icing Toppings Colour
--//Applying Icing Colour
local function ApplyIcingToppingsColour(self,Colour)
    self.IcingToppings.Color = Colour
     return Colour
end

--//Applying Sprinkles
local function ApplySprinkles(self,Sprinkles)
    Sprinkles = Sprinkles:Clone()

    --//Sizing
    Sprinkles.Size = Vector3.new(
        self().Size.X,
        Sprinkles.Size.Y,
        self().Size.Z
    )

    --//Positioning
    Sprinkles.CFrame = self().CFrame + Vector3.new(
        0,
        (self().Size.Y/2 ),
        0
    )

    --//Connecting
    local w = Instance.new("WeldConstraint")
    w.Part0 = self.Base
    w.Part1 = Sprinkles
    w.Parent = self.Base

    --//Visualising and Referencing
    Sprinkles.Parent = self.Cake

    return Sprinkles
end

--//Applying Toppings
local function ApplyToppings(self,Toppings)
    Toppings = Toppings:Clone()

    --//Positioning
    Toppings.CFrame = self().CFrame + Vector3.new(
        0,
        self().Size.Y/2 + Toppings.Size.Y/2,
        0
    )

    --//Connecting
    local w = Instance.new("WeldConstraint")
    w.Part0 = self.Base
    w.Part1 = Toppings
    w.Parent = self.Base

    --//Visualising and Referencing
    Toppings.Parent = self.Cake

    return Toppings
end

--//Object
local Cake = {}
Cake.__index = Cake

function Cake.new()
    local self = {}
    setmetatable(self,Cake)

    self.Cake                 = Instance.new("Model")
    self.Base                 = nil
    self.BaseFlavour          = nil
    self.Icing                = nil
    self.IcingColour          = nil
    self.Sprinkles            = nil
    self.IcingToppings        = nil
    self.IcingToppingsFlavour = nil
    self.CakeToppings         = nil


    return self
end

--Methods
--//To directly get cake
Cake.__call = function(cake)
    return cake.Base
end

--//To return our current cake
function Cake:GetModel()
    return self.Cake
end

--//For Base
function Cake:HasBase()
   return self.Base ~= nil
end

function Cake:ApplyBase(base)
    self.Base = AddBase(self,base)
end

--//For Base Flavour
function Cake:CanApplyBaseFlavour()
    return not self.BaseFlavour
end

function Cake:ApplyBaseFlavour(flavour)
    self.BaseFlavour = ApplyBaseFlavour(self,flavour)
end

--//Apply Icing
function Cake:CanApplyIcing()
    return not self.Icing
end

function Cake:ApplyIcing(Icing)
    self.Icing = ApplyIcing(self,Icing)
end

--//Apply Icing Colour
function Cake:CanApplyIcingColour()
    return not self.IcingColour
end

function Cake:ApplyIcingColour(Colour)
    self.IcingColour = ApplyIcingColour(self,Colour)
end

--//Apply Icing Toppings
function Cake:CanApplyIcingToppings()
    return not self.IcingToppings
end

function Cake:ApplyIcingToppings(IcingToppings)
    self.IcingToppings = ApplyIcingToppings(self,IcingToppings)
end

--//Apply Icing Topping Colour
function Cake:CanApplyIcingToppingFlavour()
    return not self.IcingToppingsFlaour
end

function Cake:ApplyIcingToppingsFlavour(Flavour)
    self.IcingToppingsFlaour = ApplyIcingToppingsColour(self,Flavour)
end

--//Applying Sprinkles
function Cake:CanApplySprinkles()
    return not self.Sprinkles
end

function Cake:ApplySprinkles(Sprinkles)
    self.Sprinkles = ApplySprinkles(self,Sprinkles)
end

--//Applying Toppings
function Cake:CanApplyCakeToppings()
    return not self.CakeToppings
end

function Cake:ApplyCakeToppings(Toppings)
    self.CakeToppings = ApplyToppings(self,Toppings)
end


return Cake
