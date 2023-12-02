extends CharacterBody2D

@export var speed = 10
@export var limit = 0.5
@export var endPoint: Marker2D

@onready var animations = $AnimationPlayer

var startPosition
var endPosition

func _ready():
	endPoint = get_node("Marker2D")
	startPosition = position
	if !endPoint:
		endPosition = startPosition + Vector2(0, 32)
		return
		
	endPosition = endPoint.global_position
	

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized()*speed
	
func updateAnimation():
	if velocity.length() == 0: #is it moving?ds
		if animations.is_playing():
			animations.stop() #stop animation
	else:
		var direction="Down"
		if velocity.x <0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y <0: direction = "Up"
	
		animations.play("walk" + direction)
	
	
func _physics_process(_delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()


