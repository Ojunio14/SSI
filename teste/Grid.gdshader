// NOTE: Este shader combina a lógica de StandardMaterial3D com o grid manual.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

// --- Uniforms do Material e do Grid ---
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform bool show_grid = false;
uniform vec4 grid_color : source_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform float grid_size = 1.0;
uniform float line_thickness = 0.05;


uniform bool is_selecting_area = false; // Liga/desliga a pintura da seleção
uniform vec3 selection_start_pos;       // Posição 3D onde o jogador clicou
uniform vec3 selection_end_pos;         // Posição 3D atual do mouse
uniform vec4 selection_color : source_color = vec4(0.2, 0.8, 1.0, 0.4); // Cor da seleção





// --- A "PONTE" (Varying) ---
// Esta variável levará a posição do mundo do vertex() para o fragment().
varying vec3 world_pos;


// --- OFICINA 1: vertex() ---
void vertex() {
	// É AQUI que sua lógica com VERTEX funciona!
	// Uma pequena correção: para ir do espaço do modelo para o mundo, a matriz mais
	// direta e correta é a MODEL_MATRIX. O resultado é o mesmo.
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

// --- OFICINA 2: fragment() ---
void fragment() {
	 // --- CAMADA 1: COR BASE DO TERRENO ---
	// Pega a cor original da textura e do uniform
	vec4 albedo_tex = texture(texture_albedo, UV);
	vec3 final_color = albedo.rgb * albedo_tex.rgb;


    // --- CAMADA 2: PINTURA DA ÁREA DE SELEÇÃO ---
    if (is_selecting_area) {
        // Pega a posição do pixel e o tamanho do grid (deve ser o mesmo uniform do seu grid)
        vec2 pixel_pos = world_pos.xz;
        float grid_s = grid_size; // Reutiliza o uniform do seu grid

        // Converte as posições 3D da seleção para células de grid 2D
        vec2 start_cell = floor(selection_start_pos.xz / grid_s);
        vec2 end_cell = floor(selection_end_pos.xz / grid_s);

        // Converte a posição do pixel atual para sua célula de grid
        vec2 current_cell = floor(pixel_pos / grid_s);

        // Encontra os cantos mínimo e máximo do retângulo de células
        vec2 min_cell = min(start_cell, end_cell);
        vec2 max_cell = max(start_cell, end_cell);

        // Checa se a célula do pixel atual está dentro do retângulo de células
        bool in_x = current_cell.x >= min_cell.x && current_cell.x <= max_cell.x;
        bool in_z = current_cell.y >= min_cell.y && current_cell.y <= max_cell.y;

        if (in_x && in_z) {
            // Se estiver dentro, mistura a cor atual com a cor da seleção
            final_color = mix(final_color, selection_color.rgb, selection_color.a);
        }
    }


	// Lógica do Grid
	if (show_grid) {
		// RECEBEMOS a posição da "ponte", em vez de tentar calculá-la aqui.


		// Usa o X e Z para o plano do chão
		vec2 grid_coords = abs(mod(world_pos.xz, grid_size));

		// O resto da lógica do grid
		vec2 grid_lines = smoothstep(line_thickness, 0.0, grid_coords);
		float grid_strength = max(grid_lines.x, grid_lines.y);

		// Mistura a cor final com a cor do grid
		final_color = mix(final_color, grid_color.rgb, grid_strength * grid_color.a);
	}

	// Atribui o resultado final à saída ALBEDO.
	ALBEDO = final_color;
}