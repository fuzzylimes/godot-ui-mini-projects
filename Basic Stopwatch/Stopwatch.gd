extends Control

onready var button = get_node("HBoxContainer/VBoxContainer/HBoxContainer/StartStopButton")
onready var reset_button = get_node("HBoxContainer/VBoxContainer/HBoxContainer/Reset")
onready var label = get_node("HBoxContainer/VBoxContainer/Timer")
onready var time_container = get_node("HBoxContainer/TimeContainer")
onready var time_separator = get_node("HBoxContainer/VSeparator")
onready var times = get_node("HBoxContainer/TimeContainer/Times")
onready var result_time = preload("ResultTime.tscn")

var running := false
var cumulative_time := 0
var start_time := 0

func _process(_delta: float) -> void:
	if running:
		_get_time()

func _get_time() -> void:
	var now := OS.get_unix_time()
	var elapsed := now - start_time + cumulative_time
	var seconds := elapsed % 60
	var hours := elapsed / 3600
	var minutes := (elapsed - (3600 * hours)) / 60
	
	label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]

func _start() -> void:
	running = true
	reset_button.hide()
	button.text = "STOP"
	start_time = OS.get_unix_time()

func _stop() -> void:
	running = false
	var pause_time := OS.get_unix_time()
	cumulative_time += pause_time - start_time
	reset_button.visible = true
	button.text = "START"

func _reset() -> void:
	var time_instance = result_time.instance()
	time_instance.text = label.text
	times.add_child(time_instance)
	cumulative_time = 0
	label.text = "00:00:00"
	reset_button.hide()
	time_container.visible = true
	time_separator.visible = true

func _on_Button_pressed() -> void:
	if running:
		_stop()
	else:
		_start()

func _on_Reset_pressed() -> void:
	_reset()
