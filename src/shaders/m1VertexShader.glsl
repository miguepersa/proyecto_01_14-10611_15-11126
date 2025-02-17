precision highp float;

uniform float roughnessFactor; 
uniform float u_roughness; // New uniform to control roughness
uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;
uniform float u_freq;
uniform float u_amp;
uniform float u_time;
uniform float u_beatSpeed;
uniform float u_beatLimit;

in vec3 position;
in vec3 normal;
in vec2 uv;

out float vRoughness;
out vec3 vNormal;
out vec3 vPosition;
out vec2 vUv;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main() {
    vNormal = normal;
    vPosition = position;
    vUv = uv;

    // Apply displacement based on roughness
    float displacement = ((random(vPosition.xy)) * u_roughness) + sin(u_time * u_beatSpeed) / u_beatLimit;  
    vec3 displacedPosition = position + (normal * displacement);

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(displacedPosition, 1.0);
}
