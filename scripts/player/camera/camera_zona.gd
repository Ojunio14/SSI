extends Node3D


@onready var camera = $InnerGimbal/Camera
@onready var innergimbal = $InnerGimbal

@export var max_zoom := 55.0
@export var min_zoom := 30.0
@export var zoom_speed := 0.9
var zoom := 35.0

@export var speed := 0.3
@export var suavidade := 1.0
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
	get_parent().connect("CameraZonaVisible",Callable(self,"CameraVisibleOn"))
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
	if Input.is_action_just_pressed("Z") and CameraVisible:
		
		$InnerGimbal.global_rotation = inicial
	if Input.is_action_pressed("rotate_cam") and CameraVisible:
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
	if event.is_action_pressed("zoom_in") and CameraVisible:
		zoom -= zoom_speed 
		
	if event.is_action_pressed("zoom_out") and CameraVisible:
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)


var CameraVisible : bool = false
var pe
func _process(delta):
	if CameraVisible:
		#zoom camera
		#scale
		pe = lerp(scale, Vector3.ONE * zoom, zoom_speed)
		camera.size = pe.y
		#clamp rotation
		innergimbal.rotation.x = clamp(innergimbal.rotation.x, -1.1, 0.3)
		#move camera
		move_cam(delta)


func CameraVisibleOn(coord,value):
	if value:
		CameraVisible = true
		$InnerGimbal/Camera.current = true
		self.process_mode = Node.PROCESS_MODE_INHERIT
		atualizar_limites_da_camera(coord.global_position)
	else:
		CameraVisible = false
		$InnerGimbal/Camera.current = false
		self.process_mode = Node.PROCESS_MODE_DISABLED
	

func move_cam(delta):
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

# 1. Pega o input e a direção
	var input_direction = Input.get_vector("A", "D", "W", "S")
	var direction = Vector3(input_direction.x, 0, input_direction.y).normalized()
	
	# 2. Calcula o vetor de movimento que DESEJARÍAMOS para este frame
	var movimento = direction * speed * delta
	
	# 3. Calcula a posição final que TERÍAMOS se não houvesse limites
	var proxima_posicao = global_position + movimento
	
	# 4. CORREÇÃO DE COLISÃO:
	#    Ajusta a posição final para que ela nunca ultrapasse os limites.
	#    Isso substitui todas as lógicas anteriores.
	proxima_posicao.x = clamp(proxima_posicao.x, min_x, max_x)
	proxima_posicao.z = clamp(proxima_posicao.z, min_z, max_z)
	
	# 5. Com a posição final já corrigida e garantida, aplicamos diretamente.
	global_position = proxima_posicao

# Variáveis para os limites. Elas serão atualizadas dinamicamente.
var min_x: float = 0.0
var max_x: float = 0.0
var min_z: float = 0.0
var max_z: float = 0.0

# Tamanho do quadrado, pode ser ajustado
@export var tamanho_do_quadrado: float = 32.0


# Esta é a função principal. Chame-a sempre que precisar definir um novo centro.
func atualizar_limites_da_camera(novo_centro: Vector3):
	print("Novos limites da câmera definidos em torno de: ", novo_centro)
	var metade_tamanho = tamanho_do_quadrado / 2.0
	
	min_x = novo_centro.x - metade_tamanho
	max_x = novo_centro.x + metade_tamanho
	min_z = novo_centro.z - metade_tamanho
	max_z = novo_centro.z + metade_tamanho

#func _input(event):
	## Exemplo: Se o jogador apertar "Enter", a área da câmera é redefinida
	#if event.is_action_pressed("ui_accept"): # "ui_accept" é a tecla Enter por padrão
		#atualizar_limites_da_camera(no_do_jogador.global_position)
