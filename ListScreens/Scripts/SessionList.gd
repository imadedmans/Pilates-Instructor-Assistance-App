extends Control

@onready var sessionItem = $Panel/ScrollContainer/VBC/HBC

func _ready():
	Global.sortSessionByDate()
	addSessions()

func addSessions():
	var og = 0
	for i in range(len(Global.sortedSessionArray)):
		if Global.sortedSessionArray[i].user == Global.currentUser:
			var a = Global.sortedSessionArray[i].startTimeDate
			og += 1
			createSessionButton(Global.sortedSessionArray[i], i, og)

func createSessionButton(curSession: Session, sesInt: int, childNum: int):
	var newSesItem = sessionItem.duplicate()
	sessionItem.get_parent().add_child(newSesItem)
	var sessionText = newSesItem.get_child(0)
	sessionText.text = "Session with "
	sessionText.text += curSession.studentAssigned.studentName
	sessionText.text += "\n"
	var newTimeString = Time.get_datetime_string_from_unix_time(curSession.startTimeDate, true)
	sessionText.text += newTimeString
	newSesItem.get_child(1).pressed.connect(delete_check.bind(curSession, sesInt, childNum))
	newSesItem.visible = true

func delete_check(c: Session, s: int, ch: int):
	$WarningMessage.visible = true
	var deleteButton = $WarningMessage/HBC/Button
	if !deleteButton.pressed.is_null():
		deleteButton.pressed.disconnect(deleteSession)
	deleteButton.pressed.connect(deleteSession.bind(c, s, ch))

func deleteSession(curSession: Session, sesInt: int, childNum: int):
	$WarningMessage.visible = false
	Global.sortedSessionArray.pop_at(sesInt)
	var curSessName = curSession.sessionName
	Global.dataRes.sessions.erase(curSessName)
	sessionItem.get_parent().get_child(childNum).visible = false
	Global.saveData()

func _on_back_button_down():
	get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")

func never_mind():
	$WarningMessage.visible = false
