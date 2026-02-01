extends Control

var curSession
var curStudent
var selectedRoutine

@onready var GC3 = $GridContainer
@onready var routineButton = $Panel/ScrollContainer/VBoxContainer/Button
@onready var exerciseThing = $Panel2/ScrollContainer/VBoxContainer/Button

func _ready():
	for student in Global.dataRes.students.values():
		$GC2/Student.add_item(student.studentName)
	$GC2/Student.selected = 0
	for routine in Global.dataRes.routines.values():
		createRoutineButton(routine)

func routineSelected(routine: Routine):
	for i in range(1, exerciseThing.get_parent().get_child_count()):
		var exrToDel = exerciseThing.get_parent().get_child(i)
		exrToDel.queue_free()

	selectedRoutine = routine
	$RoutineSelected.text = "Selected: " + routine.routineName
	var studentName = $GC2/Student.get_item_text($GC2/Student.selected)
	for student in Global.dataRes.students.values():
		if student.studentName == studentName:
			curStudent = student
	
	curSession = Global.dataRes.sessionResource.new()
	curSession.studentAssigned = curStudent
	curSession.lengthInMin = 60
	selectedRoutine.updateVar()
	curSession.routineUsed = selectedRoutine
	curSession.difficultyDecide()
	
	$GC3/NumOfExercises.text = str(curSession.routineUsed.numOfExercises)
	var timeInTheMin = selectedRoutine.approxTime / 60
	$GC3/ApproxTime.text = str(timeInTheMin) + " minute"
	if timeInTheMin != 1:
		$GC3/ApproxTime.text += "s"
	$GC3/RawDifficulty.text = str(int(curSession.totalDifficulty)) + "/100"
	if curSession.healthDifficulty > 50.0:
		$GC3/Suitable.text = "No"
	else:
		$GC3/Suitable.text = "Yes"

	for i in range(len(curSession.muscleDifficultyArray)):
		var newExer = exerciseThing.duplicate()
		exerciseThing.get_parent().add_child(newExer)
		var muscleValue = curSession.muscleDifficultyArray[i]
		newExer.text = Global.HealthCondition.find_key(muscleValue)
		newExer.visible = true

func createSession():
	curSession.TimeAndDate["day"] = $GC/Day.value
	var monthText = $GC/Month.get_item_text($GC/Month.selected)
	curSession.TimeAndDate["month"] = Global.Month[monthText] + 1
	print(Global.Month[monthText])
	curSession.TimeAndDate["year"] = $GC/Year.value
	curSession.TimeAndDate["second"] = $GC/Seconds.value
	curSession.TimeAndDate["minute"] = $GC/Minute.value
	curSession.TimeAndDate["hour"] = $GC/Hour.value
	curSession.reminderInMin = 15.0 * ($GC2/ReminderTime.selected + 1)
	curSession.getSpecificTimes()
	curSession.user = Global.currentUser
	var sessionName = "Session with " + curSession.studentAssigned.studentName
	sessionName += " At " 
	sessionName += Time.get_datetime_string_from_unix_time(curSession.startTimeDate)
	curSession.sessionName = sessionName
	Global.dataRes.sessions[sessionName] = curSession

func createRoutineButton(rt: Routine):
	var newRout = routineButton.duplicate()
	routineButton.get_parent().add_child(newRout)
	newRout.text = rt.routineName
	newRout.pressed.connect(routineSelected.bind(rt))
	newRout.visible = true

func _on_proceed_button_down():
	createSession()
	Global.saveData()
	get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")

func _on_student_item_selected(index):
	if selectedRoutine != null:
		routineSelected(selectedRoutine)

func _on_back_button_down():
	if Global.editMode == true:
		Global.editMode = false
		get_tree().change_scene_to_packed(Global.prevScene)
	else:
		get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")

#Code below changes the maximum day allowed based on the month
func _on_month_item_selected(index):
	if index < 7:
		if (index % 2) == 0:
			$GC/Day.max_value = 31
		else:
			if index != 1:
				$GC/Day.max_value = 30
			else:
				if (int($GC/Year.value) % 4) == 0:
					$GC/Day.max_value = 29
				else:
					$GC/Day.max_value = 28
	else:
		if (index % 2) == 0:
			$GC/Day.max_value = 30
		else:
			$GC/Day.max_value = 31

func _on_year_value_changed(value):
	#Changes number of days when Febuary is selected at a leap year
	if $GC/Month.selected == 1:
		if int(value) % 4 == 0:
			$GC/Day.max_value = 29
		else:
			$GC/Day.max_value = 28
