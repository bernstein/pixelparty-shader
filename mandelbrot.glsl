// infos:
// http://en.wikipedia.org/wiki/Mandelbrot_set
// http://www.ozone3d.net/tutorials/mandelbrot_set.php
#version 130

#include <hsv.glsl>
#include <complex.glsl>

uniform float time;
uniform sampler2D tex0;
uniform vec2 resolution;

smooth in vec2 tc;

const float pi = 3.14159265358979323846264;
const float maxN  = 100;
const float maxR2 = 100000.0;

vec4 black   = vec4(0.0, 0.0, 0.0,1.0);
vec4 outsideColor0 = vec4(0.01, 0.0, 0.9,1.0);
vec4 outsideColor1 = vec4(0.8, 0.9, 0.0,1.0);

//  z_n+1 = z_n + c, with z_0 = 0
vec2
iterate(in vec2 p) //, in float maxR2, in float N)
{
  vec2  c = p;
  vec2  z = vec2(0.0);
  float r2 = 0.0;
	int n=0;
  for (int i = 0 ; i < maxN && r2 < maxR2; ++i ) {
    z  = complexSquare(z) + c;
    r2 = dot(z, z);
    n = i;
  }
  //float res = float(n) - log(log(r2) / log(4.0)) / log(2.0);
  float res = float(n) - log2(0.5 * log(r2));
  return vec2(res,r2);
}

vec4
colorize(float n, float modSquared)
{
  vec4 col = black;
  if (modSquared > 4.0)
    col = mix(outsideColor0, outsideColor1, fract(n * 0.05));
  //  col = vec4(hsvToRgb(vec3(modSquared, 1.0, n*0.09)), 1.0);
  //  col = vec4(0.0, modSquared*0.001, fract(n*0.5), 1.0);
  return col;
}

void
main(void)
{
  float T = time/1000.0;
  float s = sin(T) + 1.0;

  vec2 p = s * tc - vec2(1.40,0.02);
  vec2 r = iterate(p);

  gl_FragColor = colorize(r.x, r.y);
}
