extends Node

# Accept a call to enter combat between two characters
func initiate(initiator: Character, defender: Character):
	await _attack(initiator, defender)

func _combat(initiator: Character, defender: Character):
	_attack(initiator, defender)
	_attack(initiator, defender)

func _attack(attacker: Character, defender: Character):
	await attacker.attack(defender)
