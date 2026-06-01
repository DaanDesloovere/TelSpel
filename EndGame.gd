extends Node

var numberRight = 0;
var nuts : Array[Area2D]

func AddOne() -> bool:
	numberRight += 1
	if (numberRight == 10):
		return true
	return false

func AddNut(nut: Area2D):
	nuts.append(nut)
