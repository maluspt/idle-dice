extends Control

@onready var upgrades_container = $VBoxContainer
var upgrades_button = preload("res://scenes/upgrade_button.tscn")

func _ready():
	for upgrade in Upgrades.UpgradeTypes.values():
		var button = upgrades_button.instantiate()
		button.position = Vector2(0, 0)
		button.get_type(upgrade)
		upgrades_container.add_child(button)
		
