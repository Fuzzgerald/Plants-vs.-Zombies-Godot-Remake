shader_type canvas_item;

uniform float cooldown_ratio : hint_range(0.0, 1.0) = 0.0;
uniform float can_afford : hint_range(0.0, 1.0) = 1.0;
uniform float is_selected : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // BASE COLOR (affordability)
    vec3 base_color = mix(
        tex.rgb * 0.5,   // greyed
        tex.rgb,         // normal
        can_afford
    );

    // SELECTED BOOST (slight white lift)
    base_color = mix(
        base_color,
        vec3(1),
        is_selected
    );

    // COOLDOWN OVERLAY (dark wipe from top to bottom)
    if (UV.y > (1.0 - cooldown_ratio)) {
        base_color *= 0.35;
    }

    COLOR = vec4(base_color, tex.a);
}