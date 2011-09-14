#version 330

#include <complex.glsl>

// see http://www.ozone3d.net/tutorials/image_filtering.php
// for more infos

uniform float time;
uniform sampler2D tex0;
uniform vec2 resolution;
uniform float width=1024;
uniform float height=708;

smooth in vec2 tc;
out vec4 fragColor;

float kernel[9];
float step_w = 1.0/width;
float step_h = 1.0/height;
vec2 offset[9]=vec2[9](
    vec2(-step_w, -step_h)
  , vec2(0.0, -step_h)
  , vec2(step_w, -step_h)
  , vec2(-step_w, 0.0)
  , vec2(0.0, 0.0)
  , vec2(step_w, 0.0)
  , vec2(-step_w, step_h)
  , vec2(0.0, step_h)
  , vec2(step_w, step_h)
  );

vec4
gaussian(in sampler2D tex, in vec2 t)
{
  kernel[0] = 1.0/16.0; kernel[1] = 2.0/16.0; kernel[2] = 1.0/16.0;
  kernel[3] = 2.0/16.0; kernel[4] = 4.0/16.0; kernel[5] = 2.0/16.0;
  kernel[6] = 1.0/16.0; kernel[7] = 2.0/16.0; kernel[8] = 1.0/16.0;
  vec4 sum = vec4(0.0);
  for (int i=0; i<9; ++i) {
    sum += texture(tex,t+offset[i]) * kernel[i];
  }
  return sum;
}

vec4
mean(in sampler2D tex, in vec2 t)
{
  kernel[0] = 1.0/9.0; kernel[1] = 1.0/9.0; kernel[2] = 1.0/9.0;
  kernel[3] = 1.0/9.0; kernel[4] = 1.0/9.0; kernel[5] = 1.0/9.0;
  kernel[6] = 1.0/9.0; kernel[7] = 1.0/9.0; kernel[8] = 1.0/9.0;

  vec4 sum = vec4(0.0);
  for (int i=0; i<9; ++i) {
    sum += texture(tex,t+offset[i]) * kernel[i];
  }
  return sum;
}

vec4
laplacian(in sampler2D tex, in vec2 t)
{
  kernel[0] = 0.0; kernel[1] = 1.0;  kernel[2] = 0.0;
  kernel[3] = 1.0; kernel[4] = -4.0; kernel[5] = 1.0;
  kernel[6] = 0.0; kernel[7] = 1.0;  kernel[8] = 0.0;

  vec4 sum = vec4(0.0);
  for (int i=0; i<9; ++i) {
    sum += texture(tex,t+offset[i]) * kernel[i];
  }
  return sum;
}

vec4
emboss(in sampler2D tex, in vec2 t)
{
  kernel[0] = 2.0; kernel[1] = 0.0;  kernel[2] = 0.0;
  kernel[3] = 0.0; kernel[4] = -1.0; kernel[5] = 0.0;
  kernel[6] = 0.0; kernel[7] = 0.0;  kernel[8] = -1.0;

  vec4 sum = vec4(0.0);
  for (int i=0; i<9; ++i) {
    sum += texture(tex,t+offset[i]) * kernel[i];
  }
  return sum;
}

vec4
sharp(in sampler2D tex, in vec2 t)
{
  kernel[0] = -1.0; kernel[1] = -1.0; kernel[2] = -1.0;
  kernel[3] = -1.0; kernel[4] =  9.0; kernel[5] = -1.0;
  kernel[6] = -1.0; kernel[7] = -1.0; kernel[8] = -1.0;

  vec4 sum = vec4(0.0);
  for (int i=0; i<9; ++i) {
    sum += texture(tex,t+offset[i]) * kernel[i];
  }
  return sum;
}

vec4
sobel(in sampler2D tex, in vec2 t)
{
  float G_x[9]=float[9]( -1.0,-2.0,-1.0,
                          0.0,0.0,0.0,
                          1.0,2.0,1.0);
  float G_y[9]=float[9]( -1.0,0.0,1.0,
                         -2.0,0.0,2.0,
                         -1.0,0.0,1.0);
  vec4 sumGx = vec4(0.0);
  for (int i=0; i<9; ++i) {
    sumGx += texture(tex,t+offset[i]) * G_x[i];
  }
  vec4 sumGy = vec4(0.0);
  for (int i=0; i<9; ++i) {
    sumGy += texture(tex,t+offset[i]) * G_y[i];
  }
  return sqrt(sumGx*sumGx + sumGy*sumGy);
}

void
main(void)
{
  vec2 p = 0.5 * vec2(1.0,-1.0) * tc + 0.5;
  fragColor = sobel(tex0,p);
}

