extends Control
class_name GameController

@onready var turn_label: Label = %TurnLabel
@onready var board_view: BoardView = %BoardView
@onready var new_game_button: Button = %NewGameButton
@onready var result_dialog: AcceptDialog = %ResultDialog

var model: GameModel

func _ready() -> void:
	# Create and attach Model
	model = GameModel.new()
	add_child(model)

	# Safety checks (helpful while iterating)
	if board_view == null:
		push_error("BoardView not found. Mark it Unique and use %BoardView, or fix the path."); return
	if not board_view.has_signal("cell_clicked"):
		push_error("BoardView script not attached or missing 'cell_clicked' signal."); return

	board_view.cell_clicked.connect(_on_cell_clicked)


	model.board_changed.connect(_on_board_changed)
	model.turn_changed.connect(_on_turn_changed)
	model.game_over.connect(_on_game_over)



	new_game_button.pressed.connect(_on_new_game)

	_on_new_game()

func _on_new_game() -> void:
	result_dialog.hide()
	board_view.clear_all()
	model.reset() ## emits a output when turn_changed


##to emit a cell clicked 
func _on_cell_clicked(index: int) -> void:
	model.play_at(index)

func _on_board_changed(index: int, player: String) -> void:
	board_view.put_mark(index, player)

func _on_turn_changed(player: String) -> void:
	turn_label.text = "Turn: %s" % player

func _on_game_over(winner: String) -> void:
	# Find winners to highlight
	var winners := []
	for line in GameModel.LINES:
		var a = line[0]; var b = line[1]; var c = line[2]
		if model.board[a] != "" and model.board[a] == model.board[b] and model.board[b] == model.board[c]:
			winners = line; break
	if winners.size() == 3:
		board_view.highlight_indices(winners)

	var msg := "It's a draw — Cat wins!" if winner == "Cat" else "Player %s wins!" % winner
	result_dialog.title = "Game Over"
	result_dialog.dialog_text = msg
	result_dialog.popup_centered()
