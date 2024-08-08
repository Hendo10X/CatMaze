extends CharacterBody2D

var velocidad = 16
@onready var rayleft: RayCast2D = $RayCastLeft
@onready var rayright: RayCast2D = $RayCastRight
@onready var rayup: RayCast2D = $RayCastUp
@onready var raydown: RayCast2D = $RayCastDown
func _process(delta):
	raycast()
func raycast():
	if rayleft.is_colliding():
		if rayright.is_colliding():
			velocidad = 0
		else:
			velocidad = 16
		var rayleftcollision = rayleft.get_collider()
		if rayleftcollision.is_in_group("player"):
			if Input.is_action_pressed("right"):
				var tween = create_tween()
				tween.tween_property($".", "position", Vector2.RIGHT * velocidad,0.07).as_relative().set_trans(Tween.TRANS_SINE)
	if rayright.is_colliding():
		if rayleft.is_colliding():
			velocidad = 0
		else:
			velocidad = 16
		var rayrightcollision = rayright.get_collider()
		if rayrightcollision.is_in_group("player"):
			if Input.is_action_pressed("left"):
				var tween = create_tween()
				tween.tween_property($".", "position", Vector2.LEFT * velocidad,0.07).as_relative().set_trans(Tween.TRANS_SINE)
	if rayup.is_colliding():
		if raydown.is_colliding():
			velocidad = 0
		else:
			velocidad = 16
		var rayupcollision = rayup.get_collider()
		if rayupcollision.is_in_group("player"):
			if Input.is_action_pressed("down"):
				var tween = create_tween()
				tween.tween_property($".", "position", Vector2.DOWN * velocidad,0.07).as_relative().set_trans(Tween.TRANS_SINE)
	if raydown.is_colliding():
		if rayup.is_colliding():
			velocidad = 0
		else:
			velocidad = 16
		var raydowncollision = raydown.get_collider()
		if raydowncollision.is_in_group("player"):
			if Input.is_action_pressed("up"):
				var tween = create_tween()
				tween.tween_property($".", "position", Vector2.UP * velocidad,0.07).as_relative().set_trans(Tween.TRANS_SINE)
