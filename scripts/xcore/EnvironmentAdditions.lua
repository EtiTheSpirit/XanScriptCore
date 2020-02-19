-- EnvironmentAdditions
--[[
	
	EnvironmentAdditions appends some really handy functions to the lua environment.
	
	It's in development and is kind of a loose concept right now.
	
--]]

local DEFAULT_STARBOUND_CONTEXT_VARS = {"activeItem", "commandProcessor", "message", "physics", "scriptPane", "utility", "activeItemAnimation", "config", "monster", "player", "stagehand", "vehicle", "actorMovementController", "containerPane", "movementController", "playerCompanions", "statusController", "widget", "animationConfig", "entity", "npc", "projectile", "effect", "world", "animator", "item", "object", "quest", "tech", "celestial", "localAnimator", "objectAnimator", "root", "updatableScript"}

table.contains = function (tbl, value)
	for index, object in pairs(tbl) do
		if object == value then
			return true
		end
	end
end


-- Returns the type of the object as type() might, with some added details.
-- Said details are:
-- 0) typeof(primitive) = type(primitive) (* excluding table, which has extra handling. If both cases below fail, it will return "table")
-- 1) typeof(some environment var provided by starbound) = "sbObject::varname"
-- 2) typeof(some table), if this table has a metatable, and the metatable includes a __type index with a string value, = the value of __type (if it is not a string, it will be ignored)

function typeof(obj)
	-- First off. Primitive?
	local rawType = type(obj)
	
	-- Explicitly do NOT include table.
	if rawType == "number" or rawType == "string" or rawType == "boolean" or rawType == "function" or rawType == "thread" or rawType == "userdata" or rawType == nil then
		return rawType
	end
	
	-- First table check -- Starbound global?
	if rawType == "table" then
		for index, var in ipairs(DEFAULT_STARBOUND_CONTEXT_VARS) do
			if _ENV[var] == obj then
				return "sbObject::" .. var
			end
		end
	end
	
	-- Now check table LAST.
	if rawType == "table" then
		-- User defined __type metavalue?
		local meta = getmetatable(obj)
		if type(meta) == "table" then
			if meta.__type ~= nil and type(meta.__type) == "string" then
				return meta.__type
			end
		end
		return "table"
	end
end