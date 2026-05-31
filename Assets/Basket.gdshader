shader_type canvas_item;

uniform float lighten : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    col.rgb = mix(col.rgb, vec3(1.0), lighten);  // blends toward white
    COLOR = col;
}