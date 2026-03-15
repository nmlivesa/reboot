extends Node2D

@export var cam : Camera2D
@export var target : Node2D
@export var secondary_target : Node2D

@export var follow_speed = 2
@export var zoom_speed = 2
@export var target_offset = Vector2()

@export var default_zoom = Vector2(1.0, 1.0)


var zoom : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	zoom = default_zoom
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	FollowTarget(delta)
	AdjustZoom(delta)


func FollowTarget(delta):
	cam.position = cam.position.lerp(target.position + target_offset, follow_speed * delta)


func AdjustZoom(delta):
	cam.zoom = cam.zoom.slerp(zoom, zoom_speed * delta)

func SetZoom(new_zoom: Vector2):
	zoom = new_zoom


func _on_room_3_cave_outer_body_entered(body: Node2D) -> void:
	SetZoom(Vector2(0.65, 0.65))


func _on_room_4_floating_tiles_body_entered(body: Node2D) -> void:
	SetZoom(Vector2(0.45, 0.45))


func _on_room_5_final_body_entered(body: Node2D) -> void:
	SetZoom(Vector2(0.35, 0.35))


func _on_room_transition_2_body_entered(body: Node2D) -> void:
	SetZoom(Vector2(0.9, 0.9))


func _on_room_transition_opening_body_entered(body: Node2D) -> void:
	SetZoom(Vector2(1, 1))


func _on_room_1_menu_spot_body_entered(body: Node2D) -> void:
	SetZoom(Vector2(1, 1))
