--Most code by Zippy1, some isn't though.--
--License: none yet.--

--Notice, orginally by kaeza.--
notice = { }

function notice.send(target, text)
	local player = minetest.get_player_by_name(target)
	if not player then
		return false, ("There's no player named '%s'."):format(target)
	end
	local fs = { }
	--[[
	for _, line in ipairs(text:split("|")) do
		table.insert(fs, ("label[1,%f;%s]"):format(y+1, minetest.formspec_escape(line)))
		y = y + 0.5
	end
	--]]
	local lines = { }
	for i, line in ipairs(text:split("|")) do
		local lt = { }
		for i = 1, #line, 40 do
			table.insert(lt, line:sub(i, i+39))
		end
		lines[i] = table.concat(lt, "\n")
	end
	text = table.concat(lines, "\n")
	text = minetest.formspec_escape(text)
	table.insert(fs, "size[8,4]")
	table.insert(fs, "label[1,.2;"..text.."]")
	table.insert(fs, "button_exit[3,3.2;2,0.5;alright;Alright]")
	fs = table.concat(fs)
	minetest.after(0.5, function()
		minetest.show_formspec(target, "notice:notice", fs)
	end)
	return true
end

minetest.register_chatcommand("warn", {
	params = "<player> <text>",
	privs = { ls_config=true, },
	description = "Warn a player by showing a formspec",
	func = function(name, params)
		local target, text = params:match("(%S+)%s+(.+)")
		if not (target and text) then
			return false, "Usage: /warn <player> <text>"
		end
		local ok, err = notice.send(target, text)
		if not ok then
			return false, err
		end
		return true, "Message was sent!"
	end,
})

minetest.register_chatcommand("annoy_antigravity", {
   params = "<person>",
   description = "Gives that person antigravity",
   privs = {annoy=true},
   func = function(name, param)
      local player = minetest.get_player_by_name(param)
      if player == nil then
         player = minetest.get_player_by_name(name)
      end
      minetest.chat_send_player(name, "Looking up client | NAILED IT!")
      player:set_physics_override({
         gravity = -0.1
      })
   end,
})
minetest.register_chatcommand("annoy_freeze", {
   params = "<person>",
   description = "Sets speed+jump to 0. Can't move unless teleported or blocks removed under them",
   privs = {annoy=true},
   func = function(name, param)
      local player = minetest.get_player_by_name(param)
      if player == nil then
         player = minetest.get_player_by_name(name)
      end
      minetest.chat_send_player(name, "Looking up client | NAILED IT!")
      player:set_physics_override({
         jump = 0,
         speed = 0
      })
   end,
})

minetest.register_chatcommand("annoy_jump",{
	params = "<person>",
	description = "Gives that person huge jump boost, usually killing them.",
	privs = {annoy=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
      if player == nil then
         player = minetest.get_player_by_name(name)
      end
      minetest.chat_send_player(name, "Looking up client | NAILED IT!")
		player:set_physics_override({
			jump = 1000
		})
	end
})

minetest.register_chatcommand("annoy_fast",{
	params = "<person>",
	description = "Gives that person a lot of speed",
	privs = {annoy=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
      if player == nil then
         player = minetest.get_player_by_name(name)
      end
      minetest.chat_send_player(name, "Looking up client | NAILED IT!")
		player:set_physics_override({
			speed = 10
		})
	end
})

minetest.register_chatcommand("annoy_random",{
	params = "<person>",
	description = "Gives that person very quirky controls, resulting in a literally uncontrollable character. Use with caution!",
	privs = {annoy=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
      if player == nil then
         player = minetest.get_player_by_name(name)
      end
      minetest.chat_send_player(name, "Looking up client | NAILED IT!")
		player:set_physics_override({
			speed = -1.0
		})
	end
})

minetest.register_chatcommand("glide",{
	params = "<person>",
	description = "Anti-fall damage. Slows your descent.",
	privs = {annoy=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
      if player == nil then
         player = minetest.get_player_by_name(name)
      end
      minetest.chat_send_player(name, "Looking up client | NAILED IT!")
		player:set_physics_override({
			jump = 0.3,
			gravity = 0.1
		})
	end
})


minetest.register_chatcommand("reset",{
	params = "<person>",
	description = "Resets gravity, eye offset, visual size and whether they are invisible",
	privs = {annoy=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
      if player == nil then
         player = minetest.get_player_by_name(name)
      end
		player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
		player:set_properties({
			visual_size = {x=1, y=1, z=1}
		})
      minetest.chat_send_player(param, "You have now been reset to normal.")
		player:set_physics_override({
			speed = 1.0,
			gravity = 1.0,
			jump = 1.0
		})


	end,
})

minetest.register_privilege("ls_config", "Useful for annoying people. Admin ONLY!")

minetest.register_chatcommand("kickall", {
	params = "[reason]",
	description = "Kick all online, except for the person who said the command. Do not abuse.",
	privs = {ls_config=true},
	func = function(name, reason)
		for _,player in pairs(minetest.get_connected_players()) do
			local tokick = player:get_player_name()
			if tokick ~= name then
				execute_chatcommand(name, "/kick "..tokick.." "..reason)
			end
		end
		local log_message = name .. " kicks everyone"
		if reason
		and reason ~= "" then
			log_message = log_message.." with reason \"" .. reason .. "\""
		end
		minetest.log("action", log_message)
		return true, "Kicked everyone but you."
	end,
})


mute = {}

mute.shadow_mute_list = {}
mute.ignore_lists = {}

local ignore_lists_path = minetest.get_worldpath() .. "/mute/"
local shadow_mute_path = minetest.get_worldpath() .. "/shadow_mute"

minetest.mkdir(ignore_lists_path) -- Make sure the directory exist

local shadow_mute = mute.shadow_mute_list
local ignore = mute.ignore_lists

core.register_privilege("mute", "Can mute players")

local function send_message(sender, target, message)
	if target == sender then
		minetest.chat_send_player(target, message)
		return
	end
	
	for _,muted in ipairs(shadow_mute) do
		-- Check if the player is muted by an admin/mod
		if muted == sender then
			return
		end
	end

	for _,muted_player in ipairs(ignore[target]) do
	-- Check if the player is ignored by the player
		if muted_player == sender then
			return
		end
	end
	
	minetest.chat_send_player(target, message)
end

mute.send_message = send_message

local function broadcast_message(sender, message)
	minetest.chat_send_all(message);
	irc:say(message);
end

mute.broadcast_message = broadcast_message

local function load_list(path)
	local f = io.open(path, "r")
	if f == nil then
		return {}
	else
		local output = minetest.deserialize(f:read("*all"))
		if output == nil then
			minetest.log("error", "Failed to load " .. path .. " file is corrupted")
			minetest.log("error", "Dumping contents to log file")
			minetest.debug(f:read("*all"))
			output = {}
		end
		
		f:close()
		return output
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	ignore[name] = load_list(ignore_lists_path .. name)
end)

local function save_ignore_list(player)
	local name = player:get_player_name()
	if #ignore[name] == 0 then return end
	local f = io.open(ignore_lists_path .. name, "w")
	f:write(minetest.serialize(ignore[name]))
	f:close()
end

minetest.register_on_leaveplayer(save_ignore_list)

minetest.register_on_shutdown(function()
	for _,player in ipairs(minetest.get_connected_players()) do
		save_ignore_list(player)
	end
	local f = io.open(shadow_mute_path, "w")
	f:write(minetest.serialize(shadow_mute))
	f:close()
end)

minetest.register_on_chat_message(function(username, message)
	irc:say("<" .. username .. "> " .. message)
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		if name ~= username then
			send_message(username, name, "<" .. username .. "> " .. message)
		end
	end
	return true
end)

if minetest.chatcommands["me"] then
	minetest.chatcommands["me"].func = function(name, param)
		broadcast_message(name, "* " .. name .. " " .. param)
	end
end

if minetest.chatcommands["msg"] then
	minetest.chatcommands["msg"].func = function(name, param)
		local sendto, message = param:match("^(%S+)%s(.+)$")
		if not sendto then
			return false, "Invalid usage, see /help msg."
		end
		if not minetest.get_player_by_name(sendto) then
			return false, "The player " .. sendto
					.. " is not online."
		end
		minetest.log("action", "PM from " .. name .. " to " .. sendto
				.. ": " .. message)
		send_message(sendto, name, "PM from " .. name .. ": "
				.. message)
		return true, "Message sent."
	end
end

minetest.register_chatcommand("ignore", {
	params = "<player name>",
	description = "Stop messages from this player from appearing in your chat",
	func = function(name, param)
		table.insert(ignore[name],param)
		return true, "Ignored player " .. param
	end,
})

minetest.register_chatcommand("unignore", {
	params = "<player name>",
	description = "Unignore a player",
	func = function(name, param)
		local t = ignore[name]
		for i=#t,1,-1 do
			local v = t[i]
			if v == param then
				table.remove(t, i)
			end
		end 
		return true, "Unignored player " .. param
	end,
})

minetest.register_chatcommand("mute", {
	params = "<player name>",
	description = "Stop a players messages from being displayed",
	privs = {mute = true},
	func = function(name, param)
		table.insert(shadow_mute, param)
		return true, "Muted player " .. param
	end,
})

minetest.register_chatcommand("unmute", {
	params = "<player name>",
	description = "Undo /mute",
	privs = {mute = true},
	func = function(name, param)
		for i=#shadow_mute,1,-1 do
			local v = shadow_mute[i]
			print(i, v)
			if v == param then
				table.remove(shadow_mute, i)
			end
		end 
		return true, "Unmuted player " .. param
	end,
})

shadow_mute = load_list(shadow_mute_path)
minetest.register_chatcommand("givemoderator", {
	params = "",
	description = "Default moderator",
	privs={privs=true},
	func = function(name, param)
		if minetest.get_player_by_name(param) then
			local privs=minetest.get_player_privs(param)
			privs.fast=true
			privs.home=true
			privs.interact=true
			privs.noclip=true
                        privs.kick=true
                        privs.shout=true
                        privs.spill=true
                        privs.fly=true
                        privs.give=true
			privs.settime=true
			privs.teleport=true
			minetest.set_player_privs(param,privs)
			minetest.chat_send_player(param, "You are now a moderator.")
			minetest.chat_send_player(name, param .. " is now a moderator.")
			return true
		end
end})
