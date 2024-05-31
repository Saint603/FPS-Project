@tool
class_name FPSCamera
extends Node3D

#editor features broken ATM
@export var WEAPON_TYPE : Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			WEAPON_BASE = %WeaponBase
			WEAPON_BASE.load_weapon()

@export var reset : bool = false:
	set(value):
		reset = value
		if Engine.is_editor_hint():
			reset = false
			WEAPON_BASE = %WeaponBase
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

var reloading = false
var MAX_AMMO
var current_ammo

func _ready():
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
	
	MAX_AMMO = WEAPON_TYPE.MAX_AMMO
	current_ammo = MAX_AMMO

func _on_player_weapon_fired():
	if !reloading:
		current_ammo -= 1
		Global.player.ammo.set_text(str(current_ammo) + "/" + str(MAX_AMMO))
		WEAPON_RECOIL.add_recoil()
		CAMERA_RECOIL.add_recoil()
		MUZZLE_FLASH.add_muzzle_flash()
		WEAPON_RAY.fire_ray()
		WEAPON_SOUNDS.add_sound(self.global_position, "")
		if current_ammo <= 0:
			reloading = true
			WEAPON_RELOAD.reload()

func _on_weapon_reload_reload_finished():
	WEAPON_RECOIL.snap_amount = weapon_snap_speed_up
	WEAPON_RECOIL.speed = weapon_snap_speed_down
	current_ammo = MAX_AMMO
	Global.player.ammo.set_text(str(current_ammo) + "/" + str(MAX_AMMO))
	reloading = false
