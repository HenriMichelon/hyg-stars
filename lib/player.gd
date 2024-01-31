class_name Player extends CharacterBody3D

const max_speed:float = 10.0
const acceleration:float = 0.6
const pitch_speed:float = 1.5
const roll_speed:float = 1.9
const yaw_speed:float = 1.25
const input_response:float = 8.0
const mouse_sensitivity:float = 0.005

var pitch_input:float = 0.0
var roll_input:float = 0.0
var yaw_input:float = 0.0
var forward_speed:float = 0.0

func _input(event):
	if event is InputEventMouseMotion:
		transform.basis = transform.basis.rotated(transform.basis.y, -event.relative.x * mouse_sensitivity)
		transform.basis = transform.basis.rotated(transform.basis.x, -event.relative.y * mouse_sensitivity)

func get_input(delta):
	if Input.is_action_pressed("throttle_up"):
		forward_speed = lerp(forward_speed, max_speed, acceleration * delta)
	if Input.is_action_pressed("throttle_down"):
		forward_speed = lerp(forward_speed, 0.0, acceleration * delta)
	pitch_input = lerp(pitch_input, Input.get_axis("pitch_down", "pitch_up"), input_response * delta)
	roll_input = lerp(roll_input, Input.get_axis("roll_right", "roll_left"), input_response * delta)
	yaw_input = lerp(yaw_input, Input.get_axis("yaw_right", "yaw_left"), input_response * delta)

func _physics_process(delta):
	get_input(delta)
	transform.basis = transform.basis.rotated(transform.basis.z, roll_input * roll_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.y, yaw_input * yaw_speed * delta)
	transform.basis = transform.basis.orthonormalized()
	velocity = -transform.basis.z * forward_speed
	move_and_collide(velocity * delta)
