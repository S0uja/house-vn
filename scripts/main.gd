extends Node2D

var lines := [
	{"name": "Система", "text": "Добро пожаловать в House VN."},
	{"name": "Система", "text": "Это первый прототип игры, действие которой происходит в одном доме."},
	{"name": "Главная", "text": "Здесь будут комнаты, персонажи, время, отношения и события."},
	{"name": "Главная", "text": "Нажми ПРОБЕЛ, чтобы продолжить."}
]

var current_line := 0
var dialogue_name: Label
var dialogue_text: Label

func _ready() -> void:
	_build_ui()
	_show_line()

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("18202b")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var title := Label.new()
	title.text = "HOUSE VN"
	title.position = Vector2(55, 35)
	title.add_theme_font_size_override("font_size", 34)
	add_child(title)

	var room_label := Label.new()
	room_label.text = "Дом · Холл"
	room_label.position = Vector2(55, 90)
	room_label.add_theme_font_size_override("font_size", 22)
	add_child(room_label)

	var room_panel := ColorRect.new()
	room_panel.color = Color("263442")
	room_panel.position = Vector2(55, 135)
	room_panel.size = Vector2(1170, 390)
	add_child(room_panel)

	var room_text := Label.new()
	room_text.text = "ЗАГЛУШКА КОМНАТЫ\n\nЗдесь позже появятся фон, двери, интерактивные объекты и персонажи."
	room_text.position = Vector2(80, 185)
	room_text.add_theme_font_size_override("font_size", 25)
	add_child(room_text)

	var dialogue_panel := ColorRect.new()
	dialogue_panel.color = Color("10151d")
	dialogue_panel.position = Vector2(55, 545)
	dialogue_panel.size = Vector2(1170, 125)
	add_child(dialogue_panel)

	dialogue_name = Label.new()
	dialogue_name.position = Vector2(80, 560)
	dialogue_name.add_theme_font_size_override("font_size", 22)
	add_child(dialogue_name)

	dialogue_text = Label.new()
	dialogue_text.position = Vector2(80, 600)
	dialogue_text.size = Vector2(1080, 50)
	dialogue_text.add_theme_font_size_override("font_size", 20)
	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(dialogue_text)

	var hint := Label.new()
	hint.text = "ПРОБЕЛ — продолжить"
	hint.position = Vector2(1040, 680)
	hint.add_theme_font_size_override("font_size", 14)
	add_child(hint)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialogue"):
		_next_line()

func _next_line() -> void:
	current_line = (current_line + 1) % lines.size()
	_show_line()

func _show_line() -> void:
	if dialogue_name == null:
		return
	var line: Dictionary = lines[current_line]
	dialogue_name.text = str(line["name"])
	dialogue_text.text = str(line["text"])
