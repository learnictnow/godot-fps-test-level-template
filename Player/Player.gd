extends CharacterBody3D

@export var default_speed = 5.0
@export var speed = default_speed
@export var running_speed_multiplier = 2.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002
var running = false

var player_deaths = 0
@export var start_Marker3D: Marker3D
var time_elapsed = 0.0
@export var game_end_time = 5
@export var player_ammo = 3
@export var max_ammo = 3

@export var ray_length = 10

@export var time_paused: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	global_position = start_Marker3D.global_position
	$PlayerHUD/LabelDeaths.text = " Deaths: " + str(player_deaths)
	$PlayerHUD/LabelAmmo.text = " Ammo: " + str(player_ammo)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _process(delta):
	if time_paused:
		return
	# Update the Timer HUD
	time_elapsed += delta
	#$PlayerHUD/LabelTimer.text = "%2.2f" % time_elapsed
	$PlayerHUD/LabelTimer.text = "%2.2f" % (game_end_time - time_elapsed)
	if time_elapsed >= game_end_time:
		GameManager.final_time = time_elapsed
		GameManager.final_deaths = player_deaths
		get_tree().change_scene_to_file("res://Menus/GameOver.tscn")

func _input(event):
	# If escape pressed load level select scene
	if event.is_action_pressed("pause_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
		
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
	if event.is_action_pressed("sprint"):
		running = !running
		if running:
			speed = default_speed * running_speed_multiplier
		else:
			speed = default_speed
		print("Running: " + str(running))

	if event.is_action_pressed("fire_primary"):
		primary_fire()
		
	if event.is_action_pressed("fire_secondary"):
		secondary_fire()
		print("Secondary Fire")

func death():
	player_deaths += 1
	player_ammo = max_ammo
	$PlayerHUD/LabelDeaths.text = " Deaths: " + str(player_deaths)
	$PlayerHUD/LabelAmmo.text = " Ammo: " + str(player_ammo)
	global_position = start_Marker3D.global_position
	
func primary_fire():
	if player_ammo > 0:
		player_ammo -= 1
		$PlayerHUD/LabelAmmo.text = " Ammo: " + str(player_ammo)
		print("Primary Fire")
		$Camera3D/Marker3D/LeftWeapon/AnimationPlayer.play("fire_primary")
		$Camera3D/Marker3D/LeftWeapon/AudioStreamPlayer.play()
		
		# Raycast the shot
		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create($Camera3D.global_position, $Camera3D.global_position - $Camera3D.global_transform.basis.z * ray_length)
		query.collide_with_areas = true
		
		var collision = space.intersect_ray(query)
		if collision:

			if collision.collider.is_in_group("Target"):
				print(collision.collider.name)
				collision.collider.queue_free()
				#if $PlayerHud.has_method("update_score"):
					#$PlayerHud.update_score("SHOTS", 1)
		else:
			print("Missed")
		
	else:
		$Camera3D/Marker3D/LeftWeapon/AudioStreamPlayer2.play()
		print("No ammo")

func secondary_fire():
	$Camera3D/Marker3DRight/AudioStreamPlayer.play()
	$Camera3D/Marker3DRight/AnimationPlayer.play("melee_attack")

func pickup_ammo():
	player_ammo += 1
	if player_ammo > max_ammo:
		player_ammo = max_ammo
	$PlayerHUD/LabelAmmo.text = " Ammo: " + str(player_ammo)
	
func pickup_time():
	time_elapsed -= 5
	$PlayerHUD/LabelTimer.text = "%2.2f" % (GameManager.game_length - time_elapsed)

func set_time_pause(pause):
	time_paused = pause
