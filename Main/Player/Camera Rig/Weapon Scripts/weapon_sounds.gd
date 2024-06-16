class_name WeaponSounds
extends Node

var firing_sound = "res://Sounds/Gunshots/Gunshot_Homebrew.mp3"

func play_weapon_sound():
	GF.add_sound_local(firing_sound)
	GF.add_sound_remote.rpc(firing_sound, %WeaponBase.global_position)
