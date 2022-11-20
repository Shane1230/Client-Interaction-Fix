function UseInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end

	UseInteractionExt.super.interact(self, player)

	if self._tweak_data.equipment_consume then
		managers.player:remove_special(self._tweak_data.special_equipment)

		if self._tweak_data.special_equipment == "planks" and Global.level_data.level_id == "secret_stash" then
			UseInteractionExt._saviour_count = (UseInteractionExt._saviour_count or 0) + 1
		end
	end

	if self._tweak_data.deployable_consume then
		managers.player:remove_equipment(self._tweak_data.required_deployable)
	end

	if self._tweak_data.sound_event then
		player:sound():play(self._tweak_data.sound_event)
	end

	self:remove_interact()

	if self._unit:damage() then
		self._unit:damage():run_sequence_simple("interact", {
			unit = player
		})
	end
	
	--[[if self._unit:id() ~= -1 then
		managers.network:session():send_to_peers_synched("sync_interacted", self._unit, -2, self.tweak_data, 1)
	end--]]
	managers.network:session():send_to_peers_synched("sync_interacted", self._unit, -2, self.tweak_data, 1)
	
	if self._global_event then
		managers.mission:call_global_event(self._global_event, player)
	end

	self:_check_achievements()
	print("Trying to OFF")

	if not self.keep_active_after_interaction then
		print("OFF")
		self:set_active(false)
	end

	return true
end


--[[
function CarryInteractionExt:_at_interact_start(player, timer)
end

function CarryInteractionExt:_at_interact_interupt(player, complete)
end--]]