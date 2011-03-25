// infos:
// http://en.wikipedia.org/wiki/Mandelbrot_set
// http://www.ozone3d.net/tutorials/mandelbrot_set.php
#version 130

#include <hsv.glsl>
#include <complex.glsl>

uniform float time;
uniform sampler2D tex0;
uniform vec2 resolution;

varying vec2 tc;

const float pi = 3.14159265358979323846264;
const float iterations = 30;
vec4 insideColor   = vec4(0.0, 0.0, 0.0,1.0);
vec4 outsideColor0 = vec4(0.01, 0.0, 0.9,1.0);
vec4 outsideColor1 = vec4(0.8, 0.9, 0.0,1.0);

void
main(void)
{
  float T = time/1000.0;
  float s = sin(T) + 1.0;

  vec2 p = s * tc - vec2(1.40,0.02);

  vec4 col = insideColor;
  float r2 = 0.0;

  //  zn+1 = zn2 + c, with z0 = 0
  vec2  c = p;
  vec2  z = c; // vec2(0.0);
  int iter = 0;
  for (iter = 0 ; iter < iterations && r2 < 4.0; ++iter ) {
    z  = complexSquare(z) + c;
    r2 = dot(z, z);
  }

  if (r2 > 4.0)
    col = mix(outsideColor0, outsideColor1, fract(float(iter) * 0.05));

  // col = vec4(hsvToRgb(vec3(z.x, 0.7, z.y)), 1.0);

  gl_FragColor = col;
}
