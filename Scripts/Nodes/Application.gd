extends Control

@onready var sot :SotTimer = %SotTimer
@onready var audio_manager :AudioManager = %AudioManager

@onready var input :LineEdit = %TimerInput
@onready var start_btn :Button = %TimerStartButton
@onready var reset_btn :Button = %TimerResetButton

@onready var warn_msg :Label = %WarningMessage
@onready var warn_container :PanelContainer = %WarningPanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello world!")
	
	audio_manager.play_music("HUB")
	
	warn_container.hide()
	reset_btn.hide()


func _on_timer_start_button_pressed() -> void:
	audio_manager.play_btn_sfx("START")
	
	# Start timer
	var retval :int = sot.set_timer(input.get_text())
	if retval < 0:
		warn_msg.set_text(SotTimer.ERR_MSG.get(SotTimer.CODE.find_key(retval)))
		warn_container.show()
		
		input.set_editable(true)
		start_btn.show()
		reset_btn.hide()
	else:
		retval = sot.start()
		if retval < 0:
			warn_msg.set_text(SotTimer.ERR_MSG.get(SotTimer.CODE.find_key(retval)))
			warn_container.show()
			
			input.set_editable(true)
			start_btn.show()
			reset_btn.hide()
		else:
			audio_manager.play_music("SOT")
			
			warn_container.hide()
			
			input.set_editable(false)
			start_btn.hide()
			reset_btn.show()

func _on_timer_reset_button_pressed() -> void:
	audio_manager.play_btn_sfx("RESET")
	
	# Reset timer
	var retval :int = sot.stop()
	if retval < 0:
		warn_msg.set_text(SotTimer.ERR_MSG.get(SotTimer.CODE.find_key(retval)))
		warn_container.show()
		
		input.set_editable(false)
		start_btn.hide()
		reset_btn.show()
	else:
		audio_manager.play_music("HUB")
		
		warn_container.hide()
		
		input.set_editable(true)
		start_btn.show()
		reset_btn.hide()


func _on_sot_timer_complete() -> void:
	audio_manager.play_btn_sfx("COMPLETE")
	audio_manager.play_music("HUB")
	
	# On completion
	warn_container.hide()
	
	input.set_editable(true)
	start_btn.show()
	reset_btn.hide()
