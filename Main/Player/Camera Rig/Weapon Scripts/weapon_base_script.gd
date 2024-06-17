#This script is responsible for loading weapon meshes and weapon variables
#In addition, it also currently holds sway and bob funcs that are called from the player.
#Hopefully it'll be cleaned up soon
extends Node3D
class_name WeaponBase

@onready var weapon_mesh : MeshInstance3D = %WeaponMesh
@onready var weapon_shadow : MeshInstance3D = %WeaponShadow
@onready var recoil = %CameraRecoil
@onready var muzzle_flash = %MuzzleFlash

#var raycast_debug = preload("res://Art/3D/raycast debug/raycast_debug.tscn")
##var bullet_hole = preload("res://Art/2D/Bullet Hole/bullet_decal.tscn")

var sway_noise : NoiseTexture2D
var WEAPON_TYPE : Weapons
var mouse_movement : Vector2
var random_sway_x : float = 0.0
var random_sway_y : float = 0.0
var time : float = 0.0
var weapon_bob_amount : Vector2 = Vector2.ZERO
var idle_sway_adjustment : float = 0.0
var idle_sway_rotation_strength : float = 0.0
var random_sway_amount : float = 0.0 
var bob_speed : float = 0.0
var hbob_amount : float = 0.0
var vbob_amount : float = 0.0
var damage : int = 50

func load_weapon():
	WEAPON_TYPE = owner.current_weapon
	idle_sway_adjustment = WEAPON_TYPE.idle_sway_adjustment
	idle_sway_rotation_strength = WEAPON_TYPE.idle_sway_rotation_strength
	random_sway_amount = WEAPON_TYPE.random_sway_amount
	bob_speed  = WEAPON_TYPE.bob_speed
	hbob_amount = WEAPON_TYPE.bob_amount_x
	vbob_amount  = WEAPON_TYPE.bob_amount_y
	damage = WEAPON_TYPE.damage
	
func sway_and_bob_weapon(delta, isIdle : bool):
	time += delta
	weapon_bob_amount.x = (sin(time * bob_speed) * hbob_amount)
	weapon_bob_amount.y = abs(cos(time * bob_speed) * vbob_amount)
	
	mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
	if isIdle:
		var sway_random = get_sway_noise()
		var sway_random_adjusted = sway_random * idle_sway_adjustment
		random_sway_x = (sin(time * 1.5 + sway_random_adjusted) / random_sway_amount)
		random_sway_y = (sin(time - sway_random_adjusted) / random_sway_amount) 
	
		position.x = lerp(position.x, (WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position + random_sway_x)) * delta, WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, (WEAPON_TYPE.position.y - (mouse_movement.y * WEAPON_TYPE.sway_amount_position + random_sway_y)) * delta, WEAPON_TYPE.sway_speed_position)
		rotation_degrees.x = lerp(rotation_degrees.x, (WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation + (random_sway_x * idle_sway_rotation_strength))) * delta, WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.y = lerp(rotation_degrees.y, (WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation + (random_sway_y * idle_sway_rotation_strength))) * delta, WEAPON_TYPE.sway_speed_rotation)
		
	else:
		position.x = lerp(position.x, (WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position + weapon_bob_amount.x)) * delta, WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, (WEAPON_TYPE.position.y - (mouse_movement.y * WEAPON_TYPE.sway_amount_position + weapon_bob_amount.y)) * delta, WEAPON_TYPE.sway_speed_position)
		rotation_degrees.x = lerp(rotation_degrees.x, (WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation)) * delta, WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.y = lerp(rotation_degrees.y, (WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation)) * delta, WEAPON_TYPE.sway_speed_rotation)

func get_sway_noise():
	var player_position : Vector3 = Vector3.ZERO
	player_position = owner.global_position
	var noise_location = sway_noise.noise.get_noise_2d(player_position.x,player_position.y)
	return noise_location

