extends CanvasLayer

signal volume_change
signal leave_options_menu

func _on_VolumeSlider_value_changed(value):
	emit_signal("volume_change", value)

func _on_BackButton_pressed():
	emit_signal("leave_options_menu")
