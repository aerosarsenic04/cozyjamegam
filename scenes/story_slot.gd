extends PanelContainer
class_name StorySlot

signal filled(slot: StorySlot)
signal cleared(slot: StorySlot)

@export var slot_index: int = 0

var placed_background: CardData = null
var placed_character_left: CardData = null
var placed_character_right: CardData = null

@onready var background_rect: TextureRect = $BackgroundRect
@onready var character_left_rect: TextureRect = $CharacterLeft
@onready var character_right_rect: TextureRect = $CharacterRight

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is CardData

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data.category == CardData.Category.BACKGROUND:
		placed_background = data
		background_rect.texture = data.get_display_texture()
		_refresh_character(true)
		_refresh_character(false)
	else:
		var dropped_on_left := at_position.x < (size.x / 2.0)
		if dropped_on_left:
			placed_character_left = data
		else:
			placed_character_right = data
		_refresh_character(true)
		_refresh_character(false)

	filled.emit(self)

func _refresh_character(left: bool) -> void:
	var card: CardData = placed_character_left if left else placed_character_right
	var companion: CardData = placed_character_right if left else placed_character_left
	var rect: TextureRect = character_left_rect if left else character_right_rect

	if card == null:
		rect.texture = null
		return

	var bg_id := placed_background.id if placed_background else ""
	var companion_id := companion.id if companion else ""
	rect.texture = card.get_texture_for_context(bg_id, companion_id)

func clear_background() -> void:
	placed_background = null
	background_rect.texture = null
	_refresh_character(true)
	_refresh_character(false)
	cleared.emit(self)

func clear_character(left: bool) -> void:
	if left:
		placed_character_left = null
	else:
		placed_character_right = null
	_refresh_character(true)
	_refresh_character(false)
	cleared.emit(self)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var local_pos := get_local_mouse_position()
		var on_left := local_pos.x < (size.x / 2.0)
		if on_left and placed_character_left:
			clear_character(true)
		elif not on_left and placed_character_right:
			clear_character(false)
		elif placed_background:
			clear_background()
