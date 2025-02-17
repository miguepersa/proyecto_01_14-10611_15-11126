#define PI 3.1415926535

precision highp float;

uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;
uniform float u_time;
uniform float u_roughness;

in vec3 position;
in vec3 normal;
in vec2 uv;
out vec3 vPosition;
out vec3 vNormal;
out vec2 vUv;
out float vPattern;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float noise(in vec2 st) {
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

float smoothMod(float axis, float amp, float rad) {
    float top = cos(PI * (axis / amp)) * sin(PI * (axis / amp));
    float bottom = pow(sin(PI * (axis / amp)), 2.0) + pow(rad, 2.0);
    float at = atan(top / bottom);
    return amp * (1.0 / 2.0) - (1.0 / PI) * at;
}

float fit(float unscaled, float originalMin, float originalMax, float minAllowed, float maxAllowed) {
    return (maxAllowed - minAllowed) * (unscaled - originalMin) / (originalMax - originalMin) + minAllowed;
}

float wave(vec2 pos) {
    return fit(smoothMod(pos.y * 15.0, 1.0, 1.5), 0.35, 0.6, 0.0, 1.0);
}

void main() {
    vec2 coords = uv;
    coords.y += (u_time);
    coords += noise(coords);
    float pattern = wave(coords);

    vPosition = position;
    vNormal = normal;
    vUv = uv;
    vPattern = pattern;

    vec3 newPos = normal * pattern * 0.5 * u_roughness;
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position.x, position.y, newPos.z, 1.0);
}