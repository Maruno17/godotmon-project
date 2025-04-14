extends Node

var damage

func calc(level, attack, defense, power, targets, PB, weather, glaiverush, critical, random, STAB, type, burn, other):
	var rng = RandomNumberGenerator.new()
	random = rng.randf_range(0.85, 1.0)
	damage = ((((((level * 2)/5) + 2) * power) * (attack/defense)) / 50) + 2 * (STAB*type*critical*other*random)
