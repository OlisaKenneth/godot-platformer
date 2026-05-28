extends GutTest

func test_add_xp():
	var upgrade = Upgrade.new()
	upgrade.add_xp()
	assert_eq(upgrade.xp, 1, "xp should be 1 after calling add_xp().")

func test_level_up():
	var upgrade = Upgrade.new()
	upgrade.level_up()
	assert_eq(upgrade.level, 2, "level should be 2 after calling level_up().")
	assert_eq(upgrade.xp, 0, "xp should be 0 after calling level_up().")
	
func test_calculate_required_xp():
	var upgrade = Upgrade.new()
	upgrade.calculate_required_xp()
	assert_eq(upgrade.xp_for_level_up, 5, "xp required for level up should be 5 after calling calculate_required_xp().")
	assert_eq(upgrade.exponent, 2, "exponent should be 2 after calling calculate_required_xp().")
	upgrade.calculate_required_xp()
	assert_eq(upgrade.xp_for_level_up, 8, "xp required for level up should be 8 after calling calculate_required_xp() again.")

func test_pick_random_upgrade():
	var upgrade = Upgrade.new()
	print(upgrade.pick_random_upgrades())
	assert_eq(upgrade.pick_random_upgrades().size(), 2, "pick_random_upgrade() should return an array of size 2.")
	
func test_apply_max_health_upgrade():
	var upgrade = Upgrade.new()
	upgrade.apply_max_health_upgrade()
	assert_eq(upgrade.player.max_health, 110.0, "player.max_health should be 110.0.")
	
func test_apply_bullet_speed_upgrade():
	var upgrade = Upgrade.new()
	upgrade.apply_bullet_speed_upgrade()
	assert_eq(upgrade.player.bullet_speed_multiplier, 1.1, "player.bullet_speed_multiplier should be 1.1.")
	
func test_apply_damage_upgrade():
	var upgrade = Upgrade.new()
	upgrade.apply_damage_upgrade()
	assert_eq(upgrade.player.damage_multiplier, 1.1, "player.damage_multiplier should be 1.1.")

func test_apply_speed_upgrade():
	var upgrade = Upgrade.new()
	upgrade.apply_speed_upgrade()
	assert_eq(upgrade.player.speed, 55.0, "player.speed should be 55.0.")
