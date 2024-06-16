class_name WeaponRay
extends Node

@onready var CAMERA_CONTROLLER : Camera3D = %Camera3D
@onready var WEAPON_BASE : WeaponBase = %WeaponBase

var bullet_hole : PackedScene
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
	###var instance = raycast_debug.instantiate()
	var instance = bullet_hole.instantiate()
	Global.game.synced_instances.add_child(instance)
	instance.global_position = result.get("position")
	if result.get("normal") != Vector3.UP and result.get("normal") != Vector3.DOWN:
		instance.look_at(instance.global_transform.origin + result.get("normal"), Vector3.UP)
	if result.get("normal") != Vector3.UP and result.get("normal") != Vector3.DOWN:
		instance.rotate_object_local(Vector3(1,0,0), 90)
	await get_tree().create_timer(bullet_hole_timeout).timeout
	var fade = get_tree().create_tween()
	fade.tween_property(instance, "modulate:a", 0, bullet_hole_fade_time)
	instance.queue_free()
