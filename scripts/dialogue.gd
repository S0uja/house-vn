class_name DialogueController
extends RefCounted

var lines: Array = []
var index := 0

func start(new_lines: Array) -> void:
 lines = new_lines
 index = 0

func current() -> Dictionary:
 if index >= 0 and index < lines.size(): return lines[index]
 return {}

func next() -> Dictionary:
 index += 1
 return current()

func finished() -> bool:
 return index >= lines.size()
