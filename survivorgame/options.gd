extends PopupPanel

@onready var music_slider: HSlider = $VBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $VBoxContainer/SFXSlider
@onready var back_button: Button = $VBoxContainer/Exit

var audio

func _ready() -> void:
	audio = get_node("/root/Audio")

	music_slider.value = db_to_linear(audio.music_volume_db)
	sfx_slider.value  = db_to_linear(audio.sfx_volume_db)

	# Godot 4: it’s safe to connect without checking
	music_slider.value_changed.connect(_musicSliderChanged)
	sfx_slider.value_changed.connect(_sfxSliderChanged)
	back_button.pressed.connect(_exitPressed)


func _musicSliderChanged(value: float) -> void:
	audio.set_music_volume(value)

func _sfxSliderChanged(value: float) -> void:
	audio.set_sfx_volume(value)


func _exitPressed() -> void:
	# If the game is started, Options was opened in-game → hide() only
	if GameState.started:
		if get_tree().current_scene == self:
			# Wrong state: options was opened as a scene WHILE game is running
			get_tree().change_scene_to_file("res://main.tscn")
		else:
			hide()
		return

	# If game is NOT started → return to stored previous scene (menu)
	if GameState.previous_scene != "":
		var target = GameState.previous_scene
		GameState.previous_scene = ""  # reset
		get_tree().change_scene_to_file(target)
	else:
		# failsafe
		get_tree().change_scene_to_file("res://main_menu.tscn")
