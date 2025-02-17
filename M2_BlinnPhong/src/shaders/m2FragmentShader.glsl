precision highp float;

uniform vec3 u_cameraPosition;

uniform vec3 u_lightPos;
uniform vec3  u_lightColor;
uniform vec3  u_materialColor;
uniform vec3  u_specularColor;
uniform float u_brightnessLevel;
uniform float u_shininess;

in vec3 vnormal;
in vec3 vpos;

out vec4 fragColor;

void main() {
  vec3 ambientColor = vec3(0.1, 0.0, 0.0);
  vec3 viewDirection = normalize(u_cameraPosition - vpos);
  
  vec3 normal = normalize(vnormal);
  vec3 lightDir = normalize(u_lightPos - vpos);
  float distance = dot(lightDir, lightDir);

  float lambertian = max(dot(lightDir, normal), 0.0);
  vec3 halfDir = normalize(lightDir + viewDirection);
  float specular = pow(max(dot(halfDir, normal), 0.0), u_shininess);

  vec3 colorLinear = ambientColor + 
                     u_materialColor * lambertian * u_lightColor * u_brightnessLevel / distance + 
                     u_specularColor * specular * u_lightColor * u_brightnessLevel / distance;

  fragColor = vec4(colorLinear, 1.0);

}
