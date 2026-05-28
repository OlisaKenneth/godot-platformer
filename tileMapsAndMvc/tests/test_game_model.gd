extends GutTest

var model: GameModel

## this is to signal counters + last payloads
var board_changed_count := 0
var turn_changed_count := 0
var game_over_count := 0
var invalid_move_count := 0

var last_board_index := -1
var last_board_player := ""
var last_turn_player := ""
var last_winner := ""

func before_each() -> void:
	model = load("res://Scripts/GameModel.gd").new()
	add_child(model)

	## this is to reset counters
	board_changed_count = 0
	turn_changed_count = 0
	game_over_count = 0
	invalid_move_count = 0
	last_board_index = -1
	last_board_player = ""
	last_turn_player = ""
	last_winner = ""

	# connect local handlers
	model.board_changed.connect(_on_board_changed)
	model.turn_changed.connect(_on_turn_changed)
	model.game_over.connect(_on_game_over)
	model.invalid_move.connect(_on_invalid_move)

	model.reset()

##this is to test the board to see if it is changed
func _on_board_changed(index: int, player: String) -> void:
	board_changed_count += 1
	last_board_index = index
	last_board_player = player
	
	
##this is to test the board to see if player has changed
func _on_turn_changed(player: String) -> void:
	turn_changed_count += 1
	last_turn_player = player

##to know if game is obver 
func _on_game_over(winner: String) -> void:
	game_over_count += 1
	last_winner = winner

#to test for any invalid move
func _on_invalid_move() -> void:
	invalid_move_count += 1


# ---------- TESTS ----------
##initialize board and the player turns
func test_reset_initializes_board_and_turn() -> void:
	assert_eq(model.board.size(), 9)
	for v in model.board:
		assert_eq(v, "")
	assert_eq(model.current_player, "X")

##ti see if it moves places and see if the player turns changes after played
func test_valid_move_places_mark_and_switches_turn() -> void:
	model.play_at(0)  # X
	assert_eq(model.board[0], "X")
	assert_eq(board_changed_count, 1)
	assert_eq(last_board_index, 0)
	assert_eq(last_board_player, "X")
	# After a valid move, turn should switch to O
	assert_eq(model.current_player, "O")
	assert_gt(turn_changed_count, 0)
	assert_eq(last_turn_player, "O")

##if clicked do not play again
func test_clicking_occupied_square_is_invalid_and_does_not_change_state() -> void:
	model.play_at(0)    # X
	var turn_before := model.current_player
	model.play_at(0)    # invalid (occupied)
	assert_eq(invalid_move_count, 1)
	assert_eq(model.board[0], "X")
	# No extra board_changed, no turn swap
	assert_eq(board_changed_count, 1)
	assert_eq(model.current_player, turn_before)

##see if the player is clicking out of bounds
func test_out_of_bounds_click_is_invalid() -> void:
	model.play_at(-1)
	model.play_at(9)
	assert_eq(invalid_move_count, 2)
	# No board changes
	assert_eq(board_changed_count, 0)

##testing for x to win
func test_x_wins_on_top_row() -> void:
	# X:0, O:3, X:1, O:4, X:2  -> X wins
	model.play_at(0)  # X
	model.play_at(3)  # O
	model.play_at(1)  # X
	model.play_at(4)  # O
	model.play_at(2)  # X wins
	assert_eq(game_over_count, 1)
	assert_eq(last_winner, "X")

##esting for a draw
func test_draw_cat_wins() -> void:
	# Fill with no winner (one example):
	# X:0 O:1 X:2 O:4 X:3 O:5 X:7 O:6 X:8  -> draw
	model.play_at(0) # X
	model.play_at(1) # O
	model.play_at(2) # X
	model.play_at(4) # O
	model.play_at(3) # X
	model.play_at(5) # O
	model.play_at(7) # X
	model.play_at(6) # O
	model.play_at(8) # X (board full, no winner)
	assert_eq(game_over_count, 1)
	assert_eq(last_winner, "Cat")
