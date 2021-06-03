if mods["omnimatter_energy"] then
    --SCT Lab Fixes to avoid a temporary tech loop between updates and final-fixes stage
    if mods["ScienceCostTweakerM"] then
        --SCT adds a split Lab+SP tech, edit the lab one to unlock the omnitor lab and move SCT lab stuff to the anbaric lab
        --Recreate the anbaric lab tech (doesnt exist with SCT) by deepcopying SCT lab and lock it behind anbaricity
        TechGen:import("sct-lab-t1"):
            setName("omnitech-anbaric-lab"):
            setPrereq("omnitech-anbaricity"):
            setPacks(1):
            setCost(55):
            extend()
        --Set icon size manually to avoid a crash with current omnilib version. TODO: remove this next version
        data.raw.technology["omnitech-anbaric-lab"].icon_size = 128

        --Remove t1 lab stuff from the starter lab tech:
        omni.lib.remove_unlock_recipe("sct-lab-t1","lab")
        omni.lib.remove_unlock_recipe("sct-lab-t1","sct-lab1-construction")
        omni.lib.remove_unlock_recipe("sct-lab-t1","sct-lab1-mechanization")
        omni.lib.remove_prerequisite("sct-lab-t1", "omnitech-anbaricity")
    end
end