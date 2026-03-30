extends Node2D
@export var length_offset = 30.0
@export var stiffness = 10.0
@export var damping = 2.0
@export var cooldown_on_activate : bool = true
@export var cooldown = 0.2
@export var max_displacement = 30
@export var player : CharacterBody2D
@export var move_component : Node2D
var look_dir : Vector2 = Vector2.ZERO

signal enter_vine_swing
signal start_cooldown(cooldown: float)

@onready var ray := $RayCast2D
@onready var rope := $Line2D
@onready var cooldown_timer := $cooldown_timer
var launched = false
var grapple_ready = true
var target: Vector2
var vine_length: float = 0.0

var tween : Tween

func _ready() -> void:
	cooldown_timer.wait_time = cooldown

#cooldown on activate causes ability to restart on cooldown end.
func _physics_process(delta: float) -> void:
	look_dir = move_component.target_direction(player.global_position)
	ray.look_at(to_global(look_dir))
	"""
	if look_dir:
		ray.look_at(to_global(look_dir))
	else:
		ray.look_at(get_global_mouse_position())
	"""
	
	if grapple_ready && move_component.ability_main():
		launch()
		
	if move_component.ability_main_released():
		retract()
	if launched:
		handle_grapple(delta)

func launch():
	if ray.is_colliding():
		launched = true
		enter_vine_swing.emit()
		target = ray.get_collision_point()
		rope.show()
		vine_length = player.global_position.distance_to(target) - length_offset
		grapple_ready = false
		if (cooldown_on_activate && cooldown_timer.is_stopped()):
			cooldown_timer.start()
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_method(for_tween, player.position, target, 0.15)

func for_tween(pos: Vector2)-> void:
	rope.set_point_position(1, to_local(pos))

func retract():
	launched = false
	rope.hide()
	if (!cooldown_on_activate && cooldown_timer.is_stopped()):
		cooldown_timer.start()
		start_cooldown.emit(cooldown)

func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	
	var displacement = target_dist - vine_length #+ length_offset#
	
	var force = Vector2.ZERO
	var vel_dot = player.velocity.normalized().dot(target_dir)
	if displacement > 0 && vel_dot < 0.5:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		vel_dot = player.velocity.dot(target_dir)
		var damping_applied = -damping * vel_dot * target_dir
		
		force = spring_force + damping_applied
		
	
	player.velocity += force * delta
	update_rope()
	if displacement > max_displacement:
		retract()

func update_rope():
	if !tween.is_running():
		rope.set_point_position(1, to_local(target))


func _on_vine_cooldown_timeout() -> void:
	grapple_ready = true # Replace with function body.
