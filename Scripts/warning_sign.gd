extends Node2D

@onready var area_sign = $area_sign
@onready var texture_2 = $texture2
@onready var talk = $talk


const lines : Array[String] = [
	"Olá, amigo",
	"Você é a nossa unica salvação",
	"Você precisara atravessar a cidade",
	"Em busca das três vacinas para conter o surto",
	"Espero que esteja Preparado...",
	"...BOA SORTE!!"
]

func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0:
		texture_2.show()
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			talk.play()
			texture_2.hide()
			DialogManager.start_message(global_position, lines)
	else:
		texture_2.hide()
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
