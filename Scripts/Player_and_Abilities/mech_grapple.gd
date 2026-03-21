extends Node2D


@export var rest_length = 1.0
@export var stiffness = 1000.0
@export var damping = 2.0
@export var unlatch_delay = 0.01
@export var cooldown = 3.0
@export var player : CharacterBody2D

@onready var ray := $RayCast2D
@onready var rope := $Line2D
@onready var hand := $AnimatedSprite2D
@onready var cooldown_timer := $GrappleCooldownTimer
@onready var unlatch_timer := $GrappleUnlatchTimer

var launched = false
var grapple_ready = true
var release = false
var target: Vector2

func _ready() -> void:
	hand.hide()
	cooldown_timer.wait_time = cooldown
	unlatch_timer.wait_time = unlatch_delay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	ray.look_at(get_global_mouse_position())
	
	if grapple_ready && Input.is_action_just_pressed("grapple_mech"):
		launch()
	if release && (Input.is_action_just_released("grapple_mech")|| Input.is_action_just_pressed("grapple_mech")): 
		#ready to unlatch and key just pressed or released
		retract()
	if launched:
		handle_grapple(delta)
	else:
		grapple_indicator()

func launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()
		hand.show()
		grapple_ready = false
		release = false
		unlatch_timer.start()

func retract():
	launched = false
	rope.hide()
	hand.hide()
	if (cooldown_timer.is_stopped()):
		cooldown_timer.start()

func grapple_indicator():
	if  grapple_ready && ray.is_colliding():
		hand.show()
		hand.position = to_local(ray.get_collision_point())
		hand.rotation = (-ray.get_collision_normal()).angle() # - sign must be inside parenthesis
	else:
		hand.hide()

func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness #* displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping_applied = -damping * vel_dot * target_dir
		
		force = spring_force + damping_applied
	
	player.velocity += force * delta
	update_rope()

func update_rope():
	rope.set_point_position(1, to_local(target))
	hand.position = rope.get_point_position(1)
	hand.rotation = (-ray.get_collision_normal()).angle()


func _on_unlatch_timer_timeout() -> void:
	release = true


func _on_cooldown_timer_timeout() -> void:
	grapple_ready = true
