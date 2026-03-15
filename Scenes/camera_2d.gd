extends Camera2D

@export var pan_speed = 2
@export var zoom_speed = 2
@export var camera_markers :Line2D
#@onready var room1 = $Room_1_Marker
var pan_target :Vector2
var zoom_target :Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug(get_zoom())
	zoom_target = Vector2(1,1)
	pan_target = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	Zoom(delta)
	#SimplePan(delta)


func Zoom(delta):
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)

func SimplePan(delta):
	position = position.lerp(pan_target, pan_speed * delta)



func _on_room_transition_opening_body_entered(_body: Node2D) -> void:
	zoom_target = Vector2(1,1)
	pan_target = camera_markers.get_point_position(1)
	print_debug("Opening Room Transition")


func _on_room_transition_2_body_entered(_body: Node2D) -> void:
	zoom_target = Vector2(1, 1)
	pan_target = camera_markers.get_point_position(2)
	print_debug("Column Cave Room Transition")


func _on_room_transition_1_body_entered(_body: Node2D) -> void:
	zoom_target = Vector2(1,1)
	pan_target = camera_markers.get_point_position(0)


func _on_room_3_cave_outer_body_entered(_body: Node2D) -> void:
	zoom_target = Vector2(0.65,0.65)
	pan_target = camera_markers.get_point_position(3)


func _on_room_4_floating_tiles_body_entered(_body: Node2D) -> void:
	zoom_target = Vector2(0.35,0.35)
	pan_target = camera_markers.get_point_position(4)


func _on_room_5_final_body_entered(_body: Node2D) -> void:
	zoom_target = Vector2(0.2,0.2)
	pan_target = camera_markers.get_point_position(5)
