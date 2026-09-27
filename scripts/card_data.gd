extends Resource
class_name CardData
enum Category { CHARACTER, BACKGROUND }

@export var id: String = ""
@export var display_name: String = ""
@export var category: Category = Category.CHARACTER
@export var texture: Texture2D
@export var placed_texture: Texture2D
@export var reactions: Array[CardReaction] = []

func get_display_texture() -> Texture2D:
	return placed_texture if placed_texture else texture

func get_texture_for_context(background_id: String, companion_id: String) -> Texture2D:
	for reaction in reactions:
		if reaction.background_id != "" and reaction.background_id != background_id:
			continue
		if reaction.companion_id != "" and reaction.companion_id != companion_id:
			continue
		if _reaction_flags_satisfied(reaction):
			return reaction.texture
	return get_display_texture()

func _reaction_flags_satisfied(reaction: CardReaction) -> bool:
	for f in reaction.required_flags:
		if not StoryManager.has_flag(f):
			return false
	return true
