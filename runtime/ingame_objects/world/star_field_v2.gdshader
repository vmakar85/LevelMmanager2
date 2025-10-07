shader_type canvas_item;

uniform vec2 res = vec2(1280.0, 720.0);
uniform sampler2D noise_texture: filter_nearest, repeat_enable;

// базовые параметры
uniform float density : hint_range(1.0, 500.0) = 40.0;
uniform int layers : hint_range(1, 8) = 4;
uniform float star_radius : hint_range(0.02, 1.0, 0.01) = 0.12;
uniform float jitter : hint_range(0.0, 0.8, 0.01) = 0.32;
uniform float threshold : hint_range(0.0, 1.0, 0.01) = 0.78;

// скорость и масштаб восприятия
uniform float speed_x : hint_range(-100.0,100.0,1.0) = 0.0;
uniform float speed_y : hint_range(-100.0,100.0,1.0) = -50.0;
uniform float speed_scale : hint_range(0.1,100.0,0.1) = 1.0;

// цвета и яркость
uniform vec4 color_near: source_color = vec4(1.00, 0.96, 0.90, 1.0);
uniform vec4 color_far: source_color  = vec4(0.75, 0.85, 1.00, 1.0);
uniform float global_brightness : hint_range(0.0,4.0,0.01) = 1.0;
uniform bool use_alpha = true;

// редкие звёзды: теперь контролируем цвет, размер и профиль
uniform float rare_chance : hint_range(0.0, 0.05, 0.0001) = 0.004;
uniform float rare_size : hint_range(0.0, 8.0, 0.01) = 0.0; // 0.0 = авто (будет >= 2× большого слоя)
uniform float rare_brightness : hint_range(0.1, 10.0, 0.1) = 3.5;
uniform vec4 rare_color: source_color = vec4(1.0, 0.98, 0.92, 1.0);
uniform float rare_jitter : hint_range(0.0, 0.8, 0.01) = 0.0;

// ---- хеши ----
float hash12(vec2 p) { return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123); }
vec2 hash22(vec2 p){ return vec2(hash12(p), hash12(p + 1.2345)); }

void fragment() {
    vec2 uv = UV;
    uv.x *= res.x / res.y;

    vec2 speed_uv = vec2(speed_x, speed_y) / res.y * TIME * speed_scale;

    vec3 accum = vec3(0.0);

    int L = max(1, layers);
    for (int i = 0; i < L; i++) {
        float fi = float(i);
        float layer_t = fi / max(1.0, float(L - 1));

        float scale = density * mix(0.8, 2.8, layer_t);
        float speed_mul = mix(1.0, 0.12, layer_t);

        vec2 p = uv * scale + speed_uv * speed_mul;

        vec2 cell = floor(p);
        vec2 fpos = fract(p);

        float noise_val = texture(noise_texture, (cell + vec2(0.123*fi, 0.0)) * 0.013).r;
        float layer_threshold = threshold + (layer_t - 0.5) * 0.06;

        if (noise_val > layer_threshold) {
            vec2 rnd = hash22(cell + vec2(12.34 * fi, 98.7 * fi));
            vec2 center = 0.5 + (rnd - 0.5) * jitter;
            float dist = length(fpos - center);

            float rad = star_radius * mix(1.6, 0.7, layer_t);
            float core_r = rad * 0.45;
            float halo_r = rad * 1.8;

            float core = 1.0 - smoothstep(0.0, core_r, dist);
            float halo = 1.0 - smoothstep(core_r, halo_r, dist);
            float intensity = max(core, halo * 0.22);

            intensity *= (0.8 + 0.4 * hash12(cell + vec2(7.7)));
            vec3 layer_color = mix(color_near.rgb, color_far.rgb, layer_t);
            accum += layer_color * intensity * (1.0 - layer_t * 0.3);
        }
    }

    // ---- Редкие крупные звёзды (улучшено) ----
    {
        // минимальный желаемый радиус: 2× largest star в первом слое
        float largest_layer_radius = star_radius * 1.6; // как в основном коде, для layer_t==0
        float target_core = largest_layer_radius * 2.0; // требуемое 2×

        // если rare_size == 0 или меньше target — используем target_core, иначе используем rare_size
        float rr = max(rare_size, target_core);

        // переводим rr в "ядро" и ореол (в долях ячейки rare_scale)
        float rare_core_r = rr * 0.5;   // ядро (в долях ячейки rare_scale)
        float rare_halo_r = rr * 1.0;   // ореол = 2× core по диаметру (т.е. radius*2)

        // scale редкого слоя — реже, т.е. больше ячеек на экран -> меньше совпадений
        float rare_scale = density * 0.28;
        vec2 rp = uv * rare_scale + speed_uv * 0.6;
        vec2 rcell = floor(rp);
        vec2 rf = fract(rp);

        // шанс появления
        float h = hash12(rcell * 3.77 + vec2(12.0));
        if (h < rare_chance) {
            vec2 rnd = hash22(rcell + vec2(77.7));
            vec2 center = 0.5 + (rnd - 0.5) * rare_jitter;
            float dist = length(rf - center);

            // GAUSSIAN-like profiles for smooth perfect circles
            // core_gauss: sharp, falls quickly at core radius
            float core_sigma = max(rare_core_r * 0.45, 0.001);
            float core = exp(- (dist * dist) / (core_sigma * core_sigma)); // 1 at center, small at core_r

            // halo: wider gaussian, lower amplitude
            float halo_sigma = max(rare_halo_r * 0.7, 0.001);
            float halo = exp(- (dist * dist) / (halo_sigma * halo_sigma)) * 0.28;

            // combine and scale
            float ri = core + halo;
            ri *= rare_brightness;

            // add color (rare_color) — сильнее, чтобы отличаться от мелких
            accum += rare_color.rgb * ri;
        }
    }

    accum *= global_brightness;

    if (use_alpha) {
        float alpha = clamp(max(max(accum.r, accum.g), accum.b), 0.0, 1.0);
        COLOR = vec4(accum, alpha);
    } else {
        COLOR = vec4(accum, 1.0);
    }
}
