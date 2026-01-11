class_name good_util

static func get_valid_recipes(recipes: Recipes, parts: Dictionary) -> Dictionary:
	var valid_recipes: Dictionary = {}
	for recipe: String in recipes.recipes:
		valid_recipes[recipe] = get_valid_recipe(recipes, recipe, parts)
	for recipe: String in valid_recipes:
		if valid_recipes[recipe].is_empty():
			valid_recipes.erase(recipe)
	return valid_recipes

static func get_valid_recipe(recipes: Recipes, recipe: String, parts: Dictionary) -> Array:
	var recipe_ranks: Array = []
	var part_quantity: Dictionary = {}
	for part: String in parts:
		if part in recipes.recipes[recipe]:
			for quality: int in parts[part]:
				if parts[part][quality] >= recipes.recipes[recipe][part]:
					part_quantity[quality] = part_quantity.get(quality, 0) + 1
	for part_rank: int in part_quantity:
		if part_quantity[part_rank] == recipes.recipes[recipe].size():
			recipe_ranks.append(part_rank)
	return recipe_ranks
