--Set triggers
if not omni then omni = {} end
if not omni.sea then omni.sea = {} end

if data.raw.technology["sct-automation-science-pack"] then
    omni.sea.autosp = "sct-automation-science-pack"
else
    omni.sea.autosp = "automation-science-pack"
end

require("prototypes.buildings")
require("prototypes.categorys")
require("prototypes.items")
require("prototypes.recipes")

--Remove Coal from the Omnimatter table to disable all Coal extractions 
omni.matter.remove_resource("coal")

-- TODO: verify that all of these are supposed to become startup techs
for tech_name, modify_cost in pairs({
    ["angels-copper-smelting-1"] = {false},
    ["angels-iron-smelting-1"] = {false},
    ["angels-metallurgy-1"] = {false},
    ["omnitech-base-impure-extraction"] = {true},
    ["omnitech-basic-omnitraction"] = {true}, -- TODO: Can't see this?
    ["omnitech-simple-automation"] = {true}, -- TODO: Can't see this?
    ["ore-crushing"] = {true},
    ["steel-processing"] = {false},
    ["water-treatment"] = {false}
}) do
  if data.raw.technology[tech_name] then
    seablock.startup_techs[tech_name] = modify_cost
  end
end

--Add starter recipes to seablocks table so they do not get locked behind techs
for _, rec in pairs({
  "early-omnite-brick",
  "omnic-water-condensation",
  "omnidensator-1"
}) do
  seablock.startup_recipes[rec] = true
end

--Repoint final startup tech to auto sp/ energy sp techs to avoid random techs being moved behind slag processing
if mods["omnimatter_energy"] then
  seablock.final_startup_tech = "energy-science-pack"
else
  seablock.final_startup_tech = seablock.final_scripted_tech
end