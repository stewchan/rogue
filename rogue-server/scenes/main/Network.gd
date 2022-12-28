extends Node

var network: NetworkedMultiplayerENet
var port = 1900
var max_players = 4


var players = {}


func _ready() -> void:
  print("Starting server on port: " + str(port))
  start_server()


func start_server() -> void:
  network = NetworkedMultiplayerENet.new()
  network.create_server(port, max_players)
  get_tree().set_network_peer(network)
  print("Server started on port: " + str(port))

  network.connect("peer_connected", self, "_on_peer_connected")
  network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(id: int) -> void:
  print("Peer connected: " + str(id))
  # get player name from client
  
  players[id] = {"id": id, "name": "Player " + str(id)}


func _on_peer_disconnected(id: int) -> void:
  print("Peer disconnected: " + str(id))
  players.erase(id)


# Called by client to update their info
remote func req_update(json: String) -> void:
	var pid = get_tree().get_rpc_sender_id()
	var info = str2var(json)
	players[pid] = info
	
	# Update all clients with new player info
	rpc("update_puppet", pid, json)
