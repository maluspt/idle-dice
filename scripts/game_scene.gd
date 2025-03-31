extends Node2D

@onready var dice = $TableScene/CollisionShape2D/SubViewportContainer/SubViewport/dice
@onready var dice_viewport = $TableScene/CollisionShape2D/SubViewportContainer/SubViewport
@onready var score_ui = $ScoreUI
@onready var upgrades_ui = $upgrades_ui

var normal_current_dices = []
var gold_current_dices = []
var normal_autoroll = false

var dice_scene = preload("res://scenes/dice.tscn")

func _ready():
	normal_current_dices.append(dice)
	var buttons = upgrades_ui.upgrades_container.get_children()
	for button in buttons:
		button.upgrade_button_pressed.connect(_on_upgrade_button_pressed)
		
func _process(delta):
	normal_dice_autoroll()

func _on_button_pressed():
	for dice in normal_current_dices:
		if not dice.rolling:
			dice.roll_dice()
	
	for dice in gold_current_dices:
		if not dice.rolling:
			dice.roll_dice()
			
func normal_dice_autoroll():
	if normal_autoroll:
		for dice in normal_current_dices:
			if not dice.rolling:
				dice.roll_dice()

func _on_upgrade_button_pressed(type, cost):
	if type == 0 and Global.chips >= cost:
		Global.chips -= cost
		var new_dice = dice_scene.instantiate()
		new_dice.position = Vector3(10, 10, 0)
		new_dice.type = Global.DiceType.NORMAL
		normal_current_dices.append(new_dice)
		dice_viewport.add_child(new_dice)
	elif type == 1 and Global.chips >= cost:
		Global.chips -= cost
		normal_autoroll = true
	elif type == 2 and Global.chips >= cost:
		Global.chips -= cost
		var new_dice = dice_scene.instantiate()
		new_dice.position = Vector3(10, 10, 0)
		new_dice.type = Global.DiceType.GOLD
		gold_current_dices.append(new_dice)
		dice_viewport.add_child(new_dice)
		
		
