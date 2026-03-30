extends Control

@export var vine_grapple : Node2D
@export var mech_grapple : Node2D
@export var panel_modulate_factor : float = 0.75
@export var test_with_space : bool = false

@onready var vine_panel : Panel = $PanelContainer/MarginContainer/HBoxContainer/Control/Panel_Vine
@onready var vine_panel_shaded : Panel = $PanelContainer/MarginContainer/HBoxContainer/Control/Panel_Vine_Shaded
@onready var mech_panel : Panel = $PanelContainer/MarginContainer/HBoxContainer/Control2/Panel_Mech
@onready var mech_panel_shaded : Panel = $PanelContainer/MarginContainer/HBoxContainer/Control2/Panel_Mech_Shaded




func _ready() -> void:
	if test_with_space:
		set_process(true)
	else:
		set_process(false)
	#var tween = create_tween()
	#await tween.tween_interval(1.0).finished
	#_vine_start_cooldown(4.0)
	#_mech_start_cooldown(3.0)

#func _unhandled_input(event: InputEvent) -> void:
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		_vine_start_cooldown(3.0)
		_mech_start_cooldown(3.0)

func _vine_ability_activated():
	var tween = create_tween()
	tween.tween_property(vine_panel, "scale", Vector2(1.1,1.1), 0.1)

func _vine_start_cooldown(cooldown : float):
	#var vine_tween = create_tween()
	#vine_panel.scale = Vector2(1.0,1.0)
	var tween = create_tween()
	tween.tween_property(vine_panel, "scale", Vector2(1.0,1.0), 0.1)
	vine_panel.modulate = Color.WHITE * panel_modulate_factor
	var tween_s = create_tween()
	tween_s.finished.connect(_vine_cooldown_finished)
	tween_s.tween_property(vine_panel_shaded, "scale", Vector2(1,0), cooldown).from(Vector2(1,1))

func _vine_cooldown_finished():
	vine_panel.modulate = Color(1, 1, 1, 1)

func _mech_ability_activated():
	var tween = create_tween()
	tween.tween_property(mech_panel, "scale", Vector2(1.1,1.1), 0.1)

func _mech_start_cooldown(cooldown : float):
	#var tween = create_tween()
	#tween.tween_property(mech_panel, "modulate",Color.WHITE , cooldown).from(Color(0.5,0.5,0.5,0))
	var tween = create_tween()
	tween.tween_property(mech_panel, "scale", Vector2(1.0,1.0), 0.1)
	mech_panel.modulate = Color.WHITE * panel_modulate_factor
	var tween_s = create_tween()
	tween_s.finished.connect(_mech_cooldown_finished)
	tween_s.tween_property(mech_panel_shaded, "scale", Vector2(1,0), cooldown).from(Vector2(1,1))

func _mech_cooldown_finished():
	mech_panel.modulate = Color(1, 1, 1, 1)
