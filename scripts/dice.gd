extends Node3D

@onready var rigid_body = $RigidBody3D
@onready var mesh = $RigidBody3D/MeshInstance3D

var start_pos
var roll_strength: int = 40
var rolling = false
var material: StandardMaterial3D
var type: Global.DiceType

signal roll_finished(value)

func _ready():
	start_pos = rigid_body.global_position
	setup_texture()

func load_texture():
	var normal_texture = Image.load_from_file("res://assets/images/dice-text-test.png")
	var gold_texture =  Image.load_from_file("res://assets/images/gold-dice-text-test.png")

	if type == Global.DiceType.NORMAL:
		var tex = ImageTexture.create_from_image(normal_texture)
		return tex
	elif type == Global.DiceType.GOLD:
		var tex = ImageTexture.create_from_image(gold_texture)
		return tex
	else:
		var tex = ImageTexture.create_from_image(normal_texture)
		return tex
		
func setup_texture():
	material = StandardMaterial3D.new()
	material.albedo_texture = load_texture()
	mesh.material_override = material

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
	rolling = true

func get_roll_value() -> int:

	var world_up = Vector3.UP
	var threshold = 0.9;
	var max_dot = -1;
	
	var sides = {
		rigid_body.transform.basis.y: 5, # Top
		-rigid_body.transform.basis.y: 6, # Bottom
		rigid_body.transform.basis.x: 2, # Right
		-rigid_body.transform.basis.x: 4, # Left
		rigid_body.transform.basis.z: 1, # Screen Side (You)
		-rigid_body.transform.basis.z: 3, # Backwards
	}

	var value = -1;
	for side in sides:
		var dot_product = world_up.dot(side.normalized())
		# If dot_product of current side is greator than threshold and greator than max_dot
		# we will assume that's our favorable value.
		if dot_product > threshold and dot_product > max_dot:
			max_dot = dot_product
			value = sides[side]
			

	return value

func _on_rigid_body_3d_sleeping_state_changed():
	var landed_on_side = false
	if rigid_body.sleeping:
		var value = get_roll_value()
		if value > 0:
			landed_on_side = true
			roll_finished.emit(value)
			rolling = false
		if !landed_on_side:
			roll_dice()

func _on_roll_finished(value):
	if type == Global.DiceType.NORMAL:
		Global.chips += value
	elif type == Global.DiceType.GOLD:
		Global.chips += value * 2
