if mods["omnimatter_energy"] then
    ------------------------
    ---Edit Startup Techs---
    ------------------------
    --Plan : instead of saph ore--> algaes-->circuits go for omnite-->omnicium-plates -->omnitors

    --Lets first make sure that all recipe unlocks get moved to other techs
    --Duplicates, just remove:
    omni.lib.remove_unlock_recipe("sb-startup2","basic-circuit-board")
    omni.lib.remove_unlock_recipe("sb-startup3","inserter")
    omni.lib.remove_unlock_recipe("sb-startup3","basic-transport-belt")

    --Move other unlocks somewhere else where it makes sense
    omni.lib.remove_unlock_recipe("sb-startup2","copper-cable")
    omni.lib.add_unlock_recipe("omnitech-anbaricity","copper-cable")

    --Create a new tech for algae farm + simple algae processing behind anbaricity
    omni.lib.remove_unlock_recipe("sb-startup1","algae-farm")
    omni.lib.remove_unlock_recipe("sb-startup1","algae-green-simple")
    
    TechGen:import("bio-processing-brown"):
                setName("algae-farm"):
                setPrereq("omnitech-anbaricity"):
                setPacks(1):
                setCost(10):
                nullUnlocks():
                addUnlocks("algae-farm","algae-green-simple"):
                setLocName({"recipe-name.algae-green-simple"}):
                extend()

    --Fix techs around that           
    omni.lib.replace_prerequisite("bio-paper-1","sb-startup2","algae-farm")
    omni.lib.replace_prerequisite("bio-wood-processing","sb-startup2","algae-farm")
    data.raw.technology["bio-paper-1"].unit.ingredients = {{type = "item", name = "automation-science-pack", amount = 15}}
    data.raw.technology["bio-wood-processing"].unit.ingredients = {{type = "item", name = "automation-science-pack", amount = 15}}
    omni.lib.set_prerequisite("sb-startup3","sb-startup2")
    --Put bio-wood-processing-2 behind 1
    omni.lib.replace_prerequisite("bio-wood-processing-2",omni.sea.tech4,"bio-wood-processing")

    --Add omnicium plate recipes as unlocks for startup 1
    omni.lib.add_unlock_recipe("sb-startup1","omnicium-plate-pure")
    omni.lib.add_unlock_recipe("sb-startup1","omnicium-plate-mix")

    --Edit startup 2 -->omnicium plate
    data.raw.tool["sb-algae-brown-tool"].icon = nil
	data.raw.tool["sb-algae-brown-tool"].icon_size = nil
	data.raw.tool["sb-algae-brown-tool"].icons = data.raw.item["omnicium-plate"].icons
	data.raw.tool["sb-algae-brown-tool"].localised_name = {"item-name.omnicium-plate"}
    data.raw.tool["sb-algae-brown-tool"].localised_description = "Get an Omnicium plate to complete this research."
    
    data.raw.technology["sb-startup2"].icon = nil
	data.raw.technology["sb-startup2"].icon_size = nil
	data.raw.technology["sb-startup2"].icons = data.raw.item["omnicium-plate"].icons
	data.raw.technology["sb-startup2"].localised_name = "Omnicium plate"
	data.raw.technology["sb-startup2"].localised_description = "Omnicium plates are the key material for progression in Omnimatter. Get them either by smelting crushed Omnite (lower yield) or Omnite together with Saphirite and Stiratite in an Omni furnace"
    
    --Add omnitor recipes as unlocks for startup 2
    omni.lib.add_unlock_recipe("sb-startup2","omnitor")

    --Edit startup 3 -->omnitor
	data.raw.tool["sb-basic-circuit-board-tool"].icon = nil
	data.raw.tool["sb-basic-circuit-board-tool"].icon_size = nil
	data.raw.tool["sb-basic-circuit-board-tool"].icons = data.raw.item["omnitor"].icons
	data.raw.tool["sb-basic-circuit-board-tool"].localised_name = {"item-name.omnitor"}
	data.raw.tool["sb-basic-circuit-board-tool"].localised_description = "Get an Omnitor to complete this research."

	data.raw.technology["sb-startup3"].icon = nil
	data.raw.technology["sb-startup3"].icon_size = nil
	data.raw.technology["sb-startup3"].icons = data.raw.item["omnitor"].icons
	data.raw.technology["sb-startup3"].localised_name = "Omnitor"
    data.raw.technology["sb-startup3"].localised_description = "Omnitors are the source for basic automation."
    
    --Add omnitor lab recipes as unlocks for startup 3
    omni.lib.add_unlock_recipe("sb-startup3","omnitor-lab")
    
    --Edit lab tech icon
	data.raw.tool["sb-lab-tool"].icon = "__omnimatter_energy__/graphics/icons/omnitor-lab.png"
	data.raw.tool["sb-lab-tool"].icon_size = 32
	data.raw.tool["sb-lab-tool"].localised_name = {"entity-name.omnitor-lab"}
	data.raw.tool["sb-lab-tool"].localised_description = "Get an Omnitor Lab to complete this research."
	
    --Remove the omnitor lab unlock from tech4
    omni.lib.remove_unlock_recipe(omni.sea.tech4,"omnitor-lab")

    local ignore_tech = {
        "omnitech-base-impure-extraction",
        "omnitech-simple-automation",
        "gun-turret",
        "stone-wall",
        "steel-processing"
    }
    --remove tech4 as prereq from all techs, if techs have no other prereqs then set anbaricity as prereq
    for _,tech in pairs(data.raw.technology) do
        if not omni.lib.is_in_table(tech.name, ignore_tech) then
            if omni.lib.is_in_table(omni.sea.tech4, tech.prerequisites) then
                omni.lib.remove_prerequisite(tech.name, omni.sea.tech4)
            end
            if not tech.prerequisites or not next(tech.prerequisites) then
                omni.lib.add_prerequisite(tech.name, "omnitech-anbaricity")
            end
        end
    end

    --Tech Fixes

    --Energy adds anabracity as prereq for everything electricity related without prereqs, remove that from sb-startup-1 to avoid loops
    omni.lib.remove_prerequisite("sb-startup1", "omnitech-anbaricity")
    
    --avoid tech loop
    omni.lib.remove_prerequisite("ore-crushing","automation")

    --Move basic-chemistry and water-washing-1 from prereqing automation to anbaricity
    omni.lib.replace_prerequisite("basic-chemistry","automation","omnitech-anbaricity")
    omni.lib.replace_prerequisite("water-washing-1","automation","omnitech-anbaricity")

    if mods["ScienceCostTweakerM"] then
        --SCT adds a split Lab+SP tech, edit the lab one to unlock the omnitor lab and move SCT lab stuff to the anbaric lab
        -- Move lab unlocks to the anbaric lab
        omni.lib.add_unlock_recipe("omnitech-anbaric-lab", "sct-lab1-construction")
        omni.lib.add_unlock_recipe("omnitech-anbaric-lab", "sct-lab1-mechanization")

        --Remove them from the starter lab tech:
        omni.lib.remove_unlock_recipe("sct-lab-t1","lab")
        omni.lib.remove_unlock_recipe("sct-lab-t1","sct-lab1-construction")
        omni.lib.remove_unlock_recipe("sct-lab-t1","sct-lab1-mechanization")

        --Add unlock for the omnitor lab
        --omni.lib.add_unlock_recipe("sct-lab-t1","omnitor-lab")

        --Add omni-tablet as red sp unlock
        omni.lib.add_unlock_recipe("sct-automation-science-pack","omni-tablet")

        --Remove logistic sp from electronics (required for logi SP)
        omni.lib.remove_science_pack("electronics", "logistic-science-pack")
        --Remove anbaric lab as preref from logi SP
        omni.lib.remove_prerequisite("logistic-science-pack", "omnitech-anbaric-lab")
        --Add anbaric lab as prereq for T2 lab
        omni.lib.add_prerequisite("sct-lab-t2", "omnitech-anbaric-lab")

        --Remove the boiler unlock from steam-power to its own tech (steam required for carbon which is required for greens)
        omni.lib.remove_unlock_recipe("omnitech-steam-power","boiler")
        --Copy boiler-2 if bobpower is active, else move it to chemistry
        if mods["bobpower"] then
            TechGen:import("bob-boiler-2"):
                setName("bob-boiler-1"):
                setPrereq("omnitech-anbaricity"):
                setPacks(1):
                setCost(20):
                nullUnlocks():
                addUnlocks("boiler"):
                extend()

            omni.lib.add_prerequisite("basic-chemistry","bob-boiler-1")
            omni.lib.add_prerequisite("bob-boiler-2","bob-boiler-1")
        else
            omni.lib.add_unlock_recipe("basic-chemistry","boiler")
        end
 
        --Copy over icon and localised stuff
        data.raw.technology["omnitech-anbaric-lab"].icon_size = data.raw.technology["sct-lab-t1"].icon_size
        data.raw.technology["omnitech-anbaric-lab"].icon = data.raw.technology["sct-lab-t1"].icon
        data.raw.technology["omnitech-anbaric-lab"].icons = data.raw.technology["sct-lab-t1"].icons
        data.raw.technology["omnitech-anbaric-lab"].localised_name = data.raw.technology["sct-lab-t1"].localised_name
        data.raw.technology["omnitech-anbaric-lab"].localised_description = data.raw.technology["sct-lab-t1"].localised_description

        data.raw.technology["sct-lab-t1"].icon = "__OmniSea__/graphics/technology/omnitor-lab-tech.png"
        data.raw.technology["sct-lab-t1"].icons = nil
	    data.raw.technology["sct-lab-t1"].localised_name = "Laboratory"
        data.raw.technology["sct-lab-t1"].localised_description = "Omnitor Labs are the first step of your evolution."

        --Unlock sct lab tech with the omnitor lab aswell
        data.raw.technology["sct-lab-t1"].unit = {count = 1, ingredients = {{"sb-lab-tool", 1}}, time = 5}

    else
        --Edit Startup 4 to unlock the omnitor lab
        data.raw.technology["sb-startup4"].icon = "__OmniSea__/graphics/technology/omnitor-lab-tech.png"
	    data.raw.technology["sb-startup4"].localised_name = "Laboratory"
        data.raw.technology["sb-startup4"].localised_description = "Omnitor Labs are the first step of your evolution."
        omni.lib.remove_unlock_recipe("sb-startup3", "lab")
    end

    --Remove inserter & belt from startup 2, add belt back to logistics
    omni.lib.remove_unlock_recipe("sb-startup2", "inserter")
    if data.raw.item["basic-transport-belt"] then 
        omni.lib.remove_unlock_recipe("sb-startup2", "basic-transport-belt")
        omni.lib.add_unlock_recipe("omnitech-basic-belt-logistics", "basic-transport-belt")
    else
        omni.lib.remove_unlock_recipe("sb-startup2", "transport-belt")
        omni.lib.add_unlock_recipe("omnitech-belt-logistics", "transport-belt")
    end

    --Remove the small electric pole from bio-wood-processing
    omni.lib.remove_unlock_recipe("bio-wood-processing", "small-electric-pole")

    --Disable ks power & bobs burner gens
    omni.lib.remove_unlock_recipe(omni.sea.tech4, "burner-generator")
    omni.lib.remove_unlock_recipe(omni.sea.tech4, "bob-burner-generator")
    omni.lib.disable_recipe("burner-generator")
    omni.lib.disable_recipe("bob-burner-generator")

    --Remove techs from startup4 that are unlocked later by energy
	omni.lib.remove_unlock_recipe(omni.sea.tech4, "electric-mining-drill")
	omni.lib.remove_unlock_recipe(omni.sea.tech4, "boiler")
    omni.lib.remove_unlock_recipe(omni.sea.tech4, "steam-engine")
    omni.lib.remove_unlock_recipe(omni.sea.tech4, "radar")
    omni.lib.add_unlock_recipe("omnitech-anbaricity", "radar")
end