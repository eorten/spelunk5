class_name TerminalMenuRightState extends RefCounted

var currency:int
var energy:int
var ores:Dictionary
func _init(currency:int, energy:int, ores:Dictionary) -> void:
	self.currency = currency
	self.energy = energy
	self.ores = ores
