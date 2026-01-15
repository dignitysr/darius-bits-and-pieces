shader_type canvas_item;

uniform bool screen_mode = true;
uniform int num_colors;
uniform float precision : hint_range(0.0, 1.0, 0.001) = 0.1;

uniform sampler2D palette_in;
uniform sampler2D palette_out;

// --- Uniforms --- //
//global uniform vec2 player_position;

uniform float intensity: hint_range(0.0, 1.0, 0.05) = 0.0;

//group_uniforms player;
//uniform float player_influence: hint_range(0.0, 1.0, 0.05) = 0.60;
//uniform float radius: hint_range(0.0, 1.0, 0.05) = 0.05;

varying vec4 modulate;

void vertex() {
    modulate = COLOR;
}

// --- Constants --- //
const mat4 THRESHOLD_MATRIX = mat4(
		vec4(1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0),
		vec4(13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0),
		vec4(4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0),
		vec4(16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0));

vec4 swap_color(vec4 color) {
	float inc = 1.0 / float(num_colors);
	for (int i = 0; i < num_colors; i++) {
		// lets hit the middle of the pixel to make sure it works properly
 		vec2 uv = vec2(float(i) * inc + (inc * 0.5), 0.5); 
		vec4 color_in = texture(palette_in, uv);
		if (distance(color, color_in) <= precision) {
			return texture(palette_out, uv);
		}
	}
	return color;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = swap_color(color);
	vec2 uv = UV / TEXTURE_PIXEL_SIZE;
	COLOR.a *= step(0.0, THRESHOLD_MATRIX[int(uv.x) % 4][int(uv.y) % 4] - intensity);
	COLOR *= modulate;
}
