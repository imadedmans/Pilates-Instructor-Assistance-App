class_name Routine 
extends Resource

@export var routineName = "Routine"
@export var exercises: Array[Exercise]
var generalDifficulty
var user = "Hi."
var numOfExercises = 0
var approxTime = 0
var totalMuscFocuses = 0

func updateVar():
	numOfExercises = len(exercises)
	approxTime = 0
	totalMuscFocuses = 0
	for i in range(numOfExercises):
		totalMuscFocuses += exercises[i].muscleFocuses.size()
		approxTime += exercises[i].timeInSecs

func _process(delta):
	numOfExercises = len(exercises)
