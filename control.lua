local function modify_starting_items()
    --Update character items (Mainly entities)
    if remote.interfaces["freeplay"] then
        local items_to_insert = remote.call("freeplay", "get_created_items")
        items_to_insert["omnidensator-1"] = (items_to_insert["omnidensator-1"] or 0) + 1
		items_to_insert["burner-omni-furnace"] = (items_to_insert["burner-omni-furnace"] or 0) + 1
		items_to_insert["crystallizer"] = (items_to_insert["crystallizer"] or 0) + 1
        --Start with 2 electric omnitractors to avoid unneeded handcrafting cellulose for fuel
        items_to_insert["omnitractor-1"] = 2
		--Start with 1 clarifier for the initial setup
		items_to_insert["clarifier"] = 1
		items_to_insert["omniphlog-1"] = 1
        --Nil the burner stuff
		items_to_insert["burner-mining-drill"] = nil
		items_to_insert["burner-omniphlog"] = nil
        items_to_insert["burner-omnitractor"] = nil
		remote.call("freeplay", "set_created_items", items_to_insert)

        remote.call("freeplay", "set_created_items", {})
    end

    --Add non entity starter items into Seablocks rocj chest
    local starter_items = {
        ["wood-pellets"] = 50,
        ["landfill"] = 200,
    }
    if game.active_mods["LandfillPainting"] then starter_items["landfill-sand-3"] = starter_items["landfill"] starter_items["landfill"] = nil end
    if game.active_mods["omnimatter_energy"] then starter_items["purified-omnite"] = starter_items["wood-pellets"] starter_items["wood-pellets"] = nil end
    if game.active_mods["omnimatter_wood"] then starter_items["omniwood"] = 20 end

    local remove_items = {
    }

    if remote.interfaces["SeaBlock"] then
        local old = remote.call("SeaBlock", "get_starting_items")
        for name, am in pairs(starter_items) do
            remote.call("SeaBlock", "set_starting_item", name, am + (old[name] or 0))
        end
        for _, name in pairs(remove_items) do
            remote.call("SeaBlock", "set_starting_item", name, nil)
        end
    end
end

local function set_unlocks()
    --Modify Seablocks startup Tech unlocks
    if remote.interfaces["SeaBlock"] then

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

            if game.active_mods["ScienceCostTweakerM"] then
                remote.call("SeaBlock", "set_unlock", "omnitor", {"sb-startup3", "omnitech-anbaric-lab"})
                remote.call("SeaBlock", "set_unlock", "omnitor-lab", {"energy-science-pack"})
            else
                remote.call("SeaBlock", "set_unlock", "omnitor", {"sb-startup3"})
                remote.call("SeaBlock", "set_unlock", "omnitor-lab", tech4)
            end
        end
    end
end

local function init()
    modify_starting_items()
    set_unlocks()
end


script.on_init(init)
script.on_configuration_changed(init)