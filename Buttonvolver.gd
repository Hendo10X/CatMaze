extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	var tween: Tween = get_tree().create_tween(). set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($"../..", "position", Vector2(0,0),1)
	$"../../VBoxContainer/OPCIONES".grab_focus()
