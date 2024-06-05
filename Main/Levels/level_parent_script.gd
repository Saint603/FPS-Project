class_name Level
extends Node

signal level_loaded

@export var spawns_group : Node
var spawns : Array[Vector3]

func _ready():
	if spawns_group == null:
		print("Error, no parent spawn node for level! Make a parent spawn node and add Marker3Ds to it...")
	else:
		for i in spawns_group.get_children():
			if i.get_class() != "Marker3D":
				print("Child of spawns group parent is not of type Marker3D! Ignoring....")
			else:
				spawns.append(i.global_position)
	Global.current_level = self
	level_loaded.emit()
