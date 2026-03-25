class_name Player
extends CharacterBody2D

@export
var vine_swing : State
@export
var mech_swing : State

@onready
var animations = $animations
@onready 
var state_machine = $state_machine
@onready
var move_component = $move_component

func _ready() -> void:
	state_machine.init(self, animations, move_component)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _on_vine_grapple_enter_vine_swing() -> void:
	state_machine.change_state(vine_swing)


func _on_mech_grapple_enter_mech_swing() -> void:
	state_machine.change_state(mech_swing)
