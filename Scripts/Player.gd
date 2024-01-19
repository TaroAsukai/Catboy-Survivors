extends CharacterBody2D


var projectile_scene = preload("res://Player/Bullets/Magic_Ball.tscn")
var melee_scene = preload("res://Player/Melee/melee.tscn")
var score = 0  # Skóre hráče

func _ready():
	# Nastavení časovače
	var timer = Timer.new()
	var timer_melee = Timer.new()
	
	timer.wait_time = 1  # Interval ve vteřinách
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", on_Timer_timeout_Player)
	
	timer_melee.wait_time = 1.75
	timer_melee.autostart = true
	timer_melee.one_shot = false
	timer_melee.connect("timeout", on_Timer_timeout_Melee)
	
	add_child(timer)
	add_child(timer_melee)
	
	update_score(0)


func _physics_process(_delta):
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = direction * 200
	move_and_slide()
	

func on_Timer_timeout_Player():
	# Funkce pro střelbu projektilu
	shoot()

func on_Timer_timeout_Melee():
	slash()


func shoot():
	var projectile = projectile_scene.instantiate()
	projectile.global_position = self.global_position
	projectile.set_velocity(self.velocity)
	get_parent().add_child(projectile)  # přidá projektil do scény
	
func slash():
	var slash = melee_scene.instantiate()
	
	if velocity != Vector2.ZERO:
		slash.rotation = velocity.angle() + PI
	else:
		slash.rotation = randf_range(0, 2*PI)
	
	self.add_child(slash)  # přidá projektil do scény
	
func update_score(points):
	score += points
	$ScoreLabel.text = "Skóre: " + str(score)
