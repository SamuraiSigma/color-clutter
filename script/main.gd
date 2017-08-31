extends Node2D

var screen_size

# Word length/height properties
const MIN_WORD_LENGTH = 1
const MAX_WORD_LENGTH = 2
const LENGTH_HEIGHT_PROPORTION = 2

# Maximum rotation a word may have, clockwise or counterclockwise
const MAX_ROTATION = PI/2
const BORDER_OFFSET = 15

const WORD_COLOR = {
	"red"    : Color(1, 0, 0),
	"green"  : Color(0, 1, 0),
	"blue"   : Color(0, 0, 1),
	"yellow" : Color(1, 1, 0),
	"purple" : Color(1, 0, 1),
	"orange" : Color(1, 0.5, 0),
	"white"  : Color(1, 1, 1)
}

# Existing game states
enum GAME_STATE { BEGIN, RUNNING, END }
var current_state = GAME_STATE.BEGIN

enum ANSWER_TYPE { WORD, FILL, BACKGROUND }

# Speech Recognizer node
onready var sr_runner = get_node("STT")

# Node for current word label
onready var current_word = get_node("Word")

# String for correct answer
var answer

# Number of correct guesses
var score = 0


func create_word():

	var text = WORD_COLOR.keys()[randi() % WORD_COLOR.size()]
	current_word.set_text(text)

	var color = WORD_COLOR.keys()[randi() % WORD_COLOR.size()]
	current_word.add_color_override("font_color", WORD_COLOR[color])
	
	var scale_x = rand_range(MIN_WORD_LENGTH, MAX_WORD_LENGTH + 1)
	var scale_y = scale_x/LENGTH_HEIGHT_PROPORTION
	current_word.set_scale(Vector2(scale_x, scale_y))

	var size = current_word.get_combined_minimum_size()
	var longest_size = max(size.x*scale_x/2, size.y*scale_y/2)

	var x = rand_range(longest_size, screen_size.x - longest_size)
	var y = rand_range(longest_size, screen_size.y - longest_size)
	current_word.set_pos(Vector2(x, y))
	
	var rotation = rand_range(-MAX_ROTATION, MAX_ROTATION)
	current_word.set_rotation(rotation)

	return color


func next_stage():
	var color = create_word()
	
	var bg_color
	while true:
		bg_color = WORD_COLOR.keys()[randi() % WORD_COLOR.size()]
		if bg_color != color:
			break

	VisualServer.set_default_clear_color(WORD_COLOR[bg_color])
	
	var type = randi() % ANSWER_TYPE.size()
	if type == ANSWER_TYPE.WORD:
		answer = current_word.get_text()
		get_node("AnswerType").set_text("Word")
	elif type == ANSWER_TYPE.FILL:
		answer = color
		get_node("AnswerType").set_text("Fill")
	elif type == ANSWER_TYPE.BACKGROUND:
		answer = bg_color
		get_node("AnswerType").set_text("Background")


func answer_correct():
	# Play a nice sound
	get_node("Chime").play()

	# Clear current word and STT queue
	current_word.set_text("")
	sr_runner.get_queue().clear()

	# Update score
	score += 1
	get_node("Score").set_text("Score: " + String(score))


func end_game():
	current_state = GAME_STATE.END


func _ready():
	randomize()  # Initialize RNG
	screen_size = get_viewport_rect().size

	# Start speech recognition
	sr_runner.get_config().init()
	var queue = SRQueue.new()
	sr_runner.set_queue(queue)
	sr_runner.start()

	# Define function called by timeout signal
	get_node("Timer").connect("timeout", self, "end_game")

	get_node("Score").set_text("")
	get_node("AnswerType").set_text("")
	get_node("Word").set_text("")
	
	var start_msg = get_node("StartMessage")
	var size = start_msg.get_minimum_size()
	start_msg.set_pos((screen_size - size)/2)
	
	set_process(true)


func _process(delta):
	if current_state == GAME_STATE.BEGIN:
		score = 0

		if not sr_runner.get_queue().empty():
			var user_input = sr_runner.get_queue().get()
			if user_input == "start":
				get_node("GameStart").play()
				get_node("Timer").start()
				get_node("StartMessage").set_opacity(0.0)
				get_node("Score").set_text("Score: 0")
				current_state = GAME_STATE.RUNNING

	elif current_state == GAME_STATE.RUNNING:
		if current_word.get_text() == "":
			next_stage()
	
		if not sr_runner.get_queue().empty():
			var user_input = sr_runner.get_queue().get()
			if user_input == answer:
				answer_correct()
			elif user_input == "exit":
				get_tree().quit()

	elif current_state == GAME_STATE.END:
		get_node("AnswerType").set_text("")
		get_node("Word").set_text("")
		get_node("StartMessage").set_opacity(1.0)
		current_state = GAME_STATE.BEGIN
