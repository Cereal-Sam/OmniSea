local function modify_starting_items()
	if remote.interfaces["freeplay"] then
		local items_to_insert = remote.call("freeplay", "get_created_items")
		-- local landfill = "landfill"
		-- if game.item_prototypes["landfill-sand-3"] then
		-- 	landfill = "landfill-sand-3"
		-- end
		items_to_insert["omnidensator-1"] = (items_to_insert["omnidensator-1"] or 0) + 1
		items_to_insert["burner-omni-furnace"] = (items_to_insert["burner-omni-furnace"] or 0) + 1
		items_to_insert["crystallizer"] = (items_to_insert["crystallizer"] or 0) + 1
		--Give some starter fuel for the first furnace & crusher
		items_to_insert["wood-pellets"] = (items_to_insert["wood-pellets"] or 0) + 50
		items_to_insert["landfill"] = (items_to_insert["landfill"] or 0) + 200
		--Nil the burner mining drill that omnimatter inserts
		items_to_insert["burner-mining-drill"] = nil
		--Start with 2 electric omnitractors to avoid unneeded handcrafting cellulose for fuel
		items_to_insert["omnitractor-1"] = 2
		items_to_insert["burner-omnitractor"] = nil
		--Start with 1 clarifier for the initial setup
		items_to_insert["clarifier"] = 1
		--Swap burner phlog into electric
		items_to_insert["omniphlog-1"] = 1
		items_to_insert["burner-omniphlog"] = nil
		remote.call("freeplay", "set_created_items", items_to_insert)
	end
end

local function call_remote_interfaces()
	--Modify Seablocks startup Tech unlocks
	if remote.interfaces["SeaBlock"] then
		--local unlocks = remote.call("SeaBlock","get_unlocks")
		--log(serpent.block(unlocks))

		--First tech unlocks with omnnite now
		remote.call("SeaBlock", "set_unlock", "angels-ore3-crushed", nil)
		remote.call("SeaBlock", "set_unlock", "omnite", {"sb-startup1", "landfill"})

		--Omnimatter Energy : complete overhaul
		if game.active_mods["omnimatter_energy"] then
			local tech4 = {"sb-startup4"}
			if game.active_mods["ScienceCostTweakerM"] then tech4 = {"sct-automation-science-pack", "sct-lab-t1"} end

			--Nil all default starter Tech unlocks since we modified each
			local unlocks = remote.call("SeaBlock", "get_unlocks")
			for k,v in pairs(unlocks) do
				remote.call("SeaBlock", "set_unlock", k, nil)
			end

			remote.call("SeaBlock", "set_unlock", "omnite", {"sb-startup1", "landfill"})
			remote.call("SeaBlock", "set_unlock", "omnicium-plate", {"sb-startup2"})
			remote.call("SeaBlock", "set_unlock", "omnitor", {"sb-startup3"})
			remote.call("SeaBlock", "set_unlock", "omnitor-lab", tech4)
		end
	end
end

local function init()
	modify_starting_items()
	call_remote_interfaces()
end

script.on_init(init)