class_name AudioManager extends Node

@onready var music_player :AudioStreamPlayer = %MusicPlayer
@onready var btn_player :AudioStreamPlayer = %ButtonPlayer
@onready var tmr_player :AudioStreamPlayer = %TimerPlayer

var music_hub :AudioStream = load("res://Assets/Audio/music_hub.ogg")
var music_sot :AudioStream = load("res://Assets/Audio/music_sot.ogg")

var sfx_start :AudioStream = load("res://Assets/Audio/start_button_interact.ogg")
var sfx_reset :AudioStream = load("res://Assets/Audio/timer_abort.ogg")
var sfx_complete :AudioStream = load("res://Assets/Audio/timer_finish.ogg")

var sfx_30s :AudioStream = load("res://Assets/Audio/sandtimer_30sec.ogg")
var sfx_20s: AudioStream = load("res://Assets/Audio/sandtimer_20sec.ogg")
var sfx_10s: AudioStream = load("res://Assets/Audio/sandtimer_10sec.ogg")

var musics :Dictionary = {
	"HUB": music_hub,
	"SOT": music_sot
}

var btn_sfxs :Dictionary = {
	"START": sfx_start,
	"RESET": sfx_reset,
	"COMPLETE": sfx_complete
}

var timer_sfxs :Dictionary = {
	"SECS_30": sfx_30s,
	"SECS_20": sfx_20s,
	"SECS_10": sfx_10s
}

const CODE :Dictionary = {
	SUCCESS = 0,
	UNKNOWN = -1,
	UNCHANGED = -2
}

const ERR_MSG :Dictionary = {
	SUCESS = "Success.",
	UNKNOWN = "Unknown audio.",
	UNCHANGED = "Request matches audio currently played. Nothing changed."
}

func _ready() -> void:
	print("Initializing audio manager...")
	music_hub.loop = true
	music_sot.loop = true
	
func play_music(new_music:String) -> int:
	var music :AudioStream = musics.get(new_music)
	# Check requested music
	if music == null:
		printerr(ERR_MSG.UNKNOWN)
		return CODE.UNKNOWN
		
	# Check current playing
	if music_player.get_stream() == music:
		printerr(ERR_MSG.UNCHANGED)
		return CODE.UNCHANGED

	# Switch to new music
	music_player.stop()
	music_player.set_stream(music)
	music_player.play()
	print_debug(ERR_MSG.SUCESS)
	return CODE.SUCCESS
	
func play_btn_sfx(btn_sfx:String) -> int:
	var sfx :AudioStream = btn_sfxs.get(btn_sfx)
	# Check requested sfx
	if sfx == null:
		printerr(ERR_MSG.UNKNOWN)
		return CODE.UNKNOWN

	# Switch to new sfx
	btn_player.stop()
	btn_player.set_stream(sfx)
	btn_player.play()
	print_debug(ERR_MSG.SUCESS)
	return CODE.SUCCESS

func play_timer_sfx(timer_sfx:String) -> int:
	var sfx :AudioStream = timer_sfxs.get(timer_sfx)
	# Check requested sfx
	if sfx == null:
		printerr(ERR_MSG.UNKNOWN)
		return CODE.UNKNOWN

	# Switch to new sfx
	tmr_player.stop()
	tmr_player.set_stream(sfx)
	tmr_player.play()
	print_debug(ERR_MSG.SUCESS)
	return CODE.SUCCESS
