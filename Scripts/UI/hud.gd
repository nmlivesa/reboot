extends CanvasLayer

@onready var message = $Message
@onready var message_timer = $MessageTimer

signal start_game
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_message(text):
	message.text = text
	message.show()
	message_timer.start()

func show_game_over():
	show_message("Game Over")
	
	await message_timer.timeout
	
	$StartButton.show()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Title.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	message.hide()
