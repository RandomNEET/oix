#language slang 2026
import kitty_custom_shader_types;

static const int LAYERS = 3;
static const float DENSITY = 20.0f;
static const float STAR_SIZE = 0.06f;
static const float BRIGHTNESS = 0.6f;
static const float3 STAR_COLOR = float3(0.9f, 0.93f, 1.0f);
static const float BLEND_THRESH = 0.5f;
static const float FLY_SPEED = 0.04f;

float starHash(float2 p) {
    p = frac(p * float2(127.1f, 311.7f));
    p += dot(p, p + 19.19f);
    return frac(p.x * p.y);
}

float starCell(float2 cellID, float2 cellUV, float layer, float time) {
    float2 seed = cellID + float2(layer * 17.3f, layer * 5.7f);
    float2 pos = float2(0.2f + starHash(seed) * 0.6f,
                        0.2f + starHash(seed + 0.5f) * 0.6f);
    float dist = length(cellUV - pos);
    float size = STAR_SIZE * (0.4f + starHash(seed + 2.0f) * 0.6f);
    float speed = 0.3f + starHash(seed + 5.0f) * 0.5f;
    float phase = starHash(seed + 6.0f) * 6.28318f;
    float twinkle = 0.75f + 0.25f * sin(time * speed + phase);
    float alpha = (0.5f + starHash(seed + 3.0f) * 0.5f) * BRIGHTNESS * twinkle;
    return alpha * (1.0f - smoothstep(size * 0.1f, size * 0.5f, dist));
}

public float4 fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float aspect = float(d.viewport_size_pixels.x) / max(float(d.viewport_size_pixels.y), 1.0f);
    float2 centeredUV = (t.pos - 0.5f) * float2(aspect, 1.0f);
    float brightness = 0.0f;
    for (int i = 0; i < LAYERS; i++) {
        float layer = float(i);
        float depth = 0.4f + layer * 0.5f;
        float zoom = 1.0f + frac(d.timestamp * FLY_SPEED * depth);
        float2 gridUV = centeredUV / zoom * DENSITY * (1.0f + layer * 0.4f);
        float edgeFade = 1.0f - smoothstep(0.3f, 0.8f, length(centeredUV));
        brightness += starCell(floor(gridUV), frac(gridUV), layer, d.timestamp)
                    * (1.0f - layer * 0.2f) * edgeFade;
    }
    float3 srgb = select(color.rgb <= 0.0031308f, color.rgb * 12.92f,
                        1.055f * pow(max(color.rgb, float3(0.0f)), float3(1.0f / 2.4f)) - 0.055f);
    float luma = dot(srgb, float3(0.299f, 0.587f, 0.114f));
    float blend = smoothstep(BLEND_THRESH * 0.4f, BLEND_THRESH, 1.0f - luma);
    float3 result = srgb + STAR_COLOR * brightness * blend;
    float3 linear = select(result <= 0.04045f, result / 12.92f,
                          pow((result + 0.055f) / 1.055f, float3(2.4f)));
    return float4(linear, color.a);
}
