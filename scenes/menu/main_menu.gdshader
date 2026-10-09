shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap, repeat_enable;
uniform vec2 texture_tiling = vec2(7.0, 5.0);
uniform vec2 wave_frequency = vec2(9.0, 5.0);
uniform float distortion_factor : hint_range(0.0, 1.5) = 0.8;
uniform float distortion_speed : hint_range(0.0, 2.0) = 0.5;
uniform float bulge_height : hint_range(0.0, 1.0) = 0.6;

// Height and its two derivatives form a continuous, signed wave field.
// Crossing waves make alternating concave and convex patches travel across the sheet.
vec3 wave_field(vec2 uv, float t) {
	vec2 q = uv * wave_frequency * TAU;
	float a = q.x + t * 1.4;
	float b = q.y - t * 0.9;
	float c = q.x * 0.7 + q.y * 0.8 - t * 1.2;
	float d = q.x * 1.3 - q.y * 0.6 + t;
	float height = 0.5 * sin(a) * cos(b) + 0.3 * sin(c) + 0.2 * sin(d);
	float dx = 0.5 * cos(a) * cos(b) + 0.21 * cos(c) + 0.26 * cos(d);
	float dy = -0.5 * sin(a) * sin(b) + 0.24 * cos(c) - 0.12 * cos(d);
	return vec3(height, dx, dy);
}

void vertex() {
	float t = TIME * distortion_speed;
	vec3 wave = wave_field(UV, t);
	VERTEX.y += wave.x * bulge_height * distortion_factor;
}

void fragment() {
	float t = TIME * distortion_speed;
	vec3 wave = wave_field(UV, t);
	// The image bends smoothly with the cloth; no cells, rings, or glass outlines.
	vec2 warped_uv = UV + wave.yz * vec2(0.012, 0.018) * distortion_factor;
	vec3 image = texture(albedo_tex, warped_uv * texture_tiling).rgb;
	vec2 slope = wave.yz * wave_frequency * TAU / vec2(40.0, 15.0);
	slope *= bulge_height * distortion_factor;
	vec3 surface_normal = normalize(vec3(-slope.x, -slope.y, 1.0));
	vec3 light_direction = normalize(vec3(-0.45, 0.65, 1.0));
	float lighting = 0.68 + 0.3 * max(dot(surface_normal, light_direction), 0.0);
	ALBEDO = image * lighting;
}
