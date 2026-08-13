function interacting(who, me, name)
	local tempo = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
	tempo = (tempo + 1) % 11
	local interact = EntityGetFirstComponentIncludingDisabled(me, "InteractableComponent")
	if not interact then return end
	ComponentSetValue2(interact, "ui_text", GameTextGetTranslatedOrNot("$tempo_clock_" .. tostring(tempo)))
	ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", tempo)
end