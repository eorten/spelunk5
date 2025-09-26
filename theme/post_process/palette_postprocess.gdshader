shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform int levels : hint_range(2, 256) = 256;

void fragment() {
    vec4 src_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec3 color = src_color.rgb;

    vec3 quantized = floor(color * float(levels)) / float(levels);

    COLOR = vec4(quantized, src_color.a);
}
