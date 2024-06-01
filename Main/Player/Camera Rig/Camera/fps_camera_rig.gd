# This script is to consolidate the export variables in one spot for easy assignment within the editor
# It's also supposed to function in editor mode but doesn't at the moment

@tool
class_name FPSCamera
extends Node3D

#editor features broken ATM
@export var WEAPON_TYPE : Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@export var reset : bool = false:
	set(value):
		reset = value
		if Engine.is_editor_hint():
			reset = false
			load_weapon()

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
@export var bullet_hole : PackedScene = load("res://Art/2D/Bullet Hole/bullet_decal.tscn")
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


func _ready():
	load_weapon()
	WEAPON_BASE.sway_noise = sway_noise
	WEAPON_BASE.WEAPON_TYPE = WEAPON_TYPE
	
	WEAPON_RELOAD.reload_time = WEAPON_TYPE.RELOAD_TIME
	
	CAMERA_RECOIL.recoil_amount = camera_recoil_amount
	CAMERA_RECOIL.snap_amount = camera_snap_speed_up
	CAMERA_RECOIL.speed = camera_snap_speed_down
	
	WEAPON_RECOIL.recoil_amount = weapon_recoil_amount
	WEAPON_RECOIL.snap_amount = weapon_snap_speed_up
	WEAPON_RECOIL.speed = weapon_snap_speed_down
	
	MUZZLE_FLASH.flash_time = flash_time
	
	WEAPON_RAY.bullet_hole = bullet_hole
	WEAPON_RAY.bullet_hole_timeout = fade_time
	
	WEAPON_FIRING_LOGIC.MAX_AMMO = WEAPON_TYPE.MAX_AMMO

func load_weapon():
	%WeaponMesh.mesh = WEAPON_TYPE.mesh
	%WeaponMesh.position = WEAPON_TYPE.position
	%WeaponMesh.rotation_degrees = WEAPON_TYPE.rotation
	%WeaponShadow.visible = WEAPON_TYPE.shadow
	%WeaponMesh.scale = Vector3(WEAPON_TYPE.scale,WEAPON_TYPE.scale,WEAPON_TYPE.scale)
	%WeaponBase.idle_sway_adjustment = WEAPON_TYPE.idle_sway_adjustment
	%WeaponBase.idle_sway_rotation_strength = WEAPON_TYPE.idle_sway_rotation_strength
	%WeaponBase.random_sway_amount = WEAPON_TYPE.random_sway_amount
	%WeaponBase.bob_speed = WEAPON_TYPE.bob_speed
	%WeaponBase.hbob_amount = WEAPON_TYPE.bob_amount_x
	%WeaponBase.vbob_amount = WEAPON_TYPE.bob_amount_y
	%WeaponBase.damage = WEAPON_TYPE.damage
