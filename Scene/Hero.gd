extends KinematicBody2D

export var respawn_position := Vector2(400, 600)

var gravity = 1200
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 360
var horizontalAcceleration = 1000
var jumpSpeed = 800
var jumpTerminationMultiplier = 4


func _ready():
	print("Player Scene Ready")
	add_to_group("Player")


func _process(delta):
	var moveVector = get_movement_vector()
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if (moveVector.y < 0 && (is_on_floor())):
		velocity.y = moveVector.y * jumpSpeed

	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	update_animation()
	
	if position.y > 1500:
		position = respawn_position
		velocity.y = 0



func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector


func update_animation():
	var moveVec = get_movement_vector()
	
	if (!is_on_floor()):
		$AnimatedSprite.play("Jump")
	elif (moveVec.x != 0):
		$AnimatedSprite.play("Walk")
	else:
		$AnimatedSprite.play("Idle")
	
	if (moveVec.x != 0):
		$AnimatedSprite.flip_h = false if moveVec.x > 0 else true
