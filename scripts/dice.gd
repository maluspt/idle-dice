extends Node3D

@onready var rigid_body = $RigidBody3D

var start_pos
var roll_strength = 30

signal roll_finished(value)

func _ready():
	start_pos = rigid_body.global_position

func roll_dice():
	# Reset
	rigid_body.sleeping = false
	rigid_body.freeze = false
	##rigid_body.transform.origin = start_pos
	rigid_body.linear_velocity = Vector3.ZERO
	rigid_body.angular_velocity = Vector3.ZERO
	 
	# Random rotation
	rigid_body.transform.basis = Basis(Vector3.RIGHT, randf_range(0, 2 * PI)) * rigid_body.transform.basis
	rigid_body.transform.basis = Basis(Vector3.UP, randf_range(0, 2 * PI)) * rigid_body.transform.basis
	rigid_body.transform.basis = Basis(Vector3.FORWARD, randf_range(0, 2 * PI)) * rigid_body.transform.basis
	
	# Random roll impulse
	
	var throw_vector = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	rigid_body.angular_velocity = throw_vector * roll_strength / 2
	rigid_body.apply_central_impulse(throw_vector * roll_strength)
