extends State

@export
var jump_state: State
@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State
@export
var vine_grapple: Node2D


func exit():
	vine_grapple.retract()

func process_input(event: InputEvent) -> State:
	if get_jump():
		return jump_state
	return null


func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if !vine_grapple.launched:
		return fall_state
	
	var movement = get_movement_input() * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
		parent.velocity.x += movement * 0.5 * delta
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
