extends Label

# Number of correct guesses
var score

func update():
	score += 1
	.set_text("Score: " + String(score))

func reset():
	score = 0
	.set_text("Score: " + String(score))
