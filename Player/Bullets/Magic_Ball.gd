extends RigidBody2D  # nebo KinematicBody2D / Area2D pro 2D, příslušné 3D uzly pro 3D

var velocity = Vector2(0, 0)  # Příklad rychlosti projektilu

func _ready():
	var timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	timer.connect("timeout", _on_Timer_timeout)
	add_child(timer)
	timer.start()

func set_velocity(player_velocity):
	velocity = -player_velocity

func _physics_process(delta):
	# Aktualizuje polohu projektilu
	if velocity == Vector2(0,0):
		velocity = Vector2(randi_range(0,1) * 200,randi_range(0,1) * 200)
	else: 
		pass
		
	var collission = move_and_collide(velocity*delta * 1.5)
	
	if collission:
		var object = collission.get_collider()
		
		if object:
			if object.is_in_group("Enemies"):
				object.get_hit(1)
			else:
				pass
			
		call_deferred("queue_free")

func _on_Timer_timeout():
	# Funkce pro odstranění projektilu
	call_deferred("queue_free")
