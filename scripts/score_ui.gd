extends Control

@onready var chips_label = $VBoxContainer/ChipsLabel

func _process(delta):
	setup_label()

func setup_label():
	chips_label.text = str(Global.chips) + " chips"
