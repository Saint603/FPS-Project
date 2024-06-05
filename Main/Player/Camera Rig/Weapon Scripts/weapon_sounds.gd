class_name WeaponSounds
extends Node

var firing_sound = "res://Sounds/Gunshots/Gunshot_Homebrew.mp3"

func play_weapon_sound():
	Global.game.add_sound_local(firing_sound)
	Global.game.add_sound_remote.rpc(firing_sound, %WeaponBase.global_position)
