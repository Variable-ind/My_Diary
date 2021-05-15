extends Control

onready var Audio = get_node("AudioStreamPlayer")
onready var settings = get_node("Home/Settings")
onready var path_label = settings.get_node("Panel/ColorRect/path/Path")
onready var save_settings = settings.get_node("Panel/ColorRect/save settings")
onready var music :CheckButton = settings.get_node("Panel/ColorRect/Music")
onready var Boy_Girl :CheckButton = settings.get_node("Panel/ColorRect/Boy_Girl")
onready var Select_font :OptionButton = settings.get_node("Panel/ColorRect/Writing Type/Select font")
onready var music_name = settings.get_node("Panel/ColorRect/music type/HBoxContainer/curr Name")
onready var mesg = settings.get_node("Panel/ColorRect/save settings/Note")
onready var file_manager = settings.get_node("Panel/FileManager")

onready var Special_occ_panel = get_node("Home/SpecialOccasionPanel")
onready var Special_occasions = get_node("Home/AcceptDialog")
var occasions_list = "user://Occasions.dat"
var temp_occ = "user://temp_occ.dat"
var occasions_names = ""

onready var Help = get_node("Home/Help")

var will_move = false
var old_path = ""
var save_path = "user://Settings.dat"


var save_info = {
	"style" : 0,
	"location" : "/storage/emulated/0/My Diary/",
	"name": "Calm tune",
	"music" : true,
	"gender_boy" : true
}

var save_info_pc = {
	"style" : 0,
	"location" : str(OS.get_executable_path().get_base_dir(),"/Diary Entries/"),
	"name": "Calm tune",
	"music" : true,
	"gender_boy" : true
}


func _ready():
	Boy_Girl.pressed = false
	Boy_Girl.pressed = true
	var occ_label :Label = Special_occasions.get_child(1)
	occ_label.align = Label.ALIGN_CENTER
	occ_label.valign = Label.VALIGN_CENTER
	Special_occasions.get_child(0).visible = false
	
	check_occasion()
	Help.visible = false
	settings.visible = false
	save_settings.visible = false
	Special_occ_panel.visible = false
	
	sync_with_old_save_info()
	if(music.pressed):
		Audio.play(Global.timing)
	settings.visible = false
	save_settings.visible = false
	
	var _answer = OS.request_permissions()


func _process(_delta):
	if(Audio.playing != music.pressed):
		if(music.pressed == false):
				Global.timing = 0.0
				Audio.stop()
		if(music.pressed == true):
			Audio.play(Global.timing)
			
	Global.timing = Audio.get_playback_position()


func _on_Write_Diary_pressed():
	var _error = get_tree().change_scene("res://src/MainScenes/DiaryWriting/Diary.tscn")


func _on_View_Diary_pressed():
	var _error = get_tree().change_scene("res://src/MainScenes/DiaryReading/Read.tscn")


func _on_Settings_pressed():
	will_move = false
	old_path = path_label.text
	settings.visible = true



func _on_Exit_pressed():
	get_tree().quit()
	


func _on_back_pressed():
	#check is paths differ
	
	if old_path != path_label.text:
		mesg.text = "Your old files will be moved to the new location"
		will_move = true
	save_settings.visible = true


func _on_cancel_pressed():
	#Dont do anything
	will_move = false  #unneeded statement
	#just cancel
	sync_with_old_save_info()
	save_settings.visible = false
	settings.visible = false


func _on_save_it_pressed():
	Move(will_move)
	#move files if needed
	#save and close
	save_info.location = path_label.text
	save_info.music = music.pressed
	save_info.gender_boy = Boy_Girl.pressed
	save_info.name = music_name.text
	var file = File.new()
	file.open(save_path,File.WRITE)
	file.store_var(save_info)
	file.close()
	sync_with_old_save_info()
	save_settings.visible = false
	settings.visible = false


func sync_with_old_save_info():
	var file = File.new()
	
	# switch to pc settings if os is not android
	if not file.file_exists(save_path):
		if OS.get_name() != "Android":
			save_info = save_info_pc
		
		file.open(save_path,File.WRITE)
		file.store_var(save_info)
		file.close()
	else:
		file.open(save_path,File.READ)
		var test_new :Dictionary = file.get_var()
		if not test_new.has_all(save_info.keys()):
			file.open(save_path,File.WRITE)
			file.store_var(save_info)
		file.close()
	file.open(save_path,File.READ)
	save_info = file.get_var()
	file.close()
	Select_font.selected = save_info.style
	path_label.text = ProjectSettings.globalize_path(save_info.location)
	music_name.text = save_info.name
	Audio.stream = load(str("res://Music/",save_info.name,".ogg"))
	music.pressed = save_info.music
	Boy_Girl.pressed = save_info.gender_boy


func _on_Browse_pressed():
	file_manager.start_path = path_label.text
	file_manager.popup()


func _on_File_Manager_Selected(location):
	path_label.text = location

func Move(value):
	if(value):
		var from = old_path
		var To = path_label.text
		
		var dir :Directory = Directory.new()
		if dir.dir_exists(from):
			var _err_a = dir.open(from)
			var _err_b = dir.list_dir_begin()
			while true:
				var Files = dir.get_next()
				if Files == "":
					break
				elif Files.ends_with(".txt") and "-" in Files:
					var error = dir.copy(str(from,Files),str(To,Files))
					if error == OK:
						var _err_c = dir.remove(str(from,Files))
		var _err_d = dir.remove(from)
		dir.list_dir_end()


func _on_Select_font_item_selected(index):
	save_info.style = index


#music buttons
func _on_Calm_tune_pressed():
	music_name.text = "Calm tune"
	Audio.stream = load(str("res://Music/",music_name.text,".ogg"))
	Global.timing = 0.0
	Audio.seek(Global.timing)


func _on_Piano_Music_pressed():
	music_name.text = "Piano Music"
	Audio.stream = load(str("res://Music/",music_name.text,".ogg"))
	Global.timing = 0.0
	Audio.seek(Global.timing)


func _on_Life_Is_Strange_pressed():
	music_name.text = "Life Is Strange"
	Audio.stream = load(str("res://Music/",music_name.text,".ogg"))
	Global.timing = 0.0
	Audio.seek(Global.timing)


func _on_Meadow_pressed():
	music_name.text = "Meadow"
	Audio.stream = load(str("res://Music/",music_name.text,".ogg"))
	Global.timing = 0.0
	Audio.seek(Global.timing)


#Secret help menu
func _on_TextureButton_pressed():
	Help.visible = false


func _on_Diary_label_pressed():
	Help.visible = true


#Special Occasions pannel
func _on_Special_Occasions_pressed():
	Special_occ_panel.visible = true
	var file = File.new()
	var err = file.open(occasions_list,File.READ)
	if err == OK:
		while true:
			var array = file.get_csv_line()
			if array.size() == 4:
				var button_path = preload("res://src/UI_Elements/Buttons/SpecialOccasionButton.tscn")
				var new_button = button_path.instance()
				Special_occ_panel.get_node("Panel/Container/SpecialButtons").add_child(new_button)
				new_button.update_data(array)
			if file.eof_reached():
				break
		file.close()
	file.close()


func _on_Exit_Special_pressed():
	var file = File.new()
	file.open(occasions_list,File.WRITE)
	for buttons in Special_occ_panel.get_node("Panel/Container/SpecialButtons").get_child_count():
		file.store_csv_line(Special_occ_panel.get_node("Panel/Container/SpecialButtons").get_child(buttons).give_data())
		Special_occ_panel.get_node("Panel/Container/SpecialButtons").get_child(buttons).queue_free()
	file.close()
	Special_occ_panel.visible = false


func _on_Add_pressed():
	var button_path = preload("res://src/UI_Elements/Buttons/SpecialOccasionButton.tscn")
	var new_button = button_path.instance()
	Special_occ_panel.get_node("Panel/Container/SpecialButtons").add_child(new_button)


func check_occasion():
	var file = File.new()
	var names = []
	names.clear()
	occasions_names = ""
	var error = file.open(occasions_list,File.READ)
	if error == OK:
		var tmp_file = File.new()                        #used to store "file" and then give it back with some changes
		tmp_file.open(temp_occ,File.WRITE)
		while true:
			var array = file.get_csv_line()
			if array.size() == 4:
				if str(array[3]) == "True":
					if str(array[1]) == str(OS.get_date().day) and str(array[2]) == str(OS.get_date().month):
						names.append(str( "\"", array[0] , "\"").c_unescape())
						array[3] = "False"
				tmp_file.store_csv_line(array)
			if file.eof_reached():
				break
		tmp_file.close()
	file.close()
	
	var tmp_file = File.new()
	var tmp_error = tmp_file.open(temp_occ,File.READ)
	if tmp_error == OK:
		file.open(occasions_list,File.WRITE)
		file.store_string(tmp_file.get_as_text())
		file.close()
		tmp_file.close()
		var dir_to_remove = Directory.new()
		dir_to_remove.remove(temp_occ)
	
	if names.empty():
		return
	elif names.size() == 1:
		Special_occasions.dialog_text = str(names[0]," is happening \"Today\"!").c_unescape()
		Special_occasions.popup() 
	else:
		for name in names:
			if names[0] == name:
				occasions_names = str(name)
			elif names[names.size() - 1] == name:
				occasions_names = str(occasions_names, " and ", name, "are happening \"Today\"!").c_unescape()
			else:
				occasions_names = str(occasions_names, ", ", name)
		Special_occasions.dialog_text = occasions_names
		Special_occasions.popup() 


func _on_Visit_Youtube_pressed():
	var _err = OS.shell_open("https://www.youtube.com/channel/UCkc4E2bJkQ91kejNKKd_U2g")
