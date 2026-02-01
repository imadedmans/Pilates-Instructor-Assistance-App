class_name Exercise 
extends Resource

@export var name: String = "Exercise"
@export var description: String = "Stuff goes here"
@export var previewPic: Texture
@export var equipmentInvolved: Global.Equipment
@export var muscleFocuses: Array[Global.MuscleFocus]
@export_range(18, 70) var ageMin: int = 18
@export_range(18, 70) var ageMax: int = 70
@export var timeInSecs: int = 60
@export var difficulty: Global.Difficulty
@export var previewPicSaveDir = ""

var healthCondMuscleEquate = [4, 2, 1, 5, 3, 6, 5, 2, 4, 6, 
								1, 1, 5, 2, 3, 0, 6, 6, 1, 2]

var muscleDifficultyNum = 0
var muscleDifficultyArray = []

func difficultyDecide(std: Student):
	muscleDifficultyArray = []
	muscleDifficultyNum = 0
	for muscleFocus in muscleFocuses:
		var the = healthCondMuscleEquate[muscleFocus]
		for muscDif in std.healthConditions:
			if muscDif == the:
				muscleDifficultyArray.append(the)
				muscleDifficultyNum += 1
	return float(muscleDifficultyNum)


func savePreviewPicture(filePath: String, textureUsed: Texture):
	if !filePath.is_empty():
		var splittedFile = filePath.split("/")
		var fileName = splittedFile[splittedFile.size() - 1]
		fileName = fileName.split(".")[0]
		previewPicSaveDir = Global.IMAGE_SAVE_PATH + fileName + ".jpg"
		textureUsed.get_image().save_jpg(previewPicSaveDir)
	else:
		previewPic = textureUsed
	
func loadPreviewPicture() -> Texture:
	var createdTexture = Texture.new()
	if !previewPicSaveDir.is_empty():
		var loadedImage = Image.load_from_file(previewPicSaveDir)
		createdTexture = ImageTexture.create_from_image(loadedImage)
	else:
		createdTexture = previewPic
	return createdTexture
	
