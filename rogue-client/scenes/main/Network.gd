extends Node

var peer: NetworkedMultiplayerENet
var ip: String = "127.0.0.1"
#var ip: String = "145.131.21.167" # public ip
var port: int = 1900
var is_connected: bool = false

var players = {}


func _ready() -> void:
	connect_to_server()


func connect_to_server() -> void:
	peer = NetworkedMultiplayerENet.new()
	var _err = peer.create_client(ip, port)
	print("Create client code: " + str(_err))
	get_tree().network_peer = peer
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")


func _on_connected_to_server() -> void:
	var pid = get_tree().get_network_unique_id()
	print("Connected to server: " + str(pid))
	is_connected = true


func _on_connection_failed() -> void:
	print("Connection failed")
	is_connected = false


func _on_server_disconnected() -> void:
	print("Server disconnected")
	players[get_tree().get_network_unique_id()] = null
	is_connected = false


# Send a request to server to update current player info
func req_update() -> void:
	if is_connected:
		# Convert data to json
		var json = var2str(GameData.data)
		# Send request to server
		rpc_id(1, "req_update", json)
	

# To be called by server to update remote player info
remote func update_puppet(pid: int, json: String) -> void:
	# Only server can call this
	if get_tree().get_rpc_sender_id() != 1:
		return
	# Don't update self
	if pid == get_tree().get_network_unique_id():
		return
	players[pid] = str2var(json)
	print("Updated player: " + players[pid])
