#define PI 3.1415926535

precision highp float;

uniform vec3 u_cameraPosition;
uniform float u_time;

in vec3 vPosition;
in vec3 vNormal;
in vec2 vUv;
in float vPattern;

out vec4 fragColor;

void main() {

	fragColor = vec4(vPattern, 0.2 + vPattern, 0.55 + vPattern, 1.0);
}