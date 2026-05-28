##extends the RefCounted which are just data objects in memory
extends RefCounted

##the name of the class DiceRoller
class_name DiceRoller

##making integer variables for the number of dice and number of sides
var n_dice: int
var n_sides: int


func _init(n_d: int, n_s: int):
	n_dice = n_d
	n_sides = n_s

##this takes an integer argument which is then used to set the number of dice
func set_n_dice(n:int) -> void:
	n_dice = n;

##this takes an integer argument which is then used to set the number of sides 
func set_n_sides(n:int) -> void:
	n_sides = n
	
	
##this is a getter used to get the number of dice
func get_n_dice() -> int:
	return n_dice;
	
##this is a getter used to get the number of sides
func get_n_sides() -> int:
	return n_sides;
	
##this is used to contain the number of rolls gotten from the dice roll
func get_roll() -> Array:
	var rolls =[]
	for i in range(n_dice):
		rolls.append(randi()%n_sides + 1)
	
	return rolls
	


	
