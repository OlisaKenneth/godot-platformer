extends Node
class_name GameModel

signal board_changed(index: int, player: String)
signal turn_changed(player: String)
signal game_over(winner: String) # "X", "O", or "Cat"
signal invalid_move()

var board := []                # 9 values: "", "X", "O"
var current_player := "X"
var moves_made := 0

const LINES := [
	[0,1,2],[3,4,5],[6,7,8],     # rows
	[0,3,6],[1,4,7],[2,5,8],     # cols
	[0,4,8],[2,4,6]              # diags
]


func reset() -> void:
	board = ["","","","","","","","",""]
	current_player = "X"
	moves_made = 0
	emit_signal("turn_changed", current_player)


##this is the play techniques to play and prevent certain movess
func play_at(index: int) -> void:
	if index < 0 or index > 8:
		emit_signal("invalid_move"); return
	if board[index] != "":
		emit_signal("invalid_move"); return

	board[index] = current_player
	moves_made += 1
	emit_signal("board_changed", index, current_player)

	var w := _winner()
	if w != "":
		emit_signal("game_over", w); return
	if moves_made == 9:
		emit_signal("game_over", "Cat"); return

	_swap_turns()
	
##to initiate player swap
func _swap_turns() -> void:
	current_player = "O" if current_player == "X" else "X"
	emit_signal("turn_changed", current_player)

##to announce winner
func _winner() -> String:
	for line in LINES:
		var a = line[0]; var b = line[1]; var c = line[2]
		if board[a] != "" and board[a] == board[b] and board[b] == board[c]:
			return board[a]
	return ""
