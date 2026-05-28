shader_type canvas_item;

void fragment() {
    vec2 size = 1.0 / TEXTURE_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy / size;
    
    float radius = 15.0;
    if (uv.x < radius && uv.y < radius) {
        if (distance(uv, vec2(radius, radius)) > radius) discard;
    }
    if (uv.x > size.x - radius && uv.y < radius) {
        if (distance(uv, vec2(size.x - radius, radius)) > radius) discard;
    }
    
    COLOR = texture(TEXTURE, UV);
}
