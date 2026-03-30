extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State

var since_ground_contact : float = 0.0

#func _ready() -> void:
	#acceleration = 0.075
	
func process_input(_event: InputEvent) -> State:
	if get_jump(): # and parent.is_on_floor()
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity += parent.get_gravity() * delta
	
	var movement = get_movement_input() * move_speed
	
	if movement == 0:
		return idle_state
	
	parent.animations.flip_h = movement < 0
	parent.velocity.x = lerp(parent.velocity.x, movement, acceleration)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		since_ground_contact += delta
		if since_ground_contact > coyote_time:
			return fall_state
	else:
		since_ground_contact = 0.0
	
	return null
