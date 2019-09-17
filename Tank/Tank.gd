extends KinematicBody2D
class_name Tank

onready var BULLET = preload("res://Tank/Bullet.tscn")

const GRAVITY = 98*12

export var MAX_SPEED = Vector2(200,1000)
export var JUMPING_ENABLE = true
export var FLYING_ENABLE = false

var acceleration = Vector2(0,GRAVITY)
var velocity = Vector2()

var can_shoot = true

func _ready():
	$Barrel.position = $Hull.position + Vector2(0,-40) + Vector2(40,0).rotated($Barrel.rotation)

func _physics_process(delta):
	if(Input.is_action_just_pressed("change")):
		pass
	if(Input.is_action_just_pressed("ui_accept")):
		shoot(400)
	if(Input.is_action_pressed("ui_down")):
		rotate_barrel(1)
	elif(Input.is_action_pressed("ui_up")):
		rotate_barrel(-1)
	if(Input.is_action_pressed("ui_left")):
		accelerate_x(-1000.0)
	elif(Input.is_action_pressed("ui_right")):
		accelerate_x(1000.0)
	else:
		if(abs(velocity.x) < 10):
			velocity.x =0
		acceleration.x = -velocity.x*6
	
	velocity += acceleration * delta
	
	if(abs(velocity.x) < 5):
		$Tracks/RayCast2D.enabled = false
	
	if(FLYING_ENABLE):
		velocity.y -= acceleration.y * delta
	
	if(abs(velocity.x) > MAX_SPEED.x):
		if(velocity.x > 0):
			velocity.x = MAX_SPEED.x
		else:
			velocity.x = -MAX_SPEED.x
	if(abs(velocity.y) > MAX_SPEED.y):
		if(velocity.y > 0):
			velocity.y = MAX_SPEED.y
		else:
			velocity.y = -MAX_SPEED.y
			
	if($Tracks/RayCast2D.get_collider() != null and $Tracks/RayCast2D.enabled):
		velocity.y = -30
	move_and_slide(velocity,Vector2(0,-1),false,4,1)
	
func accelerate_x(accel:float):
	if(accel>0):
		$Tracks/RayCast2D.enabled = true
		$Tracks/RayCast2D.cast_to = Vector2(-5,0)
		$Tracks/RayCast2D.position = Vector2(32,-65)
	else:
		$Tracks/RayCast2D.enabled = true
		$Tracks/RayCast2D.cast_to = Vector2(5,0)
		$Tracks/RayCast2D.position = Vector2(32,65)
	acceleration.x=accel
	
func jump():
	if(JUMPING_ENABLE and is_on_floor() or FLYING_ENABLE):
		velocity.y = -98*6

func shoot(power:float):
	if can_shoot:
		can_shoot = false
		$Shoot_timer.start(0.01)
		var new_bullet = BULLET.instance()
		new_bullet.position = $Barrel/Position2D.global_position
		new_bullet.rotation = $Barrel.rotation
		get_tree().get_root().get_child(0).get_child(0).find_node("Bullets").add_child(new_bullet)
		new_bullet.apply_impulse(Vector2(0,0),Vector2(power,0).rotated($Barrel.rotation))

func rotate_barrel(angle:float):
	if($Barrel.rotation > -PI and angle < 0 or $Barrel.rotation < 0 and angle > 0):
		var barrel_rotation = deg2rad(angle)
		$Barrel.rotate(barrel_rotation)
		$Barrel.position = $Hull.position + Vector2(0,-40) + Vector2(40,0).rotated($Barrel.rotation)
	if($Barrel.rotation < -(PI/2)):
		$Hull/Sprite.flip_h = true
	else:
		$Hull/Sprite.flip_h = false

func _on_Shoot_timer_timeout():
	can_shoot = true
