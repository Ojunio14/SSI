extends Node3D

#------------------------------PackedScene-------------------------------------------
#Carregas Scenes das Towes
#var BALISTA_TOWER : PackedScene = ResourceLoader.load("res://scene/scene_world/build/turret/balista/balista_lvl_1.tscn")#ResourceLoader.load("res://scene/scene_world/build/turret/balista/balista_lvl_1.tscn")
#var WIZARD_TOWER : PackedScene = ResourceLoader.load("res://scene/scene_world/build/turret/Wizard/Wizard_lvl_1.tscn")
#var ZONA_LEVEL_1 : PackedScene = ResourceLoader.load("res://teste/zona_1.tscn")
var ZONA_MAIN : PackedScene = ResourceLoader.load("res://scenes/game/zona/zona_industrial.tscn")
#CurrentSpawnable Variavel onde vai ter a Scene de uma Torre
var CurrentSpawnable : Node3D#StaticBody3D
var AbleBuilding : bool = true

#--------------------------------------------------------------

func _physics_process(_delta: float) -> void:
#Verifica se estou no modo de Construçao
	if GameManager.CurrentState == GameManager.State.Buildling:
		var RayCast = Ray_Cast_Plane()
		if RayCast != null:
			#CurrentSpawnable e uma Scene é vai receber a Position do mouse
			#CurrentSpawnable.activeBuildingObject
			CurrentSpawnable.global_position = Vector3(round(RayCast.x),RayCast.y,round(RayCast.z))#Vector3(vec3.x,0,vec3.z)
			#CurrentSpawnable.activeBuildingObject = true
		#Destroy Scene que estiver recebendo as cordenadas do mouse 
		if Input.is_action_just_pressed("destroy"):
				
				CurrentSpawnable.queue_free()
				GameManager.CurrentState = GameManager.State.Play
		#Verifica se area das Construçoes nao estao se colidindo
		if AbleBuilding:
			if Input.is_action_just_pressed("MouseLeft") :
				var obj := CurrentSpawnable.duplicate()
				get_tree().root.get_node("Main/World/Teste_Contrucacao/Zonas").add_child(obj)
				#obj.activeBuildingObject = false
				obj.global_position = CurrentSpawnable.global_position

#------------------------------Instanciaçao das Scenes-------------------------------------------

#essas scenes vao ser chamadas nos Script Controle_de_Compra
#func Spawn_Balista_tower() -> void:
	#SpawnOBj(BALISTA_TOWER)
#
#func Spawn_Wizard_tower() -> void:
	#SpawnOBj(WIZARD_TOWER)

#func Spawn_Zona_level_1() -> void:
	#SpawnOBj(ZONA_LEVEL_1)

func Spawn_Zona_Main() -> void:
	SpawnOBj(ZONA_MAIN)


#function usada para instancia as Scenes
func SpawnOBj(obj : PackedScene):
#Obj vai receber uma PackedScene
	if CurrentSpawnable != null:
		CurrentSpawnable.queue_free()
	CurrentSpawnable = obj.instantiate()
	CurrentSpawnable.is_in_group("")
	get_tree().root.get_node("Main/World/Teste_Contrucacao/fantasma").add_child(CurrentSpawnable)
	GameManager.CurrentState = GameManager.State.Buildling







#------------------------------Ray_Cast-------------------------------------------
#====Essas Duas Functions fazem um RayCast====

#Faz um RayCast da camera ate o mouse
func Ray_Cast_Mouse():
	var space_state = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	var mousepos = get_viewport().get_mouse_position()
	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * 1000#RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	#query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if not result.is_empty():
			return result["position"]

#Faz um RayCast da camera ate o mouse Usando Um Plane
func Ray_Cast_Plane() -> Vector3:

	var camera = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
	var cursorPos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
	return cursorPos


const RAY_LENGTH = 1000
func RayCast():
	var space_state = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()#$Camera3D
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	return result
