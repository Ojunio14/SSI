extends Node3D


@onready var grid: MeshInstance3D = $Grid
@onready var fantasma: MeshInstance3D = $Fantasma
@onready var nada: MeshInstance3D = $Nada



enum State_Building {Fantasma,Grid,Nada}
var Current_State_Building : int = State_Building.Fantasma




func _process(delta: float) -> void:
	#$Grid.get_sha
	match Current_State_Building:
		State_Building.Nada:
			fantasma.visible = false
			grid.visible = false
			nada.visible = true
		
		State_Building.Fantasma:
			fantasma.visible = true
			grid.visible = false
			nada.visible = false
		State_Building.Grid:
			
			fantasma.visible = false
			#grid.visible = true
			nada.visible = false
