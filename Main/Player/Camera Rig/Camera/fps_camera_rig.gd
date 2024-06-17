# This script is to consolidate the export variables in one spot for easy assignment within the editor
# It's also supposed to function in editor mode but doesn't at the moment

@tool
class_name FPSCamera
extends Node3D

#editor features broken ATM
@export var reset : bool = false:
	set(value):
		reset = value
		if Engine.is_editor_hint():
			reset = false
			load_weapon()

#@export var WEAPON_TYPE : Weapons:
	#set(value):
		#WEAPON_TYPE = value
		#if Engine.is_editor_hint():
			#load_weapon()

@export_category("Camera Recoil")
@export var camera_recoil_amount : Vector3 = Vector3(0.2,0,0)
@export_range(0,10,0.2) var camera_snap_speed_up : float = 5
@export_range(0,10,0.2) var camera_snap_speed_down : float = 5

@export_category("Weapon Recoil")
@export var weapon_recoil_amount : Vector3 = Vector3(0, 0.2, 0.01)
@export_range(0,10,0.2) var weapon_snap_speed_up : float = 5
@export_range(0,10,0.2) var weapon_snap_speed_down : float = 5

@export_category("Weapon Sway")
@export var sway_noise : NoiseTexture2D
@export var sway_speed : float = 1.2

@export_category("Muzzle Flash")
@export var flash_time : float = 0.2

@export_category("Weapon Ray Cast")
@export var bullet_hole : String = "res://Art/2D/Bullet Hole/bullet_decal.tscn"
@export var fade_time : float = 1.2

@onready var CAMERA : Camera3D = %Camera3D
@onready var WEAPON_BASE : WeaponBase = %WeaponBase
@onready var CAMERA_RECOIL : CameraRecoil = %CameraRecoil
@onready var WEAPON_RECOIL : WeaponRecoil = %WeaponRecoil
@onready var MUZZLE_FLASH : MuzzleFlash = %MuzzleFlash
@onready var WEAPON_RAY : WeaponRay = %WeaponRay
@onready var WEAPON_SOUNDS : WeaponSounds = %WeaponSounds
@onready var WEAPON_RELOAD : WeaponReload = %WeaponReload
@onready var WEAPON_FIRING_LOGIC = %WeaponFiringLogic

var current_weapon

func load_weapon():
	current_weapon = owner.current_weapon
	%WeaponMesh.mesh = current_weapon.mesh
	%WeaponMesh.position = current_weapon.position
	%WeaponMesh.rotation_degrees = current_weapon.rotation
	%WeaponShadow.visible = current_weapon.shadow
	%WeaponMesh.scale = Vector3(current_weapon.scale,current_weapon.scale,current_weapon.scale)
	load_weapon_checker(self)

func load_weapon_checker(object):
	for i in object.get_children():
		if i.has_method("load_weapon"):
			i.load_weapon()
		if i.get_children():
			load_weapon_checker(i)

func _on_player_weapon_switched():
	load_weapon()

func _on_player_player_loaded():
	load_weapon()
	WEAPON_BASE.sway_noise = sway_noise
	
	CAMERA_RECOIL.recoil_amount = camera_recoil_amount
	CAMERA_RECOIL.snap_amount = camera_snap_speed_up
	CAMERA_RECOIL.speed = camera_snap_speed_down
	
	#all of these need moved into the weapon resource eventually
	WEAPON_RECOIL.recoil_amount = weapon_recoil_amount
	WEAPON_RECOIL.snap_amount = weapon_snap_speed_up
	WEAPON_RECOIL.speed = weapon_snap_speed_down
	
	MUZZLE_FLASH.flash_time = flash_time
	
	WEAPON_RAY.bullet_hole = bullet_hole
	WEAPON_RAY.bullet_hole_timeout = fade_time
