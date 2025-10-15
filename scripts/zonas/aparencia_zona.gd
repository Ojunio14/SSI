# zona_delimitada.gd
extends Node3D

# --- CONTROLES NO INSPETOR ---
# Aqui você define o tamanho da sua zona diretamente no editor da Godot.
@export var tamanho_da_zona: Vector2 = Vector2(32.0, 32.0)

# Arraste sua cena 'muro_secao.tscn' para este campo no Inspetor.
@export var modelo_muro: PackedScene

# --- CONFIGURAÇÕES DO MODELO ---
# Coloque aqui o comprimento exato do seu modelo de muro.
@export var tamanho_peca_muro: float = 4.0

# Container para manter a cena organizada. Crie um nó Node3D filho chamado "MurosContainer".
@onready var muros_container = $MurosContainer

@onready var line_rect: MeshInstance3D = $LineRect
@onready var fantasma: MeshInstance3D = $Fantasma

var activeBuildingObject : bool 
var objects : Array = []


enum State_Visual_Zona {Selecao,Instanciada,Build,BuildDisabled}
var ativo_modo_selecao = false
# A função _ready() é chamada assim que a zona é colocada no mundo.
# É o lugar perfeito para dar o comando de construção.
func _ready():
	GameManager.connect("DestruirBuild",Callable(self,"DestruirBuilding"))
	get_parent().connect("MudaAparenciaZona",Callable(self,"Estado_Visual_Zona"))
	$ZonaMain.connect("area_entered",Callable(self,"_on_zona_main_area_entered"))
	$ZonaMain.connect("area_exited",Callable(self,"_on_zona_main_area_exited"))


func Estado_Visual_Zona(value,dados_grid):

	
	match value:
		State_Visual_Zona.Selecao:
			self.visible = true
			ativo_modo_selecao = true
			$Modo_Fantasma_Verde.visible = true
			activeBuildingObject = false
			
			
			pass
		State_Visual_Zona.Instanciada:
			ativo_modo_selecao = false
			$Modo_Fantasma_Vermelho.visible = false
			$Modo_Fantasma_Verde.visible = false
			#$Fantasma.visible = true
			self.visible = true
			$MurosContainer.visible = true
			gerar_muros()
			#line_rect.visible = true
			
			pass
		State_Visual_Zona.Build:
			ativo_modo_selecao = false
			self.visible = true
			#fantasma.visible = true
			grid(dados_grid)

		State_Visual_Zona.BuildDisabled:
			#fantasma.visible = false
			grid(dados_grid)
			
			
			#
		#State_Zona.ShowGrid:
			#fantasma.visible = false
			#grid(dados_grid)
			#
		#State_Zona.DisabledGrid:
			#grid(dados_grid)
	
func grid(dados_grid):
	var shader_grid = get_tree().get_first_node_in_group("TerrenoShader")
	
	var material = shader_grid.get_surface_override_material(0)
	material.set_shader_parameter("show_grid", dados_grid["grid"])
	material.set_shader_parameter("zona_centro", dados_grid["coord_grid"])
	material.set_shader_parameter("zona_tamanho", dados_grid["size_zona"])


# A função que faz todo o trabalho de construção.
func gerar_muros():
	# Limpa qualquer muro antigo, caso a função seja chamada novamente.
	for child in muros_container.get_children():
		child.queue_free()

	# Pega as dimensões para facilitar a leitura.
	var largura = tamanho_da_zona.x
	var profundidade = tamanho_da_zona.y

	if largura <= 0 or profundidade <= 0 or tamanho_peca_muro <= 0:
		print("ERRO: Tamanho da zona ou da peça do muro é inválido.")
		return

	# --- CONSTRUÇÃO DO MURO NORTE (+Z) ---
	var num_pecas_largura = int(ceil(largura / tamanho_peca_muro))
	for i in range(num_pecas_largura):
		var muro = modelo_muro.instantiate()
		muros_container.add_child(muro)
		var pos_x = -largura / 2.0 + tamanho_peca_muro / 2.0 + i * tamanho_peca_muro
		muro.position = Vector3(pos_x, 0, profundidade / 2.0)
		muro.rotation_degrees.y = 180 # Vira para fora

	# --- CONSTRUÇÃO DO MURO SUL (-Z) ---
	for i in range(num_pecas_largura):
		var muro = modelo_muro.instantiate()
		muros_container.add_child(muro)
		var pos_x = -largura / 2.0 + tamanho_peca_muro / 2.0 + i * tamanho_peca_muro
		muro.position = Vector3(pos_x, 0, -profundidade / 2.0)
		# Rotação padrão (0) já está virada para fora

	# --- CONSTRUÇÃO DO MURO LESTE (+X) ---
	var num_pecas_profundidade = int(ceil(profundidade / tamanho_peca_muro))
	for i in range(num_pecas_profundidade):
		var muro = modelo_muro.instantiate()
		muros_container.add_child(muro)
		var pos_z = -profundidade / 2.0 + tamanho_peca_muro / 2.0 + i * tamanho_peca_muro
		muro.position = Vector3(largura / 2.0, 0, pos_z)
		muro.rotation_degrees.y = 90 # Vira para fora

	# --- CONSTRUÇÃO DO MURO OESTE (-X) ---
	for i in range(num_pecas_profundidade):
		var muro = modelo_muro.instantiate()
		muros_container.add_child(muro)
		var pos_z = -profundidade / 2.0 + tamanho_peca_muro / 2.0 + i * tamanho_peca_muro
		muro.position = Vector3(-largura / 2.0, 0, pos_z)
		muro.rotation_degrees.y = -90 # Vira para fora


func _on_zona_main_area_entered(area: Area3D) -> void:
	if ativo_modo_selecao:
		if activeBuildingObject:
			objects.append(area)
			BuildManager.AbleBuilding = false
			$Modo_Fantasma_Vermelho.visible = true
			$Modo_Fantasma_Verde.visible = false
			print(BuildManager.AbleBuilding)



func _on_zona_main_area_exited(area: Area3D) -> void:
	if ativo_modo_selecao:
		if activeBuildingObject:
			
			objects.remove_at(objects.find(area))
			if objects.size() <= 0:
				$Modo_Fantasma_Vermelho.visible = false
				$Modo_Fantasma_Verde.visible = true
				BuildManager.AbleBuilding = true
