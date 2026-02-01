class_name Student 
extends Resource

@export var studentName: String
@export var healthConditions: Array[Global.HealthCondition]
@export var birthday: Dictionary = {
	"day": 1,
	"month": Global.Month.January,
}
@export_range(140, 190) var height: int = 160
@export_range(18, 70) var age: int = 18
@export var profilePicture: Texture
var user = "Hi."
var comparedExcr
@export var profPicSaveDir = ""

func saveProfilePicture(filePath: String, textureUsed: Texture):
	if !filePath.is_empty():
		profilePicture = Texture2D.new()
		var splittedFile = filePath.split("/")
		var fileName = splittedFile[splittedFile.size() - 1]
		fileName = fileName.split(".")[0]
		profPicSaveDir = Global.IMAGE_SAVE_PATH + fileName + ".jpg"
		textureUsed.get_image().save_jpg(profPicSaveDir)
	else:
		profilePicture = textureUsed
	
func loadProfilePicture() -> Texture:
	var createdTexture = Texture.new()
	if !profPicSaveDir.is_empty():
		var loadedImage = Image.load_from_file(profPicSaveDir)
		createdTexture = ImageTexture.create_from_image(loadedImage)
	else:
		createdTexture = profilePicture
	return createdTexture
