// functional images
//  see 
//   http://conal.net/papers/functional-images/fop-conal.pdf
//   http://users.info.unicaen.fr/~karczma/arpap/texturf.pdf

#version 330

#include <complex.glsl>

uniform float time;
uniform vec2 resolution;

smooth in vec2 tc;

const float pi = 3.14159265358979323846264;
const vec4 white = vec4(1.0,1.0,1.0,1.0);
const vec4 black = vec4(0.0,0.0,0.0,1.0);
const vec4 blue = vec4(0.0,0.0,1.0,1.0);
const vec4 yellow = vec4(1.0,1.0,0.0,1.0);

bool
even(float x)
{
  return mod(x,2.0) == 0.0;
}

// -----------------------------------------------------------------------------
// Transforms
vec2
scaleP(in vec2 s, in vec2 p)
{
  return vec2(s.x*p.x,s.y*p.y);
}

vec2
uScaleP(in float s, in vec2 p)
{
  return scaleP(vec2(s,s), p);
}

vec2
rotateP(in float theta, in vec2 p)
{
  return vec2(p.x*cos(theta) - p.y*sin(theta), p.y*cos(theta) + p.x*sin(theta));
}

// -----------------------------------------------------------------------------
//Regions

bool
vstrip(in vec2 p)
{
  return abs(p.x) < 0.5;
}

bool
udisk(in vec2 p)
{
  return length(p) < 1.0;
}

bool
checker(in vec2 p)
{
  return even(floor(p.x) + floor(p.y));
}

bool
altRings(in vec2 p)
{
  return even(floor(length(p)));
}

bool
polarChecker(in int n, in vec2 p)
{
  vec2 rTheta = polar(p);
  rTheta.y = rTheta.y * float(n)/pi;
  return checker(rTheta);
}

bool
annulus(in float inner, in vec2 p)
{
  return udisk(p) && !(udisk(uScaleP(1.0/inner,p)));
}

bool
radReg(in int n, in vec2 p)
{
  float a = arg(p);
  return even(floor(a*float(n)/pi));
}

bool
wedgeAnnulus(in float inner, in int n, in vec2 p)
{
  return annulus(inner, p) && radReg(n,p);
}

// -----------------------------------------------------------------------------
// Image Frac
float
wavDist(in vec2 p)
{
  return 0.5 + 0.5*cos(pi*length(p));
}

vec4
bwIm(in bool reg, in vec2 p)
{
  return reg ? black : white;
}

vec4
byIm(in bool reg, in vec2 p)
{
  return reg ? blue : yellow;
}

vec2
swirlP(in float k, in vec2 p)
{
  // (r, theta + r * constant)
  // where constant = 2pi/k
  return rotateP(length(p) * 2.0 * pi / k, p);
}

void
main(void)
{
  vec4 col = vec4(1.0);

  float s = sin(time) * 0.5 + 0.5;

  vec2 p = tc;
  //vec2 p = 0.5 * tc + 0.5;
  //vec2 p = 0.5 * complexMult(cis(pi*s), vec2(1.0,-1.0) * tc) + vec2(0.5,0.5);

  // cool
  vec4 col3 = wavDist(uScaleP(2.0,p)) * col;

  // cool
  //vec4 c4 = mix(bwIm(polarChecker(10,uScaleP(10.0,p)),p),
  //          byIm(checker(uScaleP(10.0,p)),p),
  //          wavDist(uScaleP(10.0,p)));

      //vec4(wavDist(uScaleP(10.0,p))); 
      //polarChecker(10,uScaleP(3.0,p)) ? black : white;

  // cool
  p = uScaleP(2.0,p);
  //p = swirlP(s+0.6,p);
  vec4 col5 = bwIm(vstrip(p),p);

  vec4 col6 = bwIm(wedgeAnnulus(0.25,7,p), p);

  vec4 col7 = byIm(wedgeAnnulus(0.25,7,p), p);
  col = col7;

  gl_FragColor = col;
}
