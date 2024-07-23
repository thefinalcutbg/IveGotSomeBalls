shader_type spatial;

uniform sampler2D albedo_tex;
uniform sampler2D noise_tex1;
uniform sampler2D noise_tex2;
uniform float distortion_factor;
uniform float distortion_speed;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 noise_uv = UV + TIME*distortion_speed;
	vec2 noise = vec2(texture(noise_tex1, noise_uv).r, texture(noise_tex2, noise_uv).r);
	vec2 base_uv = UV + noise*distortion_factor;
	ALBEDO = texture(albedo_tex, base_uv).rgb;
	
}
