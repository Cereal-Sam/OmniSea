if mods["omnimatter_energy"] then
    --Remove anbaric mining
    omni.lib.remove_prerequisite("automation-science-pack", "omnitech-anbaric-mining")
    data.raw.technology["omnitech-anbaric-mining"] = nil
end