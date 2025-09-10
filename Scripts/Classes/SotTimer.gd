# A dedicated wrapper class of Godot native Timer class
class_name SotTimer extends Node

const DEFAULT_SECS :int = 45
@onready var remaining_secs :int = DEFAULT_SECS
@onready var has_started :bool = false
@onready var timer :Timer = %Timer
@onready var proc_timer :Timer = $ProcessTimer

@onready var audio_manager :AudioManager = %AudioManager

const CODE :Dictionary = {
	SUCCESS=0,
	INVALID=-1,
	SET_DURING_COUNTDOWN=-2,
	ALREADY_COUNTING=-3,
	ALREADY_STOPPED=-4
}

const ERR_MSG :Dictionary = {
	SUCCESS="Success",
	INVALID="Invalid countdown parameter. Must be a positive number less than 1000.",
	SET_DURING_COUNTDOWN="Cannot set timer during countdown.",
	ALREADY_COUNTING="Countdown has already started.",
	ALREADY_STOPPED="Countdown has already stopped or not started yet."
}

# Timer expires
signal complete
# Timer updates
signal update
# Timer resets
signal reset

func _ready() -> void:
	print("Initializing timer...")
	timer.set_wait_time(remaining_secs)

func get_default_secs() -> int:
	return DEFAULT_SECS
	
func get_status() -> bool:
	return not timer.is_stopped()
	
func get_remaining_time() -> int:
	return int(remaining_secs)
	
func translate_ret_code(ret:int) -> String:
	return ERR_MSG.get(CODE.find_key(ret))

func set_timer(countdown:String) -> int:
	if has_started:
		printerr(ERR_MSG.SET_DURING_COUNTDOWN)
		return CODE.SET_DURING_COUNTDOWN
	if not countdown.is_valid_int():
		printerr(ERR_MSG.INVALID)
		return CODE.INVALID
		
	var cd :int = int(countdown)
	if cd <= 0 or cd >= 1000:
		printerr(ERR_MSG.INVALID)
		return CODE.INVALID
		
	#print_debug("Set timer countdown to " + countdown +  " seconds, previously " + str(remaining_secs) + " seconds.")
	remaining_secs = cd
	timer.set_wait_time(remaining_secs)
	return CODE.SUCCESS
	
func start() -> int:
	if has_started:
		printerr(ERR_MSG.ALREADY_COUNTING)
		return CODE.ALREADY_COUNTING
		
	#print_debug("Timer started with " + str(remaining_secs) + "-second countdown.")
	timer.start()
	proc_timer.start(1)
	has_started = not timer.is_stopped()
	update.emit()
	return CODE.SUCCESS
	
func stop() -> int:
	if not has_started:
		printerr(ERR_MSG.ALREADY_STOPPED)
		return CODE.ALREADY_STOPPED
		
	#print_debug("Timer stopped.")
	timer.stop()
	has_started = not timer.is_stopped()
	reset.emit()
	return CODE.SUCCESS


func _on_timer_timeout() -> void:
	has_started = false
	#print_debug("Timer has expired. Emitting complete signal.")
	complete.emit()


func _on_process_timer_timeout() -> void:
	if not has_started:
		return
	
	remaining_secs -= 1
	update.emit()
	if remaining_secs > 0:
		proc_timer.start(1.0)
	
	if remaining_secs == 30:
		audio_manager.play_timer_sfx("SECS_30")
	elif remaining_secs == 20:
		audio_manager.play_timer_sfx("SECS_20")
	elif remaining_secs <= 10:
		audio_manager.play_timer_sfx("SECS_10")
