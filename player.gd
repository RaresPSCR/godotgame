extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sensitivity = 0.002

var def_position=Vector3(0.662,-0.148,-1.091)

var ads=false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _stop_secondary_animations(): #stops unnecesary animations like inspect when needed to ads or shoot
	if $AnimationPlayer.current_animation=="inspect":
		$AnimationPlayer.stop()

func _anim_stop():
	$AnimationPlayer.stop()
	$Camera3D/pusca.position=def_position

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta):
	
	if Input.is_action_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("capture_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_pressed('inspect'):
		$AnimationPlayer.play("inspect")
		
	##################################################### anim stooper
	if Input.is_action_just_pressed("ads"):
		_stop_secondary_animations()
	if Input.is_action_just_pressed("shoot"):
		_stop_secondary_animations()
	##################################################### anim stopper
	
	if Input.is_action_pressed("ads"):
		if !ads:
			$AnimationPlayer.play("ads")
			ads=true
	else:
		if ads:
			$AnimationPlayer.play_backwards("ads")
			ads=false
	
	if Input.is_action_pressed("shoot"):
		
		#remove ads bug
		
		if $AnimationPlayer.current_animation=='shoot':
			if !Input.is_action_pressed("ads"):
				_anim_stop()
				$AnimationPlayer.play_backwards("ads")
				$Camera3D.fov=lerp($Camera3D.fov,75.0,6*delta)
		
		$AnimationPlayer.play("shoot")
		
		
		#resolve stutter bug
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("a", "d", "w", "s")
	if input_dir.x or input_dir.y:
		if !$AnimationPlayer.is_playing():
			if is_on_floor():
				$AnimationPlayer.play("head_bob")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
