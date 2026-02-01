extends Control

@onready var vbc = $VBoxContainer
var muscleIntStore = []
var globalData = preload("res://Globals/GlobalData.tres")
@onready var muscleItem = $Panel/ScrollContainer/VBoxContainer
@onready var muscleOptButton = $Panel/OptionButton
var imagePath: String = ""

func _ready():
	for i in range(len(Global.MuscleFocus.keys())):
		var itemName = Global.MuscleFocus.keys()[i]
		muscleOptButton.add_item(itemName)
	
	if Global.editMode:
		editExercise(Global.exerToEdit[1])

	get_tree().get_root().files_dropped.connect(on_files_dropped)

func _on_file_dialog_file_selected(path):
	imagePath = path
	var curImage = Image.new()
	curImage.load(imagePath)
	
	var curImageTex = ImageTexture.new()
	curImageTex.set_image(curImage)
	$ImageAdder.texture_normal = curImageTex

func _on_image_adder_button_down():
	$ImageAdder/FileDialog.popup()

func _on_proceed_button_down():
	if !Global.editMode:
		createExercise(Global.dataRes.exerciseResource.new())
		Global.saveData()
		get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")
	else:
		if !imagePath.is_empty():
			Global.exerToEdit[1].previewPic = Texture2D.new()
		createExercise(Global.exerToEdit[1])
		Global.saveData()
		Global.editMode = false
		get_tree().change_scene_to_packed(Global.prevScene)
	
func editExercise(exr: Exercise):
	$NameInput.text = exr.name
	$Description.text = exr.description
	$VC/EquipmentSelect.selected = exr.equipmentInvolved
	$ImageAdder.texture_normal = exr.loadPreviewPicture()
	$VC/AgeMin.assignValue(exr.ageMin)
	$VC/AgeMax.assignValue(exr.ageMax)
	$VC/TimeSecs.assignValue(exr.timeInSecs)
	print(exr.difficulty)
	$VC/DifficultySelect.selected = exr.difficulty
	var difInt = $VC/DifficultySelect.selected
	var difSelected = Global.Difficulty.find_key(difInt)
	print(difSelected)
	exr.difficulty = difSelected
	
	for i in range(len(exr.muscleFocuses)):
		var newItem = muscleItem.get_child(0).duplicate()
		muscleItem.add_child(newItem)
		var muscleFocName = Global.MuscleFocus.find_key(exr.muscleFocuses[i])
		newItem.text = muscleFocName
		newItem.visible = true

func createExercise(exr: Exercise):
	exr.name = $NameInput.text
	exr.description = $Description.text
	var equipSelect = $VC/EquipmentSelect.get_item_text($VC/EquipmentSelect.selected)
	equipSelect = equipSelect.replace(" ", "")
	exr.equipmentInvolved = Global.Equipment[equipSelect]
	exr.savePreviewPicture(imagePath, $ImageAdder.texture_normal)
	exr.ageMin = $VC/AgeMin.curVal
	exr.ageMax = $VC/AgeMax.curVal
	exr.timeInSecs = $VC/TimeSecs.curVal
	var difInt = $VC/DifficultySelect.selected
	var difSelected = $VC/DifficultySelect.get_item_text(difInt)
	print(difSelected)
	exr.muscleFocuses.clear()
	exr.difficulty = Global.Difficulty[difSelected]
	for i in range(len(muscleIntStore)):
		var mscCur = Global.MuscleFocus.find_key(muscleIntStore[i])
		print(mscCur)
		exr.muscleFocuses.append(Global.MuscleFocus[mscCur])
	
	if !Global.editMode:
		Global.dataRes.exercises[$NameInput.text] = exr
	else:
		Global.dataRes.exercises.erase(Global.exerToEdit[0])
		Global.dataRes.exercises[Global.exerToEdit[0]] = exr

func _on_option_button_item_selected(index):
	var canAddItem = true
	for i in range(len(muscleIntStore)):
		if (index == muscleIntStore[i]):
			canAddItem = false
	
	if (canAddItem):
		muscleIntStore.append(index)
		var newItem = muscleItem.get_child(0).duplicate()
		muscleItem.add_child(newItem)
		newItem.visible = true
		newItem.text = $Panel/OptionButton.get_item_text(index)

func _on_back_button_down():
	if Global.editMode == true:
		Global.editMode = false
		get_tree().change_scene_to_packed(Global.prevScene)
	else:
		get_tree().change_scene_to_file("res://MiscScenes/MainMenu.tscn")

func on_files_dropped(files):
	imagePath = files[0]
	var curImage = Image.new()
	curImage.load(imagePath)
	
	var curImageTex = ImageTexture.new()
	curImageTex.set_image(curImage)
	$ImageAdder.texture_normal = curImageTex
