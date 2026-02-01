extends Control

@export var nextScene: PackedScene

var usernameCor = false

func _on_log_in_button_down():
	disableErrorMessages(false)
	usernameCor = false
	var canProceed = true
	
	if $Login/UsernameInput.text.is_empty():
		$Login/ErrorMessage3.visible = true
		canProceed = false
		
	if $Login/PasswordInput.text.is_empty():
		$Login/ErrorMessage4.visible = true
		canProceed = false
	
	if (canProceed == true):
		searchThroughUsers()

func _on_sign_up_button_down():
	$Login.visible = false
	$Login/UsernameInput.text = ""
	$Login/PasswordInput.text = ""
	disableErrorMessages(false)
	$SignUp.visible = true

func _on_create_user_button_down():
	disableErrorMessages(true)
	var canProceed = true
	
	if $SignUp/UsernameInput.text.is_empty():
		$SignUp/ErrorMessage2.visible = true
		canProceed = false
	
	if $SignUp/PasswordInput.text.is_empty():
		$SignUp/ErrorMessage3.visible = true
		canProceed = false
	
	if $SignUp/PasswordInput.text.is_empty():
		$SignUp/ErrorMessage4.visible = true
		canProceed = false
	
	if (canProceed == true):
		createNewUser()

func _on_back_button_down():
	#Resets input fields
	$SignUp.visible = false
	$SignUp/UsernameInput.text = ""
	$SignUp/PasswordInput.text = ""
	$SignUp/PasswordInput2.text = ""
	disableErrorMessages(true)
	$Login.visible = true
	
func createNewUser():
	if $SignUp/PasswordInput.text == $SignUp/PasswordInput2.text:
		checkIfUserExists()
	else:
		$SignUp/ErrorMessage.visible = true

func searchThroughUsers():
	var postUsernameError = true
	var u = $Login/UsernameInput.text
	var p = $Login/PasswordInput.text
	while usernameCor == false:
		for i in range(len(Global.dataRes.users)):
			if u == Global.dataRes.users[i][0]:
				usernameCor = true
				if p == Global.dataRes.users[i][1]:
					Global.currentUser = Global.dataRes.users[i][0]
					get_tree().change_scene_to_packed(nextScene)
				else:
					postUsernameError = false
					$Login/ErrorMessage2.visible = true
		usernameCor = true
	if postUsernameError == true:
		$Login/ErrorMessage.visible = true
	

func checkIfUserExists():
	var canPass = true
	for i in range(len(Global.dataRes.users)):
		if $SignUp/UsernameInput.text == Global.dataRes.users[i][0]:
			canPass = false
	
	if canPass:
		var newUser = [$SignUp/UsernameInput.text, $SignUp/PasswordInput.text]
		Global.dataRes.users.append(newUser)
		_on_back_button_down()
	else:
		$SignUp/ErrorMessage5.visible = true


func disableErrorMessages(disableSignUp: bool):
	if disableSignUp:
		$SignUp/ErrorMessage.visible = false
		$SignUp/ErrorMessage2.visible = false
		$SignUp/ErrorMessage3.visible = false
		$SignUp/ErrorMessage4.visible = false
		$SignUp/ErrorMessage5.visible = false
	else:
		$Login/ErrorMessage.visible = false
		$Login/ErrorMessage2.visible = false
		$Login/ErrorMessage3.visible = false
		$Login/ErrorMessage4.visible = false
