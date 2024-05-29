extends Node3D

var recoil_amount
var snap_amount
var speed

var current_rotation : Vector3
var target_rotation : Vector3

func _process(delta):
	target_rotation = lerp(target_rotation, Vector3.ZERO, speed * delta) #wait he puts delta in a dif spot in this lerp. is this the key to chalk zone
	current_rotation = lerp(current_rotation, target_rotation, snap_amount  * delta)
	basis = Quaternion.from_euler(current_rotation)
	
func add_recoil():
	target_rotation += Vector3(randf_range(recoil_amount.x * .85, recoil_amount.x),randf_range(-recoil_amount.y, recoil_amount.y), 0)
	
