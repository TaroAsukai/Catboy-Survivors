extends Area2D


var level = 1
var damage = 1
var speed = 300
var target = Vector2.ZERO
var direction = Vector2.ZERO

func _ready():
	direction = global_position.direction_to(target)
	rotation = direction.angle() + deg_to_rad(135)
	match level:
		1:
			damage = 1
			speed = 300

func _physics_process(delta):
	position += direction * speed * delta
		
func _on_timer_timeout():
	queue_free()



func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.get_hit(damage)
		queue_free()
