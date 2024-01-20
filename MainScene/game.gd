extends Node2D


var enemy = preload("res://Enemy/Enemy.tscn")
var player = preload("res://Player/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.wait_time = 5  # Interval ve vteřinách
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", spawn_next_wave)
	add_child(timer)
	#print_all_nodes(self)
	print("xd")
	

func print_all_nodes(node):
	print(node.get_path())
	for child in node.get_children():
		print_all_nodes(child)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	get_tree().change_scene_to_file("res://MainScene/game_over.tscn")
	


func spawn_next_wave():
	var spawn_positions = [
		Vector2(100, 100),
		Vector2(800, 100),
		Vector2(100, 800),
		Vector2(800, 800)
	]

	for pos in spawn_positions:
		var enemy_char = enemy.instantiate()
		enemy_char.global_position = pos
		add_child(enemy_char)
