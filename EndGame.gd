extends Node

var numberRight = 0;

func AddOne() -> bool:
	numberRight += 1
	if (numberRight == 1):
		return true
	return false
