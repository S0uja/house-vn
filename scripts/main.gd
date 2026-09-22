extends Node2D

var state := GameState.new()
var dialogue := DialogueController.new()
var root: Control
var room_title: Label
var time_label: Label
var room_description: Label
var dialogue_panel: PanelContainer
var speaker_label: Label
var dialogue_text: Label
var choices_box: VBoxContainer
var status_label: Label

var rooms := {"Bedroom":"Спальня","Hallway":"Коридор","Living Room":"Гостиная","Kitchen":"Кухня","Bathroom":"Ванная","Yard":"Двор"}
var descriptions := {
 "Bedroom":"Твоя комната. Здесь начинается день.",
 "Hallway":"Коридор соединяет комнаты дома.",
 "Living Room":"Гостиная с диваном и телевизором.",
 "Kitchen":"Кухня. Утром здесь часто кто-нибудь находится.",
 "Bathroom":"Небольшая ванная комната.",
 "Yard":"Двор перед домом."
}

func _ready() -> void:
 build_ui()
 show_room(state.current_room)
 start_dialogue("intro")

func build_ui() -> void:
 root = Control.new()
 root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(root)
 var bg := ColorRect.new()
 bg.color = Color("#151821")
 bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 root.add_child(bg)

 var top := PanelContainer.new()
 top.position = Vector2(24,20)
 top.size = Vector2(1232,58)
 root.add_child(top)
 var row := HBoxContainer.new()
 top.add_child(row)
 room_title = Label.new()
 room_title.add_theme_font_size_override("font_size",24)
 room_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 row.add_child(room_title)
 time_label = Label.new()
 time_label.add_theme_font_size_override("font_size",20)
 row.add_child(time_label)

 var nav := PanelContainer.new()
 nav.position = Vector2(24,100)
 nav.size = Vector2(260,500)
 root.add_child(nav)
 var box := VBoxContainer.new()
 box.add_theme_constant_override("separation",8)
 nav.add_child(box)
 var caption := Label.new()
 caption.text = "КОМНАТЫ"
 caption.add_theme_font_size_override("font_size",16)
 box.add_child(caption)
 for id in rooms:
  var b := Button.new()
  b.text = rooms[id]
  b.custom_minimum_size = Vector2(0,48)
  b.pressed.connect(func(): go_to_room(id))
  box.add_child(b)

 var scene := PanelContainer.new()
 scene.position = Vector2(310,100)
 scene.size = Vector2(946,300)
 root.add_child(scene)
 room_description = Label.new()
 room_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 room_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
 room_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 room_description.add_theme_font_size_override("font_size",28)
 scene.add_child(room_description)

 dialogue_panel = PanelContainer.new()
 dialogue_panel.position = Vector2(310,420)
 dialogue_panel.size = Vector2(946,220)
 root.add_child(dialogue_panel)
 var db := VBoxContainer.new()
 db.add_theme_constant_override("separation",10)
 dialogue_panel.add_child(db)
 speaker_label = Label.new()
 speaker_label.add_theme_font_size_override("font_size",22)
 db.add_child(speaker_label)
 dialogue_text = Label.new()
 dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 dialogue_text.add_theme_font_size_override("font_size",20)
 dialogue_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
 db.add_child(dialogue_text)
 choices_box = VBoxContainer.new()
 db.add_child(choices_box)

 var actions := HBoxContainer.new()
 actions.position = Vector2(24,620)
 actions.size = Vector2(260,50)
 root.add_child(actions)
 var save := Button.new()
 save.text = "Сохранить"
 save.pressed.connect(save_game)
 actions.add_child(save)
 var load := Button.new()
 load.text = "Загрузить"
 load.pressed.connect(load_game)
 actions.add_child(load)
 status_label = Label.new()
 status_label.position = Vector2(24,680)
 root.add_child(status_label)

func _unhandled_input(event: InputEvent) -> void:
 if event.is_action_pressed("advance_dialogue"):
  advance_dialogue()

func go_to_room(id: String) -> void:
 state.current_room = id
 state.advance_time(5)
 show_room(id)
 if id == "Kitchen":
  start_dialogue("kitchen")
 else:
  dialogue.start([])
  dialogue_panel.visible = false

func show_room(id: String) -> void:
 room_title.text = rooms.get(id,id)
 room_description.text = descriptions.get(id,"")
 time_label.text = state.time_text()

func start_dialogue(id: String) -> void:
 var f := FileAccess.open("res://data/story.json",FileAccess.READ)
 if f == null: return
 var data = JSON.parse_string(f.get_as_text())
 if typeof(data) != TYPE_DICTIONARY: return
 dialogue.start(data.get(id,[]))
 render_dialogue()

func advance_dialogue() -> void:
 if dialogue.finished():
  dialogue_panel.visible = false
  return
 dialogue.next()
 render_dialogue()

func render_dialogue() -> void:
 dialogue_panel.visible = true
 for c in choices_box.get_children(): c.queue_free()
 var line := dialogue.current()
 if line.is_empty():
  dialogue_panel.visible = false
  return
 speaker_label.text = str(line.get("speaker",""))
 dialogue_text.text = str(line.get("text",""))
 var minutes := int(line.get("advance",0))
 if minutes > 0:
  state.advance_time(minutes)
  time_label.text = state.time_text()
 for choice in line.get("choices",[]):
  var b := Button.new()
  b.text = str(choice.get("text",""))
  b.custom_minimum_size = Vector2(0,38)
  b.pressed.connect(func(): choose(choice))
  choices_box.add_child(b)

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
 status_label.text = "Сохранение: " + ("OK" if SaveManager.save_game(state) else "ошибка")

func load_game() -> void:
 status_label.text = "Загрузка: " + ("OK" if SaveManager.load_game(state) else "нет сохранения")
 show_room(state.current_room)
