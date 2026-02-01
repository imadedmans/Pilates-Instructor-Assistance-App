class_name GlobalData
extends Resource

const studentResource = preload("res://ObjectsScripts/Student.gd")
const routineResource = preload("res://ObjectsScripts/Routine.gd")
const sessionResource = preload("res://ObjectsScripts/Session.gd")
const exerciseResource = preload("res://ObjectsScripts/Exercise.gd")

var screamingApeTheory = 10

@export var users = [["SuhuiGoh987", "password1"], 
			["imadedmans", "waterBottle8@"], 
			["GINGBASTER", "THEROYALSCIENTIST"]]

@export var students: Dictionary = {
	"Suhui": studentResource.new(),
	"Er Yi": studentResource.new()
}

@export var exercises: Dictionary = {
	"Curl-Ups": exerciseResource.new()
}

@export var routines: Dictionary = {
	"Fake": routineResource.new()
}

@export var sessions: Dictionary = {
	"What": sessionResource.new()
}

@export var firstTime = true

# Called when the resource enters the scene tree for the first time.
func _init():
	print("Is First Time? :", firstTime)
	if firstTime:
		instantiateStuffs()

func instantiateStuffs():
	students["Suhui"].studentName = "Suhui"
	students["Er Yi"].studentName = "Er Yi"
	exercises["Curl-Ups"].name = "Curl-Ups"
	routines["Fake"].routineName = "Fake"
	sessions.erase("What")
	#testSessionThigy()
	
	getResources("res://Students/", students)
	getResources("res://Exercises/", exercises)
	getResources("res://Routines/", routines)
	getResources("res://Sessions/", sessions)
	
	for s in sessions:
		sessions[s].sessionName = s
		sessions[s].getSpecificTimes()
		sessions[s].difficultyDecide()
	
	#Creates new image folder
	DirAccess.make_dir_absolute(Global.IMAGE_SAVE_PATH)
	
	firstTime = false

func getResources(folderStr: String, curDict: Dictionary):
	var folderThing = DirAccess.open(folderStr)
	if folderThing:
		folderThing.list_dir_begin()
		var file_name = folderThing.get_next()
		while file_name != "":
			if '.tres.remap' in file_name:
				file_name = file_name.trim_suffix(".remap")
			var loadString = folderStr + file_name
			file_name = file_name.split(".")[0] #Removes .tres from file name
			curDict.get_or_add(file_name)
			curDict[file_name] = load(loadString)
			file_name = folderThing.get_next()
