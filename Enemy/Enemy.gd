extends CharacterBody2D  # nebo KinematicBody2D

var speed = 80
var HP = 3
var player = null
var can_hit = false

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
	add_child(timer)
	timer.start()

func _physics_process(delta):
	var collision = false
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		for i in get_slide_collision_count():
			collision = get_slide_collision(i)
			if collision:
				if collision.get_collider().is_in_group("player"):
					if can_hit:
						attack(2)
						can_hit = false
		

func enable_hit():
	can_hit = true
	
func attack(number):
	player.get_attacked(number)
	
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
