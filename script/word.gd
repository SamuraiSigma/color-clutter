extends Label

# Screen dimensions
var screen_size

# Position of the lowest HUD element
var hud_height

# Word length/height properties
const MIN_WORD_LENGTH = 1
const MAX_WORD_LENGTH = 2
const LENGTH_HEIGHT_PROPORTION = 2.0

func update(text, color):
	.set_text(text)
	.add_color_override("font_color", color)

	var scale_x = rand_range(MIN_WORD_LENGTH, MAX_WORD_LENGTH + 1)
	var scale_y = scale_x/LENGTH_HEIGHT_PROPORTION
	.set_scale(Vector2(scale_x, scale_y))

	var size = .get_combined_minimum_size()
	size *= Vector2(scale_x, scale_y)

	var x = rand_range(0, screen_size.x - size.x)
	var y = rand_range(hud_height, screen_size.y - size.y)
	.set_pos(Vector2(x, y))

func _ready():
	screen_size = get_viewport_rect().size

	# Lowest HUD element is the Score label
	hud_height = get_node("../Score").get_pos().y
	hud_height += get_node("../Score").get_size().y
