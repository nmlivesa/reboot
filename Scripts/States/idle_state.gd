extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State

var since_ground_contact : float = 0.0

func enter() -> void:
	super()

func process_input(_event: InputEvent) -> State:
	if get_jump(): #and parent.is_on_floor()
		return jump_state
	if get_movement_input() != 0.0:
		return move_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity += parent.get_gravity() * delta
	parent.velocity.x = lerp(parent.velocity.x, 0.0, acceleration)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		since_ground_contact += delta
		if since_ground_contact > coyote_time:
			return fall_state
	else:
		since_ground_contact = 0.0
	return null
