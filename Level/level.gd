extends Node3D

@export var level_name:String

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#get_node("Emitter")._level_complete.connect(level_complete, ["Emitter node ready"])
	
	print("Currently playing: " + level_name)
	GameManager.previous_scene = scene_file_path
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		#body.global_position = $Marker3DPlayerSpawn.global_position
		if body.has_method("death"):
			body.death()
	pass # Replace with function body.
