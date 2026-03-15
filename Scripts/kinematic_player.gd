extends CharacterBody2D

signal dead
@export var move_accel_curve : Curve
const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const ACCELERATION = 0.1
const DECELERATION = 0.1

@onready var animated_sprite = $AnimatedSprite2D
@onready var grapple_controller := $GrappleControllerVine
@onready var mech_grapple := $GrappleControllerMech

var alive = false

func _ready():
	hide()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if alive:
		
		if Input.is_action_just_pressed("ui_accept") && (is_on_floor() || grapple_controller.launched || mech_grapple.launched):# 
			velocity.y += JUMP_VELOCITY 
			# += to maintain grapple velocity. = to replace
			grapple_controller.retract()
			#stops current grapple

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		if direction && is_on_floor():
			velocity.x = lerp(velocity.x, SPEED * direction, ACCELERATION)
			
		elif direction:
			velocity.x += SPEED * 0.5 * direction * delta
		elif (is_on_floor()):
			velocity.x = lerp(velocity.x, 0.0, DECELERATION)
			
			
		
		
		if (direction > 0):
			animated_sprite.flip_h = false
		elif (direction < 0):
			animated_sprite.flip_h = true
		if (direction == 0):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
		move_and_slide()


func start(start_position):
	position = start_position
	show()
	alive = true


func _on_hit_box_body_entered(_body: Node2D) -> void:
	alive = false
	animated_sprite.play("shocked")
	await get_tree().create_timer(1.0).timeout
	animated_sprite.play("dead")
	dead.emit()
