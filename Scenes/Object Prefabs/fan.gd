extends Node2D



@export var push_force = 1500
@export var falloff_curve : Curve


@export var push_area_size = Vector2(1000, 200)


@onready var push_area := $Area2D
@onready var direction_vector: Vector2 = Vector2.from_angle(rotation)
@onready var push_area_shape := $Area2D/CollisionShape2D
@onready var emitter := $CPUParticles2D

var obj_to_push : Array[Node2D]

func _set_area_size():
	#print_debug("area resize: ", push_area_size)
	var rect_shape = RectangleShape2D.new()
	rect_shape.set_size(push_area_size)
	push_area_shape.shape = rect_shape
	#print_debug("area resize: ", push_area_shape.shape.get_size())
	push_area_shape.position = Vector2((push_area_size.x / 2) - 100, 0)
	_set_emitter_size()

func _set_emitter_size():
	
	emitter.emission_sphere_radius = emitter.emission_sphere_radius * (push_area_size.y / 200)
	emitter.lifetime = emitter.lifetime * (push_area_size.x / 1000)
	emitter.amount = emitter.amount * (push_area_size.x / 1000)
	emitter.initial_velocity_min = emitter.initial_velocity_min * (push_force / 1500.0)
	emitter.initial_velocity_max = emitter.initial_velocity_max * (push_force / 1500.0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if push_area_shape.shape.get_size() != push_area_size:
		_set_area_size()
	#push_area.gravity = push_force # could be used to change gravity in area.
	#push_area.gravity_direction = direction_vector


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	obj_to_push = push_area.get_overlapping_bodies()
	var sampler
	for obj in obj_to_push:
		sampler = 1.0 - (obj.position.distance_to(position) / push_area_size.x)
		obj.velocity += falloff_curve.sample(sampler) * push_force * delta * direction_vector
