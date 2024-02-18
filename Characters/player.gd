extends CharacterBody2D

signal healthChanged

@export var speed: int = 80
@onready var animations = $AnimationPlayer
@onready var effects = $Effect
@onready var hurtBox = $Hitbox
@onready var hurtTimer = $hurtTimer

@export var maxHealth = 5
@onready var currentHealth: int = maxHealth

@export var knockbackPower: int = 2000

var isHurt: bool = false

func _ready():
	effects.play("RESET")

func handleInput():
	var moveDirection = Input.get_vector("ui_left","ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	
func updateAnimation():
	var direction = "Down"
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
	animations.play("Walk" + direction)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		
func _physics_process(_delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "HitBox":
				hurtByEnemy(area)

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth == 0:
		currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	isHurt = true
	
	knockback(area.get_parent().velocity)
	effects.play("HurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func _on_hitbox_area_entered(_area):
	pass

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	
func _on_hitbox_area_exited(_area):
	pass
