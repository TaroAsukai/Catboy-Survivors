extends CharacterBody2D


var projectile_scene = preload("res://Player/Bullets/Magic_Ball.tscn")
var melee_scene = preload("res://Player/Melee/melee.tscn")
var magicBall2 = preload("res://Player/Attack/MagicBall2/MagicBall2.tscn")
var arrow = preload("res://Player/Attack/YonduArrow/yondu_arrow.tscn")
var score = 0  # Skóre hráče
var speed = 200
var HP = 20
var lookingRight = true

#SPELLs
@onready var MagicBall2Timer = get_node("%MagicBall2Timer")
@onready var ArrowBase = get_node("%ArrowBase")
@onready var gameOverLabel = get_node("%GameOverLabel")
@onready var restartButton = get_node("%Button")
@onready var QuitButton = get_node("%Button2")


var magicBall2Level = 1
var MagicBall2Cooldown = 2

var arrowLevel = 1
var arrowCap = 1

#ENEMIES
var enemyInRange = []

#PLAYER LEVEL
var exp = 0
var level = 1
var expCollected = 0

@onready var expBar = get_node("%ExpBar")
@onready var levelLabel = get_node("%LevelLabel")

func _ready():
	set_exp_bar(exp, calculate_experience_cap())
	
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
	
	self.add_to_group("player")
	
	attack()
	
	update_score(0)
	update_HP(0)


func _physics_process(_delta):
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = direction * speed
	if (velocity.x < 0 and lookingRight == true):
		$AnimatedSprite2D.flip_h = true
		lookingRight = false
	elif (velocity.x > 0 and lookingRight == false):
		$AnimatedSprite2D.flip_h = false
		lookingRight = true
	move_and_slide()
		
	if (HP <= 0):
		#IMPLEMENT GAME OVER
		get_tree().paused = true
		gameOverLabel.visible = true
		restartButton.visible = true
		QuitButton.visible = true

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
	

func attack():
	if (magicBall2Level > 0):
		MagicBall2Timer.wait_time = MagicBall2Cooldown
		if (MagicBall2Timer.is_stopped()):
			MagicBall2Timer.start()
			
	if (arrowLevel > 0):
		spawnArrow()

func update_score(points):
	score += points
	$ScoreLabel.text = "Skóre: " + str(score)


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var expCrystal = area.collect()
		calculate_experience(expCrystal)


func calculate_experience(expCrystal):
	var expRequired = calculate_experience_cap()
	expCollected += expCrystal
	if (exp + expCollected >= expRequired):		#level up
		expCollected -= expRequired - exp
		level += 1
		levelLabel.text = str("level: ", level)
		exp = 0
		expRequired = calculate_experience_cap()
		calculate_experience(0)
	else:
		exp += expCollected
		expCollected = 0
		
	set_exp_bar(exp, expRequired)

func calculate_experience_cap():
	var experience_cap = level
	if (level < 20):
		experience_cap = level * 5
	elif (level < 40):
		experience_cap = 95 + (level - 19) * 8
	else:
		experience_cap = 255 + (level - 39) * 12
	return experience_cap

func set_exp_bar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value


func _on_magic_ball_2_timer_timeout():
	var target = get_target()
	if (target == null):
		return
	
	var MagicBall2Attack = magicBall2.instantiate()
	MagicBall2Attack.position = position
	MagicBall2Attack.target = target
	MagicBall2Attack.level = magicBall2Level
	add_child(MagicBall2Attack)

func get_target():
	if (enemyInRange.size() > 0):
		return enemyInRange.pick_random().global_position
	else:
		return null

func _on_magic_ball_2_range_body_entered(body):
	if not (enemyInRange.has(body)):
		enemyInRange.append(body)


func _on_magic_ball_2_range_body_exited(body):
	if (enemyInRange.has(body)):
		enemyInRange.erase(body)

func spawnArrow():
	var numberOfArrows = ArrowBase.get_child_count()
	var arrowSpawns = arrowCap - numberOfArrows
	if (arrowSpawns > 0):
		var arrowSpawn = arrow.instantiate()
		arrowSpawn.global_position = global_position
		ArrowBase.add_child(arrowSpawn)
		arrowSpawns -= 1
		
func update_HP(dmg):
	HP -= dmg
	$HPLabel.text = "HP: " + str(HP)


func _on_button_2_pressed():
	get_tree().quit()


func _on_button_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
