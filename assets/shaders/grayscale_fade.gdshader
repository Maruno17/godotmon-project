shader_type canvas_item;

uniform sampler2D transition_texture;
uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	COLOR.rgb = vec3(0);
	float color_value = 1.0 - texture(transition_texture, UV).r;
	COLOR.a *= step(1.0 - progress, color_value);
}