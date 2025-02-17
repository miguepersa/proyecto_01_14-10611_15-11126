precision highp float;

uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 u_normalMat;

in vec3 position;
in vec3 normal;

out vec3 vnormal;
out vec3 vpos;

void main() {
  gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);

  vec4 vertPos4 = modelMatrix * vec4(position, 1.0);
  vpos = vec3(vertPos4) / vertPos4.w;
  vnormal = vec3(u_normalMat * vec4(normal, 0.0));
}

