extends KinematicBody2D

var speed
var direct
var animback = {"bw":"BackWalk","bi":"BackIdle","bg":"BackGreet"}
var animfront = {"fw":"FrontWalk","fi":"FrontIdle","fg":"FrontGreet"}
var animside = {"sw":"SideWalk","si":"SideIdle","sg":"SideGreet"}
var scrsize
var spsize
onready var anisp = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	direct=Vector2.ZERO
	speed=150
	anisp.animation = animfront["fi"]
	scrsize = Vector2(1920,1080)
	spsize = anisp.frames.get_frame("BackIdle", 0).get_size()
	print("SP siz e is  ",spsize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direct = Vector2.ZERO
	checkLeft()
	checkRight()
	checkBack()
	checkForward()
	position.x = clamp(position.x,0+spsize.x/2,scrsize.x-(spsize.x/2) )
	position.y = clamp(position.y,0+spsize.y/2, scrsize.y-(spsize.y/2) )


func checkLeft():
	if(Input.is_action_pressed("ui_left")):
		direct=Vector2.LEFT
		if(anisp.flip_h==true):
			anisp.flip_h=false
		if(anisp.animation != animside["sw"]):
			anisp.animation = animside["sw"]
	
	if(Input.is_action_just_released("ui_left")):
		anisp.animation = animside["si"]


func checkRight():
	if(Input.is_action_pressed("ui_right")):
		direct=Vector2.RIGHT
		if(anisp.flip_h==false):
			anisp.flip_h=true
		if(anisp.animation != animside["sw"]):
			anisp.animation = animside["sw"]
	
	if(Input.is_action_just_released("ui_right")):
		anisp.animation = animside["si"]


func checkForward():
	if(Input.is_action_pressed("ui_down")):
		direct=Vector2.DOWN
		if(anisp.animation != animfront["fw"]):
			anisp.animation = animfront["fw"]
	
	if(Input.is_action_just_released("ui_down")):
		anisp.animation = animfront["fi"]


func checkBack():
	if(Input.is_action_pressed("ui_up")):
		direct=Vector2.UP
		if(anisp.animation != animback["bw"]):
			anisp.animation = animback["bw"]
	
	if(Input.is_action_just_released("ui_up")):
		anisp.animation = animback["bi"]


func _physics_process(delta):
	var c = move_and_collide(direct*speed*delta)
