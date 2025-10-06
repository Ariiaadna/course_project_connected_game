extends CharacterBody2D

@export var speed: float = 100.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = $"."

var last_horizontal_anim: String = "right"

func _physics_process(delta: float) -> void:
	if WordlManager.player_can_walk:
		var input_vector := Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		# Нормализуем, чтобы диагонали не были быстрее
		if input_vector != Vector2.ZERO:
			input_vector = input_vector.normalized()
		velocity = input_vector * speed
		move_and_slide()
		_update_animation(input_vector)
	


func _update_animation(direction: Vector2) -> void:
	if direction.x > 0:
		anim.play("right")
		last_horizontal_anim = "right"
	elif direction.x < 0:
		anim.play("left")
		last_horizontal_anim = "left"
	elif direction.y != 0:
		# При движении вверх/вниз проигрываем последнюю горизонтальную анимацию
		anim.play(last_horizontal_anim)
	else:
		# Остановка — ставим на паузу последнюю анимацию
		anim.play(last_horizontal_anim)
		anim.stop()
		anim.frame = 0
		
