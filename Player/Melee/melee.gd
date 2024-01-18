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
	connect("area_entered", _on_Area_entered)
	connect("area_exited", _on_Area_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _melee_Timeout():
	call_deferred("queue_free")
	
func _on_Area_entered(area):
	# Zde můžete implementovat logiku, co se stane, když něco vstoupí do oblasti zbraně
	print("yop")
	if area.is_in_group("Enemies"):
		# Udělit poškození nepříteli
		print("Hit an enemy")
	else:
		print("ye")

func _on_Area_exited(area):
	print("left")
	# Zde můžete implementovat logiku, co se stane, když něco opustí oblast zbraně
