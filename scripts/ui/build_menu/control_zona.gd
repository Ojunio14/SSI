extends Control

var Zona





func _on_zona_1_button_down() -> void:
	
	#GameManager.CurrentState = GameManager.State.Buildling
	if not BuildManager.CurrentSpawnable != null:
		BuildManager.Spawn_Zona_level_1()
	pass # Replace with function body.



func _on_industria_button_down() -> void:
	if not BuildManager.CurrentSpawnable != null:
		BuildManager.Spawn_Zona_Main()
	




func _on_area_2d_area_entered(area: Area2D) -> void:
	BuildManager.AbleBuildingUi = false
	GameManager.not_interaction_world = false
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	BuildManager.AbleBuildingUi = true
	GameManager.not_interaction_world = true
	
	pass # Replace with function body.
