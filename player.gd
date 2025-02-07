extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ladder_ray_cast: RayCast2D = $LadderRayCast

const WALK_SPEED := 500
const CLIMB_SPEED := WALK_SPEED / 1
const JUMP_VELOCITY := -550.0
const GRAVITY := 1
const FALL_GRAVITY := 1000

# Usamos diretamente a velocity fornecida pela classe CharacterBody2D

func _physics_process(delta: float) -> void:
	var ladderCollider = ladder_ray_cast.get_collider()
	
	if ladderCollider:
		_ladder_climb()
	else:
		_movement(delta)

	# O move_and_slide() é chamado sem argumentos, pois velocity já é gerenciada internamente.
	move_and_slide()

# A gravidade é aplicada diretamente dentro de _movement
func _movement(delta):
	if not is_on_floor():
		# Aplica a gravidade manualmente
		velocity.y += FALL_GRAVITY * delta

	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		# Se pressionar "ui_accept" enquanto estiver subindo, diminuir a velocidade
		velocity.y = JUMP_VELOCITY / 4

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# Se pressionar "ui_accept" no chão, aplica o pulo
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		# Se houver movimento, atualiza a velocidade horizontal
		velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
	
	# Animação baseada na direção do movimento
	if velocity.x < 0: 
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0: 
		animated_sprite_2d.flip_h = false

	if velocity.length() > 0: 
		animated_sprite_2d.play("running")
	else: 
		animated_sprite_2d.play("default")
	
func _ladder_climb():
	var direction = Vector2.ZERO
	
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction.length() > 0: 
		velocity = direction * CLIMB_SPEED
		animated_sprite_2d.play("climb")
	else: 
		velocity = Vector2.ZERO
		animated_sprite_2d.stop()
