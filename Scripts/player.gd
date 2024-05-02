extends CharacterBody2D


const SPEED = 130.0
const JUMP_FORCE = -350.0

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

#Variaveis globais do Projeto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_hurted := false
var is_dead := false
var direction
var player_life := 3
var knockback_vector := Vector2.ZERO
var knockback_power := 20

func _physics_process(delta):
	# Fisica do Personagem
	if not is_on_floor():
		velocity.y += gravity * delta

	# Acionar Pular
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE 
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
	
		
	#Movimentação do Personagem(Direita e esquerda)
	direction = Input.get_axis("left_move", "rigth_move")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction * 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
			
	move_and_slide()
	_set_state()
	

func _on_hutbox_body_entered(body: Node2D) -> void:
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	print(knockback)
	take_damage(knockback)			
		   		
func follow_camera(camera):	
	var camera_path = camera.get_path()	
	remote_transform.remote_path =camera_path
	
func take_damage(knocback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if player_life == 0:
		is_dead = true 
		await get_tree().create_timer(.9).timeout
		queue_free()
	
	if knocback_force != Vector2.ZERO:
		knockback_vector = knocback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

func _set_state():
	var state = "parado"
	
	if !is_on_floor():
		state = "pulando"
	elif direction != 0:
		state = "correndo"
		
	if is_hurted:
		state = "dano"	
		
	if is_dead:
		state = "morrendo"
		
	if animation.name != state:
		animation.play(state)
		
		
		
