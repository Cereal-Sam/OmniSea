-- No free Water!
seablock.lib.remove_recipe("offshore-pump")
seablock.lib.hide_item("offshore-pump")
seablock.lib.remove_recipe("ground-water-pump")
seablock.lib.hide_item("ground-water-pump")
omni.lib.remove_unlock_recipe("water-treatment", "ground-water-pump")

--Remove Angels Seafloor pump
omni.lib.remove_unlock_recipe("water-washing-1", "seafloor-pump")
seablock.lib.remove_recipe("seafloor-pump")
seablock.lib.hide_item("seafloor-pump")

--TODO Not required when starting with a burner omnitractor
--Set initial omnitraction recipes (saph+stir) to be craftable in an electric omnitractor aswell
data.raw.recipe["initial-omnitraction-angels-ore1"].category = "omnite-extraction-both"
data.raw.recipe["initial-omnitraction-angels-ore3"].category = "omnite-extraction-both"

--Nerf omnic waste creation (from 300 to 200) to avoid cheaty omnite creation
omni.lib.set_recipe_results("pulver-omnic-waste",{type = "fluid", name = "omnic-waste", amount = 200})

--Edit startup tech
-- Startup 1
data.raw.tool["sb-angelsore3-tool"].icon = "__omnimatter__/graphics/icons/omnite.png"
data.raw.tool["sb-angelsore3-tool"].icon_size = 64
data.raw.tool["sb-angelsore3-tool"].localised_name = {"item-name.omnite"}
data.raw.tool["sb-angelsore3-tool"].localised_description = {"tool-description.omnite"}
data.raw.technology["sb-startup1"].icon = "__omnimatter__/graphics/icons/omnite.png"
data.raw.technology["sb-startup1"].icon_size = 64
data.raw.technology["sb-startup1"].localised_name = {"technology-name.getting_omnite"}
data.raw.technology["sb-startup1"].localised_description = {"technology-description.getting_omnite"}

--Add initial omni extraction recipes as startup 1 unlock
omni.lib.add_unlock_recipe("sb-startup1", "initial-omnitraction-angels-ore1")
omni.lib.add_unlock_recipe("sb-startup1", "initial-omnitraction-angels-ore3")

omni.lib.add_unlock_recipe(seablock.final_scripted_tech, "omnite-brick")

--Add Slag Processing 2 as prereq. for Hypomnic Water Omnitraction
omni.lib.add_prerequisite("omnitech-hypomnic-water-omnitraction-1", "slag-processing-2")

--Omniwood compat: Add an early low-yield omnialgae recipe and fix the fuel value of wood
if mods["omnimatter_wood"] then
    RecGen:create("OmniSea","omnialgae-processing-0"):
        setIngredients({type="fluid",name="water-purified",amount=100}, {type="item",name="omnite",amount=40}):
        setIcons("omnialgae","omnimatter_wood"):
        setResults({type="item",name="omnialgae",amount=40}):
        setEnergy(20.0):
        setCategory("bio-processing"):
        setSubgroup("omnisea-fluids"):
        setTechName("sb-startup1"):
        setEnabled(false):
        extend()

    --Move brown algae recipe to sb startup:
    RecGen:import("algae-green-simple"):
        setTechName("sb-startup1"):
        setEnabled(false):
        setHidden(false):
        addIngredients("omnialgae",40):
        extend()

    data.raw.item["wood"].fuel_value = "6MJ"
    data.raw.item["omniwood"].fuel_value = "1MJ"
end

-- Add Omnidrill recipes for all pipes
for _, pipes in pairs(data.raw.item) do
    if pipes.subgroup == "pipe" then
        if pipes.name == "stone-pipe" then tier = 1
        elseif pipes.name == "pipe" or pipes.name == "copper-pipe" 
            then tier = 2 techreq =	{"omnitech-omnidrill-1"}		-- +40%
        elseif pipes.name == "steel-pipe" or pipes.name == "plastic-pipe" or pipes.name == "bronze-pipe" 
            then tier = 3 techreq =	{"omnitech-omnidrill-2"}		-- +15%
        elseif pipes.name == "brass-pipe" or pipes.name == "ceramic-pipe" 
            then tier = 4 techreq =	{"omnitech-omnidrill-3"}		-- +15%
        elseif pipes.name == "titanium-pipe" 
            then tier = 5 techreq =	{"omnitech-drilling-equipment-brass-pipe","omnitech-drilling-equipment-ceramic-pipe"}		-- +15%
        elseif pipes.name == "tungsten-pipe" or pipes.name == "nitinol-pipe" 
            then tier = 6 techreq =	{"omnitech-drilling-equipment-titanium-pipe"} -- +15%
        elseif pipes.name == "copper-tungsten-pipe"
            then tier = 7 techreq =	{"omnitech-drilling-equipment-tungsten-pipe","omnitech-drilling-equipment-nitinol-pipe"} -- +15%
        else tier = 1
        end

        baseout = 512		
        if tier == 1 then 
            bonus = 0
        else 
            bonus = math.floor((baseout*0.4) + ((tier-2)*(baseout*0.15)) )
        end

        local metal,check = string.gsub(pipes.name,"-pipe","")
        if check == 0 then metal = "iron" end

    local drillrec = RecGen:create("OmniSea","omnic-water-fracking-".. pipes.name):
        setIngredients({type="fluid",name="coromnic-vapour",amount=100}, {type="item",name= pipes.name,amount=1}):
        setIcons("omnic-water"):
        addSmallIcon(omni.lib.icon.of(pipes, true), 3):
        setResults({type="fluid",name="omnic-water",amount=(baseout + bonus)}):
        setEnergy(4.0):
        setCategory("omnidrilling"):
        setSubgroup("omnisea-fluid-generation"):
        setOrder(tier.."-"..pipes.order)
        if tier == 1 then
            drillrec:setTechName("omnitech-omnidrill-1")
        else
            drillrec:setTechName("omnitech-drilling-equipment-"..pipes.name):
            setTechPacks(2+math.floor(tier/2)):
            setTechCost(25+math.floor((tier/2)*25)):
            setTechTime(15):
            setTechIcons("tech-"..pipes.name,"OmniSea"):
            setTechLocName("omnitech-drilling-equipment",{"material-name."..metal})
        end
        drillrec:setTechPrereq(techreq)
        drillrec:extend()
    end
end

-- Add Omnicompressor Recipes
for i, rec in pairs(data.raw.recipe) do		
    if rec.category == "angels-chemical-void" and string.find(rec.name,"gas") then
    data:extend({
    {
        type = "recipe",
        name = "omnisea-void-"..rec.name,
        category = "omnisea-chemical-void",
        enabled = "false",
        energy_required = 1,
        ingredients = rec.ingredients, --100
        results=
        {
            {type="fluid", name= "coromnic-vapour", amount=50},
        },
        subgroup = "omnisea-void",
        icon = rec.icon,
        icon_size = 32,
        order = "omnisea-void-"..rec.name
    }
    })
    omni.lib.add_unlock_recipe("omnitech-omnidrill-1", "omnisea-void-"..rec.name)
    end
end

--Late update require
require("prototypes.compat.omnimatter_energy.data-updates")

-- Hide disabled recipes
seablock.lib.remove_recipe("sort-gem-ore")
seablock.lib.remove_recipe("slag-processing-1")
seablock.lib.remove_recipe("slag-processing-2")
seablock.lib.remove_recipe("slag-processing-3")
seablock.lib.remove_recipe("slag-processing-4")
seablock.lib.remove_recipe("slag-processing-5")
seablock.lib.remove_recipe("slag-processing-6")