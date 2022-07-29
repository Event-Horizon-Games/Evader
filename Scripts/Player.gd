extends Area2D

signal hit

export var speed = 400
var game_paused = false
var screen_size
var stopped_animation = "idle"

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	$AnimatedSprite.play()
	show()
	$CollisionShape2D.disabled = false

func _process(delta):
	if game_paused:
		return

	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play("walk_right")
	else:
		$AnimatedSprite.play("idle")

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func stop_animation():
	stopped_animation = $AnimatedSprite.animation
	$AnimatedSprite.stop()

func resume_animation():
	$AnimatedSprite.play(stopped_animation)

func _on_Main_game_paused(is_paused):
	game_paused = is_paused
