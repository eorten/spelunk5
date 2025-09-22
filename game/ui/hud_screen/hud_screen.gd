class_name HUDScreen extends Control
@onready var battery_label: Label = %BatteryLabel
@onready var hp_label: Label = %HPLabel
@onready var timer_label: Label = %TimerLabel
@onready var inventory_label: Label = %InventoryLabel
@onready var placeable_box: VBoxContainer = %PlaceableBox

func _ready() -> void:
	Viewmodel.hud_vm.state_changed.connect(func(new_state:HUDState):
		battery_label.text = "BATTERY: " + str(snapped(new_state.battery_percent, 0.01)).pad_decimals(2) + "%"
		hp_label.text = "ARMOR PLATES: " + str(new_state.hp - 1)
		if new_state.hp - 1 >= 0: hp_label.text += " [!!!]";
		var time = new_state.playtime
		var mins = time / 60 as int
		var secs = int(time) % 60 as int
		var ms = int((time - int(time)) * 100) as int
		timer_label.text = "00:" + str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2) + ":" + str(ms).pad_zeros(2)
		inventory_label.text = ""
		for key in new_state.inventory_dict:
			inventory_label.text += str(key) + ":" + str(new_state.inventory_dict[key]) + "\n"
		
		#Initialize buttons
		if new_state.placeable_dict.size() != placeable_box.get_child_count():
			for child in placeable_box.get_children():
				child.queue_free()
			for placeable in new_state.placeable_dict.size():
				placeable_box.add_child(Button.new())
		
		#Edit existing buttons
		for i in new_state.placeable_dict.size():
			var placeable := new_state.placeable_dict.keys()[i] as PlaceableTypes.Type
			var placeable_amount := new_state.placeable_dict[placeable] as int
			var button = placeable_box.get_child(i) as Button
			
			button.text = str(PlaceableTypes.Type.keys()[placeable]) + " x" + str(placeable_amount)
			button.pressed.connect(func():
				EventBus.on_button_pressed_select_placeable.emit(placeable)
			)
	)
