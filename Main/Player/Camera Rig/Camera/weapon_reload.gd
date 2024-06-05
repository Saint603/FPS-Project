class_name WeaponReload
extends Node

signal reload_finished

var reload_time
 
func _ready():
	reload_time = owner.WEAPON_TYPE.RELOAD_TIME

func reload():
	var prev_snap = %WeaponRecoil.snap_amount
	var prev_speed = %WeaponRecoil.speed
	%WeaponRecoil.snap_amount = 1.2
	%WeaponRecoil.speed = 1
	%WeaponRecoil.target_position = Vector3(0,-2,0)
	await get_tree().create_timer(reload_time).timeout
	%WeaponRecoil.snap_amount = prev_snap
	%WeaponRecoil.speed = prev_speed
	reload_finished.emit() 
