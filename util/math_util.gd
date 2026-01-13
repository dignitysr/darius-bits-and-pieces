class_name math_util

const FIXED_DELTA: float = 1.0/30.0

static func ease(param: float) -> float:
	return 1.0 / param

static func friction(param: float) -> float:
	return 1.0 - (1.0 / param)

static func apply_gravity(vel: float, threshold_vel: float = 2, rise_grav: float = 0.3, fall_grav: float = 0.4, fall_fric: float = 100) -> float:
	if vel < threshold_vel:
		vel += rise_grav
	else:
		vel += fall_grav
		vel *= friction(fall_fric)
	return vel

static func subtract_angles(param1: float, param2: float) -> float:
	var result: float = param2 - param1
	while result < -PI:
		result += PI*2
	while result > PI:
		result -= PI*2
	return result

static func convert_num(num: int) -> String:
	var suffixes: Array = ["", "K", "M", "B", "T", "Q"]
	var log_value := int(log(num)/log(10))
	@warning_ignore("integer_division")
	var power := int(log_value/3)
	@warning_ignore("narrowing_conversion")
	var scale: int = pow(10, abs((log_value%3) - 2))
	var rounded_num: float = (int((num/pow(10, (power*3)))*scale))/float(scale)
	@warning_ignore("incompatible_ternary")
	return str(rounded_num if !log_value%3 == 2 else int((num/pow(10, (power*3))))) + suffixes[power] if num >= 1000 else str(num)
