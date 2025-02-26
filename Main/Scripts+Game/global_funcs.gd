extends Node

func add_sound_local(sound, volume: float = -10, buffer: float = 0.0, randomize_pitch: bool = false):
	var sound_player = AudioStreamPlayer.new()
	add_child(sound_player)
	sound_player.set_stream(load(sound))
	sound_player.volume_db = volume
	sound_player.finished.connect(_on_sound_finished.bind(sound_player))
	if randomize_pitch: sound_player.pitch_scale = randf_range(0.9,1.1)
	await get_tree().create_timer(buffer).timeout
	sound_player.play()

@rpc ("any_peer","call_remote","reliable")
func add_sound_remote(sound, location : Vector3, volume: float = -5, buffer: float = 0.0, randomize_pitch: bool = false):
	if multiplayer.get_remote_sender_id() == multiplayer.get_unique_id(): return 0
	if Global.game.mode != Global.game.modes.MULTI_PLAYER: return 0
	var sound_player = AudioStreamPlayer3D.new()
	add_child(sound_player)
	sound_player.global_position = location
	sound_player.set_stream(load(sound))
	sound_player.volume_db = volume
	sound_player.finished.connect(_on_sound_finished.bind(sound_player))
	if randomize_pitch: sound_player.pitch_scale = randf_range(0.9,1.1)
	await get_tree().create_timer(buffer).timeout
	sound_player.play()

func add_scene_local(packed_scene : PackedScene, location : Vector3):
	var scene = packed_scene.instantiate()
	add_child(scene)
	scene.global_position = location
	
@rpc ("any_peer","call_remote","reliable")
func add_scene_remote(packed_scene : PackedScene, location : Vector3):
	add_scene_local(packed_scene, location)
	
func add_decal_local(texture, position : Vector3, normal : Vector3, timeout : float = 5, fadetime : float = 2, size : Vector3 = Vector3(0.1 ,0.1 ,0.1 )):
	var instance = Decal.new()
	instance.set_texture(Decal.TEXTURE_ALBEDO, load(texture))
	instance.size = size
	add_child(instance)
	instance.global_position = position
	if normal != Vector3.UP and normal != Vector3.DOWN:
		instance.look_at(instance.global_transform.origin + normal, Vector3.UP)
	if normal != Vector3.UP and normal != Vector3.DOWN:
		instance.rotate_object_local(Vector3(1,0,0), 90)
	await get_tree().create_timer(timeout).timeout
	var fade = get_tree().create_tween()
	fade.tween_property(instance, "albedo_mix", 0, fadetime)
	await get_tree().create_timer(fadetime).timeout
	instance.queue_free()

@rpc ("any_peer","call_local","reliable")
func add_decal_synced(texture, position : Vector3, normal : Vector3, timeout : float, fadetime : float, size : Vector3 = Vector3(0.1 ,0.1 ,0.1 )):
	add_decal_local(texture , position , normal , timeout, fadetime)

func _on_sound_finished(sound_player):
	sound_player.queue_free()

