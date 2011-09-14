#version 330

#include "complex.glsl"
#include "domain_coloring.glsl"

const float pi = 3.14159265358979323846264;
smooth in vec2 tc;
out vec4 fragColor;

const vec4 white = vec4(1.0,1.0,1.0,1.0);
const vec4 black = vec4(0.0,0.0,0.0,1.0);

bool
grid(in vec2 p)
{
  vec2 q = mod(abs(p),0.25);
  return q.x < 0.01 || q.y < 0.01;
}

vec4
bwIm(in bool reg)
{
  return reg ? white : black;
}

void 
main(void)
{
  float zoom = 2.0;
  vec2 z = zoom*tc;
  //vec2 q = col(z);
  //vec2 q = col(complexInvert(z));
  //vec2 q = col(complexSquare(z));
  //vec2 q = col(complexInvert(complexSquare(z)));
  //vec2 q = complexInvert(z+vec2(1.0,0.0)) - complexInvert(z - vec2(1.0,0.0));
  //vec2 q = complexInvert(z+vec2(1.0,0.0)) - complexInvert(z - vec2(1.0,0.0));
  vec2 q = complexInvert(z+vec2(1.0,0.0)) + complexInvert(z - vec2(1.0,0.0));
  //vec2 q = complexExp(complexInvert(z));
  //vec2 q = complexExp(complexInvert(complexSquare(z)));
  //vec2 q = complexSin(z);
  //vec2 q = complexSin(complexInvert(z));
  vec3 col = col(q);
  fragColor = vec4(col, 1.0);

  //vec4 col2 = bwIm(grid(q));
  //fragColor = col2;
}
