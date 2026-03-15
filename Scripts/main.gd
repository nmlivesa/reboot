extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _new_game() -> void:
	$Kinematic_Player.start($Start_Postition.position)


func _on_kinematic_player_dead() -> void:
	$HUD.show_game_over()


func _on_final_platform_body_entered(_body: Node2D) -> void:
	$HUD.show_message("You Won!")


func _on_checpoint_area_body_entered(_body: Node2D) -> void:
	$Kinematic_Player.start($Checkpoint.position)


func _on_reset_area_body_entered(_body: Node2D) -> void:
	$Kinematic_Player.start($Start_Postition.position)
	
