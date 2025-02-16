precision highp float;

uniform float roughnessFactor;
uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;
in vec3 position;
in vec3 normal;
in vec2 uv;

out float vRoughness;
out vec3 vNormal;
out vec3 vPosition;
out vec2 vUv;

void main() {
    vRoughness = clamp(roughnessFactor, 0.0, 1.0);
    vNormal = normal;
    vPosition = position;
    vUv = uv;
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);
}