extends Control

enum MenuEdificios {Nenhum,Build,Zona}

var current_state_menu_edificios := MenuEdificios.Nenhum

var IsZona : bool = false


@onready var control_zona: Control = $ControlZona

@onready var h_box_container: HBoxContainer = $ControlMenu/HBoxContainer

@onready var fps: Label = $"../FPS"


var fps_int : int = 0

func _process(_delta: float) -> void:
	fps_int = Engine.get_frames_per_second()
	fps.text = str(fps_int)
	$MouseArea.global_position = get_viewport().get_mouse_position()
	#$MouseArea/CollisionShape2D.position = get_viewport().get_mouse_position()
	match current_state_menu_edificios:
		MenuEdificios.Nenhum:
			if Input.is_action_just_pressed("SaidaUi"):
				if IsZona:
					IsZona = false
					current_state_menu_edificios = MenuEdificios.Zona
			pass
		MenuEdificios.Build:
			pass
		MenuEdificios.Zona:
			if IsZona:
				h_box_container.visible = false
				control_zona.visible = true
			else:
				control_zona.visible = false
				h_box_container.visible = true
			
			current_state_menu_edificios = MenuEdificios.Nenhum
			
			
			
			
	pass

func _on_zona_button_down() -> void:
	
	current_state_menu_edificios = MenuEdificios.Zona
	IsZona = true
	
