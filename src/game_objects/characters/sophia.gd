extends CharacterBody3D

@export_range(0.0,1.0) var mouse_sensitive : float = 0.25

@export var speed : float = 8
@export var acceleration : float = 50#20

@export var _last_direction : Vector3 = Vector3.BACK

@export var jump_impulse : float = 12
@export var gravity : float = -30

@onready var PivotCamera : Node3D = %PivotCamera
@onready var Camera : Node3D = %Camera3D
@onready var Model : SophiaSkin = %SophiaSkin
@onready var SpringAr = %SpringArm3D

@onready var rotation_speed : float = 12

var _camera_input_direction := Vector2.ZERO

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("focus"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	
	var is_camera_motion : bool = (
		event is InputEventMouseMotion
		and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion == true:
		_camera_input_direction = event.screen_relative * mouse_sensitive

func _physics_process(delta: float) -> void:
	PivotCamera.rotation.x += _camera_input_direction.y * delta
	
	## definir limite de rotacion
	#-40
	PivotCamera.rotation.x = clamp(PivotCamera.rotation.x,deg_to_rad(-40),deg_to_rad(70))
	
	PivotCamera.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	if Camera.position.z <= 1:
		visible = false
	else:
		visible = true
	
	
	## movimiento
	var raw_input : Vector2 = Input.get_vector(
		"move_left","move_right","move_forward","move_back"
	)
	
	var forward := Camera.global_basis.z
	var right := Camera.global_basis.x
	
	var move_direction : Vector3 = forward*raw_input.y + right*raw_input.x
	
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var _vel_y := velocity.y
	velocity.y = 0
	
	velocity = velocity.move_toward(move_direction*speed,acceleration*delta)
	
	## gravedad
	velocity.y = _vel_y + gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_impulse
	
	move_and_slide()

	if move_direction.length() > 0.2:
		_last_direction = move_direction
	
	var target_angle := Vector3.BACK.signed_angle_to(
		_last_direction, Vector3.UP
	)
	
	Model.global_rotation.y = lerp_angle(Model.global_rotation.y,target_angle,rotation_speed*delta)
	
	var ground_speed := velocity.length()
	
	if is_on_floor():
		if ground_speed == 0:
			Model.idle()
		else:
			Model.move()
	
	else:
		if ground_speed <= 0:
			Model.fall()
		else:
			Model.jump()
	
	if Input.is_action_just_pressed("camera_in"):
		SpringAr.spring_length += 1
	if Input.is_action_just_pressed("camera_out"):
			SpringAr.spring_length -= 1
	
	
	
	
	
	
	
	
