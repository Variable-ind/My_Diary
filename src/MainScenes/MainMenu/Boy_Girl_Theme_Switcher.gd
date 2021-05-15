extends CheckButton

var Theme_path = "user://Theme info.dat"

#Diary
export(NodePath) var Diary_button
export(NodePath) var Main_background
#Settings
export(NodePath) var Settings_title
export(NodePath) var Settings_BackGround
#Save_settings
export(NodePath) var Save_Settings
#Occasions Dialog
export(NodePath) var Occasions_dialogue

#appearance of Diary
onready var Diary_butt :Button = get_node(Diary_button)
onready var Main_back :TextureRect = get_node(Main_background)

#appearance of Settings
onready var settings_head :TextureRect = get_node(Settings_title)
onready var settings_back :ColorRect = get_node(Settings_BackGround)

#appearance of Save_settings
onready var Save_settings_Border :Panel = get_node(Save_Settings)
onready var Save_settings_front :ColorRect = get_node(Save_Settings).get_child(0)

#Occasions Dialog
onready var Occasion_dial :Popup = get_node(Occasions_dialogue)

var girl_mode = {
"Diary" : "res://graphics/Textures/Girls/diary.png",
"Main_back" : "res://graphics/Textures/Girls/Main background.png",
"Settings_head" : "res://graphics/Textures/Girls/Settings_head.png",
"Settings_back" : Color(0.73,0.35,0.72,1.00),
"save_settings_border" : Color(0.56,0.70,0.70,1.00),
"save_settings_front" : Color(0.52,0.15,0.67,0.52),
"Occasions" : "res://graphics/Themes/Girls/Dialogues_girls.tres",
"read_background" : "res://graphics/Textures/Girls/Read list.png",
"read_button_p" : "res://graphics/Textures/Girls/button_p.png", # pressed button texture
"read_button" : "res://graphics/Textures/Girls/button.png"
}

var boy_mode = {
"Diary" : "res://graphics/Textures/Boys/diary.png",
"Main_back" : "res://graphics/Textures/Boys/Main background.png",
"Settings_head" : "res://graphics/Textures/Boys/Settings_head.png",
"Settings_back" : Color(0.20,0.20,0.20,1.00),
"save_settings_border" : Color(0.21,0.21,0.21,1.00),
"save_settings_front" : Color(0.15,0.15,0.15,1.00),
"Occasions" : "res://graphics/Themes/Boys/Dialogues_boys.tres",
"read_background" : "res://graphics/Textures/Boys/Read list.png",
"read_button_p" : "res://graphics/Textures/Boys/button_p.png", # pressed button texture
"read_button" : "res://graphics/Textures/Boys/button.png"
}


func _on_Boy_Girl_toggled(button_pressed):
	if button_pressed == false:
		#diary
		Diary_butt.icon = load(girl_mode.Diary)
		Main_back.texture = load(girl_mode.Main_back)
		#settings
		settings_head.texture = load(girl_mode.Settings_head)
		settings_back.color = girl_mode.Settings_back
		#save_settings
		Save_settings_front.color = girl_mode.save_settings_front
		Save_settings_Border.get("custom_styles/panel").bg_color = girl_mode.save_settings_border
		#occasions
		Occasion_dial.theme = load(girl_mode.Occasions)
		
		#save for other scenes
		var file = File.new()
		file.open(Theme_path,File.WRITE)
		file.store_var(girl_mode)
		file.close()
		
	elif button_pressed == true:
		#diary
		Diary_butt.icon = load(boy_mode.Diary)
		Main_back.texture = load(boy_mode.Main_back)
		#settings
		settings_head.texture = load(boy_mode.Settings_head)
		settings_back.color = boy_mode.Settings_back
		#save_settings
		Save_settings_front.color = boy_mode.save_settings_front
		Save_settings_Border.get("custom_styles/panel").bg_color = boy_mode.save_settings_border
		#occasions
		Occasion_dial.theme = load(boy_mode.Occasions)
		
		#save for other scenes
		var file = File.new()
		file.open(Theme_path,File.WRITE)
		file.store_var(boy_mode)
		file.close()
