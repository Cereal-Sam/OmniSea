if mods["omnimatter_energy"] then

    --Disable ks power & bobs burner gens
    omni.lib.remove_unlock_recipe(omni.sea.tech4, "burner-generator")
    omni.lib.remove_unlock_recipe(omni.sea.tech4, "bob-burner-generator")
    omni.lib.disable_recipe("burner-generator")
    omni.lib.disable_recipe("bob-burner-generator")

    --Remove anbaric mining
    omni.lib.remove_prerequisite("automation-science-pack", "omnitech-anbaric-mining")
    data.raw.technology["omnitech-anbaric-mining"] = nil

    ---------------
    ---SCT FIXES---
    ---------------
    if mods["ScienceCostTweakerM"] then
        --Move some stuff that SCT messes up back to energy sp
        omni.lib.replace_prerequisite("omnitech-simple-automation", "sct-automation-science-pack", "energy-science-pack")


        omni.lib.remove_prerequisite("omnitech-base-impure-extraction", omni.sea.autosp)
        omni.lib.add_prerequisite("omnitech-base-impure-extraction", "energy-science-pack")

        log(serpent.block(data.raw.technology["omnitech-base-impure-extraction"]))

    end
end