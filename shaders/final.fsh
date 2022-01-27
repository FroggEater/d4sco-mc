/* -------------------------------------------------------------------------- */
/*                            D4SCO SHADERS - 0.0.0                           */
/* -------------------------------------------------------------------------- */

#version 120

/* -------------------------------- Includes -------------------------------- */

#include "D4SCO/colorspaces.glsl"

/* -------------------------------------------------------------------------- */
/*                                   PROGRAM                                  */
/* -------------------------------------------------------------------------- */

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

varying vec2 texcoord;

void main() {
  vec3 color = texture2D(colortex0, texcoord).rgb;
  vec3 normal = texture2D(colortex1, texcoord).rgb;
  vec3 lightmap = texture2D(colortex2, texcoord).rgb;

  color = sRGBltosRGB(color);

  gl_FragColor = vec4(color, 1.0);
}