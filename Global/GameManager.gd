extends Node

var previous_scene: String
var final_time: float = 0.0
var final_deaths: int = 0
@export var game_length = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_to_previous_scene():
	get_tree().change_scene_to_file(previous_scene)
	
func change_scene(scene):
	get_tree().change_scene_to_file(scene)

