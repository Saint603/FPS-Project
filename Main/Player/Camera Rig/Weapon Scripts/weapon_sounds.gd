class_name WeaponSounds
extends Node

var firing_sound = "res://Sounds/Gunshots/Gunshot_Homebrew.mp3"

func add_sound(locationVector, sound, buffer: float = 0.0, volume: float = -10, randomize_pitch: bool = false, is_local : bool = true):
	if Global.player.mp_check():
		is_local = false
	sound = firing_sound
	var sound_player
	if is_local:
		sound_player = AudioStreamPlayer.new()
	else:
		sound_player = AudioStreamPlayer3D.new()
		sound_player.global_position = locationVector
	add_child(sound_player)
	sound_player.set_stream(load(sound))
	sound_player.volume_db = volume
	sound_player.finished.connect(_on_sound_finished.bind(sound_player))
	if randomize_pitch: sound_player.pitch_scale = randf_range(0.9,1.1)
	await get_tree().create_timer(buffer).timeout
	sound_player.play()

func _on_sound_finished(sound_player):
	sound_player.queue_free()
	
	
