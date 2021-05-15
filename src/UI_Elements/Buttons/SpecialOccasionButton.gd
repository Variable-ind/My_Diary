extends ColorRect

onready var label = get_node("vbox/HBoxContainer/TextEdit")
onready var date = get_node("vbox/Buttons/Date")
onready var Month = get_node("vbox/Buttons/Month")
onready var Enabled = get_node("vbox/HBoxContainer/CheckButton")
onready var text_map = get_parent().get_parent().get_parent().get_child(0)
var orignal_index = 0
var monitor = false


func _ready():
	var font = preload("res://graphics/Fonts/options.tres")
	date.get_child(0).set("custom_fonts/font",font)
	Month.get_child(0).set("custom_fonts/font",font)
	orignal_index = get_index()


func _process(_delta):
	if monitor:
		text_map.text = label.text


func give_data():
	var data = [label.text,(date.selected + 1),(Month.selected + 1),Enabled.pressed]
	return data


func update_data(path :Array):
	if path.size() == 4:
		label.text = path[0]
		date.selected = (str2var(path[1]) - 1)
		Month.selected = (str2var(path[2]) - 1)
		if str(path[3]) == "True":
			Enabled.pressed = true
		elif str(path[3]) == "False":
			Enabled.pressed = false


func _on_Delete_pressed():
	queue_free()


func _on_TextEdit_focus_entered():
	if label.text == "New Occasion":
		label.text = ""
	monitor = true


func _on_TextEdit_focus_exited():
	if label.text == "":
		label.text = "New Occasion"
	monitor = false


func _on_TextEdit_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			label.text = str(label.get_line(0),label.get_line(1))


func _on_TextEdit_mouse_entered():
	label.focus_mode = true
