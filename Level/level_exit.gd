extends Node3D

var level_name

signal level_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		print("Level complete!")
		get_tree().change_scene_to_file("res://Menus/LevelWon.tscn")

	pass # Replace with function body.
