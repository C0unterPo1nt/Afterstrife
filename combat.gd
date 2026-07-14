extends Node

# Accept a call to enter combat between two characters
func initiate(initiator: Character, defender: Character):
	_combat(initiator, defender)

func _combat(initiator: Character, defender: Character):
	_attack(initiator, defender)
	_attack(initiator, defender)

func _attack(attacker: Character, defender: Character):
	defender.damage(attacker.attack())
