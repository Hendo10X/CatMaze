extends RigidBody2D


func recoger(body):
	queue_free()
	
	for enemigo in get_tree().get_nodes_in_group("enemigos"):
		enemigo.queue_free()
