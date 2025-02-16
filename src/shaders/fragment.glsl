precision highp float;

uniform vec3 color;
uniform vec3 u_cameraPosition;

in float vRoughness;
in vec3 vNormal;
in vec3 vPosition;

out vec4 fragColor;

void main() {
	vec3 viewDirection = normalize(u_cameraPosition - vPosition);
    vec3 finalColor = mix(color, vec3(1.0), vRoughness);
    fragColor = vec4(mix(viewDirection, vec3(1.0), vRoughness), 1.0);
}