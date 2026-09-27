extends Control
class_name StoryCard

@export var card_data: CardData:
	set(value):
		card_data = value
		_update_visual()

@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	_update_visual()

func _update_visual() -> void:
	if texture_rect and card_data:
		texture_rect.texture = card_data.texture

func _get_drag_data(_at_position: Vector2) -> Variant:
	if card_data == null:
		return null

	var preview := TextureRect.new()
	preview.texture = card_data.texture
	preview.custom_minimum_size = size
	preview.modulate.a = 0.85
	set_drag_preview(preview)
	
	return card_data
