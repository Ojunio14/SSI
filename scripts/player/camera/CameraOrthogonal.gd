extends Node3D


@onready var camera = $InnerGimbal/Camera
@onready var innergimbal = $InnerGimbal

@export var max_zoom := 55.0
@export var min_zoom := 30.0
@export var zoom_speed := 0.9
var zoom := 35.0

@export var speed := 0.3
@export var drag_speed = 0.005
@export var acceleration := 0.08
@export var mouse_sensitivity = 0.0009

var move = Vector3()

const  Config_Camera : Vector3 = Vector3()

var Rotation_Camera : Vector3 = Vector3(0,45,0)
var Rotation_Atual = Vector3(0,45,0)
var num : = 45
var interpo
var inicial
# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.window_fullscreen = true
	inicial = global_rotation
	pass

func _input(event):

#	if event.is_action_pressed("Z"):
#		num += 45
#		Rotation_Camera.y = num
#		interpo = lerp(Rotation_Atual,Rotation_Camera,8)
#		Rotation_Atual.y = num
#		$InnerGimbal.rotation_degrees = interpo


		
#		if Rotation_Camera == 365:
#			$InnerGimbal.rotation_degrees.y = 45
	if Input.is_action_just_pressed("Z"):
		
		$InnerGimbal.global_rotation = inicial
	if Input.is_action_pressed("rotate_cam"):
		if event is InputEventMouseMotion:
			if event.relative.x != 0:
				#$InnerGimbal.rotate_y( -event.relative.x * mouse_sensitivity)
#				print(-event.relative.x * mouse_sensitivity)
				#rotate_object_local(Vector3.UP, -event.relative.x * mouse_sensitivity)
				pass
#			if event.relative.y != 0:
#
#				var y_rotation = clamp(-event.relative.y, -30, 30)
#				innergimbal.rotate_object_local(Vector3.RIGHT, y_rotation * mouse_sensitivity)
#	if Input.is_action_pressed("move_cam"):
#		if event is InputEventMouseMotion:
#			move.x -= event.relative.x * drag_speed
#			move.z -= event.relative.y * drag_speed
#			pass
	if event.is_action_pressed("zoom_in"):
		zoom -= zoom_speed 
		
	if event.is_action_pressed("zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)

var pe
func _process(delta):
	#zoom camera
	#scale
	pe = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	camera.size = pe.y
	#clamp rotation
	innergimbal.rotation.x = clamp(innergimbal.rotation.x, -1.1, 0.3)
	#move camera
	move_cam(delta)
	
func move_cam(_delta):
	#get inputs
	#if Input.is_action_pressed("W"):
		#move.z = lerp(move.z,-speed, acceleration)
	#elif Input.is_action_pressed("S"):
		#move.z = lerp(move.z,speed, acceleration)
	#else:
		#
		#move.z = lerp(move.z, 0.0, acceleration)#move.z * 0 * acceleration
	#if Input.is_action_pressed("A"):
		#move.x = lerp(move.x,-speed, acceleration)
	#elif Input.is_action_pressed("D"):
		#move.x = lerp(move.x,speed, acceleration)
	#else:
		#move.x = lerp(move.x, 0.0, acceleration)
	var input_direction = Input.get_vector("A","D","W","S")
	var movement_direction = (transform.basis * Vector3(input_direction.x,0,input_direction.y))
	move += speed * movement_direction
	#move camera
	position = lerp(position, move, 0.05)
	#global_position += speed * move#move.rotated(Vector3.UP,self.rotation.y) * zoom
	#position.x = clamp(position.x,-20,20)
	#position.z = clamp(position.z,-20,20)
