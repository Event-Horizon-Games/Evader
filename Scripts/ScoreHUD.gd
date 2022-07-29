extends CanvasLayer

func update_time(time):
	$Control/TimeLabel.text = "Time: " + str(time)

func update_kills(kills):
	$Control/KillsLabel.text = "Kills: " + str(kills)
