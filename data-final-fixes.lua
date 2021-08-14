require("prototypes.compat.omnimatter_energy.data-final-fixes")

--Disable Mineralized-Water crystallization
RecGen:import("sb-water-mineralized-crystallization"):
	setEnabled(false):
	noTech():
	extend()

--Final energy compat
if not mods["omnimatter_energy"] then
	-- Remove the fuel value of Omnite and crushed Omnite without omni energy
	local remfuel = {
		"omnite",
		"crushed-omnite",
	}

	for _,entity in pairs(remfuel) do
		data.raw.item[entity].fuel_category = nil
		data.raw.item[entity].fuel_value = nil
	end
end