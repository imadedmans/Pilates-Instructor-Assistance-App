class_name Session 
extends Resource

@export var studentAssigned: Student
@export var lengthInMin: float
@export var reminderInMin: float
@export var routineUsed: Routine

var sessionName = "new"
var exerDefDifficulty = 0.0
var exerMuscleDifficulty = 0.0
var healthDifficulty = 0.0
var totalDifficulty = 0.0

var maxDifPoints = 18
var maxTimePoints = 12
var maxHealthCondPoints = 70

@export var TimeAndDate := {
	"hour": 1,
	"minute": 1,
	"second": 1,
	"day": 1,
	"month": Global.Month.January,
	"year": 2026
}

var startTimeDate: int = 10
var remindTimeDate: int = 10
var endTimeDate: int = 10

@export var hasReminded = false
@export var hasStarted = false
@export var hasEnded = false

var muscleDifficultyArray = []
var user = "Hi."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func difficultyDecide():
	exerDefDifficulty = 0.0
	exerMuscleDifficulty = 0.0
	healthDifficulty = 0.0
	totalDifficulty = 0.0
	
	for exr in routineUsed.exercises:
		exerDefDifficulty += float(exr.difficulty + 1)
		exerMuscleDifficulty += exr.difficultyDecide(studentAssigned)
		addMuscDif(exr.muscleDifficultyArray)
	
	var muscDivisor = float(exerMuscleDifficulty) / float(routineUsed.totalMuscFocuses)
	print(float(exerMuscleDifficulty))
	print(float(routineUsed.totalMuscFocuses))
	healthDifficulty = muscDivisor * 100.0
	print("Health: ", healthDifficulty)
	totalDifficulty = maxHealthCondPoints * muscDivisor
	
	exerDefDifficulty = (exerDefDifficulty / float(len(routineUsed.exercises)))
	exerDefDifficulty *= float(maxDifPoints)
	totalDifficulty += exerDefDifficulty
	totalDifficulty += min(0.1 * float(lengthInMin), 12.0)
	print("Insensitive: ", float(lengthInMin))
	print("Timing: ", min(0.1 * float(lengthInMin), 12.0))
	#Code above considers the length of the session
	
		#print("Difficulty thing: ", exerMuscleDifficulty)
	#print("Huh? okay wait... ", float(routineUsed.totalMuscFocuses))
	#print("Muscle Divider: ", muscDivisor)


func addMuscDif(m: Array):
	if len(muscleDifficultyArray) > 0:
		for i in range(len(m)):
			var canAdd = true
			for j in range(len(muscleDifficultyArray)):
				if muscleDifficultyArray[j] == m[i]:
					canAdd = false
			if (canAdd):
				muscleDifficultyArray.append(m[i])
	else:
		for i in range(len(m)):
			muscleDifficultyArray.append(m[i])

func getSpecificTimes():
	#TimeAndDate["month"] += 1
	startTimeDate = Time.get_unix_time_from_datetime_dict(TimeAndDate)
	print("Session time: ", Time.get_datetime_string_from_datetime_dict(TimeAndDate, true))
	remindTimeDate = startTimeDate - int(60 * reminderInMin)
	endTimeDate = startTimeDate + int(60 * lengthInMin)
	#print("Remind time: ", Time.get_datetime_string_from_unix_time(remindTimeDate))
	#print("End time: ", Time.get_datetime_string_from_unix_time(endTimeDate))
