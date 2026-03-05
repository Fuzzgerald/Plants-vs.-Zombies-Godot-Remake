shader_type canvas_item;

uniform float white_tint: hint_range(0.0, 0.5) = 0;
uniform float grey_tint: hint_range(0.0, 0.35) = 0;
uniform float yellow_tint: hint_range(0.0, 0.25) = 0;

uniform float cooldown_ratio: hint_range(0.0, 1.0) = 0;
uniform float fade_ratio: hint_range(0.0, 1.0) = 1;
uniform float progress_ratio : hint_range(0.0, 1.0) = 1.0;


uniform vec3 white_color: source_color;
uniform vec3 grey_color: source_color;
uniform vec3 yellow_color: source_color;



void fragment() {
	vec4 base = texture(TEXTURE, UV);
	
	vec3 color = base.rgb;
	
	color = mix(
	color, 
	white_color, 
	white_tint
	);
	
	color = mix(
	color, 
	grey_color, 
	grey_tint
	);
	
	color = mix(
	color, 
	yellow_color, 
	yellow_tint
	);
	
	if (UV.y > (1.0 - cooldown_ratio)) {
      color *= 0.35;
    }
	
	if (UV.x < 1.0 - progress_ratio) {
        discard;
    }

	base.a *= fade_ratio;
	
	COLOR = vec4(color, base.a);
}