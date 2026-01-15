extends HBoxContainer

@export var object_list: ObjectList
@export var small_ranks_resource: RanksResource
@export var quantity_label: PackedScene

var parts: Dictionary[String, int]
var rank: ImageTexture

func _ready() -> void: 
	for part: String in parts:
		var quantity_label_scene = quantity_label.instantiate()
		quantity_label_scene.amount = parts[part]
		quantity_label_scene.rank = rank
		quantity_label_scene.icon_texture = good_util.direct_image(object_list.parts[part].icon)
		add_child(quantity_label_scene)
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	for label in get_children():
		tween.tween_property(label, "position:y", label.position.y-10, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel()
	for label in get_children():
		tween.tween_property(label, "position:y", label.position.y+5, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	pivot_offset = Vector2(size.x/2, size.y)
	
func _physics_process(delta):
	modulate.a -= delta*(1+get_index())/3
	if modulate.a <= 0:
		queue_free()
	#scale -= Vector2((0.0002 / (1.0 + exp(10.0 * (get_index() - 10.0)))), (0.0002 / (1.0 + exp(2.0 * (get_index() - 10.0)))))
