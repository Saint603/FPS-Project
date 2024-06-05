extends Node
class_name MultiplayerHandler

signal server_disconnected #outgoing signals
signal player_disconnected #player disconnected isn't used yet but figured i'd wire it up while im here

const PORT = 9999

var enet_peer = ENetMultiplayerPeer.new()
var address = "localhost"
var player_spawns : Array[Vector3]
var players = [] 

func _host():
	Global.game.mode = Global.game.modes.MULTI_PLAYER
	enet_peer.create_server(PORT)
	#connect multiplayer signals
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect( _on_player_disconnected)
	add_player(multiplayer.get_unique_id())
	upnp_setup()

func _join(): # i didnt connect signals here, maybe do the ones in _ready that need double connected
	Global.game.mode = Global.game.modes.MULTI_PLAYER
	enet_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	add_player(multiplayer.get_unique_id())
	
func add_player(peer_id):
	player_spawns = Global.current_level.spawns
	var player : Player
	player = Global.PLAYER_SCENE.instantiate()
	player.name = str(peer_id)
	players.append(player)
	Global.game.add_child(player)
	if !player_spawns: await Global.current_level.level_loaded
	player.global_position = player_spawns.pick_random()

func upnp_setup(): #Code from https://www.youtube.com/watch?v=n8D3vEx7NAE
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())

func _on_player_disconnected(peer_id):
	for i in players:
		if i.name == str(peer_id):
			print(str(peer_id) + " has disconnected!")
			i.queue_free()
			players.erase(i)
			player_disconnected.emit()

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	Global.game.main_menu.visible = true
	Global.game.main_menu.ERROR_LABEL.visible = true
	Global.game.main_menu.ERROR_LABEL.text = "ERROR: server shut down"
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	print("Server Shutting Down")
	

