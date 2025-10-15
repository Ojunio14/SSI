extends Control

signal Ativar_Ui_Zona_Config
signal Ativar_Ui_Zona_Constru



var Ui_Zona_Ativada := false
var zona

func _ready() -> void:
	ZonaUiManager.connect("Ativar_Ui_Para_Zona_Industrial",Callable(self,"Ativar_Ui_Zona_Industrial"))
	
	ZonaUiManager.connect("Ui_Zona_Config_Disabled",Callable(self,"disabled_ui_config"))
	ZonaUiManager.connect("Ui_Zona_Constru_Disabled",Callable(self,"disabled_ui_constru"))


func disabled_ui_config():
	$Zona_Industrial_Config.visible = false
	
	#zona_atual_ativa = null
	pass

func disabled_ui_constru():
	
	$zona_industrial_construcao.visible = false
	zona.Current_State_Visual_Zona = zona.State_Visual_Zona.BuildDisabled
	zona.State_Visual()
	zona = null

func Ativar_Ui_Zona_Industrial(value):
	zona = value
	match zona.Current_State_Ui_Zona:
		#Se AZona for zerada entao Ela vai para ui de configuracao
		zona.State_Ui_Zona.ConfigInicial:
			if Ui_Zona_Ativada:
				pass
			else:
		
				emit_signal("Ativar_Ui_Zona_Config",zona)
				ZonaUiManager.ui_ativada_da_zona = true
				Ui_Zona_Ativada = true
				

		zona.State_Ui_Zona.Config:
			

			pass
		
		zona.State_Ui_Zona.Constru:
			if Ui_Zona_Ativada:
				pass
			else:
				Ui_Zona_Ativada = true
				ZonaUiManager.ui_ativada_da_zona = true
				emit_signal("Ativar_Ui_Zona_Constru")
				zona.Current_State_Visual_Zona = zona.State_Visual_Zona.Build
				zona.State_Visual()
				#if zona.especializacao_da_zona_selecionada:
					#zona.Current_State_Zona = zona.State_Zona.ShowGrid
					#disabled_ui_config()

					#pass
				#else:
					#zona.Current_State_Zona = zona.State_Zona.Contrucao
					#zona.State_Visual()
					#disabled_ui_config()
					#ZonaUiManager.ui_ativada_da_zona = true
					#emit_signal("Ativar_Ui_Zona_Constru")
		
		
		
		
