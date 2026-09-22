class_name GameState
extends RefCounted

var day := 1
var hour := 8
var minute := 0
var current_room := "Bedroom"
var relationships := {"Anna":0,"Mia":0,"Kate":0}
var inventory: Array[String] = []
var quests := {}
var flags := {}

func advance_time(minutes: int) -> void:
 minute += minutes
 while minute >= 60:
  minute -= 60
  hour += 1
 while hour >= 24:
  hour -= 24
  day += 1

func time_text() -> String:
 return "День %d  %02d:%02d" % [day,hour,minute]
