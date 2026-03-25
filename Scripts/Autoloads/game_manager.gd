extends Node

var start_index = 0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SceneLoader.load_scene("res://Scenes/main_menu.tscn")

func set_start_index(new_val: int) -> void:
	start_index = new_val

func get_start_index() -> int:
	return start_index
