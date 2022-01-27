/* -------------------------------------------------------------------------- */
/*                            D4SCO SHADERS - 0.0.0                           */
/* -------------------------------------------------------------------------- */

#version 120

/* -------------------------------- Includes -------------------------------- */

#include "D4SCO/helpers.glsl"

/* -------------------------------------------------------------------------- */
/*                                   PROGRAM                                  */
/* -------------------------------------------------------------------------- */

varying vec2 texcoord;
varying vec2 lightcoord;
varying vec3 normal;
varying vec4 vcolor;

void main() {
  gl_Position = ftransform();

  texcoord = gl_MultiTexCoord0.xy;
  normal = gl_NormalMatrix * gl_Normal;

  lightcoord = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.xy;
  lightcoord = (lightcoord * 33.05 / 32.0) - (1.05 / 32.0);

  vcolor = gl_Color;
}