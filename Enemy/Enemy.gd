extends CharacterBody2D  # nebo KinematicBody2D

var speed = 80
var HP = 3
var player = null

var expCrystal = preload("res://Experience/Experience.tscn")
@export var exp = 1

func _ready():
	player = get_node("../Player")
	self.add_to_group("Enemies")

func _physics_process(delta):
	var collission = false
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		collission = move_and_collide(velocity * delta)
	
	
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
