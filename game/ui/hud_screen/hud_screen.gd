class_name HUDScreen extends Control
@onready var battery_label: Label = %BatteryLabel
@onready var hp_label: Label = %HPLabel
@onready var timer_label: Label = %TimerLabel
@onready var inventory_label: Label = %InventoryLabel
@onready var placeable_box: VBoxContainer = %PlaceableBox
@onready var reticle: Control = %Reticle


func _ready() -> void:
	Viewmodel.hud_reticle_vm.state_changed.connect(func(new_state:HUDReticleState):
		reticle.position = new_state.reticle_pos
	)
	
	Viewmodel.hud_vm.state_changed.connect(func(new_state:HUDState):
		battery_label.text = "BATTERY: " + str(snapped(new_state.battery_percent, 0.01)).pad_decimals(2) + "%"
		hp_label.text = "ARMOR PLATES: " + str(new_state.hp - 1)
		if new_state.hp - 1 >= 0: hp_label.text += " [!!!]";
		var time = new_state.playtime
		var mins = time / 60 as int
		var secs = int(time) % 60 as int
		timer_label.text = "00:" + str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2)
		inventory_label.text = ""
		for key in new_state.inventory_dict:
			inventory_label.text += str(key) + ":" + str(new_state.inventory_dict[key]) + "\n"
		
		#Initialize buttons
		if new_state.placeable_dict.size() != placeable_box.get_child_count():
			for child in placeable_box.get_children():
				child.queue_free()
			for i in new_state.placeable_dict.size():
				var placeable := new_state.placeable_dict.keys()[i] as PlaceableTypes.Type
				var new_button = Button.new()
				new_button.focus_mode = Control.FOCUS_NONE
				placeable_box.add_child(new_button)
				new_button.button_up.connect(func():
					EventBus.on_button_pressed_select_placeable.emit(placeable)
				)
		
		#Edit existing buttons
		for i in new_state.placeable_dict.size():
			var placeable := new_state.placeable_dict.keys()[i] as PlaceableTypes.Type
			var placeable_amount := new_state.placeable_dict[placeable] as int
			var button = placeable_box.get_child(i) as Button
			if new_state.selected_placeable == placeable:
				button.set_theme_type_variation("SelectedButton")
			else:
				button.set_theme_type_variation("Button")
				
			button.text = str(PlaceableTypes.Type.keys()[placeable]) + " x" + str(placeable_amount)

	)
