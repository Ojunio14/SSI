extends BaseZone

#1b2929

var Zone := BaseZone.new()
#var janela_visivel

var construcao_fantasma : bool = true

var eventos
var state_zona_inicial


var dados_zonas : Dictionary = {"teste":"deu certo"}

var size_zona : Vector2 = Vector2(30,30)


func _ready() -> void:
	ZonaUiManager.connect("Zona_Ativada",Callable(self, "ativar_zona"))
	
	#BaseZone.new()
	pass




func ativar_zona():
	ZonaUiManager.emit_signal("Ui_Zona_Config_Visible")
	
	ZonaUiManager.emit_signal("Ativar_Ui_Zona_Config",dados_zonas,1)
	
	
	pass
