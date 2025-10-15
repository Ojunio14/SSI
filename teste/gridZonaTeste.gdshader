// Define que este é um shader do tipo espacial (para objetos 3D).
shader_type spatial;

// --- Parâmetros ---
uniform float grid_size = 1.0;
uniform bool show_grid = false;
uniform vec3 terreno_cor : source_color;
uniform sampler2D textura_terreno : source_color;
uniform vec4 grid_cor : source_color = vec4(0.0, 0.0, 0.0, 0.5);

// uniform float grid_espessura = 0.02; // AVISO: Não é mais usado pela nova lógica.

uniform vec3 zona_centro;
uniform vec2 zona_tamanho;

// NOVO UNIFORM PARA CONTROLAR A FINURA DA LINHA
// Valores maiores que 1.0 deixam a linha mais fina e nítida.
// Você pode ajustar o "hint_range" se precisar de valores maiores.
uniform float grid_finura : hint_range(1.0, 10.0) = 2.0;


// --- Variáveis de Passagem ---
varying vec3 world_pos;


// --- Shader de Vértice ---
void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}


// --- Shader de Fragmento (com controle de finura) ---
void fragment() {
	vec4 cor_da_textura = texture(textura_terreno, UV);
	vec3 final_color = terreno_cor.rgb;
	
	if (show_grid) {
		// --- Lógica da Zona (Sem 'if') ---
		vec2 meio_tamanho = zona_tamanho / 2.0;
		vec2 dist_do_centro = abs(world_pos.xz - zona_centro.xz);
		float mask_x = 1.0 - step(meio_tamanho.x, dist_do_centro.x);
		float mask_z = 1.0 - step(meio_tamanho.y, dist_do_centro.y);
		float dentro_da_zona = mask_x * mask_z;
		
		// --- Lógica do Grid com fwidth() ---
		vec2 world_pos_scaled = world_pos.xz / grid_size;
		vec2 fw = fwidth(world_pos_scaled);
		vec2 grid_line = abs(fract(world_pos_scaled - 0.5) - 0.5);
		grid_line = grid_line - fw * 0.5;
		
		// AQUI É A MUDANÇA: Multiplicamos pelo nosso fator de finura
		vec2 grid_aa = (grid_line / fw) * grid_finura;
		
		float fator_grid_total = min(grid_aa.x, grid_aa.y);
		fator_grid_total = 1.0 - clamp(fator_grid_total, 0.0, 1.0);
		
		// --- Mistura Final ---
		float fator_de_mistura = fator_grid_total * grid_cor.a * dentro_da_zona;
		final_color = mix(final_color, grid_cor.rgb, fator_de_mistura);
	}
	
	ALBEDO = final_color;
}