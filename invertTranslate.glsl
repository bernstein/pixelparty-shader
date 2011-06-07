#version 330
// Fragmentshader

#include <complex.glsl>

uniform float time;
uniform vec2 resolution;
uniform sampler2D tex0;

smooth in vec2 tc;
out vec4 fragColor;

const float pi = 3.14159265358979323846264;

void 
main(void)
{
  float s   = sin(time) * 0.5 + 0.5;

  vec2  z   = complexMult(cis(pi*s),tc); // rotate complex plane
  vec2  t   = vec2(s+0.4, s+0.1);
  z         = t + complexInvert(z); // invert and translate
  vec3  col = texture2D(tex0, 0.25*z).rgb;

  float r2  = dot(tc,tc);
  fragColor = vec4(r2*col,1.0);
}
