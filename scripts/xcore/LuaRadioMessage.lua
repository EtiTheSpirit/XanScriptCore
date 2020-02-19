-- LuaRadioMessage
-- Offers the ability to create messages and send them later. Usage example in your own script:
--[[
	self.direMessage = LuaRadioMessage:NewMessage({
		text = "Oh no!"
	})
	
	--For whatever reason, if you forget to specify a parameter above or you need to change a parameter...
	self.direMessage.important = true --You can edit it after creation.
	
	--To send it...
	self.direMessage:SendToEntityInWorld(entity, world)
	
	--If your context already has this, you can call this without specifying the arguments "entity" and "world" and it will automatically grab the vars out of the context
--]]
require("/scripts/xcore/LoggingOverride.lua")

LuaRadioMessage = {}
LuaRadioMessage.__index = LuaRadioMessage

local function ValueOrDefault(Value, Default)
	if Value ~= nil then
		return Value
	end
	return Default
end

function LuaRadioMessage:NewMessage(messageData)
	local messageData = messageData or {}
	messageData.unique = ValueOrDefault(messageData.unique, true)
	messageData.important = ValueOrDefault(messageData.important, false)
	messageData.type = ValueOrDefault(messageData.type, "generic")
	messageData.text = ValueOrDefault(messageData.text, "")
	messageData.senderName = ValueOrDefault(messageData.senderName, "SAIL")
	messageData.portraitImage = ValueOrDefault(messageData.portraitImage, "talk.<frame>")
	messageData.portraitFrames = ValueOrDefault(messageData.portraitFrame, 2)
	messageData.portraitSpeed = ValueOrDefault(messageData.portraitSpeed, 0.25)
	messageData.textSpeed = ValueOrDefault(messageData.textSpeed, 40)
	messageData.persistTime = ValueOrDefault(messageData.persistTime, 6)
	messageData.chatterSound = ValueOrDefault(messageData.chatterSound, "/sfx/interface/aichatter1_loop.ogg")
	messageData.messageId = ValueOrDefault(messageData.messageId, tostring(math.random()))
	
	setmetatable(messageData, LuaRadioMessage)
	
	return messageData
end

function LuaRadioMessage:SendToEntityInWorld(userEntity, userWorld)
	
	
	-- Where "user" means "user-specified"
	local entity = entity or userEntity
	local world = world or userWorld
	
	local RadioMessage = {
		unique = self.unique;
		important = self.important;
		type = self.type;
		text = self.text;
		senderName = self.senderName;
		portraitImage = self.portraitImage;
		portraitFrames = self.portraitFrames;
		portraitSpeed = self.portraitSpeed;
		textSpeed = self.textSpeed;
		persistTime = self.persistTime;
		chatterSound = self.chatterSound;
		messageId = self.messageId;
	}
	world.sendEntityMessage(entity.uniqueId(), "radioMessage", RadioMessage) --This works because of the deployment script, see PlayerReplicator.lua
end