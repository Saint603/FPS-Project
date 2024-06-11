@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Spawns", "Node", preload("Node Scripts/spawns.gd"), preload("Node Textures/godot marker logo.png"))
	add_custom_type("Item", "StaticBody3D", preload("Node Scripts/item.gd"), preload("Node Textures/godot item logo.png"))
	
func _exit_tree():
	remove_custom_type("Spawns")
	remove_custom_type("Item")
