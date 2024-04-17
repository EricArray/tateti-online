class_name Match extends Resource

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
