extends Node2D

# STT node
onready var stt = get_node("STT")

# STT queue
var queue = STTQueue.new()

# Node for current word label
onready var current_word = get_node("Word")

# Node for score label
onready var score = get_node("Score")

# Colors used in the game
const COLORS = {
	Color(1, 0, 0)     : "red",
	Color(0, 1, 0)     : "green",
	Color(0, 0, 1)     : "blue",
	Color(1, 1, 0)     : "yellow",
	Color(0.5, 0, 0.5) : "purple",
	Color(1, 0.5, 0)   : "orange",
	Color(1, 1, 1)     : "white" 
}

# Existing game states
enum GAME_STATE { START, RUNNING }

# State the game is currently in
var current_state = GAME_STATE.START

# Possible answer categories
enum ANSWER_TYPE { WORD, FILL, BACKGROUND }

# String for correct answer
var answer

func update_word():
	var text = COLORS.keys()[randi() % COLORS.size()]
	text = COLORS[text]
	var color = COLORS.keys()[randi() % COLORS.size()]

	current_word.update(text, color)

func update_background():
	var word_color = current_word.get_color("font_color")
	var bg_color

	while true:
		# Background color mustn't be the same as word color
		bg_color = COLORS.keys()[randi() % COLORS.size()]
		if bg_color != word_color:
			break

	VisualServer.set_default_clear_color(bg_color)

func update_answer():
	var type = randi() % ANSWER_TYPE.size()

	if type == ANSWER_TYPE.WORD:
		answer = current_word.get_text()
		get_node("AnswerType").set_text("Word")
	elif type == ANSWER_TYPE.FILL:
		answer = current_word.get_color("font_color")
		answer = COLORS[answer]
		get_node("AnswerType").set_text("Fill")
	elif type == ANSWER_TYPE.BACKGROUND:
		answer = VisualServer.get_default_clear_color()
		answer = COLORS[answer]
		get_node("AnswerType").set_text("Background")

func answer_hit():
	get_node("Chime").play()
	queue.clear()
	score.update()

func start_game():
	get_node("GameStart").play()
	get_node("Timer").start()
	score.reset()

	get_node("StartMessage").set_opacity(0.0)
	current_state = GAME_STATE.RUNNING

func end_game():
	get_node("AnswerType").set_text("")

	get_node("StartMessage").set_opacity(1.0)
	current_word.set_text("")
	current_state = GAME_STATE.START

func _ready():
	# Initialize RNG
	randomize()

	# Start speech recognition
	var err = stt.get_config().init()
	if err != STTError.OK:
		print(STTError.get_error_string(err))
		get_tree().quit()

	stt.set_queue(queue)
	err = stt.start()
	if err != STTError.OK:
		print(STTError.get_error_string(err))
		get_tree().quit()

	# Define function called by timeout signal
	get_node("Timer").connect("timeout", self, "end_game")

	# Clear text of some labels
	get_node("Score").set_text("")
	get_node("AnswerType").set_text("")
	current_word.set_text("")

	set_process(true)

# Game loop
func _process(delta):
	var user_input

	if !stt.running():
		var err = stt.get_run_error()
		print(STTError.get_error_string(err))
		get_tree().quit()

	if not stt.get_queue().empty():
		user_input = stt.get_queue().get()

	if current_state == GAME_STATE.START:
		if user_input == "start":
			start_game()
			update_word()
			update_background()
			update_answer()
	elif current_state == GAME_STATE.RUNNING:
		if user_input == answer:
			answer_hit()
			update_word()
			update_background()
			update_answer()

	if user_input == "exit":
		get_tree().quit()
