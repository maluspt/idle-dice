extends Control

@onready var title = $TextureButton/Title
@onready var description = $TextureButton/Description
@onready var cost = $TextureButton/Cost

@onready var button = $TextureButton

var upgrade_cost = 0

var upgrade_type: Upgrades.UpgradeTypes

signal upgrade_button_pressed(type: Upgrades.UpgradeTypes, cost: int)

func _ready():
	button.pressed.connect(_on_texture_button_pressed)
	setup_properties(upgrade_type)
	
func get_type(type: Upgrades.UpgradeTypes):
	upgrade_type = type

func setup_properties(type: Upgrades.UpgradeTypes):
	if type == 0:
		title.text = "normal dice"
		description.text = "add one more normal die to the table"
		upgrade_cost = 10
		cost.text = str(upgrade_cost)  + " chips"
	elif type == 1:
		title.text = "autoroll 01"
		description.text = "autorolls normal dice for you"
		upgrade_cost = 100
		cost.text = str(upgrade_cost)  + " chips"
	elif type == 2:
		title.text = "gold dice"
		description.text = "adds a gold die to the table. gold dice scores 2x"
		upgrade_cost = 300
		cost.text = str(upgrade_cost)  + " chips"

func _on_texture_button_pressed():
	upgrade_button_pressed.emit(upgrade_type, upgrade_cost)
