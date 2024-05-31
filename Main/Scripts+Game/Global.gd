extends Node

var PLAYER_SCENE : PackedScene = load("res://Main/Player/Main/player.tscn")
var debug : DebugPanel #debug panel ref
var current_level : Level
var game : Game
var player : Player
