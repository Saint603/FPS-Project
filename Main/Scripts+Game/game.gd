extends Node
class_name Game

@onready var main_menu : MainMenu = %MainMenu
@onready var synced_instances = %SyncedInstances

enum modes {SINGLE_PLAYER, MULTI_PLAYER}
var mode : modes = modes.SINGLE_PLAYER

func _ready():
	Global.game = self
	%MultiplayerSpawner.add_spawnable_scene(Global.PLAYER_SCENE.resource_path)

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
	if multiplayer.get_remote_sender_id() == multiplayer.get_unique_id(): return
	if mode != modes.MULTI_PLAYER: return
	var sound_player = AudioStreamPlayer3D.new()
	add_child(sound_player)
	sound_player.global_position = location
	sound_player.set_stream(load(sound))
	sound_player.volume_db = volume
	sound_player.finished.connect(_on_sound_finished.bind(sound_player))
	if randomize_pitch: sound_player.pitch_scale = randf_range(0.9,1.1)
	await get_tree().create_timer(buffer).timeout
	sound_player.play()

func _on_sound_finished(sound_player):
	sound_player.queue_free()
