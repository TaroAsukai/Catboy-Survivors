extends Area2D

var level = 1
var damage = 3
var speed = 400
var paths = 1
var cooldown = 4.0

var target = Vector2.ZERO
var target_array = []
var direction = Vector2.ZERO
var resetPosition = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var collision = $CollisionShape2D
@onready var attackTimer = get_node("%AttackTimer")
@onready var ChangeDirectionTimer = get_node("%ChangeDirection")
@onready var resetPosTimer = get_node("%ResetPosTimer")
signal remove_from_array(object)

func _ready():
	updateArrow()
	#_on_reset_pos_timer_timeout()
	
func updateArrow():
	level = player.arrowLevel
	match level:
		1:
			damage = 3
			speed = 500
			paths = 1
			
	attackTimer.wait_time = cooldown

func _physics_process(delta):
	if (target_array.size() > 0):
		position += direction * speed * delta
	else:
		var playerDirection = global_position.direction_to(resetPosition)
		var distanceDif = global_position - player.global_position
		var returnSpeed = 50
		if (abs(distanceDif.x) > 500 or abs(distanceDif.y) > 500):
			returnSpeed = 250
		position += playerDirection * returnSpeed * delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(135)

func addPaths():
	emit_signal("remove_from_array", self)
	target_array.clear()
	for i in range(paths):
		var newPath = player.get_target()
		target_array.append(newPath)
		enableAttack(true)
	target = target_array[0]
	processPath()
	
func processPath():
	if (target == null):
		ChangeDirectionTimer.start()
		return
		
	direction = global_position.direction_to(target)
	ChangeDirectionTimer.start()
	var tween = create_tween()
	var newRotation = direction.angle() + deg_to_rad(135)
	tween.tween_property(self, "rotation", newRotation, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _on_attack_timer_timeout():
	addPaths()

func enableAttack(attack = true):
	if (attack == true):
		collision.call_deferred("set", "disabled", false)
	else:
		collision.call_deferred("set", "disabled", true)

func _on_change_direction_timeout():
	if (target_array.size() > 0):
		target_array.remove_at(0)
		if (target_array.size() > 0):
			target = target_array[0]
			processPath()
			emit_signal("remove_from_array", self)
		else:
			enableAttack(false)
	else:
		ChangeDirectionTimer.stop()
		attackTimer.start()
		enableAttack(false)


#func _on_reset_pos_timer_timeout():
	var chooseDirection = randi() % 4
	resetPosition = player.global_position
#	match chooseDirection:
#		0:
#			resetPosition.x += 50
#		1:
#			resetPosition.x -= 50
#		2:
#			resetPosition.y += 50
#		3:
#			resetPosition.y -= 50


func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.get_hit(damage)
