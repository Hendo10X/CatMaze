extends CharacterBody2D
##  MOVEMENT VARIABLES
@export var speed = 6.4  # speed of movement
const Tile_Size = 16 #size of the grid or number of pixels to move
var initial_position = Vector2(0,0) 
var direction_pressed = Vector2(0,0)
var movement = false
var next_movement_tile = 0.0
var paralyzed = false 

## ANIMATION VARIABLES ##
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
var stopanimation = false
var dead = false

## SHOOT VARIABLE ##
var disparolana : PackedScene
var municion = 0
var mira : Marker2D 
@onready var ray: RayCast2D = $RayCast2D

# New variable to track the last movement time
var last_movement_time = 0.0
# Cooldown time between movements (in seconds)
const MOVEMENT_COOLDOWN = 0.1

func _ready():
	initial_position = position 
	disparolana = preload("res://Projectiles/disparo_lana.tscn")
	animation_player.play("Parado")
	mira = $Mira
func _process(delta):
	if ray.rotation_degrees == 270:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("movible"):
				collider.direccionx = 1
				collider.direcciony = 0
				collider.move_and_slide()
		elif ray.rotation_degrees == 90:
			if ray.is_colliding():
				var collider = ray.get_collider()
				if collider.is_in_group("movible"):
					collider.direccionx = -1
					collider.direcciony = 0
					collider.move_and_slide()
		elif ray.rotation_degrees == 0:
			if ray.is_colliding():
				var collider = ray.get_collider()
				if collider.is_in_group("movible"):
					collider.direcciony = 1
					collider.direccionx = 0
					collider.move_and_slide()
		elif ray.rotation_degrees == 180:
			if ray.is_colliding():
				var collider = ray.get_collider()
				if collider.is_in_group("movible"):
						collider.direcciony = -1
						collider.direccionx = 0
						collider.move_and_slide()
	if Input.is_action_just_pressed("reiniciar") and dead == false:
		animation_player.play("Enterrado")
		reiniciarnivel()
	if Input.is_action_just_pressed("shot"):
		if municion > 0:
			shot()
			municion -= 1 
			Global.municion -=1
#			$TiroLana.play()  ## sonido
func _physics_process(delta):
	if movement == false:
		player_movimiento()
		
	elif direction_pressed != Vector2.ZERO:
		move(delta)
	else:
		movement = false
	animaciones(delta)
func player_movimiento():  # controles de movimiento 
	if dead == false and paralyzed == false:
		if direction_pressed.y == 0 :
			direction_pressed.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		if direction_pressed.x == 0:
			direction_pressed.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
			
		if direction_pressed != Vector2.ZERO:
			initial_position = position
			movement = true

func move(delta):
	ray.target_position = direction_pressed * 16
	ray.force_raycast_update()
	if !ray.is_colliding():
		next_movement_tile += speed * delta
		if next_movement_tile >= 1.0:
			position = initial_position + (Tile_Size * direction_pressed)
			next_movement_tile = 0.0
			movement = false
		else:
			position = initial_position + (Tile_Size * direction_pressed * next_movement_tile)
	else:
		movement = false
func shot():
	var disparo = disparolana.instantiate()
	disparo.global_position = mira.global_position
	disparo.disparar(Vector2(cos(mira.rotation), sin(mira.rotation)))
	get_tree().current_scene.add_child(disparo)
func animaciones(delta):
	if dead == false:
		if direction_pressed.x == 1:
			stopanimation = false
			mira.rotation_degrees = 0
			animation_player.play("Lateral")
			sprite.flip_h = true
		elif direction_pressed.x == -1:
			stopanimation = false
			mira.rotation_degrees = 180
			animation_player.play("Lateral")
			sprite.flip_h = false
		elif direction_pressed.y == -1:
			stopanimation = false
			mira.rotation_degrees = 270
			animation_player.play("Arriba")
		elif direction_pressed.y == 1:
			stopanimation = false 
			mira.rotation_degrees = 90
			animation_player.play("Abajo")
		else:
			stopanimation = true
		if stopanimation == true:
			animation_player.stop()
func _municion():
	municion += 2
	Global.municion += 2
func reiniciarnivel():
	stopanimation = false
	dead = true
	await  get_tree().create_timer(1.4).timeout
	Transicion.reload_scene()
	Global.municion = 0
func Muerte(body):
	if body.is_in_group("aplastar"):
		animation_player.play("Aplastado")
		reiniciarnivel()

func _on_daño_enemigos_area_entered(area):
	if area.is_in_group("fuego"):
		animation_player.play("Quemado")
		reiniciarnivel()
	if area.is_in_group("comer"):
		animation_player.play("Enterrado")
		reiniciarnivel()
	if area.is_in_group("paraliza"):
		animation_player.play("Atrapadonivora")
		reiniciarnivel()
		await get_tree().create_timer(0.5).timeout
		animation_player.play("Acido")
	if area.is_in_group("asustado"):
		animation_player.play("Paralizadosusto")
		reiniciarnivel()
		await get_tree().create_timer(0.5).timeout
		animation_player.play("Atrapadoaraña")
	elif area.is_in_group("desierto"):
		speed = 4.0
func Detectar(area):
	if area.is_in_group("lengua"):
		paralyzed = true 
		stopanimation = true
		animation_player.play("Atrapado")
		await get_tree().create_timer(2.4).timeout
		animation_player.play("Parado")
		paralyzed = false


func _on_daño_enemigos_area_exited(area):
	if area.is_in_group("desierto"):
		speed = 6.4
