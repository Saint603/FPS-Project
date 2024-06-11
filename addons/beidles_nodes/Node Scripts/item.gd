@tool
class_name Item
extends StaticBody3D

var DEFAULT_MESH = preload("res://addons/beidles_nodes/Node Assets/Item/item_mesh.tres")

func _ready():
	_generate_nodes()
	
func _generate_nodes(): #ripped from @tool documentation 
	var collision = CollisionShape3D.new()
	var pickup_area = Area3D.new()
	var pickup_area_collision = CollisionShape3D.new()
	var mesh = MeshInstance3D.new()
	
	mesh.name = "ItemMesh"
	mesh.mesh = DEFAULT_MESH
	
	pickup_area.name = "PickupArea"
	pickup_area.set_collision_layer_value(1, false)
	pickup_area.set_collision_mask_value(1, false)
	pickup_area.set_collision_mask_value(2, true) #set to only listen for player
	
	pickup_area_collision.name = "PickupAreaCollision"
	pickup_area_collision.shape = SphereShape3D.new()
	pickup_area_collision.shape.radius = 2.0
	
	collision.name = "ItemCollision"
	collision.shape = BoxShape3D.new()
	collision.shape.size = Vector3(1.5, 2.5, 1.5)
	
	add_child(collision)
	add_child(pickup_area)
	add_child(mesh)
	pickup_area.add_child(pickup_area_collision)
	
	collision.owner = get_tree().edited_scene_root
	pickup_area.owner = get_tree().edited_scene_root
	mesh.owner =  get_tree().edited_scene_root
	pickup_area_collision.owner = get_tree().edited_scene_root
