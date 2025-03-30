-- Factorio Crashed Ship Scenario
-- Place this file as control.lua in a scenario folder:
-- [Factorio folder]/scenarios/crashed-ship/control.lua

-- Initialize scenario when player is created
script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  
  -- Welcome message
  player.print("Emergency alert: Teleporter catastrophe imminent! Brace for uncertainty...")
  
  -- Wait 2 seconds before creating crash effects
  script.on_nth_tick(120, function(event_data)
      -- Only run once
      script.on_nth_tick(nil)
      
      -- Create the crash site
      create_crash_site(player)
      
      -- Add salvaged items to inventory
      add_salvaged_items(player)
      
      -- Unlock some technologies
      unlock_salvaged_technologies(player)
      
      -- Final message
      player.print("You've survived a teleporter malfunction and now find yourself on an alien planet. Build a base and explore this solar system.")
  end)
end)

-- Create visual crash site
function create_crash_site(player)
  local surface = player.surface
  local position = player.position

  
  -- Crash site debris and chests
  for i=1, 20 do
      local x = position.x + math.random(-20, 20)
      local y = position.y + math.random(-20, 20)
      
      -- Create random debris
      local chest_type = math.random(1, 2)
      surface.create_entity{
          name = "crash-site-chest-" .. chest_type, 
          position = {x, y}
      }
  end
  
  -- Create fire effects
  for i=1, 10 do
      local x = position.x + math.random(-15, 15)
      local y = position.y + math.random(-15, 15)
      
      -- Small fires around the crash site
      surface.create_entity{
          name = "fire-flame", 
          position = {x, y}
      }
  end
  
  
  -- Create a small starting area clear of enemies
  local clear_radius = 100
  for _, entity in pairs(surface.find_entities_filtered{
      area = {{position.x - clear_radius, position.y - clear_radius}, 
             {position.x + clear_radius, position.y + clear_radius}},
      force = "enemy"
  }) do
      entity.destroy()
  end
  
  -- Add some initial pollution from the crash
  surface.pollute(position, 500)
  
  -- Clear trees and rocks in immediate area
  for _, entity in pairs(surface.find_entities_filtered{
      area = {{position.x - 20, position.y - 20}, 
             {position.x + 20, position.y + 20}},
      type = {"tree", "simple-entity"}
  }) do
      if math.random() > 0.3 then -- Leave some trees/rocks for aesthetics
          entity.destroy()
      end
  end
  
  -- Create explosion effects without relying on remnants
  for i=1, 8 do
      local x = position.x + math.random(-12, 12)
      local y = position.y + math.random(-12, 12)
      
      -- Create an actual explosion for effect
      surface.create_entity{
          name = "big-explosion",
          position = {x, y}
      }
  end
end

-- Add salvaged items to player inventory
function add_salvaged_items(player)
  -- Basic Materials
  player.insert{name="iron-plate", count=500}
  player.insert{name="steel-plate", count=200}
  player.insert{name="copper-plate", count=300}
  player.insert{name="electronic-circuit", count=150}
  player.insert{name="advanced-circuit", count=50}
  
  -- Power Systems
  player.insert{name="battery", count=75}
  player.insert{name="solar-panel", count=10}
  player.insert{name="accumulator", count=5}
  
  -- Propulsion
  player.insert{name="engine-unit", count=40}
  player.insert{name="electric-engine-unit", count=15}
  player.insert{name="uranium-fuel-cell", count=10}
  player.insert{name="uranium-235", count=5}
  player.insert{name="uranium-238", count=20}
  
  -- Equipment
  player.insert{name="assembling-machine-2", count=5}
  player.insert{name="inserter", count=20}
  player.insert{name="fast-inserter", count=10}
  player.insert{name="medium-electric-pole", count=20}
  player.insert{name="substation", count=3}
  player.insert{name="logistic-robot", count=10}
  player.insert{name="construction-robot", count=10}
  player.insert{name="roboport", count=1}
  
  -- Defense
  player.insert{name="laser-turret", count=5}
  player.insert{name="stone-wall", count=100}
  
  -- Extra Tools
  player.insert{name="repair-pack", count=50}
  player.insert{name="blueprint", count=5}
  player.insert{name="deconstruction-planner", count=1}
  player.insert{name="steel-chest", count=10}
  
  -- Some armor and equipment
  player.insert{name="modular-armor", count=1}
  player.insert{name="personal-roboport-equipment", count=1}
  player.insert{name="battery-equipment", count=2}
  player.insert{name="solar-panel-equipment", count=5}
end

-- Unlock some initial technologies
function unlock_salvaged_technologies(player)
  local force = player.force
  
  -- Logistics tech
  force.technologies["logistics"].researched = true
  force.technologies["logistics-2"].researched = true
  
  -- Automation tech
  force.technologies["automation"].researched = true
  force.technologies["automation-2"].researched = true
  
  -- Power tech
  force.technologies["electronics"].researched = true
  force.technologies["solar-energy"].researched = true
  force.technologies["electric-energy-distribution-1"].researched = true
  
  -- Military tech - basic defenses
  force.technologies["military"].researched = true
  force.technologies["laser"].researched = true
  force.technologies["laser-turret"].researched = true
  force.technologies["stone-wall"].researched = true
  
  -- Equipment tech
  force.technologies["modular-armor"].researched = true
  force.technologies["solar-panel-equipment"].researched = true
  force.technologies["battery-equipment"].researched = true
  force.technologies["personal-roboport-equipment"].researched = true
  
  -- Robotics
  force.technologies["construction-robotics"].researched = true
  force.technologies["logistic-robotics"].researched = true
end

-- Create scenario.json in the same folder with:
--[[
{
"name": "Crashed Ship Scenario",
"description": "You've crash-landed on this alien planet. Salvage what you can from your ship and build a new base to survive.",
"version": "1.0.0"
}
]]--
