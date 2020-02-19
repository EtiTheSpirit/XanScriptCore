-- (IN DEVELOPMENT)
-- XUtils is a bunch of random garbage that I probably won't ever use. It's here as a just-in-case.
--[[
	API:
	
		XUtils:IsAnyNil(object args...)
			Returns true if any of the specified arguments are nil.
			THIS WILL FAIL IF THE LAST ELEMENT IS NIL.
			You can resolve this by putting a dummy value at the end of your args, like the global var XNULL created by this script
			For instance:
			XUtils:IsAnyNil(a, b, c)
				If c is nil, this will return false (aka "nothing is nil" due to how tables work in lua.)
				HOWEVER:
			XUtils:IsAnyNil(a, b, c, XNULL)
				If c is nil, this will return true because, as a result of the placeholder XNULL at the end, the table now has a hole in it where c would go.
		
		XUtils:CanFindContextVars(string[] args...)
			Returns true if the specified variables exist in _ENV. This is mainly intended for context-specific commands where access to certain objects (e.g. entity) are required.
			All arguments MUST be strings (e.g. "entity" rather than entity)
			Will print an error message to starbound.log if one of the vars is missing, but will NOT stop the game or the script.
			
		XUtils:PlaySound(Variant<table, string> soundOrList, vec2 position = entity.position())
			Plays a sound or random selection from a list of sounds (depending on what you input to the function) at the specified position.
			If position is nil, it uses `entity.position()` -- If you don't have the entity value in your current context, it will not work.
			If position is specified, the requirement for entity is removed and you can run it so long as the context has `world`
--]]

require("/scripts/vec2.lua")
require("/scripts/util.lua")
require("/scripts/xcore/LoggingOverride.lua")

XUtils = {}

-- Similar to IsAnyNil but looks for environment vars specifically.
-- You ***MUST*** pass in string values (e.g. "entity" rather than entity)
-- Automatically prints an error message specifying which vars are missing.
function XUtils:CanFindContextVars(...)
	local array = {...}
	if #array == 1 and type(array[1]) == "table" then
		-- Catch case for if a user inputs a table.
		array = array[1]
	end

	local missingVars = {}
	for index, value in pairs(array) do
		if not _ENV[value] then
			table.insert(missingVars, value)
		end
	end
	
	if #missingVars > 0 then
		return false, missingVars
	end
	return true, {}
end

-- Plays a sound at the specified position.
-- If Position is nil, then the entity table will be required (resulting in an error if this context doesn't have it) to use entity.position()
function XUtils:PlaySound(soundOrList, position)
	local requiredVars = {"world"}
	if not position then
		table.insert(requiredVars, "entity")
	end
	
	if not XUtils:CanFindContextVars(requiredVars) then return end
	if type(soundOrList) == "string" then
		soundOrList = {soundOrList}
	end
	
	if not position then
		position = entity.position()
	end
	
	-- And now: The hackiest thing you will see in a while.
	world.spawnProjectile("invisibleprojectile", position, nil, {0,0}, false, 
	{
		timeToLive = 0,
		actionOnReap = {
			{
				action = "actions",
				list = {
					{
						action = "sound",
						options = soundOrList
					}
				}
			}
		}
	})
end