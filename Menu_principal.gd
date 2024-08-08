extends Node2D
@onready var menu_princpial = $"Menu Princpial"
@onready var botonespanol = $"Menu Princpial/MarginContainer/Lenguaje/HBoxContainer/Español"
@onready var botoningles = $"Menu Princpial/MarginContainer/Lenguaje/HBoxContainer/Ingles"
@onready var check_box = $"Menu Princpial/MarginContainer/Tamaño Pantalla/CheckBox"
@onready var musica = $"Menu Princpial/MarginContainer/Sonido/HSlider"
@onready var efectos = $"Menu Princpial/MarginContainer/Sonido/HSlider2"
var traduccion: bool
func _ready():
	$"Menu Princpial/VBoxContainer/JUGAR".grab_focus()
	traduccion = Save.game_data.traduccion
	if traduccion:
		TranslationServer.set_locale("en")
	if !traduccion:
		TranslationServer.set_locale("es")
	## SE ENCARGAR DE INICIAR LAS FUNCIONES TAL CUAL SE ALLA GUARDADO
	check_box.button_pressed = Save.game_data.fullscreen_on
	_on_check_box_pressed()
	musica.value = Save.game_data.musica
	efectos.value = Save.game_data.efectos
func _on_jugar_pressed(): ## CUANDO SE PRESIONA EL BOTON DE JUGAR 
	Transicion.change_scene("res://Niveles/nivel1.tscn")

func _on_opciones_pressed(): ## BOTON DE OPCIONES
	var tween: Tween = get_tree().create_tween(). set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($"Menu Princpial", "position", Vector2(-600,0),1)
	$"Menu Princpial/MarginContainer/Tamaño Pantalla/CheckBox".grab_focus()



func _on_check_box_pressed():
	pantallacompleta()

func pantallacompleta():
	if check_box.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Save.game_data.fullscreen_on = check_box.button_pressed
	Save.save_data()
func _on_español_toggled(button_pressed):
	traduccion = false
	if traduccion == false:
		TranslationServer.set_locale("es")
		botonespanol.disabled = true
		botoningles.disabled = false
	Save.game_data.traduccion = traduccion
	Save.save_data()
func _on_ingles_toggled(button_pressed):
	traduccion = true 
	if traduccion == true:
		TranslationServer.set_locale("en")
		botonespanol.disabled = false
		botoningles.disabled = true
	Save.game_data.traduccion = traduccion
	Save.save_data()
func _on_h_slider_value_changed(value):
	update_vol(1,value)

func _on_h_slider_2_value_changed(value):
	update_vol(2,value)
	
func update_vol(index, vol):
	AudioServer.set_bus_volume_db(index,linear_to_db(vol))
	match index:
		1:
			Save.game_data.musica = vol
		2:
			Save.game_data.efectos = vol
	Save.save_data()
