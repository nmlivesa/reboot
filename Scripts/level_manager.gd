extends Node
@export
var level_map_manager : Node2D
@export
var player : CharacterBody2D
@export
var camera_director : Node2D

func _ready() -> void:
	player.position = level_map_manager.start_pos_line.get_point_position(GameManager.get_start_index())
	camera_director.SetPosition(level_map_manager.start_pos_line.get_point_position(GameManager.get_start_index()))
