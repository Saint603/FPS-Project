class_name WeaponReload
extends Node

signal reload_finished

var reload_time

func reload():
	%WeaponRecoil.snap_amount = 1.2
	%WeaponRecoil.speed = 1
	%WeaponRecoil.target_position = Vector3(0,-2,0)
	await get_tree().create_timer(reload_time).timeout
	reload_finished.emit() 
