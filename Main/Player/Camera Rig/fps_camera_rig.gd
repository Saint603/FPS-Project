class_name FPSCamera
extends Node3D

@export var WEAPON_TYPE : Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			WEAPON_BASE.load_weapon()

@export var reset : bool = false:
	set(value):
		reset = value
		if Engine.is_editor_hint():
			reset = false
			WEAPON_BASE.load_weapon()

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

@onready var CAMERA : Camera3D = %Camera3D
@onready var WEAPON_BASE : WeaponBase = %WeaponBase
@onready var CAMERA_RECOIL = %CameraRecoil
@onready var WEAPON_RECOIL = %WeaponRecoil
@onready var MUZZLE_FLASH = %MuzzleFlash

func _ready():
	
	%WeaponBase.sway_noise = sway_noise
	%WeaponBase.WEAPON_TYPE = WEAPON_TYPE
	%CameraRecoil.recoil_amount = camera_recoil_amount
	%CameraRecoil.snap_amount = camera_snap_speed_up
	%CameraRecoil.speed = camera_snap_speed_down
	
	%WeaponRecoil.recoil_amount = weapon_recoil_amount
	%WeaponRecoil.snap_amount = weapon_snap_speed_up
	%WeaponRecoil.speed = weapon_snap_speed_down
	
	%MuzzleFlash.flash_time = flash_time


func _on_player_weapon_fired():
	WEAPON_RECOIL.add_recoil()
	CAMERA_RECOIL.add_recoil()
	MUZZLE_FLASH.add_muzzle_flash()
	
