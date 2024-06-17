class_name WeaponRay
extends Node

@onready var CAMERA_CONTROLLER : Camera3D = %Camera3D
@onready var WEAPON_BASE : WeaponBase = %WeaponBase

var bullet_hole
var bullet_hole_fade_time : float
var bullet_hole_timeout: float = 5.0

func fire_ray():
	var space_state = CAMERA_CONTROLLER.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = CAMERA_CONTROLLER.project_ray_origin(screen_center)
	var end = origin + CAMERA_CONTROLLER.project_ray_normal(screen_center) * 1000 ##1000 is range? maybe use this for inaccuracy
	var query = PhysicsRayQueryParameters3D.create(origin, end) ##make ray cast
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		create_decal(result)
		if result.get("collider").has_method("receive_damage"):
				result.get("collider").receive_damage.rpc(WEAPON_BASE.damage)

func create_decal(result):
	GF.add_decal_synced.rpc(bullet_hole, result.get("position"), result.get("normal"), bullet_hole_timeout, bullet_hole_fade_time)
