@abstract class_name Action

var name: String
var sequence: Array[SubAction]

class Move extends Action:
	func _init():
		name = "Move"
		sequence = [SubAction.Move.new()]

class Attack extends Action:
	func _init():
		name = "Attack"
		sequence = [SubAction.Attack.new()]
