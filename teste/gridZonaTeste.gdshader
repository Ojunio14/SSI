// Define que este é um shader do tipo espacial (para objetos 3D).
shader_type spatial;



uniform bool show_grid = false;

uniform vec3 terreno_cor : source_color;



// --- Parâmetros (Pontes entre GDScript e o Shader) ---
// Estes 'uniforms' são variáveis que podemos controlar de fora (via código).

// A textura base do nosso terreno (ex: grama, terra).
uniform sampler2D textura_terreno : source_color;
// A cor das linhas do grid.
uniform vec4 grid_cor : source_color = vec4(0.0, 0.0, 0.0, 0.5); // Preto semitransparente por padrão
// A espessura das linhas (valores menores = linhas mais finas).
uniform float grid_espessura = 0.02;

// Informações da nossa Zona, que serão enviadas pelo script.
uniform vec3 zona_centro; // Posição central da zona no mundo.
uniform vec2 zona_tamanho; // Tamanho da zona (largura e profundidade).

// --- Variáveis de Passagem ---
// Uma 'varying' é uma variável passada do shader de vértice para o de fragmento.
varying vec3 world_pos;


// --- Shader de Vértice ---
// Este código roda uma vez para cada vértice da malha.
void vertex() {
	// Calcula a posição exata de cada vértice no mundo do jogo...
	// ...e a passa para a variável 'world_pos'.
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

// --- Shader de Fragmento ---
// Este código roda uma vez para CADA PIXEL do objeto na tela.
void fragment() {
	// Pega a cor original da textura do terreno na posição correta.
	vec4 cor_da_textura = texture(textura_terreno, UV);
	//vec3 final_color = cor_terreno.rgb * cor_terreno.rgb;
	// Por padrão, a cor final é a cor do terreno.
	//vec3 cor_final = cor_terreno.rgb;
	
	vec3 final_color = terreno_cor.rgb;//terreno_cor.rgb  * textura_terreno.rgb;
	
	
	if (show_grid){
			// --- Lógica da Zona ---
	// Calcula a distância do pixel atual até o centro da zona (ignorando a altura).
	vec2 dist_do_centro = abs(world_pos.xz - zona_centro.xz);
	
	// Checa se o pixel está DENTRO dos limites retangulares da zona.
	if (dist_do_centro.x < zona_tamanho.x / 2.0 && dist_do_centro.y < zona_tamanho.y / 2.0) {
		
		// --- Lógica do Grid ---
		// Pega a parte fracionária da posição no mundo. Ex: 12.7 -> 0.7
		vec2 pos_fracionaria = fract(world_pos.xz);
		
		// Calcula um fator de grid. Será 1.0 se estiver perto de uma linha, 0.0 caso contrário.
		// Cria uma linha horizontal se a posição Z está perto de um número inteiro.
		float fator_grid_z = step(1.0 - grid_espessura, pos_fracionaria.y) + step(pos_fracionaria.y, grid_espessura);
		// Cria uma linha vertical se a posição X está perto de um número inteiro.
		float fator_grid_x = step(1.0 - grid_espessura, pos_fracionaria.x) + step(pos_fracionaria.x, grid_espessura);
		
		// Combina as linhas horizontais e verticais.
		float fator_grid_total = max(fator_grid_x, fator_grid_z);
		
		// --- Mistura Final ---
		// A função 'mix' mistura duas cores. Se 'fator_grid_total' for 0, usa 'cor_terreno'.
		// Se for 1, usa 'grid_cor'. Valores intermediários criam uma mistura.
		final_color = mix(final_color, grid_cor.rgb, fator_grid_total * grid_cor.a);
		}
			}
	
	// Define a cor final do pixel.
	ALBEDO = final_color;
}