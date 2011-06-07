#version 330

#include "complex.glsl"

uniform float time;
uniform sampler2D tex0;
uniform vec2 resolution;

smooth in vec2 tc;
out vec4 fragColor;

const float pi  = 3.14159265;
const float tau = 6.28318531;

vec2
rotate(in vec2 p, in float phi)
{
  return complexMult(cis(phi), p);
}

vec2
tunnel(in vec2 p, in float move, in float scaleR, in float scalePhi)
{
  // Invert r
  // Scale phi 
  // Scale r
  // Add move to r
  return vec2(move + scaleR/magnitude(p), scalePhi*arg(p));
}

/*
vec2
tunnel2(in vec2 p, in float move)
{
  vec2 p2 = complexConjugate(complexInvert(p));
  vec2 p3 = polar(complexMult(p2,vec2(0.1,0.0)));
  return vec2(move, 0.0) + vec2(1.0, 1.0/tau) * p3;
}
*/

void 
main(void)
{
  vec2 p = tc; //rotate(tc, 0.5*time);
  float scaleR = 1.0; //0.1;
  float scalePhi = 3.0/tau;
  vec2 q = tunnel(p, 0.75*time, scaleR, scalePhi);
  vec3 c =  texture2D(tex0,q).xyz;

  float r = magnitude(p);
  fragColor = vec4(c*r,1.0);
}
