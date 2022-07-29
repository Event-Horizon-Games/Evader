extends Node2D

signal game_paused

export(PackedScene) var enemy_scene
var time
var game_paused = false
var music_position = 0.0

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	randomize()
	new_game()
	$PauseHUD.get_child(0).hide() #disable the pause canvas
	$QuitConfirmHUD.get_child(0).hide() # disable the pause confirm canvas
	$OptionsHUD.get_child(0).hide() #disable the options menu

func _process(delta):
	if Input.is_action_just_released("toggle_pause"):
		if game_paused:
			unpause()
			emit_signal("game_paused", false)
		else:
			pause()
			emit_signal("game_paused", true)
	if Input.is_action_just_released("attack"):
		$Player/AnimatedSprite.play("attack_1")

func game_over():
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	get_tree().call_group("enemies", "queue_free")

func new_game():
	time = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$BackgroundMusic.play()

func pause():
	$PauseHUD.get_child(0).show()
	get_tree().call_group("entities", "stop_animation")
	$Player/AnimatedSprite.stop()
	get_tree().paused = true
	game_paused = true
	music_position = $BackgroundMusic.get_playback_position()
	$BackgroundMusic.stop()

func unpause():
	$PauseHUD.get_child(0).hide()
	$OptionsHUD.get_child(0).hide()
	$QuitConfirmHUD.get_child(0).hide()
	get_tree().call_group("entities", "resume_animation")
	$Player/AnimatedSprite.play()
	$Player.resume_animation()
	get_tree().paused = false
	game_paused = false
	$BackgroundMusic.play(music_position)

func _on_ScoreTimer_timeout():
	# basically a clock
	if not game_paused:
		time += 1
		$ScoreHUD.update_time(time)

func _on_StartTimer_timeout():
	# grace period, after start game
	$EnemyTimer.start()
	$ScoreTimer.start()

func _on_EnemyTimer_timeout():
	if game_paused:
		return

	# enemy spawner
	var enemy = enemy_scene.instance()

	$EnemyPath/EnemySpawnLocation.offset = randi()

	var direction = $EnemyPath/EnemySpawnLocation.rotation + PI / 2

	enemy.position = $EnemyPath/EnemySpawnLocation.position

	direction += rand_range(-(PI / 4), (PI / 4))
	enemy.rotation = direction

	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)

	add_child(enemy)

func _on_PauseHUD_options_menu_open():
	$PauseHUD.get_child(0).hide()
	$OptionsHUD.get_child(0).show()

func _on_PauseHUD_quit_game():
	$PauseHUD.get_child(0).hide()
	$QuitConfirmHUD.get_child(0).show()

func _on_PauseHUD_unpause_game():
	unpause()

func _on_QuitConfirmHUD_cancel_quit():
	$PauseHUD.get_child(0).show()
	$QuitConfirmHUD.get_child(0).hide()

func _on_QuitConfirmHUD_confirm_quit():
	get_tree().quit()

func _on_OptionsHUD_leave_options_menu():
	$OptionsHUD.get_child(0).hide()
	$PauseHUD.get_child(0).show()

func volume_change(volume):
	#default is at 50
	#default db is at 0
	# subtract 50 from whatever value is chaged to, then divide by 10
	if volume == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		var new_volume_db = (volume - 50.0) / 10
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), new_volume_db)
