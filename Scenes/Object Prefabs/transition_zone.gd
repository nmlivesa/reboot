extends Node2D

@export var scene_name = "default"
@export var start_index: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(_body: Node2D) -> void:
	GameManager.set_start_index(start_index)
	SceneLoader.load_scene(scene_name)
