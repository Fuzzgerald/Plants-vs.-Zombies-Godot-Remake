shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;

/* --- Charge tint --- */
uniform float charge_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 charge_color : source_color = vec4(1.0, 0.99, 0.95, 1.0);

/* --- Fade --- */
uniform float fade : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	/* Damage flash (white) */
	vec4 flashed = mix(
		tex,
		vec4(1.0, 1.0, 1.0, tex.a),
		flash_amount
	);

	/* Yellow charge tint */
	vec4 charged = mix(
		flashed,
		charge_color * flashed.a,
		charge_amount
	);

	/* Final output (fade applied) */
	charged.a *= fade;
	COLOR = charged;
}
