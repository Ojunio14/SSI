extends Control


#signal Ui_Zona_Construcao(value)

@onready var menu_tipo_industrias: OptionButton = $Config_Inicial/VBoxContainer/VBoxContainer/Menu_Tipo_Industrias
@onready var menu_produto: OptionButton = $Config_Inicial/VBoxContainer/VBoxEspecializacao/Menu_Produto



@onready var v_box_especializacao: VBoxContainer = $Config_Inicial/VBoxContainer/VBoxEspecializacao

enum Tipo_da_Industria {Mertalugia, Quimica, eletrica, Nada}
var Industria_Atual : int = Tipo_da_Industria.Nada

enum  Tipo_Especializacao {Siderugia,Cobre,Teste, Nada}
var Especializacao_atual = Tipo_Especializacao.Nada

var Industria_escolhida : Dictionary = {Tipo_da_Industria.Nada : Tipo_Especializacao.Nada}


var zona



var tipo_industria
var produto


func _ready() -> void:
	ZonaUiManager.connect("Ui_Zona_Config_Visible",Callable(self,"ui_config_visible"))
	ZonaUiManager.connect("Ui_Zona_Config_Disabled",Callable(self,"ui_config_disabled"))
	#ZonaUiManager.connect("Ativar_Ui_Zona_Config",Callable(self,"ativar_ui_zona_config"))
	get_parent().connect("Ativar_Ui_Zona_Config",Callable(self,"ativar_ui_zona_config"))






func ui_config_visible():
	self.visible = true
	ZonaUiManager.ui_ativada_da_zona = true
	$Area2D.process_mode = Node.PROCESS_MODE_INHERIT
	pass


func ui_config_disabled():
	self.visible = false
	ZonaUiManager.ui_ativada_da_zona = false
	$Area2D.process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().Ui_Zona_Ativada = false
	pass

func ui_especializacao():
	v_box_especializacao.visible = true
	pass




func ativar_ui_zona_config(value) -> void:
	ui_config_visible()
	menu_tipo_industrias.select(-1)
	menu_produto.select(-1)
	tipo_industria = null
	produto = null
	zona = value
	#if get_parent().zona_atual_ativa.zona_nova:
		#menu_tipo_industrias.select(-1)
		#menu_produto.select(-1)
		#tipo_industria = null
		#produto = null
	#else:
		#menu_tipo_industrias.select(tipo_industria)
		#menu_produto.select(produto)
		#get_parent().zona_atual_ativa.zona_nova = false
		
		



func _on_menu_tipo_industrias_item_selected(index: int) -> void:
	ui_especializacao()
	tipo_industria = index
	pass # Replace with function body.


func _on_option_button_item_selected(index: int) -> void:
	
	produto = index




func _on_confirmar_button_down() -> void:
	if tipo_industria != null and tipo_industria >= -1 :
		if produto != null and produto >= -1 :
			zona.Current_State_Ui_Zona = zona.State_Ui_Zona.Constru
			ui_config_disabled()
			ZonaUiManager.emit_signal("Ativar_Ui_Para_Zona_Industrial",zona)
			zona = null
			
			#get_parent().zona_atual_ativa.Definir_Dados(tipo_industria,produto)
		#emit_signal("Ui_Zona_Construcao")

	



func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManager.not_interaction_world = false


func _on_area_2d_area_exited(area: Area2D) -> void:
	GameManager.not_interaction_world = true
