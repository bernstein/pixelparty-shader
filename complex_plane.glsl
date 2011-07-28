#version 330

#include "complex.glsl"
#include "domain_coloring.glsl"

const float pi = 3.14159265358979323846264;
smooth in vec2 tc;
out vec4 fragColor;

void 
main(void)
{
  float zoom = 3.0;
  vec2 z = zoom*tc;
  //vec2 q = col(z);
  //vec2 q = col(complexInvert(z));
  //vec2 q = col(complexSquare(z));
  //vec2 q = col(complexInvert(complexSquare(z)));
  //vec2 q = complexInvert(z+vec2(1.0,0.0)) - complexInvert(z - vec2(1.0,0.0));
  //vec2 q = complexInvert(z+vec2(1.0,0.0)) - complexInvert(z - vec2(1.0,0.0));
  vec2 q = complexInvert(z+vec2(1.0,0.0)) + complexInvert(z - vec2(1.0,0.0));
  vec3 col = col(q);
  fragColor = vec4(col, 1.0);
}

