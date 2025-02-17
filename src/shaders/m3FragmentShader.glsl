#define PI 3.1415926535

precision highp float;

uniform vec3 u_cameraPosition;  // Camera position
uniform vec3 u_lightPosition;   // Light position
uniform vec3 u_lightColor;      // Light color
uniform vec3 u_objectColor;     // Base object color
uniform float u_lightIntensity; // Light intensity
uniform float u_metallic;       // Metallic factor (0 = plastic, 1 = metal)
uniform float u_roughness;      // Surface roughness
uniform float u_time;           // Time variable

in vec3 vPosition;  // Vertex position
in vec3 vNormal;    // Vertex normal
in vec2 vUv;        // UV coordinates
in float vPattern;  // Pattern factor

out vec4 fragColor;

void main() {
    // Normalize inputs
    vec3 norm = normalize(vNormal);
    vec3 lightDir = normalize(u_lightPosition - vPosition);
    vec3 viewDir = normalize(u_cameraPosition - vPosition);
    
    // Compute diffuse lighting
    float diff = max(dot(norm, lightDir), 0.0);

    // Fresnel Effect for metallic reflection
    float fresnel = pow(1.0 - max(dot(viewDir, norm), 0.0), 5.0);

    // Specular reflection (Blinn-Phong model)
    vec3 halfDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(norm, halfDir), 0.0), mix(4.0, 64.0, 1.0 - u_roughness));

    // Mix diffuse and specular based on metallic level
    vec3 diffuseColor = u_objectColor * diff * (1.0 - u_metallic);
    vec3 specularColor = mix(vec3(0.04), u_objectColor, u_metallic) * spec;

    // Final color blending
    vec3 finalColor = diffuseColor + specularColor * u_lightColor * u_lightIntensity;

    // Add pattern effect
    fragColor = vec4(finalColor + vPattern * 0.1, 1.0);
}
