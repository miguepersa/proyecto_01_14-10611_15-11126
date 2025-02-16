precision highp float;

uniform vec3 color;
uniform vec3 u_cameraPosition;
uniform float u_noiseFactor;
uniform float u_freq;

in float vRoughness;
in vec3 vNormal;
in vec3 vPosition;

out vec4 fragColor;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

void main() {
	
    vec3 viewDirection = normalize(u_cameraPosition - vPosition);
    vec3 negative = vec3(1.0f) - viewDirection;
    vec3 finalColor = mix(viewDirection, negative, (sin(vPosition.x * u_freq) + 1.0f) / 2.0f);

    if (u_noiseFactor == 0.0f) {
        fragColor = vec4(mix(finalColor, vec3(1.0), vRoughness), 1.0);
    }
    else {
        fragColor = vec4(mix(finalColor * noise(vPosition.xy * u_noiseFactor), vec3(1.0), vRoughness), 1.0);
    }
}