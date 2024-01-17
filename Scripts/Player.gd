extends CharacterBody2D


func _physics_process(_delta):
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = direction * 200
	move_and_slide()
	

