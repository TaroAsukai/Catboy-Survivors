extends CharacterBody2D  # nebo KinematicBody2D

var speed = 80
var HP = 3
var player = null
var can_hit = false
var lookingLeft = true

var expCrystal = preload("res://Experience/Experience.tscn")
@export var exp = 1

func _ready():
	player = get_node("../Player")
	self.add_to_group("Enemies")
	
	var timer = Timer.new()
	
	timer.wait_time = 1  # Interval ve vteřinách
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", enable_hit)
	
	self.add_child(timer)

func _physics_process(delta):
	var collission = false
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		if (velocity.x < 0 and lookingLeft == false):
			$Sprite2D.flip_h = false
			lookingLeft = true
		elif (velocity.x > 0 and lookingLeft == true):
			$Sprite2D.flip_h = true
			lookingLeft = false
		
		move_and_slide()
		for i in get_slide_collision_count():
			collission = get_slide_collision(i).get_collider()
			if collission:
				if collission.is_in_group("player") and can_hit:
					collission.update_HP(2)  # Předpokládáme, že hráč má funkci get_hit
					can_hit = false  # Zabrání opakovaným zásahům
			
			
func enable_hit():
	can_hit = true
	
	
func get_hit(dmg):
	if HP - dmg >= 1:
		HP -= dmg
	else:
		player.update_score(20)
		var newCrystal = expCrystal.instantiate()
		newCrystal.global_position = global_position
		newCrystal.experience = exp
		get_parent().call_deferred("add_child", newCrystal)
		queue_free()
