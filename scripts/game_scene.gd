extends Node2D

@onready var dice = $TableScene/CollisionShape2D/SubViewportContainer/SubViewport/dice
@onready var dice2 = $TableScene/CollisionShape2D/SubViewportContainer/SubViewport/dice2
@onready var score_ui = $ScoreUI

func _process(delta):
	pass

func _on_button_pressed():
	dice.roll_dice()
	dice2.roll_dice()

func _on_dice_roll_finished(value):
	Global.chips += value
	
func _on_dice_2_roll_finished(value):
	Global.chips += value
