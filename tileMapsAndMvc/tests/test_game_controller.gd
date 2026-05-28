extends GutTest

var game: Node
var controller: GameController
var model: GameModel
var view: BoardView
var turn_label: Label

func before_each() -> void:
	var scene := load("res://scenes/Game.tscn")
	game = scene.instantiate()
	add_child_autofree(game)

	# Get references
	controller = game as GameController
	assert_not_null(controller, "Game scene root must have GameController script.")


	await get_tree().process_frame

	# Grab nodes
	view = get_node_or_null("/root/TestRunner/Game/BoardView") as BoardView
	if view == null:
		view = game.get_node("BoardView") as BoardView
	assert_not_null(view, "BoardView not found or script not attached.")

	model = null
	for child in game.get_children():
		if child is GameModel:
			model = child
			break
	assert_not_null(model, "GameModel not found (controller should add it).")

	turn_label = game.get_node("TurnLabel") as Label
	assert_not_null(turn_label)

func test_click_places_X_then_turn_changes_to_O() -> void:
	# Simulate click on cell 0
	view.emit_signal("cell_clicked", 0)
	await get_tree().process_frame

	assert_eq(model.board[0], "X")
	assert_eq(turn_label.text, "Turn: O") 

func test_clicking_occupied_cell_does_nothing() -> void:
	# First click
	view.emit_signal("cell_clicked", 0)
	await get_tree().process_frame
	var after_first = model.current_player   # should be "O"

	# Click same cell again (occupied)
	watch_signals(model)
	view.emit_signal("cell_clicked", 0)
	await get_tree().process_frame

	assert_signal_emitted(model, "invalid_move")
	assert_eq(model.board[0], "X")
	assert_eq(model.current_player, after_first)  # turn did not change

func test_game_over_dialog_shows_on_win() -> void:

	view.emit_signal("cell_clicked", 0) # X
	await get_tree().process_frame
	view.emit_signal("cell_clicked", 3) # O
	await get_tree().process_frame
	view.emit_signal("cell_clicked", 1) # X
	await get_tree().process_frame
	view.emit_signal("cell_clicked", 4) # O
	await get_tree().process_frame
	view.emit_signal("cell_clicked", 2) # X wins
	await get_tree().process_frame

	var dlg := game.get_node("ResultDialog") as AcceptDialog
	assert_true(dlg.visible, "Result dialog should be visible after win.")
