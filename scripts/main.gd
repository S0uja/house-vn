extends Node2D

var state := GameState.new()
var dialogue := DialogueController.new()

var ui: Control
var room_name: Label
var clock_label: Label
var message_label: Label
var dialogue_panel: PanelContainer
var speaker_label: Label
var dialogue_text: Label
var choices_box: VBoxContainer
var room_buttons: HBoxContainer
var scene_texture: Texture2D
var rooms_atlas: Texture2D

var current_room := "Living Room"
var rooms := ["Bedroom", "Living Room", "Kitchen", "Bathroom", "Hallway", "Yard"]
var room_names := {
 "Bedroom":"Спальня",
 "Living Room":"Гостиная",
 "Kitchen":"Кухня",
 "Bathroom":"Ванная",
 "Hallway":"Коридор",
 "Yard":"Двор"
}

func _ready() -> void:
 state.current_room = current_room
 if ResourceLoader.exists("res://assets/scenes/rooms_atlas.jpg"):
  rooms_atlas = load("res://assets/scenes/rooms_atlas.jpg")
 elif ResourceLoader.exists("res://assets/scenes/living_room_scene.jpg"):
  scene_texture = load("res://assets/scenes/living_room_scene.jpg")
 build_ui()
 show_room(current_room)
 queue_redraw()

func _draw() -> void:
 var size := get_viewport_rect().size
 if rooms_atlas:
  var room_index := rooms.find(current_room)
  if room_index >= 0:
   var col := room_index % 3
   var row := int(room_index / 3)
   var source_rect := Rect2(col * 256, row * 144, 256, 144)
   draw_texture_rect_region(Rect2(0, 0, size.x, size.y), rooms_atlas, source_rect)
   return
 if scene_texture:
  draw_texture_rect(scene_texture, Rect2(0, 0, size.x, size.y), false)
  return
 draw_rect(Rect2(0, 0, size.x, size.y), Color("#11141b"))
 draw_living_room(size.x, size.y)

func draw_living_room(w: float, h: float) -> void:
 draw_rect(Rect2(0, 0, w, h), Color("#c8b49b"))
 draw_rect(Rect2(0, 0, w, h * 0.57), Color("#eee5d7"))
 draw_rect(Rect2(0, h * 0.57, w, h * 0.43), Color("#8c674e"))
 for x in range(0, int(w), 70):
  draw_line(Vector2(x, h * 0.57), Vector2(x + 45, h), Color("#76533f"), 2.0)
 draw_rect(Rect2(w * 0.12, h * 0.32, w * 0.33, h * 0.27), Color("#725b50"))
 draw_rect(Rect2(w * 0.14, h * 0.36, w * 0.29, h * 0.17), Color("#a88772"))
 draw_rect(Rect2(w * 0.63, h * 0.18, w * 0.20, h * 0.25), Color("#4b3e38"))
 draw_rect(Rect2(w * 0.645, h * 0.20, w * 0.17, h * 0.20), Color("#293743"))
 draw_rect(Rect2(w * 0.82, h * 0.28, w * 0.08, h * 0.29), Color("#53654c"))
 draw_circle(Vector2(w * 0.86, h * 0.23), 65, Color("#6f865f"))
 draw_circle(Vector2(w * 0.82, h * 0.20), 45, Color("#78966b"))
 draw_character(Vector2(w * 0.54, h * 0.60))
 draw_string(ThemeDB.fallback_font, Vector2(w * 0.50, h * 0.78), "Наташа", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("#3c2a25"))

func draw_kitchen(w: float, h: float) -> void:
 draw_rect(Rect2(0,0,w,h), Color("#d8d0c5"))
 draw_rect(Rect2(0,h*0.60,w,h*0.40), Color("#806957"))
 draw_rect(Rect2(w*0.08,h*0.28,w*0.84,h*0.25), Color("#b6aa9c"))
 draw_rect(Rect2(w*0.12,h*0.32,w*0.28,h*0.15), Color("#59636a"))
 draw_rect(Rect2(w*0.48,h*0.32,w*0.35,h*0.15), Color("#ebe4d9"))
 draw_circle(Vector2(w*0.67,h*0.22), 55, Color("#87976d"))
 draw_character(Vector2(w*0.55,h*0.57))
 draw_string(ThemeDB.fallback_font, Vector2(w*0.49,h*0.77), "Наташа", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("#3c2a25"))

func draw_bedroom(w: float, h: float) -> void:
 draw_rect(Rect2(0,0,w,h), Color("#d5c5b8"))
 draw_rect(Rect2(0,h*0.62,w,h*0.38), Color("#765c4d"))
 draw_rect(Rect2(w*0.10,h*0.32,w*0.56,h*0.30), Color("#7c6258"))
 draw_rect(Rect2(w*0.12,h*0.34,w*0.52,h*0.22), Color("#d9d0c8"))
 draw_rect(Rect2(w*0.74,h*0.28,w*0.10,h*0.31), Color("#806d5f"))

func draw_generic_room(w: float, h: float) -> void:
 draw_rect(Rect2(0,0,w,h), Color("#d0c5b8"))
 draw_rect(Rect2(0,h*0.62,w,h*0.38), Color("#806957"))

func draw_character(pos: Vector2) -> void:
 draw_circle(pos + Vector2(0,-92), 32, Color("#e0b08e"))
 draw_circle(pos + Vector2(0,-98), 34, Color("#c7a46e"))
 draw_rect(Rect2(pos.x-25,pos.y-62,50,88), Color("#d98f9c"), true)
 draw_line(pos + Vector2(-20,20), pos + Vector2(-28,88), Color("#e0b08e"), 13)
 draw_line(pos + Vector2(20,20), pos + Vector2(28,88), Color("#e0b08e"), 13)
 draw_line(pos + Vector2(-14,26), pos + Vector2(-8,88), Color("#b87882"), 15)
 draw_line(pos + Vector2(14,26), pos + Vector2(8,88), Color("#b87882"), 15)
 draw_line(pos + Vector2(-22,-35), pos + Vector2(-52,22), Color("#e0b08e"), 12)
 draw_line(pos + Vector2(22,-35), pos + Vector2(52,22), Color("#e0b08e"), 12)

func build_ui() -> void:
 ui = Control.new()
 ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(ui)

 var top := PanelContainer.new()
 top.position = Vector2(24,16)
 top.size = Vector2(1232,52)
 ui.add_child(top)
 var row := HBoxContainer.new()
 row.add_theme_constant_override("separation", 18)
 top.add_child(row)

 room_name = Label.new()
 room_name.add_theme_font_size_override("font_size",22)
 room_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 row.add_child(room_name)
 clock_label = Label.new()
 clock_label.add_theme_font_size_override("font_size",18)
 row.add_child(clock_label)

 room_buttons = HBoxContainer.new()
 room_buttons.position = Vector2(24,650)
 room_buttons.size = Vector2(1232,50)
 room_buttons.add_theme_constant_override("separation",8)
 ui.add_child(room_buttons)

 for id in rooms:
  var b := Button.new()
  b.text = room_names[id]
  b.custom_minimum_size = Vector2(125,48)
  b.pressed.connect(func(): go_to_room(id))
  room_buttons.add_child(b)

 var talk := Button.new()
 talk.text = "💬 Поговорить с Наташей"
 talk.position = Vector2(860,570)
 talk.size = Vector2(340,48)
 talk.pressed.connect(func(): start_dialogue("living_room_natasha"))
 ui.add_child(talk)

 var sofa := Button.new()
 sofa.text = "Диван"
 sofa.position = Vector2(155,425)
 sofa.size = Vector2(180,55)
 sofa.modulate = Color(1,1,1,0.0)
 sofa.pressed.connect(func(): show_message("Можно присесть и немного отдохнуть."))
 ui.add_child(sofa)

 var tv := Button.new()
 tv.text = "Телевизор"
 tv.position = Vector2(755,250)
 tv.size = Vector2(170,100)
 tv.modulate = Color(1,1,1,0.0)
 tv.pressed.connect(func(): show_message("Телевизор выключен."))
 ui.add_child(tv)

 var save := Button.new()
 save.text = "💾"
 save.tooltip_text = "Сохранить"
 save.position = Vector2(1120,20)
 save.size = Vector2(50,45)
 save.pressed.connect(save_game)
 ui.add_child(save)

 var load_button := Button.new()
 load_button.text = "↻"
 load_button.tooltip_text = "Загрузить"
 load_button.position = Vector2(1175,20)
 load_button.size = Vector2(50,45)
 load_button.pressed.connect(load_game)
 ui.add_child(load_button)

 message_label = Label.new()
 message_label.position = Vector2(40,595)
 message_label.size = Vector2(780,42)
 message_label.add_theme_font_size_override("font_size",18)
 ui.add_child(message_label)

 build_dialogue()

func build_dialogue() -> void:
 dialogue_panel = PanelContainer.new()
 dialogue_panel.position = Vector2(60,455)
 dialogue_panel.size = Vector2(1160,175)
 dialogue_panel.visible = false
 ui.add_child(dialogue_panel)
 var box := VBoxContainer.new()
 box.add_theme_constant_override("separation",8)
 dialogue_panel.add_child(box)
 speaker_label = Label.new()
 speaker_label.add_theme_font_size_override("font_size",22)
 box.add_child(speaker_label)
 dialogue_text = Label.new()
 dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 dialogue_text.add_theme_font_size_override("font_size",20)
 dialogue_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
 box.add_child(dialogue_text)
 choices_box = VBoxContainer.new()
 box.add_child(choices_box)

func go_to_room(id: String) -> void:
 current_room = id
 state.current_room = id
 state.advance_time(5)
 show_room(id)
 dialogue_panel.visible = false
 message_label.text = "Вы вошли в: " + room_names[id]
 queue_redraw()

func show_room(id: String) -> void:
 room_name.text = room_names.get(id,id)
 clock_label.text = state.time_text()

func show_message(text: String) -> void:
 message_label.text = text
 state.advance_time(1)
 clock_label.text = state.time_text()

func start_dialogue(id: String) -> void:
 var f := FileAccess.open("res://data/story.json",FileAccess.READ)
 if f == null: return
 var data = JSON.parse_string(f.get_as_text())
 if typeof(data) != TYPE_DICTIONARY: return
 dialogue.start(data.get(id,[]))
 render_dialogue()

func render_dialogue() -> void:
 dialogue_panel.visible = true
 for child in choices_box.get_children(): child.queue_free()
 var line := dialogue.current()
 if line.is_empty():
  dialogue_panel.visible = false
  return
 speaker_label.text = str(line.get("speaker",""))
 dialogue_text.text = str(line.get("text",""))
 for choice in line.get("choices",[]):
  var b := Button.new()
  b.text = str(choice.get("text",""))
  b.custom_minimum_size = Vector2(0,34)
  b.pressed.connect(func(): choose(choice))
  choices_box.add_child(b)

func advance_dialogue() -> void:
 if dialogue.finished():
  dialogue_panel.visible = false
  return
 dialogue.next()
 render_dialogue()

func _unhandled_input(event: InputEvent) -> void:
 if event.is_action_pressed("advance_dialogue"):
  if dialogue_panel.visible:
   advance_dialogue()

func choose(choice: Dictionary) -> void:
 for name in choice.get("relationship",{}):
  state.relationships[name] = int(state.relationships.get(name,0)) + int(choice["relationship"][name])
 var next_id := str(choice.get("next",""))
 if next_id != "":
  for i in range(dialogue.lines.size()):
   if str(dialogue.lines[i].get("id","")) == next_id:
    dialogue.index = i
    render_dialogue()
    return
 advance_dialogue()

func save_game() -> void:
 message_label.text = "Сохранение: " + ("готово" if SaveManager.save_game(state) else "ошибка")

func load_game() -> void:
 message_label.text = "Загрузка: " + ("готово" if SaveManager.load_game(state) else "нет сохранения")
 current_room = state.current_room
 show_room(current_room)
 queue_redraw()
