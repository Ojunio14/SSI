extends Node


signal AtivarZona




func _input(_event: InputEvent) -> void:

	if Input.is_action_just_pressed("MouseLeft") and GameManager.not_interaction_world and BuildManager.BuildAtiva:
		var result = BuildManager.RayCast()
		if result["collider"].is_in_group("ZonaMain"):
			if result["collider"].get_parent().get_parent().get_parent().name == "Zonas":
				var zona = result["collider"].get_parent().get_parent()
				
				zona.emit_signal("IniciaZona")
				

	if Input.is_action_just_pressed("destroy"):
		if ZonaUiManager.ui_ativada_da_zona:
			ZonaUiManager.emit_signal("Ui_Zona_Config_Disabled")
			ZonaUiManager.emit_signal("Ui_Zona_Constru_Disabled")
			
