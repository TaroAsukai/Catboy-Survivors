extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = .5
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", _melee_Timeout)
	timer.start()
	
	connect("body_entered", _on_Body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _melee_Timeout():
	call_deferred("queue_free")
	
func _on_Body_entered(body):
	# Zde můžete implementovat logiku, co se stane, když něco vstoupí do oblasti zbraně
	if body.is_in_group("Enemies"):
		# Udělit poškození nepříteli
		body.get_hit(2)
	else:
		print("ye")

func _on_Area_exited(area):
	print("left")
	# Zde můžete implementovat logiku, co se stane, když něco opustí oblast zbraně
