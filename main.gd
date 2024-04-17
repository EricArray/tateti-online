extends Node2D


enum Menu {
	NONE,
	MAIN_MENU,
	FINDING_OPPONENT_MENU,
	CONNECTING_MENU,
	SERVER_MENU,
	WINNER_MENU,
	LOSER_MENU,
	DRAW_MENU,
}


const SERVER_PORT = 9999
const MAX_CLIENTS = 20


@onready var main_menu: Control = %MainMenu
@onready var button_host_as_server: Button = %HostAsServer
@onready var button_find_a_match: Button = %FindAMatch
@onready var button_gen_random_name: Button = %GenRandomName
@onready var input_server_address: LineEdit = %MainMenuServerAddress
@onready var input_your_name: LineEdit = %YourName

@onready var server_menu: Control = %ServerMenu
@onready var button_shutdown_server: Button = %ShutdownServer
@onready var connected_players_list: Control = %ConnectedPlayersList

@onready var connecting_menu: Control = %ConnectingMenu

@onready var finding_opponent_menu: Control = %FindingOpponentMenu
@onready var button_cancel_find_opponent: Button = %CancelFindOpponent

@onready var board: Board = %Board

@onready var winner_menu: Control = %WinnerMenu
@onready var winner_play_again_button: Button = %WinnerPlayAgain

@onready var loser_menu: Control = %LoserMenu
@onready var loser_play_again_button: Button = %LoserPlayAgain

@onready var draw_menu: Control = %DrawMenu
@onready var draw_play_again_button: Button = %DrawPlayAgain

@onready var match_title_container: Control = %MatchTitleContainer
@onready var match_title_label: Label = %MatchTitle
@onready var match_players_label: Label = %MatchPlayers

@onready var turn_indicator_container: Control = %TurnIndicatorContainer
@onready var turn_indicator_label: Label = %TurnIndicatorLabel


var mode: String = ""
var displayed_menu: Menu:
	set(value):
		main_menu.visible = value == Menu.MAIN_MENU
		server_menu.visible = value == Menu.SERVER_MENU
		connecting_menu.visible = value == Menu.CONNECTING_MENU
		finding_opponent_menu.visible = value == Menu.FINDING_OPPONENT_MENU
		winner_menu.visible = value == Menu.WINNER_MENU
		loser_menu.visible = value == Menu.LOSER_MENU
		draw_menu.visible = value == Menu.DRAW_MENU


var players_in_lobby: Array[PlayerInLobby] = []
var matches: Array[Match] = []
var last_match_id: int = 0

var client_match: Match = null

func _ready():
	print("Starting Ta Te Ti")
	
	input_your_name.text = RandomNameGenerator.gen_random_name()
	button_gen_random_name.pressed.connect(func():
		input_your_name.text = RandomNameGenerator.gen_random_name()
	)
	
	button_host_as_server.pressed.connect(on_host_as_server_pressed)
	button_shutdown_server.pressed.connect(on_shutdown_server_pressed)
	button_find_a_match.pressed.connect(on_find_a_match_pressed)
	button_cancel_find_opponent.pressed.connect(on_cancel_find_opponent_pressed)
	winner_play_again_button.pressed.connect(on_play_again_pressed)
	loser_play_again_button.pressed.connect(on_play_again_pressed)
	draw_play_again_button.pressed.connect(on_play_again_pressed)

	# #####################
	# Server
	multiplayer.peer_connected.connect(func(id: int):
		if multiplayer.is_server():
			custom_print(">> multiplayer.peer_connected(id = %d)" % id)
	)
	multiplayer.peer_disconnected.connect(func(id: int):
		if multiplayer.is_server():
			custom_print(">> multiplayer.peer_disconnected(id = %d)" % id)
			players_in_lobby = players_in_lobby.filter(
				func(pil):
					return pil.peer_id != id
			)
			refresh_displayed_connected_players()
	)
	
	# #####################
	# Client
	multiplayer.connected_to_server.connect(func():
		custom_print(">> multiplayer.connected_to_server")
		mode = "CLIENT"
		displayed_menu = Menu.FINDING_OPPONENT_MENU
		enter_lobby.rpc_id(0, input_your_name.text)
	)

	multiplayer.connection_failed.connect(func():
		custom_print(">> multiplayer.connection_failed")
		disconnect_from_server()
	)

	multiplayer.server_disconnected.connect(func():
		custom_print(">> multiplayer.server_disconnected")
		disconnect_from_server()
	)
	
	board.square_clicked.connect(on_board_square_clicked)
	
	if OS.has_feature("dedicated_server"):
		on_host_as_server_pressed()


func on_host_as_server_pressed():
	var peer = ENetMultiplayerPeer.new()
	custom_print("Serving on port %d" % SERVER_PORT)
	var error = peer.create_server(SERVER_PORT, MAX_CLIENTS)
	if error != OK:
		custom_print("Error creating server")
		return
	multiplayer.multiplayer_peer = peer
	custom_print("Server listening on port %d" % SERVER_PORT)
	displayed_menu = Menu.SERVER_MENU
	mode = "SERVER"


func on_shutdown_server_pressed():
	multiplayer.multiplayer_peer = null
	mode = ""
	displayed_menu = Menu.MAIN_MENU


func on_find_a_match_pressed():
	displayed_menu = Menu.CONNECTING_MENU
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(input_server_address.text, SERVER_PORT)
	if error != OK:
		custom_print("Error connecting to server")
		return
	multiplayer.multiplayer_peer = peer
	custom_print("Connecting to server %s port %d" % [input_server_address.text, SERVER_PORT])


func on_cancel_find_opponent_pressed():
	disconnect_from_server()


func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	mode = ""
	displayed_menu = Menu.MAIN_MENU


func custom_print(message: String):
	print("[", multiplayer.multiplayer_peer.get_unique_id(), "] ", message)


@rpc("call_local", "reliable")
func broadcast_print(message: String):
	custom_print("Broadcast received: \"%s\"" % message)

@rpc("any_peer", "reliable")
func enter_lobby(player_name: String):
	custom_print("Player %d \"%s\" entered the lobby" % [multiplayer.get_remote_sender_id(), player_name])
	var player_in_lobby: PlayerInLobby = PlayerInLobby.new()
	player_in_lobby.peer_id = multiplayer.get_remote_sender_id()
	player_in_lobby.player_name = player_name
	players_in_lobby.append(player_in_lobby)
	refresh_displayed_connected_players()
	try_to_matchup()


func refresh_displayed_connected_players():
	for child in connected_players_list.get_children():
		child.queue_free()
		
	for player_in_lobby in players_in_lobby:
		var new_label = Label.new()
		new_label.text = "[%d] %s" % [player_in_lobby.peer_id, player_in_lobby.player_name]
		connected_players_list.add_child(new_label)


func try_to_matchup():
	if players_in_lobby.size() >= 2:
		matchup(players_in_lobby.slice(0, 2))


func matchup(players: Array[PlayerInLobby]):
	players_in_lobby = players_in_lobby.filter(func(p): return p != players[0] and p != players[1])
	refresh_displayed_connected_players()
	
	var new_match = Match.new()
	last_match_id += 1
	new_match.match_id = last_match_id
	new_match.match_name = RandomNameGenerator.get_random_event_name()
	new_match.players
	new_match.players.assign(players.map(func(player):
		var player_in_match: PlayerInMatch = PlayerInMatch.new()
		player_in_match.peer_id = player.peer_id
		player_in_match.player_name = player.player_name
		return player_in_match
	))
	
	var shapes = [0, 1, 2]
	new_match.players[0].shape = shapes.pick_random()
	shapes.erase(new_match.players[0].shape)
	new_match.players[1].shape = shapes.pick_random()
	
	new_match.turn_of_peer_id = players.pick_random().peer_id
	new_match.squares.assign([
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
	])
	
	matches.append(new_match)
	
	var match_as_str = var_to_str(new_match)
	match_started.rpc_id(players[0].peer_id, match_as_str)
	match_started.rpc_id(players[1].peer_id, match_as_str)


@rpc("reliable")
func match_started(match_as_str: String):
	client_match = str_to_var(match_as_str)
	displayed_menu = Menu.NONE
	board.refresh_squares(client_match)
	match_title_container.visible = true
	match_title_label.text = client_match.match_name
	match_players_label.text = (
		client_match.players[0].player_name +
		" VS " +
		client_match.players[1].player_name
	)
	turn_indicator_container.visible = true
	refresh_turn_indicator()


func on_board_square_clicked(x: int, y: int):
	if client_match:
		player_clicked_board_square.rpc_id(1, client_match.match_id, x, y)

@rpc("any_peer", "reliable")
func player_clicked_board_square(match_id: int, x: int, y: int):
	var match_: Match = matches.filter(func(m): return m.match_id == match_id).front()
	if not match_:
		custom_print("Invalid match ID")
		return
	
	var marked_by = multiplayer.get_remote_sender_id()
	if match_.turn_of_peer_id != marked_by:
		custom_print("Not your turn")
		return
		
	if match_.squares[y][x] != 0:
		custom_print("Square already used")
		return
	
	match_.squares[y][x] = marked_by
	
	render_square_mark_on_client.rpc_id(match_.players[0].peer_id, x, y, multiplayer.get_remote_sender_id())
	render_square_mark_on_client.rpc_id(match_.players[1].peer_id, x, y, multiplayer.get_remote_sender_id())
	
	match_.turn_of_peer_id = match_.players.filter(func(p): return p.peer_id != marked_by).front().peer_id
	
	check_match_state(match_)
	

@rpc("reliable")
func render_square_mark_on_client(x: int, y: int, marked_by_peer_id: int):
	$AudioStreamPlayer.play()
	
	client_match.squares[y][x] = marked_by_peer_id
	board.refresh_squares(client_match)
	client_match.turn_of_peer_id = client_match.players.filter(func(p): return p.peer_id != marked_by_peer_id).front().peer_id
	refresh_turn_indicator()


func refresh_turn_indicator():
	if client_match.turn_of_peer_id == multiplayer.get_unique_id():
		turn_indicator_label.text = "Your turn"
	else:
		var other: PlayerInMatch = client_match.players.filter(func(p): return p.peer_id == client_match.turn_of_peer_id).front()
		turn_indicator_label.text = "Waiting for %s" % other.player_name


func check_match_state(match_: Match):
	var possible_winning_lines = [
		# vertical
		[[0,0], [0,1], [0,2]],
		[[1,0], [1,1], [1,2]],
		[[2,0], [2,1], [2,2]],
		
		# horizontal
		[[0,0], [1,0], [2,0]],
		[[0,1], [1,1], [2,1]],
		[[0,2], [1,2], [2,2]],
		
		# diagonal
		[[0,0], [1,1], [2,2]],
		[[0,2], [1,1], [2,0]],
	]
	
	for line in possible_winning_lines:
		var marks = line.map(func(point): return match_.squares[point[0]][point[1]])
		if marks[0] != 0 and marks[0] == marks[1] and marks[0] == marks[2]:
			match_has_a_winner(match_, marks[0])
			return
	
	var board_is_full = match_.squares.all(
		func(line): return line.all(
			func(square): return square != 0
		)
	)
	if board_is_full:
		match_is_a_draw(match_)

func match_has_a_winner(match_: Match, winner_peer_id: int):
	match_.winner_peer_id = winner_peer_id
	match_.state = Match.MatchState.SOMEONE_WON
	declare_winner.rpc_id(match_.players[0].peer_id, winner_peer_id, match_.players[0].peer_id == winner_peer_id)
	declare_winner.rpc_id(match_.players[1].peer_id, winner_peer_id, match_.players[1].peer_id == winner_peer_id)

@rpc("reliable")
func declare_winner(winner_peer_id: int, you_win: bool):
	if you_win:
		displayed_menu = Menu.WINNER_MENU
	else:
		displayed_menu = Menu.LOSER_MENU
	client_match = null

func match_is_a_draw(match_: Match):
	match_.state = Match.MatchState.DRAW
	declare_draw.rpc_id(match_.players[0].peer_id)
	declare_draw.rpc_id(match_.players[1].peer_id)

@rpc("reliable")
func declare_draw():
	displayed_menu = Menu.DRAW_MENU
	client_match = null

func on_play_again_pressed():
	displayed_menu = Menu.FINDING_OPPONENT_MENU
	enter_lobby.rpc_id(0, input_your_name.text)
