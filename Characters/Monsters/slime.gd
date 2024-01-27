extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@onready var animations = $AnimatedSprite2D

var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = startPosition + Vector2(0, 3*16)
	
func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd
	
func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed
	
func updateAnimations():
	var animationString = "WalkUp"
	if velocity.y > 0:
		animationString = "WalkDown"
	
	animations.play(animationString)
	
func _physics_process(_delta):
	updateVelocity()
	move_and_slide()
	updateAnimations()
