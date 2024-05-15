extends Node2D

@onready var player := $player as CharacterBody2D
@onready var camera := $camera as Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player.follow_camera(camera)
	player.player_has_died.connect(game_over)
	Globals.player_life = 3
	
	
	
func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
