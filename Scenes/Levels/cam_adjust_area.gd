extends Area2D
@export var Camera_Director : Node2D
@export var new_zoom : Vector2 = Vector2(1.0,1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	Camera_Director.SetZoom(new_zoom)
