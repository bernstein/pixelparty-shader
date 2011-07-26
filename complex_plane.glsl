#version 330

#include "complex.glsl"
#include "hsv.glsl"

const float pi = 3.14159265358979323846264;
smooth in vec2 tc;
out vec4 fragColor;

float
argTesting(in vec2 z)
{
  return atan(z.y,z.x);
}

void 
main(void)
{
  vec2 z = tc; // polar(tc);
  vec3 col = hsvToRgb(vec3(argTesting(z)/(2.0*pi), 0.7, magnitude(z)));
  fragColor = vec4(col, 1.0);
}

