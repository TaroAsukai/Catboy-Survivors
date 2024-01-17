extends Node2D


var enemy = preload("res://Enemy/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.wait_time = 5  # Interval ve vteřinách
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", spawn_next_wave)
	add_child(timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_next_wave():
	var enemy_char = enemy.instantiate()
	enemy_char.global_position = Vector2(100,100)
	self.add_child(enemy_char)  # přidá projektil do scény
