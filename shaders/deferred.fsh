/* -------------------------------------------------------------------------- */
/*                            D4SCO SHADERS - 0.0.0                           */
/* -------------------------------------------------------------------------- */

#version 120

/* -------------------------------- Includes -------------------------------- */

#include "D4SCO/colorspaces.glsl"

/* -------------------------------------------------------------------------- */
/*                                   PROGRAM                                  */
/* -------------------------------------------------------------------------- */

uniform sampler2D shadowtex0;
uniform sampler2D depthtex0;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

/*
const int colortex0Format = RGBA32F;
const int colortex1Format = RGB16;
const int colortex2Format = RGBA16;
*/

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform vec3 sunPosition;

varying vec2 texcoord;

const int shadowMapResolution = 4096;
const float sunRotation = -40.0;
const float ambientLight = 0.1;

/* ---------------------------- Lightmap Methods ---------------------------- */

float computeLightmapBlocklight(in float light) {
  const float C = 2.0;
  const float P = 5.0;

  return C * pow(light, P);
}

float computeLightmapSkylight(in float light) {
  return pow(light, 4.0);
}

vec2 computeLightmap(in vec2 lightmap) {
  lightmap.x = computeLightmapBlocklight(lightmap.x);
  lightmap.y = computeLightmapSkylight(lightmap.y);

  return lightmap;
}

vec3 computeLightmapColor(in vec2 lightmap, in float mi = 0.0) {
  lightmap = computeLightmap(lightmap);

  const vec3 blocklightColor = vec3(0.25, 1.0, 0.08);
  const vec3 skylightColor = vec3(0.05, 0.15, 0.3);

  vec3 blocklight = lightmap.x * blocklightColor;
  vec3 skylight = max(lightmap.y, mi) * skylightColor;
  return blocklight + skylight;
}

/* ----------------------------- Shadow Methods ----------------------------- */

float getShadowCoeff(float depth, float bias = 0.001) {
  vec3 clip = vec3(texcoord, depth) * 2.0 - 1.0;

  vec4 view0 = gbufferProjectionInverse * vec4(clip, 1.0);
  vec3 view = view0.xyz / view0.w;

  vec4 world = gbufferModelViewInverse * vec4(view, 1.0);

  vec4 shadow = shadowProjection * shadowModelView * world;

  vec3 samplecoord = shadow.xyz * 0.5 + 0.5;

  return step(samplecoord.z - bias, texture2D(shadowtex0, samplecoord.xy).r);
} 

/* ---------------------------------- Main ---------------------------------- */

void main() {
  vec3 color = sRGBtosRGBl(texture2D(colortex0, texcoord).rgb);
  float depth = texture2D(depthtex0, texcoord).r;
  if (depth == 1.0) {
    gl_FragData[0] = vec4(color, 1.0);
    return;
  }

  vec3 normal = normalize(texture2D(colortex1, texcoord).rgb * 2.0 - 1.0);

  vec2 lightmap = texture2D(colortex2, texcoord).rg;
  vec3 lightColor = computeLightmapColor(lightmap, 1.0);

  float ndotl = max(dot(normal, normalize(sunPosition)), 0.0);

  vec3 diffuse = color * (lightColor + ndotl * getShadowCoeff(depth) + ambientLight);

  /*DRAWBUFFERS:012*/
  gl_FragData[0] = vec4(diffuse, 1.0);
  gl_FragData[1] = vec4(normal, 1.0);
  gl_FragData[2] = vec4(lightColor, 1.0);
}