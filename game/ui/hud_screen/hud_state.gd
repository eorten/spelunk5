class_name HUDState extends RefCounted

var battery_percent:float
var hp:int
var playtime:float
func _init(battery_percent:float, hp:int, playtime:float):
	self.battery_percent = battery_percent
	self.hp = hp
	self.playtime = playtime
