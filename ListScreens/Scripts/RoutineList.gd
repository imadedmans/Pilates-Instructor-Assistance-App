extends Control

@onready var routineItem = $Panel/SC/VBC/HBC

func _ready():
	addRoutines()

func addRoutines():
	var og = 0
	for routine in Global.dataRes.routines.values():
		if routine.user == Global.currentUser:
			og += 1
			createRoutineButton(routine, og)

func createRoutineButton(curRoutine: Routine, childNum: int):
	var newSesItem = routineItem.duplicate()
	routineItem.get_parent().add_child(newSesItem)
	newSesItem.get_child(0).text = "\n" + curRoutine.routineName + "\n"
	newSesItem.get_child(0).pressed.connect(editRoutine.bind(curRoutine))
	newSesItem.get_child(1).pressed.connect(delete_check.bind(curRoutine, childNum))
	newSesItem.visible = true

func editRoutine(routine: Routine):
	Global.routineToEdit[0] = Global.dataRes.routines.find_key(routine)
	Global.routineToEdit[1] = routine
	Global.prevScene = load(get_tree().current_scene.scene_file_path)
	Global.editMode = true
	var scenePath = "res://CreationScreens/RoutineCreation.tscn"
	get_tree().change_scene_to_file(scenePath)

func delete_check(c: Routine, ch: int):
	$WarningMessage.visible = true
	var deleteButton = $WarningMessage/HBC/Button
	if !deleteButton.pressed.is_null():
		deleteButton.pressed.disconnect(deleteRoutine)
	deleteButton.pressed.connect(deleteRoutine.bind(c, ch))

func deleteRoutine(curRoutine: Routine, childNum: int):
	$WarningMessage.visible = false
	Global.dataRes.routines.erase(curRoutine.routineName)
	routineItem.get_parent().get_child(childNum).visible = false
	Global.saveData()

func _on_back_button_down():
	get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")

func never_mind():
	$WarningMessage.visible = false
