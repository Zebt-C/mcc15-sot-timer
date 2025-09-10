extends Window

@onready var sot :SotTimer = %SotTimer

@onready var cd_label :Label = %CountdownLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()

func secs_to_min_and_secs(time:int) -> String:		
	if time < 0:
		printerr("Negative second representation.")
		return ""
		
	var secs :int = time % 60
	var mins :int = time / 60
	var str :String = str(mins) + " : "
	if secs < 10:
		str = str + "0" + str(secs)
	else:
		str = str + str(secs)
	
	return str

func reposition() -> void:
	var screen_size = DisplayServer.screen_get_size()
	var sandclock_size = self.get_size()
	self.set_position(Vector2((screen_size.x - sandclock_size.x) / 2, 35))


func _on_sot_timer_update() -> void:
	cd_label.set_text(self.secs_to_min_and_secs(sot.get_remaining_time()))
	self.show()
	self.reposition()

func _on_sot_timer_reset() -> void:
	cd_label.set_text("Countdown")
	self.hide()

func _on_sot_timer_complete() -> void:
	cd_label.set_text("Countdown")
	self.hide()
