extends Node

func activarpantallacompleta():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
func desactivarpantalla():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
