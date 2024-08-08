extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("Cierreshader")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play("Aperturashader")

func reload_scene() -> void:
	$AnimationPlayer.play("Cierreshader")
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
	$AnimationPlayer.play("Aperturashader")
