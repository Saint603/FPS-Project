@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Spawns", "Node", preload("spawns.gd"), preload("Node Textures/godot marker logo.png"))

func _exit_tree():
	remove_custom_type("Spawns")
