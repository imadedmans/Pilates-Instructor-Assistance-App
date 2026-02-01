extends Control

@onready var exerButton = $GetAllExercises/Panel/ScrollContainer/GridContainer/Button
@onready var exerListTemp = $MainScreen/Panel/ScrollContainer/VBoxContainer/Item1

var tempExerArray: Array[Exercise]
var numOfExer = 0
var approxTime = 0

func _ready():
	$MainScreen.visible = true
	$GetAllExercises.visible = false
	for exer in Global.dataRes.exercises.values():
		createExerciseButton(exer)
	
	if Global.editMode:
		editRoutine(Global.routineToEdit[1])

func _process(delta):
	$MainScreen/GridContainer/NumOfExer.text = str(numOfExer)
	var approxTimeStr = str(approxTime) + " minutes"
	$MainScreen/GridContainer/ApproxTime.text = approxTimeStr
	
func editRoutine(selectRout: Routine):
	$MainScreen/NameInput.text = selectRout.routineName
	numOfExer = selectRout.numOfExercises
	approxTime = selectRout.approxTime
	for exr in selectRout.exercises:
		_on_add_exercise_down(exr)
	
func createExerciseButton(curExercise: Exercise):
	var buttonStr = ""
	buttonStr += curExercise.name
	buttonStr += "\n" + "\n" + "Difficulty: "
	buttonStr += Global.Equipment.keys()[curExercise.difficulty]
	buttonStr += "\n" + "\n" + "Muscle Focuses: "
	buttonStr += "(...)"
	buttonStr += "\n" + "\n" + "Reccomended For User?: Yes"
	
	var newButton = exerButton.duplicate()
	exerButton.get_parent().add_child(newButton)
	newButton.text = buttonStr
	newButton.pressed.connect(_on_add_exercise_down.bind(curExercise))
	newButton.visible = true

func _on_exercise_screen_button_down():
	$MainScreen.visible = false
	$GetAllExercises.visible = true

func _on_add_exercise_down(exer: Exercise):
	var newExer = exerListTemp.duplicate()
	exerListTemp.get_parent().add_child(newExer)
	newExer.text = exer.name
	newExer.visible = true
	numOfExer += 1
	approxTime += exer.timeInSecs / 60
	tempExerArray.append(exer)

func _on_back_to_main_button_down():
	$MainScreen.visible = true
	$GetAllExercises.visible = false

func _on_proceed_button_down():
	if !Global.editMode:
		createRoutine(Global.dataRes.routineResource.new())
		Global.saveData()
		get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")
	else:
		createRoutine(Global.routineToEdit[1])
		Global.saveData()
		Global.editMode = false
		get_tree().change_scene_to_packed(Global.prevScene)

func createRoutine(newRoutine: Routine):
	newRoutine.routineName = $MainScreen/NameInput.text
	newRoutine.exercises = tempExerArray
	newRoutine.generalDifficulty = Global.Difficulty.Intermediate
	newRoutine.numOfExercises = numOfExer
	newRoutine.approxTime = approxTime
	newRoutine.user = Global.currentUser
	
	if !Global.editMode:
		Global.dataRes.routines[$MainScreen/NameInput.text] = newRoutine
	else:
		newRoutine.routineName = $MainScreen/NameInput.text
		Global.dataRes.routines.erase(Global.routineToEdit[0])
		Global.dataRes.routines[Global.routineToEdit[0]] = newRoutine

func _on_back_button_down():
	if Global.editMode == true:
		Global.editMode = false
		get_tree().change_scene_to_packed(Global.prevScene)
	else:
		get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")
