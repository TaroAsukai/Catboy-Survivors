extends CharacterBody2D


func _ready():
	# Nastavení časovače
	var timer = Timer.new()
	timer.wait_time = 1  # Interval ve vteřinách
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", on_Timer_timeout_Player)
	add_child(timer)


func _physics_process(_delta):
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = direction * 200
	move_and_slide()
	

func on_Timer_timeout_Player():
	# Funkce pro střelbu projektilu
	shoot()

var projectile_scene = preload("res://Player/Bullets/Magic_Ball.tscn")

func shoot():
	var projectile = projectile_scene.instantiate()
	projectile.global_position = self.global_position
	projectile.set_velocity(self.velocity)
	get_parent().add_child(projectile)  # přidá projektil do scény
