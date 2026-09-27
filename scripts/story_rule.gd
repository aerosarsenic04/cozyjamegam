extends Resource
class_name StoryRule
 
@export var slot_backgrounds: Array[String] = []
@export var slot_left_characters: Array[String] = []
@export var slot_right_characters: Array[String] = []
 
@export var required_flags: Array[String] = []
 
@export var sets_flags: Array[String] = []
@export_multiline var outcome_text: String = ""
@export var outcome_sprite: Texture2D
@export var unlocks_cards: Array[String] = []
@export var next_scene: String = ""
 
