precision highp float;

uniform vec3 color;
uniform vec3 u_cameraPosition;
uniform float u_freq;
uniform float u_amp;

in vec3 vNormal;
in vec3 vPosition;

out vec4 fragColor;

void main() {
	
    vec3 viewDirection = normalize(u_cameraPosition - vPosition);
    vec3 negative = vec3(1.0f) - viewDirection;
    vec3 finalColor = mix(viewDirection, negative, (sin(((vPosition.x) / 2.0) * u_freq) + 1.0f) / 2.0);
    fragColor = vec4(finalColor, 1.0);

}