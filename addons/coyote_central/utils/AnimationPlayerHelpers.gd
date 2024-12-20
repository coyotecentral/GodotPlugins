class_name AnimationPlayerHelpers

# Expect player to have a function get_animation_list. Can't strongly type or define shared interface because of 
# duck typing.
static func get_anim_list_hint_str(player: Variant) -> String:
	var hint = ""
	var list = player.get_animation_list()
	var size: int = list.size()
	for i in range(0, size):
		hint += "%s" % list[i]
		if i < size - 1:
			hint += ","
	return hint