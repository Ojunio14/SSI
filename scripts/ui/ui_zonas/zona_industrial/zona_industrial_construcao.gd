extends Control


func _ready() -> void:
	get_parent().connect("Ativar_Ui_Zona_Constru",Callable(self,"ativar_ui_zona_contru"))



func ativar_ui_zona_contru():
	self.visible = true
	pass
