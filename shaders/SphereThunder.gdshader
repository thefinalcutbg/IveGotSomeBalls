shader_type spatial;
render_mode unshaded;

uniform vec2 direction_and_speed = vec2(0.25, 0.00);
uniform vec2 scale = vec2(1.0);
uniform bool flip = false;
uniform sampler2D albedo: hint_albedo;

void fragment() {
	vec2 uv = UV * scale - direction_and_speed * TIME;
	if (flip) { uv = 1.0 - uv; }
	ALBEDO = texture(albedo, uv).rgb;
}