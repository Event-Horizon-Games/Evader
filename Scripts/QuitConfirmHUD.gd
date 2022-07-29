extends CanvasLayer

signal confirm_quit
signal cancel_quit

func _on_ReallyQuitButton_pressed():
	emit_signal("confirm_quit")

func _on_CancelQuitButton_pressed():
	emit_signal("cancel_quit")
