class_name Board extends Node2D


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
