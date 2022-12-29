extends CanvasLayer


var output: String = ""

onready var label = $OutputLabel


func print(text: String) -> void:
	# Output to console
	print(text)
	# Output log to window
	output += text + "\n"
	label.text = output
	

func clear() -> void:
	output = ""
	label.text = output


func _on_Button_button_up() -> void:
	clear()
