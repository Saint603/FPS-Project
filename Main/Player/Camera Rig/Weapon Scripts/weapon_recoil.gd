class_name WeaponRecoil
extends Node3D

var speed : float
var snap_amount : float
var recoil_amount : Vector3
var current_position : Vector3
var target_position : Vector3

func _ready():
	pass
	
func _process(delta):
	target_position = lerp(target_position, Vector3.ZERO, speed * delta)
	current_position = lerp(current_position, target_position, snap_amount * delta)
	position = current_position

func add_recoil():
	target_position += Vector3(randf_range(recoil_amount.x, recoil_amount.x * 2), randf_range(recoil_amount.y, recoil_amount.y * 2), randf_range(recoil_amount.z, recoil_amount.z * 2))
