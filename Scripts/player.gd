extends CharacterBody2D


const SPEED = 200.0
const JUMP_FORCE = -350.0

@onready var animation := $anim as AnimatedSprite2D

#Variaveis globais do Projeto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_shooting := false
var direction
var is_crounching := false

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
	
	#Acionar Tiro	
	if Input.is_action_pressed("fire"):
		is_shooting = true
	else:
		is_shooting = false
		
	#Movimentação do Personagem(Direita e esquerda)
	direction = Input.get_axis("left_move", "rigth_move")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction * 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
			
	move_and_slide()
	handle_animation()
	
func handle_animation():
	if !is_on_floor() and !is_shooting:
		animation.play("pulando")
	elif direction and !is_shooting:
		animation.play("correndo")
	elif !direction and is_shooting:
		animation.play("bater")
	else:
		animation.play("parado")
