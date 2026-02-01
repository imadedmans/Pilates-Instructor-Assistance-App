extends Control

@onready var dateLabel = $Calendar/HBC/SC/VBC/Date
@onready var dateTmrLabel = $Calendar/HBC/SC2/VBC2/Date2
@onready var sessionLabelToday = $Calendar/HBC/SC/VBC/SessionThing
@onready var sessionLabelTomm = $Calendar/HBC/SC2/VBC2/SessionThing

var updateStart = true

@export var testTime := {
	"hour": 20,
	"minute": 40,
	"second": 30
}

@export var testDate := {
	"day": 1,
	"month": Global.Month.December,
	"year": 2026
}

var todayStartTime = 0
var todayEndTime = 0
var nextDayEndTime = 0

func _ready():
	for i in range($HSC/VC1.get_child_count()):
		$HSC/VC1.get_child(i).pressed.connect(changeSceneButton.bind(i))
	for i in range($HSC/VC2.get_child_count()):
		$HSC/VC2.get_child(i).pressed.connect(changeSceneButton.bind(i + 4))
	
	Global.saveData()
	setCalendarTimings()
	placeSessionsInCalendar()

func _process(delta):
	setCalendarTimings()
	dateLabel.text = Time.get_date_string_from_system()
	dateTmrLabel.text = getNextDay(Time.get_datetime_dict_from_system(), 1)

func testSession():
	if updateStart and Global.globalDateTime != 0:
		print(Global.globalDateTime)
		var ack = Global.dataRes.sessions["What"]
		ack.studentAssigned = Global.dataRes.students["Er Yi"]
		ack.lengthInMin = 0.1
		ack.reminderInMin = 0.1
		ack.routineUsed = Global.dataRes.routines["Fake"] 
		ack.startTimeDate = Global.globalDateTime + 20
		ack.getSpecificTimes()
		updateStart = false

func changeSceneButton(chnInt: int):
	var scenePath = ""
	match chnInt:
		0:
			scenePath = "res://ListScenes/SessionList.tscn"
		1:
			scenePath = "res://ListScenes/StudentList.tscn"
		2:
			scenePath = "res://ListScenes/ExerciseList.tscn"
		3:
			scenePath = "res://ListScenes/RoutineList.tscn"
		4:
			scenePath = "res://CreationScreens/SessionCreation.tscn"
		5:
			scenePath = "res://CreationScreens/StudentCreation.tscn"
		6:
			scenePath = "res://CreationScreens/ExerciseCreation.tscn"
		7:
			scenePath = "res://CreationScreens/RoutineCreation.tscn"
	if (!scenePath.is_empty()):
		get_tree().change_scene_to_file(scenePath)

func setCalendarTimings():
	var todayDate = Time.get_date_dict_from_system()
	todayStartTime = Time.get_unix_time_from_datetime_dict(todayDate)
	todayEndTime = todayStartTime + 86400
	nextDayEndTime = todayEndTime + 86400

func getNextDay(currentDate: Dictionary, numOfDays: int):
	var curUnixTime = Time.get_unix_time_from_datetime_dict(currentDate)
	curUnixTime += 86400 * numOfDays   #Adds a whole 24 hours to the date
	var newStr = Time.get_date_string_from_unix_time(curUnixTime)
	return newStr
	
func placeSessionsInCalendar():
	for i in range(len(Global.sortedSessionArray)):
		var a = Global.sortedSessionArray[i].startTimeDate
		if a >= todayStartTime and a < todayEndTime:
			if a <= Time.get_unix_time_from_system():
				createSessionLabel(Global.sortedSessionArray[i], true)
		elif a >= todayEndTime and a < nextDayEndTime:
			createSessionLabel(Global.sortedSessionArray[i], false)
	
func createSessionLabel(curSession: Session, isToday: bool):
	var newSes
	if isToday:
		newSes = sessionLabelToday.duplicate()
		sessionLabelToday.get_parent().add_child(newSes)
	else:
		newSes = sessionLabelTomm.duplicate()
		sessionLabelTomm.get_parent().add_child(newSes)
	newSes.text = "Session With: " + curSession.studentAssigned.studentName
	newSes.text += "\n" + "At "
	var timeStr = curSession.startTimeDate
	newSes.text += Time.get_time_string_from_unix_time(timeStr)
	newSes.visible = true

func _on_log_out_button_down():
	get_tree().change_scene_to_file("res://LogInScreen.tscn")
