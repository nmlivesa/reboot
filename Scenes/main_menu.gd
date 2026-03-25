extends Control

@onready var mainButtons : VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer_Main
@onready var levelButtons : VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer_Levels

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#Main Buttons
func _on_start_button_pressed() -> void:
	SceneLoader.load_scene("res://Scenes/Levels/test_new_player.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_level_select_button_pressed() -> void:
	mainButtons.hide()
	levelButtons.show()



#Level Select Buttons
func _on_demo_button_pressed() -> void:
	SceneLoader.load_scene("res://Scenes/Levels/test_new_player.tscn")


func _on_old_demo_button_pressed() -> void:
	SceneLoader.load_scene("res://Scenes/main.tscn")


func _on_back_to_main_button_pressed() -> void:
	levelButtons.hide()
	mainButtons.show()


func _on_level_2_button_pressed() -> void:
	SceneLoader.load_scene("res://Scenes/Levels/Level_1.tscn")
