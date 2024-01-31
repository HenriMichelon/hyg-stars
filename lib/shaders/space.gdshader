shader_type sky;

uniform sampler2D background_image: filter_linear, source_color, hint_default_black;

void sky() {
	COLOR = texture(background_image, SKY_COORDS).rgb;
}
