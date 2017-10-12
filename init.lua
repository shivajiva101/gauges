-- Adds health bars above players.
-- Code by 4aiman, textures by Calinou. Licensed under CC0.

local hp_bar = {
	physical = false,
	collisionbox = {x = 0, y = 0, z = 0},
	visual = "sprite",
	textures = {"20.png"}, -- The texture is changed later in the code.
	visual_size = {x = 1.5, y = 0.09375, z = 1.5}, -- Y value is (1 / 16) * 1.5.
	wielder = nil,
}

function hp_bar:on_step(dtime)
	local wielder = self.wielder
	if wielder == nil or
			minetest.get_player_by_name(wielder:get_player_name()) == nil then
		self.object:remove()
		return
	end

	local hp = wielder:get_hp()
	local breath = wielder:get_breath()
	self.object:set_properties({
		textures = {
			"health_" .. tostring(hp) .. ".png^breath_" .. tostring(breath) .. ".png",
		},
	})
end

minetest.register_entity("gauges:hp_bar", hp_bar)

local function add_HP_gauge(player)
	local pos = player:get_pos()
	local ent = minetest.add_entity(pos, "gauges:hp_bar")
	if ent ~= nil then
		ent:set_attach(player, "", {x = 0, y = 10, z = 0}, {x = 0, y = 0, z = 0})
		ent = ent:get_luaentity()
		ent.wielder = player
	end
end

-- If health_bars not defined or set to true
if minetest.setting_getbool("health_bars") ~= false and
		minetest.setting_getbool("enable_damage") then
	minetest.register_on_joinplayer(add_HP_gauge)
end
