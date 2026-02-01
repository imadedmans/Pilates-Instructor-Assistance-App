extends Control

func _on_ok_button_down():
	queue_free()

func assignStatement(s: String):
	$Panel/RichTextLabel.text = "[center]" + s
