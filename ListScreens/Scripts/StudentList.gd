extends Control

@onready var stdTemplate = $Panel/ScrollContainer/VBoxContainer/HBoxContainer

func _ready():
	for student in Global.dataRes.students.values():
		if student.user == Global.currentUser:
			var newTemp = stdTemplate.duplicate()
			stdTemplate.get_parent().add_child(newTemp)
			newTemp.get_child(0).text = "\n" + student.studentName + "\n" 
			newTemp.get_child(0).text += "\n" + "Next Session: "
			newTemp.get_child(0).text += "None"
			newTemp.get_child(0).text += "\n" + "\n"
			newTemp.get_child(1).texture = student.loadProfilePicture()
			newTemp.get_child(0).pressed.connect(_edit_student.bind(student))
			newTemp.visible = true

func _edit_student(std: Student):
	Global.studentToEdit[0] = Global.dataRes.students.find_key(std)
	Global.studentToEdit[1] = std
	Global.prevScene = load(get_tree().current_scene.scene_file_path)
	Global.editMode = true
	var scenePath = "res://CreationScreens/StudentCreation.tscn"
	get_tree().change_scene_to_file(scenePath)

func _on_back_button_down():
	get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")
