extends CharacterBody2D

var yercekimi = 1500.0
var ziplama_gucu = -500.0

func _physics_process(delta):
	velocity.y += yercekimi * delta
	move_and_slide()
	
	# YENİ EKLEDİĞİMİZ HAYATİ KONTROL:
	if is_on_floor() or is_on_ceiling():
		if is_on_floor() or is_on_ceiling():
			get_tree().call_group("merkez", "oyunu_bitir")

func _input(event):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or (event is InputEventScreenTouch and event.pressed):
		velocity.y = ziplama_gucu
