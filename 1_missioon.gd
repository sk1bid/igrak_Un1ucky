extends Node2D
@export var enemy_scenes: Array[PackedScene] = []
@export var enemy_scenes2: Array[PackedScene] = []
@onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
var player = null
@onready var timer = $EnemySpawnTimer

@onready var enemy_container = $EnemyContainer
@onready var enemy_container2 = $EnemyContainer2

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.laser_shot2.connect(_on_player_laser_shot2)
	
func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	
func _on_player_laser_shot2(laser_scene2, location):
	var laser2 = laser_scene2.instantiate()
	laser2.global_position = location
	laser_container.add_child(laser2)	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes2.pick_random().instantiate()
	e.global_position = Vector2(1920,520)
	enemy_container.add_child(e)
	

	



func _on_enemy_spawn_timer_2_timeout():
	var t = enemy_scenes.pick_random().instantiate()
	t.global_position = Vector2(180,520)
	enemy_container.add_child(t)
