extends RigidBody2D

var stopped_anim = "walk"

func _ready():
	$AnimatedSprite.play("walk")

func _process(delta):
	pass

func resume_animation():
	$AnimatedSprite.play(stopped_anim)

func stop_animation():
	stopped_anim = $AnimatedSprite.animation
	$AnimatedSprite.stop()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
