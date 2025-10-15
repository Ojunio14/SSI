extends Node3D

#1b2929

signal IniciaZona
signal MudaAparenciaZona(State,Dados)
signal CameraZonaVisible(coord,value)


var Zone := BaseZone.new()

enum State_Visual_Zona {Selecao,Instanciada,Build,BuildDisabled}
var Current_State_Visual_Zona : int

enum Industria {Metalugica,Quimica,Nada}
enum Produto {Siderugia,Cobre,Nada}

var Industria_selecionada := Industria.Nada
var Especializacao_da_Induatria := Produto.Nada
var especializacao_da_zona_selecionada : bool = false




var size_zona : Vector2 = Vector2(30,30)
var grid : bool = false
var coord_grid : Vector3

var dic_grid : Dictionary


#Variaveis para Ui da zona de configuraçao 

#Vai decidir qual Ui vai abrir
enum State_Ui_Zona {Config,Constru,ConfigInicial}
var Current_State_Ui_Zona : int = State_Ui_Zona.ConfigInicial

var Ui_Zona_Ativada : bool = false
var zona_nova : bool = true

var in_modo_selecao : bool = false


func _ready() -> void:
	#BaseZone.new()
	#Inicia a Zona Industrial
	self.connect("IniciaZona",Callable(self,"ativar_zona"))

	if get_parent().name == "Zonas":
		Current_State_Visual_Zona = State_Visual_Zona.Instanciada
		State_Visual()
		in_modo_selecao = false
	else:
		Current_State_Visual_Zona = State_Visual_Zona.Selecao
		State_Visual()
		in_modo_selecao = true
		pass
	
	pass

#È onde faz ativaçao da zona
func ativar_zona():
	ZonaUiManager.emit_signal("Ativar_Ui_Para_Zona_Industrial",self)




func Definir_Dados(value,value2):
	match value:
		Industria.Metalugica:
			match value2:
				Produto.Siderugia:
					Industria_selecionada = Industria.Metalugica
					Especializacao_da_Induatria = Produto.Cobre
					Current_State_Ui_Zona = State_Ui_Zona.Constru
					ZonaUiManager.emit_signal("Zona_Ativada",self)
					Current_State_Visual_Zona = State_Visual_Zona.Build
					State_Visual()
					#emit_signal("MudaAparenciaZona",)
					#emit_signal()
					pass
				
				Produto.Cobre:
					
					pass
				
				
		Industria.Quimica:
			
			
			pass
			pass

func State_Visual():
	
	match Current_State_Visual_Zona:
		State_Visual_Zona.Selecao:
			emit_signal("MudaAparenciaZona",Current_State_Visual_Zona,1)
			
			pass
		State_Visual_Zona.Instanciada:
			emit_signal("MudaAparenciaZona",Current_State_Visual_Zona,1)
			$Aparencia_zona.process_mode = Node.PROCESS_MODE_PAUSABLE
			
			pass
		State_Visual_Zona.Build:
			#$Aparencia_zona.process_mode = Node.PROCESS_MODE_INHERIT
			get_tree().get_first_node_in_group("CameraWorld").current = false
			emit_signal("CameraZonaVisible",self,true)
			
			
			grid = true
			coord_grid = self.global_position
			size_zona = size_zona
			
			
			
			
			dic_grid = {"grid" : grid, "coord_grid" : coord_grid, "size_zona" : size_zona}
			emit_signal("MudaAparenciaZona",Current_State_Visual_Zona,dic_grid)
			#emit_signal("MudaAparenciaZona",Current_State_Zona,1)
			
			pass
		State_Visual_Zona.BuildDisabled:
			
			get_tree().get_first_node_in_group("CameraWorld").current = true
			emit_signal("CameraZonaVisible",self,false)
			
			grid = false
			coord_grid = self.global_position
			size_zona = size_zona
			
			
			dic_grid = {"grid" : grid, "coord_grid" : coord_grid, "size_zona" : size_zona}
			emit_signal("MudaAparenciaZona",Current_State_Visual_Zona,dic_grid)
			pass
		
