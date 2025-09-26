class_name TerminalMenuRightState extends RefCounted

var currency:int
var quota
var energy:int
var ores:Dictionary
func _init(currency:int, energy:int, ores:Dictionary, quota) -> void:
	self.currency = currency
	self.energy = energy
	self.ores = ores
	self.quota = quota
