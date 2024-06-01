class_name WeaponFiringLogic
extends Node

var fire_rate : float = 2
var MAX_AMMO : int
var current_ammo : int
var reloading = false
var on_cooldown = false

func _ready():
	await owner.ready
	current_ammo = MAX_AMMO

func _on_player_weapon_fired():
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


func _on_weapon_reload_reload_finished():
	%WeaponRecoil.snap_amount = owner.weapon_snap_speed_up
	%WeaponRecoil.speed = owner.weapon_snap_speed_down
	current_ammo = MAX_AMMO
	Global.player.ammo.set_text(str(current_ammo) + "/" + str(MAX_AMMO))
	reloading = false
