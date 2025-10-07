extends Control




@onready var menu_tipo_industrias: OptionButton = $Config_Inicial/VBoxContainer/VBoxContainer/Menu_Tipo_Industrias

@onready var v_box_especializacao: VBoxContainer = $Config_Inicial/VBoxContainer/VBoxEspecializacao


var zona_estar_ativa : bool = false

enum Tipo_da_Industria {Mertalugia, Quimica, eletrica, Nada}
var Industria_Atual : int = Tipo_da_Industria.Nada

enum  Tipo_Especializacao {Siderugia,Cobre,Teste, Nada}
var Especializacao_atual = Tipo_Especializacao.Nada


var Industria_escolhida : Dictionary = {Tipo_da_Industria.Nada : Tipo_Especializacao.Nada}

func _ready() -> void:
	ZonaUiManager.connect("Ui_Zona_Config_Visible",Callable(self,"ui_config_visible"))
	ZonaUiManager.connect("Ui_Zona_Config_Disabled",Callable(self,"ui_config_disabled"))
	ZonaUiManager.connect("Ativar_Ui_Zona_Config",Callable(self,"ativar_ui_zona_config"))
	






func ui_config_visible():
	self.visible = true
	ZonaUiManager.ui_ativada_da_zona = true
	pass


func ui_config_disabled():
	self.visible = false
	ZonaUiManager.ui_ativada_da_zona = false
	pass

func ui_especializacao():
	v_box_especializacao.visible = true
	pass




func teste():
	match Industria_Atual:
		Tipo_da_Industria.Nada:
			
			pass
		Tipo_da_Industria.Mertalugia:
			ui_especializacao()
			pass


func _process(_delta: float) -> void:
	if ZonaUiManager.ui_ativada_da_zona:
		
	
		var tipo_zona = menu_tipo_industrias.get_selected_id()
		if tipo_zona > -1:
			match tipo_zona:
				Tipo_da_Industria.Mertalugia:
					ui_especializacao()
					pass
					
		



func ativar_ui_zona_config(zona,state_ui) -> void:

		
	
	
	zona_estar_ativa = true
	
	pass

	


func _on_confirmar_button_down() -> void:
	
	$"../zona_industrial_construcao".visible = true
	
	
	
	pass # Replace with function body.
