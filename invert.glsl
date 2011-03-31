#version 130
// Fragmentshader

#include <complex.glsl>

uniform float time;
uniform vec2 resolution;
uniform sampler2D tex0;

smooth in vec2 tc;

const float pi = 3.14159265358979323846264;

void 
main(void)
{
  float s   = sin(time) * 0.5 + 0.5;

  vec2  p   = complexMult(cis(pi*s),tc); // rotate complex plane
  p         = complexInvert(p);          // invert
  vec4  col = texture2D(tex0, p);
  gl_FragColor = col;
}
