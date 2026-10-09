shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_never, shadows_disabled;

uniform vec4 bolt_color : source_color = vec4(0.12, 0.4, 1.0, 1.0);
uniform float brightness : hint_range(0.0, 2.0) = 1.0;

void fragment() {
	float edge = abs(UV.x * 2.0 - 1.0);
	float halo = pow(max(1.0 - edge, 0.0), 2.0);
	float core = 1.0 - smoothstep(0.08, 0.3, edge);
	// The soft blue skirt remains visible even in levels with bloom disabled.
	ALBEDO = (bolt_color.rgb * halo * 2.0 + vec3(0.8, 0.92, 1.0) * core * 4.0) * brightness;
	ALPHA = (1.0 - smoothstep(0.6, 1.0, edge)) * clamp(brightness, 0.0, 1.0);
}
