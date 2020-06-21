local DCM = require "__DeadlockCrating__/prototypes/shared"

DCM.ITEM_TIER = {
	[4] = {
		"wood",
		"iron-ore",
		"copper-ore",
		"stone",
		"coal",
		"iron-plate",
		"copper-plate",
		"steel-plate",
		"stone-brick"
	},
	[5] = {
		"copper-cable",
		"iron-gear-wheel",
		"iron-stick",
		"sulfur",
		"plastic-bar",
		"solid-fuel",
		"electronic-circuit",
		"advanced-circuit"
	}
}
DCM.TIERS = 5
DCM.TIER_COLOURS = {
	[1] = {r = 210, g = 180, b = 80},
	[2] = {r = 210, g = 60, b = 60},
	[3] = {r = 80, g = 180, b = 210},
	[4] = {r = 165, g = 10, b = 225},
	[5] = {r = 10, g = 225, b = 25}
}

if mods["boblogistics"] and mods["LoaderRedux"] then
	DCM.LOADER_ONE = "loader"
	DCM.LOADER_TWO = "fast-loader"
	DCM.LOADER_THREE = "express-loader"
	DCM.LOADER_FOUR = "purple-loader"
	DCM.LOADER_FIVE = "green-loader"
elseif mods["deadlock-integrations"] then
	DCM.LOADER_ONE = "transport-belt-beltbox"
	DCM.LOADER_TWO = "fast-transport-belt-beltbox"
	DCM.LOADER_THREE = "express-transport-belt-beltbox"
	if data.raw.item["ultimate-transport-belt-beltbox"] then
		DCM.LOADER_FOUR = "turbo-transport-belt-beltbox"
		DCM.LOADER_FIVE = "ultimate-transport-belt-beltbox"
	else
		DCM.LOADER_FOUR = "express-transport-belt"
		DCM.LOADER_FIVE = "express-transport-belt"
	end
else
	DCM.LOADER_ONE = "transport-belt"
	DCM.LOADER_TWO = "fast-transport-belt"
	DCM.LOADER_THREE = "express-transport-belt"
	if data.raw.item["ultimate-transport-belt"] then
		DCM.LOADER_FOUR = "turbo-transport-belt"
		DCM.LOADER_FIVE = "ultimate-transport-belt"
	else
		DCM.LOADER_FOUR = "express-transport-belt"
		DCM.LOADER_FIVE = "express-transport-belt"
	end
end

for tier = 1, DCM.TIERS do
	DCM.create_machine_entity(
		tier,
		nil,
		nil,
		nil,
		nil,
		nil,
		(tier < DCM.TIERS) and (DCM.MACHINE_PREFIX .. (tier + 1)) or nil,
		nil
	)
end

for tier = 4, DCM.TIERS do
	DCM.create_machine_item(tier)
end

DCM.create_machine_recipe(
	4,
	{
		{"deadlock-crating-machine-3", 1},
		{DCM.LOADER_FOUR, 4},
		{"steel-plate", 10}
	}
)

DCM.create_machine_recipe(
	5,
	{
		{"deadlock-crating-machine-4", 1},
		{DCM.LOADER_FIVE, 4},
		{"steel-plate", 10}
	}
)

data.raw.recipe[DCM.MACHINE_PREFIX .. "1"].ingredients = {
	{DCM.LOADER_ONE, 8},
	{"assembling-machine-1", 1},
	{"steel-plate", 10}
}

data.raw.recipe[DCM.MACHINE_PREFIX .. "2"].ingredients = {
	{DCM.MACHINE_PREFIX .. "1", 1},
	{DCM.LOADER_TWO, 4},
	{"steel-plate", 10}
}

data.raw.recipe[DCM.MACHINE_PREFIX .. "3"].ingredients = {
	{DCM.MACHINE_PREFIX .. "2", 1},
	{DCM.LOADER_THREE, 4},
	{"steel-plate", 10}
}

function getCraftingSpeed(level)
	return level * settings.startup["bobmods-logistics-beltspeedperlevel"].value / 15
end

if
	settings.startup["bobmods-logistics-beltoverhaulspeed"] and
		settings.startup["bobmods-logistics-beltoverhaulspeed"].value
 then
	-- yellow
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "1"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "1"].crafting_speed = getCraftingSpeed(2)
	end
	-- red
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "2"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "2"].crafting_speed = getCraftingSpeed(3)
	end
	-- blue
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "3"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "3"].crafting_speed = getCraftingSpeed(4)
	end
	-- purple
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "4"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "4"].crafting_speed = getCraftingSpeed(5)
	end
	-- green
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "5"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "5"].crafting_speed = getCraftingSpeed(6)
	end
end

-- set replace groups
for tier = 1, DCM.TIERS do
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. tier] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. tier].fast_replaceable_group = "crating-machine"
		if (tier < 5) then
			data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. tier].next_upgrade = DCM.MACHINE_PREFIX .. tier + 1
		else
			data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. tier].next_upgrade = ""
		end
	end
end

unit = table.deepcopy(data.raw.technology["inserter-capacity-bonus-6"].unit)
unit.count = unit.count * 2
DCM.create_crating_technology(4, nil, {DCM.TECH_PREFIX .. 3}, unit)

unit = table.deepcopy(data.raw.technology["inserter-capacity-bonus-7"].unit)
unit.count = unit.count * 2
DCM.create_crating_technology(5, nil, {DCM.TECH_PREFIX .. 4}, unit)
