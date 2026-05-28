##this is the beginner of the test script 
extends GutTest

##this is the variable use to preload the file diceroller
var dice_roller

##this is a run before each statement to run the file before each compilation
func before_each():
	dice_roller = preload("res://dice_roller.gd").new(2,6)
	
##this is a test for the constructor
func test_init():
	assert_not_null(dice_roller)


##this is a test for the setter for the dice and the getters for the dice
func test_set_n_dice():
	dice_roller.set_n_dice(4)
	assert_eq(dice_roller.get_n_dice(), 4)
	
	
##this is a test for the setter for the sides and the getters for the sides
func test_set_n_sides():
	dice_roller.set_n_sides(6)
	assert_eq(dice_roller.get_n_sides(),6)

##this is used to test if the roll gave a result of type array
func test_get_roll():
	var result = dice_roller.get_roll()
	assert_eq(typeof(result), TYPE_ARRAY)
	
