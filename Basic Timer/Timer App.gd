extends Control

onready var start_stop_button = $VBoxContainer/ButtonContainer/StartStop
onready var reset_button = $VBoxContainer/ButtonContainer/Reset
onready var timer_wheels = $VBoxContainer/TimerWheels
onready var hours_wheel = $VBoxContainer/TimerWheels/Hours
onready var minutes_wheel = $VBoxContainer/TimerWheels/Minutes
onready var seconds_wheel = $VBoxContainer/TimerWheels/Seconds
onready var countdown_timer = $CountdownTimer
onready var countdown = $VBoxContainer/Countdown

# Track the number of seconds remaining
var countdown_seconds : int = 0
# Track whether or not the timer has been set
var is_timer_set := false
var is_running := false

func _process(_delta: float) -> void:
	if is_running:
		_get_time()

func _get_time() -> void:
	var time_left := int(countdown_timer.get_time_left())
	var seconds := time_left % 60
	var hours := time_left / 3600
	var minutes := (time_left - (3600 * hours)) / 60
	
	countdown.text = "%02d:%02d:%02d" % [hours, minutes, seconds]

func _on_StartStop_pressed() -> void:	
	if !is_running:
		is_running = true
		reset_button.visible = false
		start_stop_button.text = "PAUSE"
		if !is_timer_set:
			countdown_seconds = hours_wheel.value * 3600 + minutes_wheel.value * 60 + seconds_wheel.value
			timer_wheels.visible = false
			countdown.visible = true
			is_timer_set = true
		countdown_timer.wait_time = countdown_seconds
		countdown_timer.start()
	else:
		is_running = false
		reset_button.visible = true
		start_stop_button.text = "RESUME"
		countdown_seconds = int(countdown_timer.time_left)
		countdown_timer.stop()

func _handle_reset() -> void:
	is_timer_set = false
	reset_button.visible = false
	countdown.visible = false
	timer_wheels.visible = true
	start_stop_button.text = "START"

func _on_CountdownTimer_timeout() -> void:
	is_running = false
	_handle_reset()

func _on_Reset_pressed() -> void:
	_handle_reset()
