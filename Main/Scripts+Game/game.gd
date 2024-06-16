extends Node
class_name Game

@onready var main_menu : MainMenu = %MainMenu
@onready var synced_instances = %SyncedInstances

enum modes {SINGLE_PLAYER, MULTI_PLAYER}
var mode : modes = modes.SINGLE_PLAYER

func _ready():
	Global.game = self
	%MultiplayerSpawner.add_spawnable_scene(Global.PLAYER_SCENE.resource_path)
