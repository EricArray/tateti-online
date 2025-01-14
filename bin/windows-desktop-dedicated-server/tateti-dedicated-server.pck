GDPC                                                                                          P   res://.godot/exported/206107301/export-218a8f2b3041327d8a5756f3a245f83b-icon.res�      '      ��\�����y9�{)��v    P   res://.godot/exported/206107301/export-3070c538c03ee49b7677ff960a3f5195-main.scnP3      �       ����4���_�i�    X   res://.godot/exported/206107301/export-98289422cd7d93003950872a7b97021f-background.res  �       '      D�MXJ|�ȧC75    T   res://.godot/exported/206107301/export-9ba3e1addef5169d007f42a0a7e5163d-player-3.res]      '      $y�G���8��;�>��    T   res://.godot/exported/206107301/export-b21cdbf443801928e74ff08f52fe0a00-player-2.res [      '      �[`��n�p�
!]�    T   res://.godot/exported/206107301/export-c35ee08df54f217cbf28fd790a8d994f-player-1.res�X      '      �[�g~^0c��[�Z�2    X   res://.godot/exported/206107301/export-de75b109a0ef34bfbb9569df46f58a57-new_theme.res   �U      o      ��c&M�$���R<�    ,   res://.godot/global_script_class_cache.cfg  p      f      �W*D��J�̤=��.av       res://.godot/uid_cache.bin  @v      �       5ayA���S4�Gŕ6)       res://Board.gd        �      L�>+�h��("h5E/�       res://Match.gd   T      �      �/1�
���Di�q       res://PlayerInLobby.gd  @^      i       ƻQ���vѡ�:Ƽ>       res://PlayerInMatch.gd  �^      �       ����Ӈ��B!!�t       res://RandomNameGenerator.gd@_      �      �vJ�^;OR���y�^.�       res://background.png.import         �       C��3:�I4�2���Z�       res://icon.svg  �r      �      C��=U���^Qu��U3       res://icon.svg.import   �      �       |�!��y8Bk�`��       res://main.gd   �      �*      G,�r�����0�)NL�       res://main.tscn.remap   0o      a       �gV��J=����ܒ       res://new_theme.tres.remap  �o      f       A��Б!N�Z��b       res://player-1.png.import   X      �       P�m���XT����T�       res://player-2.png.import    Z      �       l���|��+�o�Q"�^       res://player-3.png.import   0\      �       ˣ)�d |F�s�S=�       res://project.binary w      �      Q�--�v�-u��/~                [remap]

importer="texture"
type="PlaceholderTexture2D"
uid="uid://nmfs8eyg2ye1"
metadata={
"vram_texture": false
}
path="res://.godot/exported/206107301/export-98289422cd7d93003950872a7b97021f-background.res"
              RSRC                    PlaceholderTexture2D            ��������                                                  resource_local_to_scene    resource_name    size    script        #   local://PlaceholderTexture2D_0tidb �          PlaceholderTexture2D       
      D   D      RSRC         class_name Board extends Node2D


signal square_clicked(x: int, y: int)


@export var shapes: Array[Texture2D]


@onready var marks: Array[Array] = [
	[$Mark00, $Mark01, $Mark02],
	[$Mark10, $Mark11, $Mark12],
	[$Mark20, $Mark21, $Mark22],
]


func _ready():
	hide_marks()
	connect_marks()


func hide_marks():
	for y in range(3):
		for x in range(3):
			marks[y][x].get_node("Sprite2D").visible = false


func connect_marks():
	for y in range(3):
		for x in range(3):
			marks[y][x].input_event.connect(func(viewport, event, shape_idx): on_mark_input(x, y, event))


func on_mark_input(x: int, y: int, event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			square_clicked.emit(x, y)


func refresh_squares(match_: Match):
	for y in range(3):
		for x in range(3):
			var marked_by = match_.squares[y][x]
			if marked_by == 0:
				marks[y][x].get_node("Sprite2D").visible = false
			else:
				var player = match_.players.filter(func(p): return p.peer_id == marked_by).front()
				var shape = shapes[player.shape]
				marks[y][x].get_node("Sprite2D").visible = true
				marks[y][x].get_node("Sprite2D").texture = shape
               [remap]

importer="texture"
type="PlaceholderTexture2D"
uid="uid://b4je6826xq8l4"
metadata={
"vram_texture": false
}
path="res://.godot/exported/206107301/export-218a8f2b3041327d8a5756f3a245f83b-icon.res"
   RSRC                    PlaceholderTexture2D            ��������                                                  resource_local_to_scene    resource_name    size    script        #   local://PlaceholderTexture2D_o67d4 �          PlaceholderTexture2D       
      C   C      RSRC         extends Node2D


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
	
	match_.squares[y][x] = marked_by
	
	render_square_mark_on_client.rpc_id(match_.players[0].peer_id, x, y, multiplayer.get_remote_sender_id())
	render_square_mark_on_client.rpc_id(match_.players[1].peer_id, x, y, multiplayer.get_remote_sender_id())
	
	match_.turn_of_peer_id = match_.players.filter(func(p): return p.peer_id != marked_by).front().peer_id
	
	check_match_state(match_)
	

@rpc("reliable")
func render_square_mark_on_client(x: int, y: int, marked_by_peer_id: int):
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
          RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    size    script    custom_solver_bias    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset 	   _bundled       Script    res://main.gd ��������   Script    res://Board.gd ��������   Theme    res://new_theme.tres ���VY2   #   local://PlaceholderTexture2D_ple5u �      #   local://PlaceholderTexture2D_5dccc �      #   local://PlaceholderTexture2D_4umam #      #   local://PlaceholderTexture2D_sx0sr X      #   local://PlaceholderTexture2D_g4n2b �         local://RectangleShape2D_okvhx �      #   local://PlaceholderTexture2D_7uvdg �      #   local://PlaceholderTexture2D_1e6do (      #   local://PlaceholderTexture2D_ad4vq ]      #   local://PlaceholderTexture2D_nhvvk �      #   local://PlaceholderTexture2D_k43ns �      #   local://PlaceholderTexture2D_sgx8t �      #   local://PlaceholderTexture2D_4ujen 1      #   local://PlaceholderTexture2D_daeep f         local://LabelSettings_0k6iv �         local://PackedScene_3ydqp �         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
      D   D         PlaceholderTexture2D       
     �B  �B         RectangleShape2D       
     
C  C         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         PlaceholderTexture2D       
     �B  �B         LabelSettings              	         
                    �?         PackedScene          	         names "   Q      Node2D    script 	   Camera2D    Board    unique_name_in_owner    shapes    Background    texture 	   Sprite2D    Mark00 	   position    Area2D    CollisionShape2D    shape    Mark01    Mark02    Mark10    Mark11    Mark12    Mark20    Mark21    Mark22    UI    CanvasLayer    CenterContainer    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    theme 	   MainMenu    custom_minimum_size    layout_mode    PanelContainer    MarginContainer    VBoxContainer    Label    text    label_settings    horizontal_alignment    HBoxContainer    size_flags_horizontal    MainMenuServerAddress    expand_to_text_length 	   LineEdit    HBoxContainer2    GenRandomName    Button 	   YourName    placeholder_text    FindAMatch    HostAsServer    FindingOpponentMenu    visible    CancelFindOpponent    ConnectingMenu    Cancel    ServerMenu    Label3    ConnectedPlayersList    Label2    ShutdownServer    WinnerMenu    WinnerPlayAgain 
   LoserMenu    LoserPlayAgain 	   DrawMenu    DrawPlayAgain    MatchTitleContainer    anchor_left    offset_left    offset_right    offset_bottom    size_flags_vertical    MatchTitle    MatchPlayers    TurnIndicatorContainer    anchor_top    offset_top    TurnIndicatorLabel    	   variants    >                                                                       
     $�  �                  
     @�  �         
     %C  �         
     �   A         
      @  �@      	   
     #C  @@      
   
     �  C         
     ��  C         
     'C  (C                    �?               
     �C       	   Ta Te Ti                            Server 
     C       
   localhost    
   Your name       🎲       Enter your name here       Find a match       Host as server              Finding an opponent...       Cancel
       Connecting to server...       Connected players:       Listening to connections...       Shutdown server    	   YOU WIN!       Play again    
   YOU LOSE!       IT'S A DRAW!             ?     ��     �A     HB                        ��     �A      node_count    V         nodes     �  ��������        ����                            ����                       ����                                      ����                       	   ����   
                       ����                          ����                          ����   
                       ����      	                    ����                          ����   
   
       
             ����             
             ����                          ����   
                       ����                          ����                          ����   
                       ����                          ����                          ����   
                       ����                          ����                          ����   
                       ����                          ����                          ����   
                       ����                          ����                          ����   
                       ����                          ����                           ����                     ����                                                   "      ����                !          !       #   #   ����   !          "       $   $   ����   !          #       %   %   ����   !      &      '      (          #       )   )   ����   !          %       %   %   ����   !      *       &   !       %       -   +   ����             "   !      &   #   ,          #       )   .   ����   !          (       %   %   ����   !      *       &   $       (       0   /   ����         !      &   %       (       -   1   ����             "   !      2   &   ,          #       0   3   ����         !      &   '       #       0   4   ����         !      &   (               "   5   ����         6   )   !          .       #   #   ����   !          /       $   $   ����   !          0       %   %   ����   !      &   *       0       0   7   ����         !      &   +               "   8   ����         6   )   !          3       #   #   ����   !          4       $   $   ����   !          5       %   %   ����   !      &   ,       5       0   9   ����   !      &   +               "   :   ����         6   )   !          8       #   #   ����   !          9       $   $   ����   !          :       %   %   ����   !      &   !       :       %   ;   ����   !      &   -       :       $   <   ����         !          :       %   =   ����   !      &   .       :       0   >   ����         !      &   /               "   ?   ����         6   )   !          @       #   #   ����   !          A       $   $   ����   !          B       %   %   ����   !      &   0   '      (          B       0   @   ����         !      &   1               "   A   ����         6   )   !          E       #   #   ����   !          F       $   $   ����   !          G       %   %   ����   !      &   2   '      (          G       0   B   ����         !      &   1               "   C   ����         6   )   !          J       #   #   ����   !          K       $   $   ����   !          L       %   %   ����   !      &   3   '      (          L       0   D   ����         !      &   1              "   E   ����         6   )      4   F   5      5   G   6   H   7   I   8         *   9   J   :       O       $   $   ����   !          P       %   K   ����         !      '      (          P       %   L   ����         !                 "   M   ����         6   )      ;   F   5   N         5         G   <   O   <   H   =            :   *   9   J   :       S       $   $   ����   !          T       %   P   ����         !      (                conn_count              conns               node_paths              editable_instances              version             RSRC             class_name Match extends Resource

enum MatchState {
	PLAYING,
	DRAW,
	SOMEONE_WON,
}

@export var match_id: int
@export var match_name: String
@export var players: Array[PlayerInMatch]
@export var turn_of_peer_id: int

# matrix of peer_id of who did click the square, and zero if none
@export var squares: Array[Array]

@export var state: MatchState = MatchState.PLAYING

@export var winner_peer_id: int = 0
       RSRC                    Theme            ��������                                                  resource_local_to_scene    resource_name    default_base_scale    default_font    default_font_size    Label/colors/font_shadow_color +   LineEdit/constants/minimum_character_width (   MarginContainer/constants/margin_bottom &   MarginContainer/constants/margin_left '   MarginContainer/constants/margin_right %   MarginContainer/constants/margin_top    script           local://Theme_ccl7p          Theme                        �?                           	         
               RSRC [remap]

importer="texture"
type="PlaceholderTexture2D"
uid="uid://t1rtu20wq3g6"
metadata={
"vram_texture": false
}
path="res://.godot/exported/206107301/export-c35ee08df54f217cbf28fd790a8d994f-player-1.res"
                RSRC                    PlaceholderTexture2D            ��������                                                  resource_local_to_scene    resource_name    size    script        #   local://PlaceholderTexture2D_evxbd �          PlaceholderTexture2D       
     �B  �B      RSRC         [remap]

importer="texture"
type="PlaceholderTexture2D"
uid="uid://dlvf54t1ylv73"
metadata={
"vram_texture": false
}
path="res://.godot/exported/206107301/export-b21cdbf443801928e74ff08f52fe0a00-player-2.res"
               RSRC                    PlaceholderTexture2D            ��������                                                  resource_local_to_scene    resource_name    size    script        #   local://PlaceholderTexture2D_4i0xi �          PlaceholderTexture2D       
     �B  �B      RSRC         [remap]

importer="texture"
type="PlaceholderTexture2D"
uid="uid://u7wwvqfa0bip"
metadata={
"vram_texture": false
}
path="res://.godot/exported/206107301/export-9ba3e1addef5169d007f42a0a7e5163d-player-3.res"
                RSRC                    PlaceholderTexture2D            ��������                                                  resource_local_to_scene    resource_name    size    script        #   local://PlaceholderTexture2D_v8ulg �          PlaceholderTexture2D       
     �B  �B      RSRC         class_name PlayerInLobby extends Resource

@export() var peer_id: int
@export() var player_name: String

       class_name PlayerInMatch extends Resource

@export() var peer_id: int
@export() var player_name: String
@export() var shape: int
               class_name RandomNameGenerator extends Node

const ADJECTIVES: Array[String] = [
	"Ancient",
	"Minimalist",
	"Beautiful",
	"Ornate",
	"Complex",
	"Practical",
	"Durable",
	"Quirky",
	"Elegant",
	"Robust",
	"Functional",
	"Sculptural",
	"Geometric",
	"Timeless",
	"Handcrafted",
	"Unique",
	"Innovative",
	"Versatile",
	"Intricate",
	"Shiny",
	"Majestic",
	"Smooth",
	"Minimalist",
	"Big",
	"Ornate",
	"Dirty",
	"Practical",
	"Hard",
	"Quirky",
	"Round",
	"Robust",
	"Stripy",
	"Sculptural",
	"Filthy",
	"Timeless",
	"Dark",
	"Unique",
	"Shiny",
	"Versatile",
	"Bright",
	"Shiny",
	"Clean",
	"Smooth",
	"Small",
	"Big",
	"Colorful",
	"Dirty",
	"Expensive",
	"Hard",
	"Full",
	"Round",
	"Smelly",
	"Stripy",
	"Blunt",
	"Filthy",
	"New",
	"Dark",
	"Transparent",
	"Shiny",
	"Spotless",
	"Bright",
	"Opaque",
	"Clean",
	"Empty",
	"Small",
	"Soft",
	"Colorful",
	"Blunt",
	"Expensive",
	"Old",
	"Full",
	"Sharp",
	"Smelly",
	"Clean",
	"Blunt",
	"Small",
	"New",
	"Colorful",
	"Transparent",
	"Expensive",
	"Spotless",
	"Full",
	"Opaque",
	"Smelly",
	"Empty",
	"Blunt",
	"Soft",
	"New",
	"Blunt",
	"Transparent",
	"Old",
	"Spotless",
	"Sharp",
	"Opaque",
	"Clean",
	"Empty",
	"Small",
	"Soft",
	"Colorful",
	"Bright",
]

const NOUNS: Array[String] = [
	"Dragon",
	"Griffin",
	"Phoenix",
	"Centaur",
	"Unicorn",
	"Nymph",
	"Gnome",
	"Elf",
	"Dwarf",
	"Troll",
	"Basilisk",
	"Chimera",
	"Pixie",
	"Sylph",
	"Gargoyle",
	"Leprechaun",
	"Mermaid",
	"Cyclops",
	"Djinni",
	"Werewolf",
	"Vampire",
	"Banshee",
	"Kraken",
	"Harpy",
	"Minotaur",
	"Goblin",
	"Ogre",
	"Wraith",
	"Specter",
	"Salamander",
	"Homunculus",
	"Yeti",
	"Sphinx",
	"Leviathan",
	"Manticore",
	"Faun",
	"Pegasus",
	"Satyr",
	"Valkyrie",
	"Seraphim",
	"Necromancer",
	"Warlock",
	"Sorcerer",
	"Witch",
	"Mage",
	"Wizard",
	"Familiar",
	"Shapeshifter",
	"Elemental",
	"Zephyr",
	"Avalon",
	"El Dorado",
	"Shangri-La",
	"Atlantis",
	"Camelot",
	"Middle-Earth",
	"Narnia",
	"Asgard",
	"Valhalla",
	"Olympus",
	"Neverland",
	"Wonderland",
	"Elysium",
	"Hades",
	"Tartarus",
	"Arcadia",
	"Utopia",
	"Limbo",
	"Purgatory",
	"Aether",
	"Ether",
	"Underworld",
	"Nirvana",
	"Eden",
	"Styx",
	"Pantheon",
	"Valinor",
	"Xanadu",
	"Hyperborea",
	"Agartha",
	"Avalonia",
	"Brigadoon",
	"Cimmeria",
	"Dystopia",
	"Empyrean",
	"Faerie",
	"Gehenna",
	"Hel",
	"Ithaca",
	"Jotunheim",
	"Kailasa",
	"Lemuria",
	"Mirkwood",
	"Nastrond",
	"Olympos",
	"Pandemonium",
	"Quivira",
	"Ragnarok",
	"Samarkand",
	"Thule",
]

const EVENT_NOUNS: Array[String] = [
	"Encounter",
	"Celebration",
	"Incident",
	"Gathering",
	"Ceremony",
	"Festival",
	"Competition",
	"Performance",
	"Parade",
	"Wedding",
	"Tournament",
	"Ritual",
	"Conference",
	"Exhibition",
	"Reunion",
	"Showcase",
	"Spectacle",
	"Procession",
	"Happening",
	"Occurrence",
	"Festivity",
	"Pageant",
	"Assembly",
	"Symposium",
	"Gala",
	"Jamboree",
	"Convention",
	"Ceremonial",
	"Gathering",
	"Performance",
	"Celebration",
	"Competition",
	"Parade",
	"Festival",
	"Wedding",
	"Tournament",
	"Ritual",
	"Conference",
	"Exhibition",
	"Reunion",
	"Showcase",
	"Spectacle",
	"Procession",
	"Happening",
	"Occurrence",
	"Festivity",
	"Pageant",
	"Assembly",
	"Symposium",
	"Gala",
	"Jamboree",
	"Convention",
	"Ceremonial",
	"Gathering",
	"Performance",
	"Celebration",
	"Competition",
	"Parade",
	"Festival",
	"Wedding",
	"Tournament",
	"Ritual",
	"Conference",
	"Exhibition",
	"Reunion",
	"Showcase",
	"Spectacle",
	"Procession",
	"Happening",
	"Occurrence",
	"Festivity",
	"Pageant",
	"Assembly",
	"Symposium",
	"Gala",
	"Jamboree",
	"Convention",
	"Ceremonial",
	"Gathering",
	"Performance",
	"Celebration",
	"Competition",
	"Parade",
	"Festival",
	"Wedding",
	"Tournament",
	"Ritual",
	"Conference",
	"Exhibition",
	"Reunion",
	"Showcase",
	"Spectacle",
	"Procession",
	"Happening",
	"Occurrence",
	"Festivity",
	"Pageant",
	"Assembly",
	"Symposium",
	"Gala",
]

static func gen_random_name() -> String:
	return ADJECTIVES.pick_random() + " " + NOUNS.pick_random()

static func get_random_event_name() -> String:
	return ADJECTIVES.pick_random() + " " + EVENT_NOUNS.pick_random()
 [remap]

path="res://.godot/exported/206107301/export-3070c538c03ee49b7677ff960a3f5195-main.scn"
               [remap]

path="res://.godot/exported/206107301/export-de75b109a0ef34bfbb9569df46f58a57-new_theme.res"
          list=Array[Dictionary]([{
"base": &"Node2D",
"class": &"Board",
"icon": "",
"language": &"GDScript",
"path": "res://Board.gd"
}, {
"base": &"Resource",
"class": &"Match",
"icon": "",
"language": &"GDScript",
"path": "res://Match.gd"
}, {
"base": &"Resource",
"class": &"PlayerInLobby",
"icon": "",
"language": &"GDScript",
"path": "res://PlayerInLobby.gd"
}, {
"base": &"Resource",
"class": &"PlayerInMatch",
"icon": "",
"language": &"GDScript",
"path": "res://PlayerInMatch.gd"
}, {
"base": &"Node",
"class": &"RandomNameGenerator",
"icon": "",
"language": &"GDScript",
"path": "res://RandomNameGenerator.gd"
}])
          <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             � �'�Π=   res://icon.svg|`Y�UD   res://player-1.png?����j   res://player-3.png|�0��n   res://player-2.png:�ow_�   res://background.png֌����   res://main.tscn���VY2   res://new_theme.tres             ECFG      _custom_features         dedicated_server   application/config/name         online-ta-te-ti    application/run/main_scene         res://main.tscn    application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg  "   display/window/size/viewport_width         #   display/window/size/viewport_height            display/window/stretch/mode         viewport   display/window/stretch/aspect         expand  #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility2   rendering/environment/defaults/default_clear_color      ��>���>���=  �?             