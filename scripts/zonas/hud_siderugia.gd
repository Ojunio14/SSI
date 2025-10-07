# A palavra 'extends' é como dizemos: "Este script herda TUDO da classe BaseZone".
# Ele já vem com todas as variáveis e funções que escrevemos antes.
# Ele encontra "BaseZone" por causa do 'class_name' que definimos no outro arquivo.
extends BaseZone

# A função '_ready' é chamada quando um nó entra na cena pela primeira vez.
# É o lugar perfeito para configurar as propriedades específicas desta zona.
func _ready():
	# 1. Definimos o tipo desta zona para que a lógica de compatibilidade funcione.
	tipo_de_zona = ZoneType.SIDERURGIA
	
	# 2. Adicionamos a primeira peça física e visual da nossa zona.
	# Esta chamada executa a função 'adicionar_expansao' que está na classe MÃE.
	var csg_box = $VisualZone/CSGCombiner3D/CSGBox3D
	adicionar_expansao(Vector3.ZERO, csg_box.size)


## A palavra 'override' indica que estamos intencionalmente substituindo
## a função "em branco" que veio da classe mãe.
#override func _aplicar_bonus_especifico(body):
	## Esta é a "personalidade" da Zona de Siderurgia.
	#print("BÔNUS DE SIDERURGIA: Aplicado em ", body.name)
	#if body.has_method("set_production_speed_multiplier"):
		#body.set_production_speed_multiplier(1.5) # Aumenta a velocidade em 50%
#
#override func _remover_bonus_especifico(body):
	#print("BÔNUS DE SIDERURGIA: Removido de ", body.name)
	#if body.has_method("set_production_speed_multiplier"):
		#body.set_production_speed_multiplier(1.0) # Volta à velocidade normal
