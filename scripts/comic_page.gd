extends Control

@export var rules: Array[StoryRule] = []
 
@onready var slots: Array = [$Panels/Slot1, $Panels/Slot2, $Panels/Slot3]
@onready var outcome_label: RichTextLabel = $OutcomeLabel
 
func _ready() -> void:
	outcome_label.hide()
	for slot in slots:
		slot.filled.connect(_on_slot_changed)
		slot.cleared.connect(_on_slot_changed)
 
func _on_slot_changed(_slot = null, _card = null) -> void:
	outcome_label.hide()
	var rule: StoryRule = StoryManager.evaluate(slots, rules)
	if rule:
		_show_outcome(rule)
 
func _show_outcome(rule: StoryRule) -> void:
	outcome_label.text = rule.outcome_text
	outcome_label.show()
 
	if rule.next_scene != "":
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file(rule.next_scene)
