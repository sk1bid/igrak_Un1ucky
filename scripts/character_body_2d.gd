extends CharacterBody2D

@onready var sprite_2D = $Player
@onready var animation_player = $Node/Animation1

const GRAVITY = 1000.0
const RUN_SPEED = 120.0
const JUMP_VELOCITY = -400.0
const MAX_FALL = 400.0

enum PLAYER_STATE { IDLE, RUN, JUMP, FALL}

var _state: PLAYER_STATE = PLAYER_STATE.IDLE

func _physics_process(delta):
	apply_gravity(delta)
	move_horizontal()
	move_and_slide()
	jump_handler()
	clamp_fall_velocity()
	calculate_state()


func apply_gravity(delta):
	if !is_on_floor():
		
		velocity.y += GRAVITY * delta
		




func move_horizontal():
	velocity.x = 0
	
	if Input.is_action_pressed('move_left'):
		velocity.x -= RUN_SPEED
	elif Input.is_action_pressed('move_right'):
		velocity.x += RUN_SPEED
		
		
func jump_handler():
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func clamp_fall_velocity(): 
	velocity.y = clampf(velocity.y , JUMP_VELOCITY, MAX_FALL)
	
func set_state(new_state: PLAYER_STATE):
	if new_state == _state:
		return
	match _state:
		PLAYER_STATE.IDLE:
			animation_player.play('idle')
		PLAYER_STATE.RUN:
			animation_player.play('run')
		PLAYER_STATE.JUMP:
			animation_player.play('jump')
		PLAYER_STATE.FALL:
			animation_player.play('fall')
		
func calculate_state():
	if is_on_floor():
		if velocity.x == 0:
			set_state(PLAYER_STATE.IDLE)
		else:
			set_state(PLAYER_STATE.RUN)
	else:
		if velocity.y > 0:
			set_state(PLAYER_STATE.FALL)
		else:
			set_state(PLAYER_STATE.JUMP)
		

