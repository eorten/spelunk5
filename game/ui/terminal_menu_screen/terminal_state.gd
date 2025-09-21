class_name TerminalState extends RefCounted

var text:String
func _init(text:String) -> void:
	self.text = "> " + text.to_upper()
