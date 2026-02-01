extends Node

const SAVE_PATH = "user://GlobalData.tres"
const IMAGE_SAVE_PATH = "user://Images/"
var notifObj = preload("res://MiscScenes/NotificationBox.tscn")

enum HealthCondition {Scoliosis, Hip, Elbow, Shoulder, Back, 
					 Knee, Abdominal}
enum Difficulty {Foundational, Intermediate, Advanced}
enum Equipment {None, Reformer, Cadillac,
				WundaChair, Barrels, PedAPul, 
				ArmChair, MagicCircle}
enum MuscleFocus {Back, Elbow, Hip, Knee, Shoulder, Abdominals,
				 Hamstrings, Triceps, ScapularStablisers, 
				 AbdominalObliques, Adductors, Quadriceps,
				AnkleFootPlantarflexors, Biceps, Deltoids, Rhomboids,
				Pectorals, Intercostals, Gluteals, PosteriorDeltoid}
enum Month {January, Febuary, March, April, May, June, July,
			August, September, October, November, December}

var healthCondMuscleEquate = [4, 2, 1, 5, 3, 6, 5, 2, 4, 6, 
								1, 1, 5, 2, 3, 0, 6, 6, 1, 2]

var globalDateTime := 0
var currentUser = ""
#var dataRes: GlobalData = null
var dataRes: GlobalData = null

#Variables for edit mode
var exerToEdit = ["", ""]
#Stores two variables
#The key of the exercise
#And the exercise resource itself
var studentToEdit = ["", ""]
var routineToEdit = ["", ""]
var sessionToEdit = ["", ""]

var prevScene: PackedScene
var editMode = false
var sortedSessionArray = []
var firstTime = false
#Variable used in creation screens
# - If enabled, then only the current resource being editted will be changed

@export var BirthdayFormat := {
	"day": 1,
	"month": Month.January
}

@export var DateFormat := {
	"day": 1,
	"month": Month.January,
	"year": 2026,
}

@export var TimeFormat := {
	"hour": 1,
	"minute": 1,
	"second": 1,
}

func _init():
	loadData()

func _ready():
	sortSessionByDate()

func _process(delta):
	globalDateTime = int(Time.get_unix_time_from_system())
	sessionTimeCheck()
	
func sessionTimeCheck():
	for i in range(len(sortedSessionArray)):
		var session = sortedSessionArray[i]
		if (session.remindTimeDate == globalDateTime and !session.hasReminded):
			sessionNotification(session, false)
			session.hasReminded = true
		if (session.startTimeDate == globalDateTime and !session.hasStarted):
			sessionNotification(session, true)
			session.hasStarted = true
		if (session.endTimeDate == globalDateTime and !session.hasEnded):
			session.hasEnded = true
			var keyToDel = dataRes.sessions.find_key(session)
			sortedSessionArray.pop_at(i)
			dataRes.sessions.erase(keyToDel)

func sessionNotification(curSession: Session, startNow: bool):
	var statement = "Session with "
	statement += curSession.studentAssigned.studentName
	if startNow:
		statement += " starts now!"
	else:
		statement += " starts at " + str(curSession.reminderInMin) + " minutes!"
	var newNotif = notifObj.instantiate()
	get_tree().get_root().add_child(newNotif)
	newNotif.assignStatement(statement)

func sortSessionByDate():
	sortedSessionArray.clear()
	for sesName in Global.dataRes.sessions:
		var session = Global.dataRes.sessions[sesName]
		session.getSpecificTimes()
		var t = Time.get_unix_time_from_system()
		if t < session.endTimeDate:
			sortedSessionArray.append(session)
		else:
			Global.dataRes.sessions.erase(sesName)
	
	#Bubble sort array
	for i in range(len(sortedSessionArray)):
		for j in range(1, len(sortedSessionArray)):
			var a1 = sortedSessionArray[j - 1].startTimeDate
			var a2 = sortedSessionArray[j].startTimeDate
			if a1 > a2:
				var temp = sortedSessionArray[j]
				sortedSessionArray[j] = sortedSessionArray[j - 1]
				sortedSessionArray[j - 1] = temp

func saveData():
	ResourceSaver.save(dataRes, SAVE_PATH)

func loadData():
	if ResourceLoader.exists(SAVE_PATH):
		dataRes = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		dataRes = GlobalData.new()
