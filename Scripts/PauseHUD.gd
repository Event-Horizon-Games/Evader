extends CanvasLayer

signal unpause_game
signal options_menu_open
signal quit_game

func _on_UnpauseButton_pressed():
	emit_signal("unpause_game")

func _on_OptionsButton_pressed():
	emit_signal("options_menu_open")

func _on_QuitButton_pressed():
	emit_signal("quit_game")
