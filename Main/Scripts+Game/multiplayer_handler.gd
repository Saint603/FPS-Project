extends Node
class_name MultiplayerHandler

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()
var address = "localhost"
var player_spawn : Vector3
var test_flag = false


func _host():
	Global.game.mode = Global.game.modes.MULTI_PLAYER
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()

func _join():
	Global.game.mode = Global.game.modes.MULTI_PLAYER
	enet_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	player_spawn = Global.game.spawn.global_position
	var player : Player
	player = Global.PLAYER_SCENE.instantiate()
	player.global_position = player_spawn
	player.name = str(peer_id)
	Global.game.add_child(player)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func upnp_setup():
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
