extends Node
 
 
signal outcome_triggered(rule: StoryRule)
signal no_match_found(placed_ids: Array)
 
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
	var placed_ids: Array[String] = []
	for slot in slots:
		if slot.placed_card == null:
			return null  
		placed_ids.append(slot.placed_card.id)
 
	for rule in rules:
		if not _flags_satisfied(rule):
			continue
		if _matches(rule, placed_ids):
			_trigger(rule)
			return rule
 
	no_match_found.emit(placed_ids)
	return null
 
func _flags_satisfied(rule: StoryRule) -> bool:
	for f in rule.required_flags:
		if not has_flag(f):
			return false
	return true
 
func _matches(rule: StoryRule, placed_ids: Array[String]) -> bool:
	if rule.slot_requirements.size() != placed_ids.size():
		return false
 
	if rule.order_matters:
		for i in placed_ids.size():
			var required := rule.slot_requirements[i]
			if required != "" and required != placed_ids[i]:
				return false
		return true
	else:
		var remaining := placed_ids.duplicate()
		for required in rule.slot_requirements:
			if required == "":
				continue
			if not remaining.has(required):
				return false
			remaining.erase(required)
		return true
 
func _trigger(rule: StoryRule) -> void:
	for f in rule.sets_flags:
		set_flag(f)
	for id in rule.unlocks_cards:
		unlock_card(id)
	outcome_triggered.emit(rule)
