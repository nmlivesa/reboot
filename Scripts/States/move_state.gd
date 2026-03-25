extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State

func _ready() -> void:
	acceleration = 0.075
	
func process_input(event: InputEvent) -> State:
	if get_jump() and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = get_movement_input() * move_speed
	
	if movement == 0:
		return idle_state
	
	parent.animations.flip_h = movement < 0
	parent.velocity.x = lerp(parent.velocity.x, movement, acceleration)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
