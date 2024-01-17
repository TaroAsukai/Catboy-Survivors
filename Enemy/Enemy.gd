extends CharacterBody2D  # nebo KinematicBody2D

var speed = 80
var player = null

func _ready():
	player = get_node("../Player")

func _physics_process(delta):
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
