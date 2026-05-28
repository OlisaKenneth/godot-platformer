extends GutTest

var view: BoardView

func before_each():
	view = BoardView.new()
	view.columns = 3
	add_child_autofree(view)
	# Create 9 buttons like the scene
	for i in range(9):
		var b := Button.new()
		b.name = "Cell_%d" % i
		view.add_child(b)
	await get_tree().process_frame
	view._ready()

func test_put_mark_text_mode() -> void:
	view.use_images = false
	view.clear_all()
	view.put_mark(4, "X")
	var b := view.get_node("Cell_4") as Button
	assert_eq(b.text, "X")
	assert_true(b.disabled)
