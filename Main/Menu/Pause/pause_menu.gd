class_name PauseMenu
extends Control

func _on_resume_pressed():
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_disconnect_pressed():
	multiplayer.multiplayer_peer = null
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_quit_pressed():
	get_tree().quit()
