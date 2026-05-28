extends GridContainer
class_name BoardView

signal cell_clicked(index: int)

@export var use_images: bool = true
@export var x_texture: Texture2D
@export var o_texture: Texture2D

var cells: Array[Button] = []

func _ready() -> void:
	columns = 3
	_collect_or_create_cells()
	_connect_cells()
	clear_all()

func _collect_or_create_cells() -> void:
	cells.clear()
	for i in range(9):
		var name := "Cell_%d" % i
		var b := get_node_or_null(name) as Button
		if b == null:
			b = Button.new()
			b.name = name
			b.custom_minimum_size = Vector2(128, 128)
			b.focus_mode = Control.FOCUS_NONE
			add_child(b)
		b.text = ""
		b.expand_icon = true
		cells.append(b)

func _connect_cells() -> void:
	for i in range(cells.size()):
		var idx := i
		for c in cells[i].pressed.get_connections():
			cells[i].pressed.disconnect(c.callable)
		cells[i].pressed.connect(func(): emit_signal("cell_clicked", idx))

func clear_all() -> void:
	for b in cells:
		b.disabled = false
		b.text = ""
		b.icon = null
		b.remove_theme_color_override("font_color")
		b.remove_theme_color_override("font_hover_color")
		b.remove_theme_color_override("font_pressed_color")

func put_mark(index: int, player: String) -> void:
	var b := cells[index]
	b.disabled = true
	if use_images:
		if player == "X" and x_texture != null:
			b.icon = x_texture
			b.text = ""
		elif player == "O" and o_texture != null:
			b.icon = o_texture
			b.text = ""
		else:
			b.icon = null
			b.text = player
	else:
		b.icon = null
		b.text = player

func highlight_indices(indices: Array) -> void:
	for i in range(cells.size()):
		var b := cells[i]
		if i in indices:
			b.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2))
			b.add_theme_color_override("font_hover_color", Color(0.2, 0.8, 0.2))
			b.add_theme_color_override("font_pressed_color", Color(0.2, 0.8, 0.2))
		else:
			b.disabled = true
