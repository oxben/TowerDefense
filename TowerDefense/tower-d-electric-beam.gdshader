shader_type particles;

uniform vec2 emitter_global_position;
uniform vec2 target_global_position;

uniform float speed = 120.0;       // pixel/s
uniform float kill_distance = 8.0; // pixels
uniform float jitter_amount = 8.0; // pixels

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

void start() {
	// Emit from emitter global position
    TRANSFORM[3].xy = emitter_global_position;
	// Random initial rotation
	float rotation = hash(TRANSFORM[3].xy) * TAU;
	CUSTOM.x = rotation;
	// Random size
	float n = hash(TRANSFORM[3].xy + TIME);
    float scale = 1.0 + (n - 0.5) * 0.75; // ±50%
    CUSTOM.y = scale;
}

void process() {
    vec2 pos = TRANSFORM[3].xy;

    vec2 to_target = target_global_position - pos;
    float dist = length(to_target);

    if (dist < kill_distance) {
        ACTIVE = false;
    } else {

        vec2 dir = to_target / max(dist, 0.0001);
        vec2 perp = vec2(-dir.y, dir.x);

        // ----------------------------
        // BASE MOTION (stable flow)
        // ----------------------------
        vec2 velocity = dir * speed;

        // ----------------------------
        // CONTROLLED JITTER (±8 px)
        // ----------------------------
        float n = hash(pos * 3.0 + TIME * 2.0);
        float offset = (n - 0.5) * 2.0; // [-1, 1]

        vec2 jitter = perp * offset * jitter_amount;

        // ----------------------------
        // FINAL VELOCITY
        // ----------------------------
        VELOCITY.xy = velocity + jitter;

		// Slow rotation over time (180 deg/s)
		CUSTOM.x += PI * DELTA;
		float a = CUSTOM.x;
		TRANSFORM[0].xy = vec2(cos(a), sin(a));
		TRANSFORM[1].xy = vec2(-sin(a), cos(a));

		// Size
		float s = CUSTOM.y;
    	TRANSFORM[0].xy *= s;
    	TRANSFORM[1].xy *= s;
    }
}