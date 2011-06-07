#version 330

#include <complex.glsl>

uniform float time;
uniform sampler2D tex0;
uniform vec2 resolution;

smooth in vec2 tc;
out vec4 fragColor;

const float pi = 3.14159265358979323846264;

void
main(void)
{
  vec4 col = vec4(0.0);

  float s = sin(time) * 0.5 + 0.5;

  vec2 p = 0.5 * complexMult(cis(pi*s), vec2(1.0,-1.0) * tc) + vec2(0.5,0.5);
  col = texture(tex0, p);
  fragColor = col;
}
