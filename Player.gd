extends CharacterBody3D



const SPEED = 1.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
	if event is InputEventMouseMotion:
	#	print(event.velocity)
		rotation += Vector3(-event.velocity.y,-event.velocity.x,0) * 0.0001
func _ready():
	activate_mouse_controls()
func activate_mouse_controls():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector3.ZERO
	if(Input.is_action_pressed("go_forward")):
		direction += Vector3.FORWARD
		direction = direction.rotated(Vector3.UP, rotation.y)
	if Input.is_action_pressed("go_back"):
		direction += Vector3.BACK
		direction = direction.rotated(Vector3.UP, rotation.y)
	if Input.is_action_pressed("strafe_left"):
		direction += Vector3.LEFT
		direction = direction.rotated(Vector3.UP, rotation.y)
	if Input.is_action_pressed("strafe_right"):
		direction += Vector3.RIGHT
		direction = direction.rotated(Vector3.UP, rotation.y)
	direction = direction.normalized()
	if direction:
		velocity += (direction * SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
