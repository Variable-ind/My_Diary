extends Control
onready var buttons = get_node("lists/Panel/ScrollContainer/VBoxContainer")
onready var Delete_panel = get_node("Delete?")
var read_path = ""
onready var reader = get_node("reader")
onready var lists = get_node("lists")
var Theme_path = "user://Theme info.dat"


func _ready():
	var settings = File.new()
	settings.open("user://Settings.dat",File.READ)
	var base_info = settings.get_var()
	settings.close()
	
	var Read_theme = File.new()
	Read_theme.open(Theme_path,File.READ)
	var Theme_info = Read_theme.get_var()
	Read_theme.close()
	get_node("lists/Panel").texture = load(Theme_info.read_background)
	
	read_path = base_info.location
	#read_path = "user://Settings/My Diary/"   #testing on pc
	
	if base_info.style == 0:
		var dynamic_font = preload("res://graphics/Fonts/For Writting/Read_Block.tres")
		reader.get_node("ScrollContainer/TextEdit").set("custom_fonts/normal_font", dynamic_font)
	elif base_info.style == 1:
		var dynamic_font = preload("res://graphics/Fonts/For Writting/Read_cursive.tres")
		reader.get_node("ScrollContainer/TextEdit").set("custom_fonts/normal_font", dynamic_font)
	
	Delete_panel.visible = false
	reader.visible = false
	var log_name = []
	var dir = Directory.new()
	if !dir.dir_exists(read_path):
		dir.make_dir_recursive(read_path)
		
	dir.open(read_path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".txt") and "-" in file:
			log_name.append(file)
	dir.list_dir_end()
	
	var button_path = load("res://src/UI_Elements/Buttons/EntryButton.tscn")
	for file in log_name:
		var new_button = button_path.instance()
		new_button.texture_normal = load(Theme_info.read_button)
		new_button.texture_pressed = load(Theme_info.read_button_p)
		new_button.get_node("Label").text = file
		new_button.connect("pressed",self,"button_pressed",[file])
		buttons.add_child(new_button)


func button_pressed(name):
	if not get_node("lists/Panel/ScrollContainer").swiping:
		get_tree().paused = true
		var file = File.new()
		reader.visible = true
		reader.get_node("Panel/Label").text = name
		
		file.open(str(read_path,name),File.READ)
		OS.set_clipboard(file.get_as_text())
		reader.get_node("ScrollContainer/TextEdit").text = file.get_as_text()
		file.close()


func _on_reader_close_pressed():
	reader.get_node("Panel/Label").text = ""
	reader.visible = false
	get_tree().paused = false


func _on_scene_close_pressed():
	var error = get_tree().change_scene("res://src/MainScenes/MainMenu/Menu.tscn")


func _on_Delete_pressed():
	Delete_panel.visible = true


func _on_No_pressed():
	get_tree().paused = false
	Delete_panel.visible = false


func _on_Delete_it_pressed():
	get_tree().paused = false
	var dir = Directory.new()
	dir.open(read_path)
	
	dir.remove(str(read_path,reader.get_node("Panel/Label").text))
	get_tree().reload_current_scene()
