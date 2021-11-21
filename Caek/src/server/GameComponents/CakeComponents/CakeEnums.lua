--[[

	Enums for Cake

	Bases
	Icings
	IcingToppings
	Sprinkles
	CakeToppings
	BaseFlavours
	IcingFlavour

]]

local CakeEnums = {}
local n = {}
local Storage   = game:GetService("ReplicatedStorage"):FindFirstChild("Storage")

--//Base
CakeEnums.Bases         = {}
CakeEnums.Icings        = {}
CakeEnums.IcingToppings = {}
CakeEnums.Sprinkles     = {}
CakeEnums.CakeToppings  = {}

n.Bases        = {}
n.Icings        = {}
n.IcingToppings = {}
n.Sprinkles     = {}
n.CakeToppings  = {}


--//Referencing
for index, Table in pairs(CakeEnums) do
	table.foreach(Storage[index]:GetChildren(),function(_,model)
        Table[model.Name] = model
		table.insert(n[index],model.Name)
	end)
end

for index,_ in pairs(CakeEnums.Sprinkles) do
	CakeEnums.Sprinkles[index] = {}
	n.Sprinkles[index] = {}
	for _,child in pairs(Storage.Sprinkles[index]:GetChildren()) do
		CakeEnums.Sprinkles[index][child.Name] = child
	table.insert(n.Sprinkles[index],child.Name)
	end
end

--//Base Flavours
CakeEnums.BaseFlavours = {
	["Chocolate"   ] =  Color3.fromRGB(98,52,18);
	["Vanilla"     ] =  Color3.fromRGB(243, 229, 171);
	["Strawberry"  ] =  Color3.fromRGB(252, 146, 215);
	["Marble"      ] =  Color3.fromRGB(255,255,255);
	["BlueBerry"   ] =  Color3.fromRGB(79, 134, 247);
	["RedVelvet"   ] =  Color3.fromRGB(127,42,60);
	["Carrot"      ] =  Color3.fromRGB(237,145,33);
	["BlackForest" ] =  Color3.fromRGB(19, 18, 18);
	["Lemon"       ] =  Color3.fromRGB(255,244,139);
}

--//Icing Flavours
CakeEnums.IcingColour = {
	["Chocolate"   ] =  Color3.fromRGB(73, 38, 13);
	["Vanilla"     ] =  Color3.fromRGB(255, 232, 140);
	["Strawberry"  ] =  Color3.fromRGB(252, 115, 215);
	["Marble"      ] =  Color3.fromRGB(245, 241, 241);
	["BlueBerry"   ] =  Color3.fromRGB(79, 82, 247);
	["RedVelvet"   ] =  Color3.fromRGB(127, 42, 51);
	["Carrot"      ] =  Color3.fromRGB(237, 172, 33);
	["BlackForest" ] =  Color3.fromRGB(12, 11, 11);
	["Lemon"       ] =  Color3.fromRGB(255, 245, 151);
}

n.BaseFlavours = {}
n.IcingColour  = {}
for Index,_ in pairs(CakeEnums.BaseFlavours) do
	table.insert(n.BaseFlavours,Index)
end

n.IcingColour = n.BaseFlavours
CakeEnums.n = n

return CakeEnums