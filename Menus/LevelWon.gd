extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if GameManager.final_deaths == 0:
		$CenterContainer/VBoxContainer/LabelDeaths.text = "Amazing"
	elif GameManager.final_deaths == 1:
		$CenterContainer/VBoxContainer/LabelDeaths.text = "You had one death!"
	elif GameManager.final_deaths <= 10:
		$CenterContainer/VBoxContainer/LabelDeaths.text = "You died " + str(GameManager.final_deaths) + " times!"
	else: 
		$CenterContainer/VBoxContainer/LabelDeaths.text = "You died " + str(GameManager.final_deaths) + " times!, You got there though!"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
	pass # Replace with function body.


func _on_button_retry_pressed():
	get_tree().change_scene_to_file(GameManager.previous_scene)
	pass # Replace with function body.
