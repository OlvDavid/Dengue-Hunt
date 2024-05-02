extends Control

@onready var life_counter = $container/life_container/life_counter as Label

func _ready():
	life_counter.text = str("%02d" % Globals.player_life)

func _process(delta):
	life_counter.text = str("%02d" % Globals.player_life)
