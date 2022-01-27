/* -------------------------------------------------------------------------- */
/*                            D4SCO SHADERS - 0.0.0                           */
/* -------------------------------------------------------------------------- */

#version 120

/* -------------------------------------------------------------------------- */
/*                                   PROGRAM                                  */
/* -------------------------------------------------------------------------- */

uniform sampler2D texture;

varying vec2 texcoord;
varying vec2 lightcoord;
varying vec3 normal;
varying vec4 vcolor;

void main() {
  vec4 color = texture2D(texture, texcoord) * vcolor;

  /*DRAWBUFFERS:012*/
  gl_FragData[0] = color;
  gl_FragData[1] = vec4(normal * 0.5 + 0.5, 1.0);
  gl_FragData[2] = vec4(lightcoord, 0.0, 1.0);
}
