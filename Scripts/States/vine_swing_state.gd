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

var since_in_air: float = 0.0

func enter():
	super()
	since_in_air = 0.0

func exit():
	vine_grapple.retract()

func process_input(_event: InputEvent) -> State:
	if get_jump():
		return jump_state
	return null


func process_physics(delta: float) -> State:
	parent.velocity += parent.get_gravity() * delta
	
	if !vine_grapple.launched:
		return fall_state
	
	var movement = get_movement_input() * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
		parent.velocity.x += movement * 0.5 * delta
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		parent.velocity.x = lerp(parent.velocity.x, 0.0, acceleration * 0.5)
		since_in_air += delta
		if since_in_air > (coyote_time * 2):
			if movement != 0:
				return move_state
			else:
				return idle_state
	else:
		since_in_air = 0.0
		
	
	return null
