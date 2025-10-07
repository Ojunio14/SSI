extends Node


signal AtivarZona




func _input(_event: InputEvent) -> void:
	#if get_viewport().gui_is_hovering_ui():
		#return
	if Input.is_action_just_pressed("MouseLeft") and GameManager.not_interaction_world:
	
		
		var result = BuildManager.RayCast()
		if result["collider"].is_in_group("ZonaMain"):
			if result["collider"].get_parent().get_parent().get_parent().name == "Zonas":
				var zona = result["collider"].get_parent().get_parent()
				ZonaUiManager.emit_signal("Zona_Ativada")
				#print("okkkkkkkkkk")
				pass
	if Input.is_action_just_pressed("destroy"):
		if ZonaUiManager.ui_ativada_da_zona:
			ZonaUiManager.emit_signal("Ui_Zona_Config_Disabled")
			
		#ZonaUiManager.emit_signal("Zona_Ativada")
		pass
