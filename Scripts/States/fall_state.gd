extends State

@export
var jump_state: State
@export
var idle_state: State
@export
var move_state: State
@export 
var jump_buffer : float = 2.0


var time_since_jump_pressed: float = jump_buffer

func exit() -> void:
	time_since_jump_pressed = jump_buffer

func process_input(_event: InputEvent) -> State:
	if get_jump():
		time_since_jump_pressed = 0
	return null

func process_physics(delta: float) -> State:
	parent.velocity += parent.get_gravity() * delta
	time_since_jump_pressed += delta

	var movement = get_movement_input() * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
		parent.velocity.x += movement * 0.25 * delta
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if time_since_jump_pressed < jump_buffer:
			return jump_state
		if movement != 0:
			return move_state
		return idle_state
	return null
