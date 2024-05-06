shader_type spatial;

uniform sampler2D albedo_tex;
uniform sampler2D noise_tex1;
uniform sampler2D noise_tex2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 noise_uv = UV;
	vec2 noise = vec2(texture(noise_tex1, noise_uv).r, texture(noise_tex2, noise_uv).r);
	ALBEDO = texture(albedo_tex, UV).rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
