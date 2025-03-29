extends Node2D

@onready var dice = $TableScene/CollisionShape2D/SubViewportContainer/SubViewport/dice

func _process(delta):
	pass

func _on_button_pressed():
	dice.roll_dice()
