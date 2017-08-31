extends Label

# Milliseconds passed since beginning of program
var sum_msec = 0.0

# Current average user response time, in msecs
var current_average = 0.0

func update_average(n):
	current_average = sum_msec/n

	# Convert average value to time format (sec:msec)
	var approx_average = int(current_average)
	var sec = str(approx_average / 1000).substr(0, 2).pad_zeros(2)
	var msec = str(approx_average % 1000).substr(0, 2).pad_zeros(2)
	self.set_text(sec + ":" + msec)

func _ready():
	#var screen_size = get_viewport_rect().size
	#var size = get_size()
	#self.set_pos(screen_size - size)
	set_process(true)

func _process(delta):
	sum_msec += 1000*delta
