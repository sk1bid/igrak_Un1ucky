class_name Enemy extends Area2D

@export var speed = 150
func _physics_process(delta):
	global_position.x += speed * delta

func  die():
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()	


func _on_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://scripts/menu.tscn")
		
