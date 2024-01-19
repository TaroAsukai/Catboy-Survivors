extends CharacterBody2D  # nebo KinematicBody2D

var speed = 80
var HP = 3
var player = null

func _ready():
	player = get_node("../Player")
	self.add_to_group("Enemies")

func _physics_process(delta):
	var collission = false
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
	
	
func get_hit(dmg):
	if HP - dmg >= 1:
		HP -= dmg
	else:
		player.update_score(20)
		queue_free()
