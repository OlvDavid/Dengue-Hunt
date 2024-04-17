extends CharacterBody2D


const SPEED = 200.0
const JUMP_FORCE = -300.0

@onready var animation := $anim as AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left_move", "rigth_move")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction * 3
		if !is_jumping:
			animation.play("correndo")
	elif is_jumping:
		animation.play("pulando")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("parado")

	move_and_slide()
