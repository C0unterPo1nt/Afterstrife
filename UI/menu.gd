extends TabContainer

enum Tabs { EndTurn, ActionMenu}

@onready var action_menu = $ActionMenu

func make_action_selection(character: Character) -> Action:
	var actions: Array[Action] = character.stats.actions
	current_tab = Tabs.ActionMenu
	for action in actions:
		if action.predicate(character):
			action_menu.create(action)
	var selected_action: Action = await action_menu.selected
	action_menu.destroy()
	current_tab = Tabs.EndTurn
	return selected_action
