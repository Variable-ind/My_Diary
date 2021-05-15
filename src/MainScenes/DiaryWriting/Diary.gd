extends Control
var save_path = ""
var path = ""
onready var save_pannel = get_node("Save?")
onready var todays_Date = get_node("VBoxContainer/Panel2/Date")
onready var todays_Day = get_node("VBoxContainer/Panel2/Day")
onready var text_pannel = get_node("VBoxContainer/Panel2/TextEdit")
onready var music = get_node("AudioStreamPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	text_pannel.text = ""
	save_pannel.visible = false
	var settings = File.new()
	settings.open("user://Settings.dat",File.READ)
	var base_info = settings.get_var()
	
	save_path = base_info.location           #Set storage path
	#save_path = "user://Settings/My Diary/"   #testing on pc
	
	music.stream = load(str("res://Music/",base_info.name,".ogg"))    #Set Music name and playing
	music.playing = base_info.music
	music.seek(Global.timing)
	
	if base_info.style == 0:
		var dynamic_font = preload("res://graphics/Fonts/For Writting/Block writing.tres")
		text_pannel.set("custom_fonts/font", dynamic_font)
		var date_dynamic_font = preload("res://graphics/Fonts/For Writting/Date day block.tres")
		todays_Date.set("custom_fonts/font",date_dynamic_font)
		todays_Day.set("custom_fonts/font",date_dynamic_font)
	elif base_info.style == 1:
		var dynamic_font = preload("res://graphics/Fonts/For Writting/Joining.tres")
		text_pannel.set("custom_fonts/font", dynamic_font)
		var date_dynamic_font = preload("res://graphics/Fonts/For Writting/Date day Cursive.tres")
		todays_Date.set("custom_fonts/font",date_dynamic_font)
		todays_Day.set("custom_fonts/font",date_dynamic_font)
	settings.close()
	var dir = Directory.new()
	if !dir.dir_exists(save_path):
		dir.make_dir_recursive(save_path)


func _process(_delta):
	Global.timing = music.get_playback_position()
	var curr_date_day = Get_date_day()
	if todays_Date.text != curr_date_day.Date.replace("Was","is"):
		todays_Date.text = curr_date_day.Date.replace("Was","is")
		todays_Day.text = curr_date_day.Day
		OS.set_clipboard(todays_Date.text)


func _on_done_pressed():
	if text_pannel.text != "Your entry has been saved" or text_pannel.text != "There has been an error, check if the path is correct, reinstall the app or check if the required permissions are enabled":
		path = str(save_path , OS.get_datetime().day, "-" , OS.get_datetime().month, "-" , OS.get_datetime().year , ".txt")
		var file = File.new()
		var old_text = ""
		
		if not file.file_exists(path):
			var curr_date_day = Get_date_day()
			file.open(path,File.WRITE)
			file.store_line(curr_date_day.Date)
			file.store_line(curr_date_day.Day)
			file.store_line("")
			file.close()
		
		file.open(path,File.READ)
		old_text = file.get_as_text()
		file.close()
		var error = file.open(path,File.WRITE)
		if error == OK:
			file.store_string(old_text)
			file.store_line(str("---->","Entry at:" , OS.get_datetime().hour , ":" , OS.get_datetime().minute , ":" , OS.get_datetime().second))
			file.store_line("")
			file.store_line(text_pannel.text)
			file.store_line("")
			file.store_line("")
			text_pannel.text = str("Your entry has been saved at:" ,file.get_path_absolute())
			file.close()
		else:
			text_pannel.text = str("There has been an error, check if the path is correct, and check if the required permission (Storage) is enabled")
		save_pannel.visible = false


func _on_cancel_pressed():
	save_pannel.visible = false


func _on_Save_pressed():
	save_pannel.visible = true


func _on_TextureButton_pressed():
	var error = get_tree().change_scene("res://src/MainScenes/DiaryReading/Read.tscn")


func _on_back_pressed():
	var error = get_tree().change_scene("res://src/MainScenes/MainMenu/Menu.tscn")


func Get_date_day():
	var date = ""
	var prefix = ""
	var curr_week = ""
	if OS.get_datetime().day == 1 or OS.get_datetime().day == 21  or OS.get_datetime().day == 31:
		prefix = "st  of "
	elif OS.get_datetime().day == 2 or OS.get_datetime().day == 22:
		prefix = "nd  of "
	elif OS.get_datetime().day == 3 or OS.get_datetime().day == 23:
		prefix = "rd  of "
	else:
		prefix = "th  of "
	
	if OS.get_datetime().weekday == 1:
		curr_week = "Monday"
	elif OS.get_datetime().weekday == 2:
		curr_week = "Tuesday"
	elif OS.get_datetime().weekday == 3:
		curr_week = "Wednesday"
	elif OS.get_datetime().weekday == 4:
		curr_week = "Thursday"
	elif OS.get_datetime().weekday == 5:
		curr_week = "Friday"
	elif OS.get_datetime().weekday == 6:
		curr_week = "Saturday"
	else:
		curr_week = "Sunday"
	
	
	if OS.get_datetime().month == 1:
		date = "January"
	elif OS.get_datetime().month == 2:
		date = "Feburary"
	elif OS.get_datetime().month == 3:
		date = "March"
	elif OS.get_datetime().month == 4:
		date = "April"
	elif OS.get_datetime().month == 5:
		date = "May"
	elif OS.get_datetime().month == 6:
		date = "June"
	elif OS.get_datetime().month == 7:
		date = "July"
	elif OS.get_datetime().month == 8:
		date = "August"
	elif OS.get_datetime().month == 9:
		date = "September"
	elif OS.get_datetime().month == 10:
		date = "Octuber"
	elif OS.get_datetime().month == 11:
		date = "November"
	else:
		date = "December"
	var info = { "Date" : str("The Date Was :" , OS.get_datetime().day, prefix , date , "," , OS.get_datetime().year),
				 "Day": str("And the Day is :" , curr_week)}
	return info


func _on_TextEdit_focus_entered():
	if "Your entry has been saved" in text_pannel.text:
		text_pannel.text = ""
