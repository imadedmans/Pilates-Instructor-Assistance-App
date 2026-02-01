extends Control

@onready var exerTemplate = $Panel/ScrollCont/VBoxContainer/HBoxContainer


func _ready():
	for exercise in Global.dataRes.exercises.values():
		var newTemp = exerTemplate.duplicate()
		exerTemplate.get_parent().add_child(newTemp)
		newTemp.get_child(0).text = exercise.name
		newTemp.get_child(1).text = "\n" + "Muscles Involved: "
		for musc in exercise.muscleFocuses:
			newTemp.get_child(1).text += Global.MuscleFocus.keys()[musc] + ", "
		newTemp.get_child(1).text += "\n" + "\n" + "Difficuly: "
		newTemp.get_child(1).text += Global.Difficulty.keys()[exercise.difficulty]
		newTemp.get_child(1).text += "\n" + "\n"
		print(exercise.previewPicSaveDir)
		newTemp.get_child(2).texture = exercise.loadPreviewPicture()
		newTemp.get_child(0).pressed.connect(_edit_exercise.bind(exercise))
		newTemp.visible = true

func _edit_exercise(exr: Exercise):
	Global.exerToEdit[0] = Global.dataRes.exercises.find_key(exr)
	Global.exerToEdit[1] = exr
	Global.prevScene = load(get_tree().current_scene.scene_file_path)
	Global.editMode = true
	var scenePath = "res://CreationScreens/ExerciseCreation.tscn"
	get_tree().change_scene_to_file(scenePath)

func _on_back_button():
	get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")
