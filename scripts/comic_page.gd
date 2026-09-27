extends Control

@export var rules: Array[StoryRule] = []

@onready var slots: Array = $Panels.get_children()
@onready var outcome_label: RichTextLabel = $OutcomeLabel
@onready var outcome_sprite: TextureRect = $OutcomeSprite
@onready var outcome_button: Button = $OutcomeButton
@onready var creds_button: Button = $CredsButton
func _ready() -> void:
	outcome_label.hide()
	outcome_sprite.hide()
	outcome_button.hide()
	creds_button.hide()
	
	print("RULE CONTROLLER NODE: ", get_path())
	print("RULE COUNT: ", rules.size())
	for slot in slots:
		slot.filled.connect(_on_slot_changed)
		slot.cleared.connect(_on_slot_changed)
		
func _on_slot_changed(_slot = null, _card = null) -> void:
	outcome_label.hide()
	var rule: StoryRule = StoryManager.evaluate(slots, rules)
	print("NUMBER OF RULES LOADED: ", rules.size())
	print("SLOTS: ", slots.size())

	for slot in slots:
		print(
			slot.name,
			" BG=", slot.placed_background.id if slot.placed_background else "EMPTY",
			" LEFT=", slot.placed_character_left.id if slot.placed_character_left else "EMPTY",
			" RIGHT=", slot.placed_character_right.id if slot.placed_character_right else "EMPTY"
		)

	outcome_label.hide()


	if rule:
		print("RULE MATCHED: ", rule.outcome_text)
		_show_outcome(rule)
	else:
		print("NO RULE MATCH")
	
	if rule:
		_show_outcome(rule)
		
		
		
		
func _show_outcome(rule: StoryRule) -> void:
	outcome_label.hide()

	
	if rule.outcome_sprite:
		outcome_sprite.texture = rule.outcome_sprite
		outcome_sprite.show()
		outcome_button.show()
		creds_button.show()
	else:
		outcome_sprite.hide()

	if rule.next_scene != "":
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file(rule.next_scene)
	

	if rule.next_scene != "":
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file(rule.next_scene)
