#version 330

#include "complex.glsl"

uniform float time;
uniform sampler2D tex0;
uniform vec2 resolution;

smooth in vec2 tc;

const float pi  = 3.14159265;
const float tau = 6.28318531;

vec2
rotate(in vec2 p, in float phi)
{
  return complexMult(cis(phi), p);
}

vec2
funny(in vec2 p, in float move, in float scaleR, in float scalePhi)
{
  return vec2((0.5 + 0.5*sin(move))/magnitude(p),0.0) + vec2(scaleR,scalePhi) * polar(p);
}

void 
main(void)
{
  vec2 p = tc; //rotate(tc, 0.5*time);
  float scaleR = 1.0; //0.1;
  float scalePhi = 3.0/tau;
  vec2 q = funny(p, 0.75*time, scaleR, scalePhi);
  vec3 c =  texture2D(tex0,q).xyz;

  float r = magnitude(p);
  gl_FragColor = vec4(c*r,1.0);
}
