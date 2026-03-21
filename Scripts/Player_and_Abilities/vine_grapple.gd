extends Node2D
@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping = 2.0
@export var cooldown = 0.2
@export var max_displacement = 30
@export var player : CharacterBody2D

@onready var ray := $RayCast2D
@onready var rope := $Line2D
@onready var cooldown_timer := $cooldown_timer
var launched = false
var grapple_ready = true
var target: Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	ray.look_at(get_global_mouse_position())
	
	if grapple_ready && Input.is_action_just_pressed("grapple_vine"):
		launch()
		rest_length = player.global_position.distance_to(target)
	if Input.is_action_just_released("grapple_vine"):
		retract()
	if launched:
		handle_grapple(delta)

func launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()
		grapple_ready = false
		if (cooldown_timer.is_stopped()):
			cooldown_timer.start()

func retract():
	launched = false
	rope.hide()
	

func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping_applied = -damping * vel_dot * target_dir
		
		force = spring_force + damping_applied
	
	player.velocity += force * delta
	update_rope()
	if displacement > max_displacement:
		retract()

func update_rope():
	rope.set_point_position(1, to_local(target))


func _on_vine_cooldown_timeout() -> void:
	grapple_ready = true # Replace with function body.
