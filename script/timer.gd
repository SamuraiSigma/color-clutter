extends Timer

func _ready():
	set_process(true)

func _process(delta):
	if self.get_time_left() > 0:
		var time_left = self.get_time_left()
		var time_left_str = String(time_left).substr(0, 5)
		get_node("AverageTime").set_text(time_left_str)
	else:
		get_node("AverageTime").set_text("")
