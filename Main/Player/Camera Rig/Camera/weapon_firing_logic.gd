class_name WeaponFiringLogic
extends Node

var fire_rate : float
var MAX_AMMO : int
var current_ammo : int
var reloading = false
var on_cooldown = false
var trigger_down = false
var BURST_LENGTH : float
var burst_index : int = 1

func _ready():
	fire_rate = owner.WEAPON_TYPE.FIRE_RATE
	MAX_AMMO = owner.WEAPON_TYPE.MAX_AMMO
	BURST_LENGTH = owner.WEAPON_TYPE.BURST_LENGTH
	current_ammo = MAX_AMMO

func fire():
	if !reloading and !on_cooldown:
		current_ammo -= 1
		Global.player.ammo.set_text(str(current_ammo) + "/" + str(MAX_AMMO))
		%WeaponRecoil.add_recoil()
		%CameraRecoil.add_recoil()
		%MuzzleFlash.add_muzzle_flash()
		%WeaponRay.fire_ray()
		%WeaponSounds.add_sound(owner.global_position, "")
		on_cooldown = true
		if current_ammo <= 0:
			reloading = true
			%WeaponReload.reload()
		await get_tree().create_timer(1 / fire_rate).timeout
		on_cooldown = false #I'd rather do this with signals i think
		if owner.WEAPON_TYPE.FIRE_MODE == 2 and trigger_down == true: #0 = SINGLE, 1 = BURST, 2 = AUTO
			fire()
		if owner.WEAPON_TYPE.FIRE_MODE == 1 and trigger_down:
			burst_index +=1
			if burst_index < BURST_LENGTH:
				fire()

func _on_player_player_loaded():
	Global.player.ammo.set_text(str(current_ammo) + "/" + str(MAX_AMMO))

func _on_player_weapon_trigger_down():
	trigger_down = true
	if owner.WEAPON_TYPE.FIRE_MODE == 1:
		burst_index = 0
	fire()

func _on_player_weapon_trigger_up():
	trigger_down = false

func _on_weapon_reload_reload_finished():
	%WeaponRecoil.snap_amount = owner.weapon_snap_speed_up
	%WeaponRecoil.speed = owner.weapon_snap_speed_down
	current_ammo = MAX_AMMO
	Global.player.ammo.set_text(str(current_ammo) + "/" + str(MAX_AMMO))
	reloading = false
