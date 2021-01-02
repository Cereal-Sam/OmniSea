--Edit Startup 2
if mods["omnimatter_energy"] then
	data.raw.tool["sb-basic-circuit-board-tool"].icon = nil
	data.raw.tool["sb-basic-circuit-board-tool"].icon_size = nil
	data.raw.tool["sb-basic-circuit-board-tool"].icons = data.raw.item["omnitor"].icons
	data.raw.tool["sb-basic-circuit-board-tool"].localised_name = {"item-name.omnitor"}
	data.raw.tool["sb-basic-circuit-board-tool"].localised_description = "Get an Omnitor to complete this research."

	data.raw.technology["sb-startup2"].icon = nil
	data.raw.technology["sb-startup2"].icon_size = nil
	data.raw.technology["sb-startup2"].icons = data.raw.item["omnitor"].icons
	data.raw.technology["sb-startup2"].localised_name = "Omnitor"
	data.raw.technology["sb-startup2"].localised_description = "Omnitors are the source for basic automation."
	
	data.raw.tool["sb-lab-tool"].icon = "__omnimatter_energy__/graphics/icons/omnitor-lab.png"
	data.raw.tool["sb-lab-tool"].icon_size = 32
	data.raw.tool["sb-lab-tool"].localised_name = {"entity-name.omnitor-lab"}
	data.raw.tool["sb-lab-tool"].localised_description = "Get an Omnitor Lab to complete this research."
	
	
    
    --Remove the omnitor lab unlock from tech
    omni.lib.remove_unlock_recipe(omni.sea.tech4,"omnitor-lab")
    omni.lib.enable_recipe("omnitor-lab")

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
    omni.lib.remove_prerequisite("sct-lab-t2", "electronics")
    --avoid tech loop
    omni.lib.remove_prerequisite("basic-chemistry","automation")
    omni.lib.remove_prerequisite("ore-crushing","automation")

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
        omni.lib.add_unlock_recipe("sct-lab-t1","omnitor-lab")
        
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


    else
        --Edit Startup 4 to unlock the omnitor lab
        data.raw.technology["sb-startup4"].icon = "__OmniSea__/graphics/technology/omnitor-lab-tech.png"
	    data.raw.technology["sb-startup4"].localised_name = "Laboratory"
        data.raw.technology["sb-startup4"].localised_description = "Omnitor Labs are the first step of your evolution."
        omni.lib.remove_unlock_recipe("bio-wood-processing", "lab")
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