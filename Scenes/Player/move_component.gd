extends Node2D



# Return the desired direction of movement for the character
# in the range [-1, 1], where positive values indicate a desire
# to move to the right and negative values to the left.
func get_movement_direction() -> float:
	return Input.get_axis('move_left', 'move_right')

# Return a boolean indicating if the character wants to jump
func wants_jump() -> bool:
	#print_debug(time_since_jump_pressed)
	return Input.is_action_just_pressed('jump')


func target_direction(player_pos: Vector2) -> Vector2:
	if Input.get_vector("target_left","target_right","target_up","target_down"):
		return Input.get_vector("target_left","target_right","target_up","target_down")
	elif Input.get_vector("target2_left","target2_right","target2_up","target2_down"):
		return Input.get_vector("target2_left","target2_right","target2_up","target2_down")
	else:
		return player_pos.direction_to(get_global_mouse_position())

func ability_main() -> bool:
	return Input.is_action_pressed("ability_main")
	
func ability_main_released() -> bool:
	return Input.is_action_just_released("ability_main")

func ability_secondary() -> bool:
	return Input.is_action_pressed("ability_secondary")

func ability_secondary_released() -> bool:
	return Input.is_action_just_released("ability_secondary")
