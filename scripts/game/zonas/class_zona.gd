# A linha 'class_name' é extremamente importante.
# Ela registra este script como um novo "tipo" na Godot.
# Isso nos permite usar "BaseZone" em outros scripts (como em `extends BaseZone`)
# e também como uma dica de tipo (ex: var zona: BaseZone).
class_name BaseZone
extends Node3D

# Um 'enum' é uma forma segura de criar uma lista de opções.
# Em vez de usarmos strings como "siderurgia" (que podemos digitar errado),
# usamos BaseZone.ZoneType.SIDERURGIA, e o Godot nos ajuda com o autocompletar.
enum ZoneType {
	GENERICO,
	SIDERURGIA,
	PESQUISA,
	AGRICULTURA
}


var janela_visivel : bool = false

# A anotação '@export' transforma esta variável em um campo no Inspetor da Godot.
# Isso permite que você ou um designer de níveis possa escolher o tipo da zona
# com um menu dropdown, sem precisar mexer no código.
@export var tipo_de_zona: ZoneType = ZoneType.GENERICO

# Este dicionário é o coração da nossa lógica de detecção.
# A chave será o objeto (módulo) que entrou na zona.
# O valor será um NÚMERO que conta em quantas 'Area3D' esse objeto está.
var corpos_na_zona = {}

# Uma lista simples para sabermos quais objetos estão, oficialmente, dentro da zona lógica.
var modulos_ativos = []

# A anotação '@onready' faz com que a Godot espere até que a cena esteja
# completamente carregada antes de atribuir esta variável. Isso evita erros se
# o script tentar encontrar o nó "PhysicsZone" antes que ele exista.
@onready var physics_zone = $PhysicsZone

# --- SEÇÃO DE LÓGICA COMUM ---

# Esta função será chamada para adicionar novas expansões à zona.
# Ela cria a 'Area3D' que faz a detecção física.
func adicionar_expansao(posicao: Vector3, tamanho: Vector3):
	var nova_area = Area3D.new()
	var shape_node = CollisionShape3D.new()
	shape_node.shape = BoxShape3D.new()
	shape_node.shape.size = tamanho
	
	nova_area.add_child(shape_node)
	nova_area.position = posicao
	
	# Esta é a conexão do sinal via código. Estamos dizendo:
	# "Quando o sinal 'body_entered' da 'nova_area' for emitido,
	# chame a função '_on_body_entered_area' DESTE SCRIPT."
	nova_area.body_entered.connect(_on_body_entered_area)
	nova_area.body_exited.connect(_on_body_exited_area)
	
	physics_zone.add_child(nova_area)

# Esta função é o "receptor" do sinal de entrada.
func _on_body_entered_area(body):
	# Primeiro, fazemos verificações de segurança. O corpo é um módulo válido?
	# Ele é compatível com este tipo de zona?
	# Usamos 'get_meta' que é uma forma segura de checar propriedades em qualquer nó.
	if not body.has_meta("zonas_compativeis") or not body.get_meta("zonas_compativeis").has(tipo_de_zona):
		return # Se não for compatível, a função para aqui.

	# Pega a contagem atual (ou 0 se for a primeira vez) e adiciona 1.
	var contagem_anterior = corpos_na_zona.get(body, 0)
	corpos_na_zona[body] = contagem_anterior + 1
	
	# A MÁGICA: Apenas se a contagem anterior era 0, significa que o módulo
	# ACABOU DE ENTRAR na nossa super-zona.
	if contagem_anterior == 0:
		modulos_ativos.append(body)
		_aplicar_bonus_especifico(body) # Chama a função de bônus que a filha irá definir.

# Esta função é o "receptor" do sinal de saída.
func _on_body_exited_area(body):
	if not corpos_na_zona.has(body): return # Verificação de segurança

	corpos_na_zona[body] -= 1
	
	# A MÁGICA: Apenas se a contagem chegou a 0, significa que o módulo
	# ACABOU DE SAIR da última área em que estava.
	if corpos_na_zona[body] == 0:
		corpos_na_zona.erase(body)
		modulos_ativos.erase(body)
		_remover_bonus_especifico(body) # Chama a função de remoção de bônus.


# --- SEÇÃO DE FUNÇÕES "MODELO" (PARA AS FILHAS PREENCHEREM) ---

# Deixamos esta função "em branco" de propósito.
# Cada tipo de zona (Siderurgia, Pesquisa) terá sua própria versão desta função
# para aplicar seu bônus único.
func _aplicar_bonus_especifico(body):
	# O 'pass' significa "não faça nada".
	pass

# Também deixamos esta em branco para que as filhas possam implementar
# a lógica correta para remover seu bônus específico.
func _remover_bonus_especifico(body):
	pass
