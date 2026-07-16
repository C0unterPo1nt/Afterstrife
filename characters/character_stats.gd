class_name CharacterStats
extends Resource

@export var attack_strength: int
@export var movement: int
@export var max_health: int = 100
var health: int = max_health
@export var maximum_actions: int = 2
var remaining_actions: int = maximum_actions
