extends Node3D

@export var recoil_amount : Vector3
@export var snap_amount : float
@export var speed : float

##@export var weapon : WeaponBase

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
