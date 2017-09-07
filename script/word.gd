extends Label

# Screen dimensions
var screen_size

# Word length/height properties
const MIN_WORD_LENGTH = 1
const MAX_WORD_LENGTH = 2
const LENGTH_HEIGHT_PROPORTION = 2

# Maximum rotation a word may have, clockwise or counterclockwise
const MAX_ROTATION = PI/2

# Minimum distance from a word to the screen border
const BORDER_OFFSET = 15

func update(text, color):
	.set_text(text)
	.add_color_override("font_color", color)

	var scale_x = rand_range(MIN_WORD_LENGTH, MAX_WORD_LENGTH + 1)
	var scale_y = scale_x/LENGTH_HEIGHT_PROPORTION
	.set_scale(Vector2(scale_x, scale_y))

	var size = .get_combined_minimum_size()
	var longest_size = max(size.x*scale_x/2, size.y*scale_y/2)

	var x = rand_range(longest_size, screen_size.x - longest_size)
	var y = rand_range(longest_size, screen_size.y - longest_size)
	.set_pos(Vector2(x, y))

	var rotation = rand_range(-MAX_ROTATION, MAX_ROTATION)
	.set_rotation(rotation)

func _ready():
	screen_size = get_viewport_rect().size
