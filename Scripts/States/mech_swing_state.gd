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
var mech_grapple: Node2D


func enter() -> void:
	parent.velocity = Vector2.ZERO

func exit() -> void:
	#print_debug(parent.velocity)
	parent.velocity += parent.velocity.normalized() *150
	#print_debug(parent.velocity)

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * 0.2 * delta
	
	if !mech_grapple.launched:
		return fall_state
	
	var movement = get_movement_input() * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
		parent.velocity.x += movement * delta
	
	parent.move_and_slide()
	""" #should be impossible and may cause early exits
	if parent.is_on_floor(): 
		if movement != 0:
			return move_state
		return idle_state
	"""
	return null
