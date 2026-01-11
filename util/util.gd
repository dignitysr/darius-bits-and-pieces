class_name good_util

func get_valid_recipes(recipes: Recipes, parts_list: PartsList, parts: Dictionary) -> Dictionary:
	var valid_recipes: Dictionary = {}
	for recipe: String in recipes:
		valid_recipes[recipe] = get_valid_recipe(recipes, recipe, parts)
	for recipe: String in valid_recipes:
		if valid_recipes[recipe].is_empty():
			valid_recipes.erase(recipe)
	return valid_recipes

func get_valid_recipe(recipes: Recipes, recipe: String, parts: Dictionary) -> Array:
	var recipe_ranks: Array = []
	var part_quantity: Dictionary
	for part: String in parts:
		if part in recipes[recipe]:
			for quality: int in parts[part]:
				if parts[part][quality] > recipes[recipe][part]:
					part_quantity[quality] += 1
	for part_rank: int in part_quantity:
		if part_quantity[part_rank] == recipes[recipe].size():
			recipe_ranks.append(part_rank)
	return recipe_ranks
