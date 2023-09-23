class_name Player extends CharacterBody2D

var laser_scene = preload("res://pula.tscn")
var laser_scene2 = preload("res://pula2.tscn")
var shoot_cd := false
@export var speed: float = 200.0
@export var  jump_velocity: float = -450
signal laser_shot(laser_scene, location)
signal laser_shot2(laser_scene2, location)
@onready var muzzle = $Muzzle
@onready var muzzle2 = $Muzzle2


@onready var fss = $shagi
@onready var animated_sprite : AnimatedSprite2D =$AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		if was_in_air == true:
			land()
		was_in_air = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("move_left", "move_right","jump","down")
	
	if direction.x != 0 && animated_sprite.animation != "jump_end":
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
func  update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
		
	elif direction.x < 0:
		animated_sprite.flip_h = true
func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_start")
	animation_locked = true
func land():
	
	animated_sprite.play("jump_end")
	animation_locked = true
	
		
	

func _on_animated_sprite_2d_animation_finished():
	if (animated_sprite.animation == "jump_end"):
		animation_locked = false
func play_fs():
	var rand_fs = floor(randf_range(0,6))
	match str(rand_fs):
		"0":
			fss.stream = preload("res://sounds/grass1.ogg")
		"1":
			fss.stream = preload("res://sounds/grass3 (1).ogg")
		"2":
			fss.stream = preload("res://sounds/grass4.ogg")
		"3":
			fss.stream = preload("res://sounds/grass6.ogg")
		"4":
			fss.stream = preload("res://sounds/grass8.ogg")
		"5":
			fss.stream = preload("res://sounds/grass10.ogg")
	fss.play()
		



@warning_ignore("unused_parameter")
func _on_area_2d_body_entered(Man_with_gun):
	get_tree().change_scene_to_file("res://1_missioon.tscn")



	


@warning_ignore("unused_parameter")
func _on_boloto_body_entered(Man_with_gun):
	if velocity.y > -450:
		gravity = 15
		speed = 0
	if velocity.y <-450:
		jump_velocity = 0
		gravity = 15
		speed = 0

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_pressed("hit"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(0.5).timeout
			shoot_cd = false
		
func shoot():
	if animated_sprite.flip_h == false and is_on_floor():
		laser_shot.emit(laser_scene, muzzle.global_position)
	if animated_sprite.flip_h == true and is_on_floor():
		laser_shot2.emit(laser_scene2, muzzle2.global_position)
		
func die():
	queue_free()

		
		
	
		
	
