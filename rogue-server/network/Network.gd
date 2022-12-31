extends Node

var peer: NetworkedMultiplayerENet
var port = 1900
var max_players = 4


var players = {}


onready var l = $Log


func _ready() -> void:
	start_server()


func start_server() -> void:
	peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(port, max_players)	
	if err != 0:
		l.print("Creating server peer error code: " + str(err))
	get_tree().set_network_peer(peer)
	l.print("Server started on port: " + str(port))

	# warning-ignore:return_value_discarded
	peer.connect("peer_connected", self, "_on_peer_connected")
	# warning-ignore:return_value_discarded
	peer.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(id: int) -> void:
	l.print("Peer connected: " + str(id))
	# get player name from client
	players[id] = {"id": id, "name": "Player " + str(id)}


func _on_peer_disconnected(id: int) -> void:
	l.print("Peer disconnected: " + str(id))
	
	players.erase(id)


# Called by client to update their info
remote func req_update(json: String) -> void:
	var pid = get_tree().get_rpc_sender_id()
	assert(pid != 1, "Error: player update was incorrectly requested by a call from the server")
	var data = str2var(json)
	# Store server copy of player data
	players[pid] = data
	# Update all clients with new player info
	rpc("update_puppet", pid, json)


