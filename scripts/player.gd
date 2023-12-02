extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 35
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtTimer = $hurtTimer
@onready var hurtBox = $hurtbox

@export var maxHealth = 3
@onready var currentHealth: int = maxHealth

@export var knockbackPower: int = 200

@export var inventory: Inventory

var isHurt: bool = false
var enemyCollisions = []

func _ready():
	effects.play("RESET")

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")#order is important
	velocity = moveDirection*speed

func updateAnimation():
	if velocity.length() == 0: #is it moving?
		if animations.is_playing():
			animations.stop() #stop animation
	else:
		var direction="Down"
		if velocity.x <0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y <0: direction = "Up"
	
		animations.play("walk" + direction)

func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth < 0:
		currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	isHurt = true
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false


func _on_hurtbox_area_entered(area): 
	if area.has_method("collect"):
		area.collect(inventory)
	

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized()*knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	
		


func _on_hurtbox_area_exited(area): pass
	#enemyCollisions.erase(area)
