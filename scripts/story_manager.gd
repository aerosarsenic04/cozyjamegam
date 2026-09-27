extends Node
 
signal outcome_triggered(rule: StoryRule)
signal no_match_found(left_ids: Array, right_ids: Array, bg_ids: Array)
 
var flags: Dictionary = {}
var unlocked_cards: Dictionary = {}
 
func set_flag(flag_name: String) -> void:
	flags[flag_name] = true
 
func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)
 
func unlock_card(id: String) -> void:
	unlocked_cards[id] = true
 
func is_unlocked(id: String) -> bool:
	return unlocked_cards.get(id, false)
 
func evaluate(slots: Array, rules: Array[StoryRule]) -> StoryRule:
	var left_ids: Array[String] = []
	var right_ids: Array[String] = []
	var bg_ids: Array[String] = []
 
	for slot in slots:
		if slot.placed_background == null:
			return null
		left_ids.append(slot.placed_character_left.id if slot.placed_character_left else "")
		right_ids.append(slot.placed_character_right.id if slot.placed_character_right else "")
		bg_ids.append(slot.placed_background.id)
 
	for rule in rules:
		if not _flags_satisfied(rule):
			continue
		if _matches(rule, left_ids, right_ids, bg_ids):
			_trigger(rule)
			return rule
 
	no_match_found.emit(left_ids, right_ids, bg_ids)
	return null
 
func _flags_satisfied(rule: StoryRule) -> bool:
	for f in rule.required_flags:
		if not has_flag(f):
			return false
	return true
 
func _matches(rule: StoryRule, left_ids: Array[String], right_ids: Array[String], bg_ids: Array[String]) -> bool:
	if rule.slot_backgrounds.size() != bg_ids.size():
		return false
 
	for i in bg_ids.size():
		var req_bg := rule.slot_backgrounds[i]
		if req_bg != "" and req_bg != bg_ids[i]:
			return false
 
		if i < rule.slot_left_characters.size():
			var req_left := rule.slot_left_characters[i]
			if req_left != "" and req_left != left_ids[i]:
				return false
 
		if i < rule.slot_right_characters.size():
			var req_right := rule.slot_right_characters[i]
			if req_right != "" and req_right != right_ids[i]:
				return false
 
	return true
 
func _trigger(rule: StoryRule) -> void:
	for f in rule.sets_flags:
		set_flag(f)
	for id in rule.unlocks_cards:
		unlock_card(id)
	outcome_triggered.emit(rule)
