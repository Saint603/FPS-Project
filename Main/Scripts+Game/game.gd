extends Node
class_name Game

@onready var synced_instances = %SyncedInstances
var spawn

enum modes {SINGLE_PLAYER, MULTI_PLAYER}
var mode : modes = modes.SINGLE_PLAYER
func _ready():
	Global.game = self
	spawn = %Spawn
"res://cs_office.tscn"
