extends RigidBody2D

var EXPLOSION = preload("res://Tank/Explosion.tscn")

onready var terrain = get_tree().get_root().get_node("Main/Game/Env/Terrain")

func _physics_process(delta):
	rotation = linear_velocity.angle()
	var colliding_bodies = get_colliding_bodies()
	if colliding_bodies.size() != 0:
		var new_boom = EXPLOSION.instance()
		new_boom.position = global_position
		get_tree().get_root().get_child(0).find_node("Particles").add_child(new_boom)
		terrain.fast_circle(global_position.x,global_position.y,30)
#		terrain.fast_crave(global_position.x,global_position.y,"dist_square",80)

		queue_free()
		
