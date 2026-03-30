extends Node2D


@export var release_distance = 100.0
@export var stiffness = 1500.0
@export var damping = 2.0
@export var unlatch_delay = 1.25
@export var cooldown = 3.0
@export var player : CharacterBody2D
@export var move_component : Node2D
var look_dir : Vector2 = Vector2.ZERO

signal enter_mech_swing
signal start_cooldown(cooldown: float) 

@onready var ray : RayCast2D = $RayCast2D
@onready var rope : Line2D = $Line2D
@onready var hand : AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer := $GrappleCooldownTimer
@onready var unlatch_timer := $GrappleUnlatchTimer

var launched = false
var grapple_ready = true
#var release = false
var target: Vector2 = Vector2.ZERO
var target_normal: Vector2 = Vector2.ZERO
var tween_launch : Tween

func _ready() -> void:
	hand.hide()
	cooldown_timer.wait_time = cooldown
	unlatch_timer.wait_time = unlatch_delay
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !launched:
		look_dir = move_component.target_direction(player.global_position)
		ray.look_at(to_global(look_dir))
		if ray.is_colliding():
			target = ray.get_collision_point()
			target_normal = ray.get_collision_normal()
	if grapple_ready && move_component.ability_secondary():
		launch()
		
	if launched && move_component.ability_secondary_released(): 
		retract()
		
	if launched:
		handle_grapple(delta)
	else:
		grapple_indicator()

func launch():
	if player.global_position.distance_to(target) < ray.target_position.x:
		ray.look_at(target)
		ray.force_raycast_update()
		target = ray.get_collision_point()
		launched = true
		enter_mech_swing.emit()
		rope.show()
		hand.show()
		#hand.play("Grabbed") #in tween now
		grapple_ready = false
		#release = false
		unlatch_timer.start()
		tween_launch = create_tween()
		tween_launch.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween_launch.tween_method(for_tween, player.position, target, 0.25)
		tween_launch.finished.connect(_tween_launch_finished)
		

func for_tween(pos: Vector2)-> void:
	rope.set_point_position(1, to_local(pos))
	hand.position = rope.get_point_position(1)
	hand.rotation = (-target_normal).angle()

func _tween_launch_finished():
	hand.play("Grabbed")

func retract():
	launched = false
	rope.hide()
	hand.play("Open")
	hand.hide()
	if (cooldown_timer.is_stopped()):
		cooldown_timer.start()
		start_cooldown.emit(cooldown)

func grapple_indicator():
	if  grapple_ready && player.global_position.distance_to(target) < ray.target_position.x:
		hand.show()
		hand.position = to_local(target)
		hand.rotation = (-target_normal).angle() # - sign must be inside parenthesis
	else:
		hand.hide()

func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	var displacement = target_dist - release_distance
	
	var force = Vector2.ZERO
	
	if displacement > 0 && !tween_launch.is_running():
		var spring_force_magnitude = stiffness #* displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping_applied = -damping * vel_dot * target_dir
		
		force = spring_force + damping_applied
	elif displacement < 0:
		retract()
	
	player.velocity += force * delta
	if !tween_launch.is_running():
		update_rope()

func update_rope():
	rope.set_point_position(1, to_local(target))
	hand.position = rope.get_point_position(1)
	hand.rotation = (-target_normal).angle()


func _on_unlatch_timer_timeout() -> void:
	#release = true
	retract()

func _on_cooldown_timer_timeout() -> void:
	grapple_ready = true
