extends Control

var imagePath: String = ""
var healthCondIntStore = []
@onready var condItem = $Panel/ScrollContainer/VBoxContainer
@onready var condOptButton = $Panel/OptionButton

func _ready():
	for i in range(len(Global.HealthCondition.keys())):
		var itemName = Global.HealthCondition.keys()[i]
		if i > 0:
			itemName += " Pain"
		condOptButton.add_item(itemName)
	
	if Global.editMode:
		editStudent(Global.studentToEdit[1])
	
	get_tree().get_root().files_dropped.connect(on_files_dropped)

func _on_proceed_button_down():
	if !Global.editMode:
		createStudent(Global.dataRes.studentResource.new())
		Global.saveData()
		get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")
	else:
		if !imagePath.is_empty():
			Global.studentToEdit[1].profilePicture = Texture2D.new()
		createStudent(Global.studentToEdit[1])
		Global.saveData()
		Global.editMode = false
		get_tree().change_scene_to_packed(Global.prevScene)
	

func _on_file_dialog_file_selected(path):
	imagePath = path
	var curImage = Image.new()
	curImage.load(path)
	
	var curImageTex = ImageTexture.new()
	curImageTex.set_image(curImage)
	$ImageAdder.texture_normal = curImageTex

func createStudent(newStudent: Student):
	newStudent.studentName = $GC/NameInput.text
	newStudent.age = $GC/AgeInput.curVal
	newStudent.height = $GC/HeightInput.value
	var monSel = $GC/BirthdaySelection/Month
	newStudent.birthday["day"] = $GC/BirthdaySelection/Day.value
	newStudent.birthday["month"] = monSel.get_item_text(monSel.selected)
	newStudent.saveProfilePicture(imagePath, $ImageAdder.texture_normal)
	newStudent.healthConditions.clear()
	for i in range(1, condItem.get_child_count()):
		var condText = condItem.get_child(i).text
		if !condText.contains("Scoliosis"):
			condText = condText.split(" ")[0]
		newStudent.healthConditions.append(Global.HealthCondition[condText])
		print(newStudent.healthConditions[i - 1])
	newStudent.user = Global.currentUser
	
	if !Global.editMode:
		Global.dataRes.students[$GC/NameInput.text] = newStudent
	else:
		newStudent.studentName = $GC/NameInput.text
		print("Student name: ", Global.studentToEdit[0])
		Global.dataRes.students.erase(Global.studentToEdit[0])
		print(Global.dataRes.students.keys())
		Global.dataRes.students[Global.studentToEdit[0]] = newStudent

func editStudent(std: Student):
	$GC/NameInput.text = std.studentName
	$GC/AgeInput.assignValue(std.age)
	$GC/HeightInput.value = std.height
	$GC/BirthdaySelection/Day.value = std.birthday["day"]
	#monSel.selected = Global.Month[std.birthday["month"]]
	if typeof(std.birthday["month"]) == 4:
		$GC/BirthdaySelection/Month.selected = Global.Month[std.birthday["month"]]
	elif typeof(std.birthday["month"]) == 2:
		$GC/BirthdaySelection/Month.selected = std.birthday["month"]
	#Global.Month[std.birthday["month"]]
	$ImageAdder/DragLabel.visible = false
	$ImageAdder.texture_normal = std.loadProfilePicture()
	
	print("Num of health conditions: ", len(std.healthConditions))
	for i in range(len(std.healthConditions)):
		var newItem = condItem.get_child(0).duplicate()
		condItem.add_child(newItem)
		var condName = Global.HealthCondition.find_key(std.healthConditions[i])
		newItem.text = condName
		newItem.visible = true
	

func _on_image_adder_button_down():
	$ImageAdder/FileDialog.popup()

func _on_option_button_item_selected(index):
	var canAddItem = true
	for i in range(len(healthCondIntStore)):
		if (index == healthCondIntStore[i]):
			canAddItem = false

	if (canAddItem):
		healthCondIntStore.append(index)
		var newItem = condItem.get_child(0).duplicate()
		condItem.add_child(newItem)
		newItem.visible = true
		newItem.text = $Panel/OptionButton.get_item_text(index)
		
	#If the Health condition integer isn't already stored, the item won't be added
	#i.e (there's already Scilosis (identified with index 0))

func on_files_dropped(files):
	imagePath = files[0]
	var curImage = Image.new()
	curImage.load(imagePath)
	
	var curImageTex = ImageTexture.new()
	curImageTex.set_image(curImage)
	$ImageAdder.texture_normal = curImageTex
	$ImageAdder/DragLabel.visible = false
		

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
			$GC/BirthdaySelection/Day.max_value = 31
		else:
			if index != 1:
				$GC/BirthdaySelection/Day.max_value = 30
			else:
				$GC/BirthdaySelection/Day.max_value = 28
	else:
		if (index % 2) == 0:
			$GC/BirthdaySelection/Day.max_value = 30
		else:
			$GC/BirthdaySelection/Day.max_value = 31
