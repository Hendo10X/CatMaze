extends RigidBody2D

var trapped = false ## IF FROG IS CATCHED, THE MAIN COLLISION IS DEACTIVATED
@onready var box = $"." #BODY TO MOVE THAT IS THE BOX
@onready var boxsprite = $Sprite2D # BOX SPRITE
var speed = 260 ## SPEED WHEN CATCHED BY THE FROG 
@onready var collision_shape_2d = $CollisionShape2D # COLLISION THAT SHOULD BE DEACTIVATED IF RENE CATCHES A BOX WITH HIS TONGUE

## BOX MOVEMENT
@onready var down = $Raycast/Abajo
@onready var down2 = $Raycast/Abajo2
@onready var up = $Raycast/Arriba
@onready var up2 = $Raycast/Arriba2
@onready var left = $Raycast/Izquierda
@onready var left2 = $Raycast/Izquierda2
@onready var right = $Raycast/Derecha
@onready var right2 = $Raycast/Derecha2

var tile_sizey = 16
var tile_sizex = 16

func _process(delta):
	if up.is_colliding():
		var upcollision = up.get_collider()
		var upcollision2 = up2.get_collider()
		if upcollision and upcollision.is_in_group("inmovible") or upcollision2 and upcollision2.is_in_group("inmovible"):
			down.enabled = false
			down2.enabled = false
	else:
		down.enabled = true
		down2.enabled = true 
	if down.is_colliding():
		var downcollision = down.get_collider()
		var downcollision2 = down2.get_collider()
		if downcollision and downcollision.is_in_group("inmovible") or downcollision2 and downcollision2.is_in_group("inmovible"):
			up.enabled = false
			up2.enabled = false
	else:
		up.enabled = true
		up2.enabled = true
	if left.is_colliding():
		var leftcollision = left.get_collider()
		var leftcollision2 = left2.get_collider()
		if leftcollision and leftcollision.is_in_group("inmovible") or leftcollision2 and leftcollision2.is_in_group("inmovible"):
			right.enabled = false
			right2.enabled = false
	else:
		right.enabled = true
		right2.enabled = true 
	if right.is_colliding():
		var rightcollision = right.get_collider()
		var rightcollision2 = right2.get_collider()
		if rightcollision and rightcollision.is_in_group("inmovible") or rightcollision2 and rightcollision2.is_in_group("inmovible"):
			left.enabled = false
			left2.enabled = false
	else:
		left.enabled = true
		left2.enabled = true
## IT IS RESPONSIBLE FOR CONTROLLING COLLISIONS AND SPRITE CHANGE
	if boxsprite.animation == "atrapadaxrana":
		trapped = true
		collision_shape_2d.disabled = true
		await get_tree().create_timer(0.6).timeout
		collision_shape_2d.disabled = false
		trapped = false 
	downpush()
	uppush()
	leftpush()
	rightpush()
func _on_collision_rana_area_entered(area):
	if area.is_in_group("lengua"):
		trapped = true
		boxsprite.animation = "atrapadaxrana"
		await get_tree().create_timer(2.4).timeout
		boxsprite.animation = "normal"
		trapped = false
func downpush(): 
	if down.is_colliding() and down2.is_colliding():
		var tile_sizey = 16
		var downcollision = down.get_collider()
		if up.is_colliding():
			tile_sizey = 0
		if downcollision and downcollision.is_in_group("player"):
			if Input.is_action_pressed("up"):
				box.global_position.y -= tile_sizey
func uppush():
	if up.is_colliding() and up2.is_colliding():
		var tile_sizey = 16
		var upcollision = up.get_collider()
		if down.is_colliding():
			tile_sizey = 0
		if upcollision and upcollision.is_in_group("player"):
			if Input.is_action_pressed("down"):
				box.global_position.y += tile_sizey
func leftpush():
	if left.is_colliding() and left2.is_colliding():
		var tile_sizex = 16
		var leftcollision = left.get_collider()
		if right.is_colliding():
			tile_sizex = 0
		if leftcollision and leftcollision.is_in_group("player"):
			if Input.is_action_pressed("right"):
				box.global_position.x += tile_sizex
func rightpush():
	if right.is_colliding() and right2.is_colliding():
		var tile_sizex = 16
		var derechacollision = right.get_collider()
		if left.is_colliding():
			tile_sizex = 0
		if derechacollision and derechacollision.is_in_group("player"):
			if Input.is_action_pressed("left"):
				box.global_position.x -= tile_sizex
