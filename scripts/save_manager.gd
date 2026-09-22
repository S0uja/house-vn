class_name SaveManager
extends RefCounted

const SAVE_PATH := "user://save.json"

static func save_game(state: GameState) -> bool:
 var data = {"day":state.day,"hour":state.hour,"minute":state.minute,"current_room":state.current_room,"relationships":state.relationships,"inventory":state.inventory,"quests":state.quests,"flags":state.flags}
 var f := FileAccess.open(SAVE_PATH,FileAccess.WRITE)
 if f == null: return false
 f.store_string(JSON.stringify(data))
 return true

static func load_game(state: GameState) -> bool:
 if not FileAccess.file_exists(SAVE_PATH): return false
 var f := FileAccess.open(SAVE_PATH,FileAccess.READ)
 if f == null: return false
 var data = JSON.parse_string(f.get_as_text())
 if typeof(data) != TYPE_DICTIONARY: return false
 state.day = int(data.get("day",1))
 state.hour = int(data.get("hour",8))
 state.minute = int(data.get("minute",0))
 state.current_room = str(data.get("current_room","Bedroom"))
 state.relationships = data.get("relationships",{})
 state.inventory = data.get("inventory",[])
 state.quests = data.get("quests",{})
 state.flags = data.get("flags",{})
 return true
