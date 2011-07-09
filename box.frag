#version 330

// draws a bunch of distorted 3d boxes

#include <complex.glsl>
#include <matrix.glsl>

uniform vec2      resolution;
uniform float     time;
uniform sampler2D tex0;
smooth in vec2    tc;
out vec4          fragColor;

const vec4 blue = vec4(0.0,0.0,1.0,1.0);
const vec4 yellow = vec4(1.0,1.0,0.0,1.0);
const float pi = 3.14159265358979323846264;

struct triangle
{
  vec4 A;
  vec4 B;
  vec4 C;
};

void perspectiveDivide(inout triangle t);
vec3 barycentric(in vec2 p0, in vec2 p1, in vec2 p2, in vec2 p);
bool triangle2(in vec2 A, in vec2 B, in vec2 C, in vec2 p);

float f01(in vec2 p0, in vec2 p1, in vec2 p) {
  return (p0.y-p1.y)*p.x + (p1.x-p0.x)*p.y + p0.x*p1.y - p1.x*p0.y;
}

float f20(in vec2 p0, in vec2 p2, in vec2 p) {
  return (p0.y-p2.y)*p.x + (p2.x-p0.x)*p.y + p0.x*p2.y - p2.x*p0.y;
}

vec3
barycentric(in vec2 p0, in vec2 p1, in vec2 p2, in vec2 p)
{
  float beta = f20(p0,p2,p) / f20(p0,p2,p1);
  float gamma = f01(p0,p1,p) / f01(p0,p1,p2);
  float alpha = 1.0 - beta - gamma;
  return vec3(alpha, beta, gamma);
}

bool
triangle2(in vec2 A, in vec2 B, in vec2 C, in vec2 p)
{
  vec3 bc = barycentric(A,B,C,p);
  return bc.x > 0 && bc.y > 0 && bc.z > 0;
}

vec4 byIm(in bool reg, in vec2 p)
{
  return reg ? blue : yellow;
}

void
transformTriangle(in mat4 m, inout triangle t)
{
  t.A *= m;
  t.A /= t.A.w;
  t.B *= m;
  t.B /= t.B.w;
  t.C *= m;
  t.C /= t.C.w;
}

// clip space to normalized device coordinates (NDC)
void
perspectiveDivide(inout triangle t)
{
  t.A /= t.A.w;
  t.B /= t.B.w;
  t.C /= t.C.w;
}

const vec4 boxVertices[36] = vec4[36](
  // back
  vec4(-0.5,-0.5,-0.5,1.0),
  vec4( 0.5,-0.5,-0.5,1.0),
  vec4( 0.5, 0.5,-0.5,1.0),
  vec4(-0.5,-0.5,-0.5,1.0),
  vec4( 0.5, 0.5,-0.5,1.0),
  vec4(-0.5, 0.5,-0.5,1.0),

  // front
  vec4(-0.5,-0.5, 0.5,1.0),
  vec4( 0.5,-0.5, 0.5,1.0),
  vec4( 0.5, 0.5, 0.5,1.0),
  vec4(-0.5,-0.5, 0.5,1.0),
  vec4( 0.5, 0.5, 0.5,1.0),
  vec4(-0.5, 0.5, 0.5,1.0),

  // top
  vec4(-0.5, 0.5, 0.5,1.0),
  vec4(-0.5, 0.5,-0.5,1.0),
  vec4( 0.5, 0.5,-0.5,1.0),
  vec4(-0.5, 0.5, 0.5,1.0),
  vec4( 0.5, 0.5,-0.5,1.0),
  vec4( 0.5, 0.5, 0.5,1.0),

  // bottom
  vec4(-0.5,-0.5, 0.5,1.0),
  vec4(-0.5,-0.5,-0.5,1.0),
  vec4( 0.5,-0.5,-0.5,1.0),
  vec4(-0.5,-0.5, 0.5,1.0),
  vec4( 0.5,-0.5,-0.5,1.0),
  vec4( 0.5,-0.5, 0.5,1.0),

  // left
  vec4(-0.5,-0.5,-0.5,1.0),
  vec4(-0.5,-0.5, 0.5,1.0),
  vec4(-0.5, 0.5, 0.5,1.0),
  vec4(-0.5,-0.5,-0.5,1.0),
  vec4(-0.5, 0.5, 0.5,1.0),
  vec4(-0.5, 0.5,-0.5,1.0),

  // right
  vec4( 0.5,-0.5,-0.5,1.0),
  vec4( 0.5,-0.5, 0.5,1.0),
  vec4( 0.5, 0.5, 0.5,1.0),
  vec4( 0.5,-0.5,-0.5,1.0),
  vec4( 0.5, 0.5, 0.5,1.0),
  vec4( 0.5, 0.5,-0.5,1.0)
  );

triangle boxTriangles[12]=triangle[12](
  // back
  triangle( vec4(-0.5,-0.5,-0.5,1.0),
            vec4( 0.5,-0.5,-0.5,1.0),
            vec4( 0.5, 0.5,-0.5,1.0)),
  triangle( vec4(-0.5,-0.5,-0.5,1.0),
  // front
            vec4( 0.5, 0.5,-0.5,1.0),
            vec4(-0.5, 0.5,-0.5,1.0)),
  triangle( vec4(-0.5,-0.5, 0.5,1.0),
            vec4( 0.5,-0.5, 0.5,1.0),
            vec4( 0.5, 0.5, 0.5,1.0)),
  triangle( vec4(-0.5,-0.5, 0.5,1.0),
            vec4( 0.5, 0.5, 0.5,1.0),
            vec4(-0.5, 0.5, 0.5,1.0)),
  //top
  triangle( vec4(-0.5, 0.5, 0.5,1.0),
            vec4(-0.5, 0.5,-0.5,1.0),
            vec4( 0.5, 0.5,-0.5,1.0)),
  triangle( vec4(-0.5, 0.5, 0.5,1.0),
            vec4( 0.5, 0.5,-0.5,1.0),
            vec4( 0.5, 0.5, 0.5,1.0)),
  //bottom
  triangle( vec4(-0.5,-0.5, 0.5,1.0),
            vec4(-0.5,-0.5,-0.5,1.0),
            vec4( 0.5,-0.5,-0.5,1.0)),
  triangle( vec4(-0.5,-0.5, 0.5,1.0),
            vec4( 0.5,-0.5,-0.5,1.0),
            vec4( 0.5,-0.5, 0.5,1.0)),
  // left
  triangle( vec4(-0.5,-0.5,-0.5,1.0),
            vec4(-0.5,-0.5, 0.5,1.0),
            vec4(-0.5, 0.5, 0.5,1.0)),
  triangle( vec4(-0.5,-0.5,-0.5,1.0),
            vec4(-0.5, 0.5, 0.5,1.0),
            vec4(-0.5, 0.5,-0.5,1.0)),
  // right
  triangle( vec4( 0.5,-0.5,-0.5,1.0),
            vec4( 0.5,-0.5, 0.5,1.0),
            vec4( 0.5, 0.5, 0.5,1.0)),
  triangle( vec4( 0.5,-0.5,-0.5,1.0),
            vec4( 0.5, 0.5, 0.5,1.0),
            vec4( 0.5, 0.5,-0.5,1.0)));

void main(void)
{
  float s = sin(time) * 1.5 + 0.5;
  vec2 p = mod(cos(tc.y)*tc,0.2)-vec2(0.1);

  mat4 projection = perspective(45.0, 1.0, 1.0, 100.0);
  mat4 translate = make_translate(vec3(0.0, 0.0, 20.0));
  mat4 mvp = rotZ(4.0*time)*rotX(time) * translate * projection;

  transformTriangle(mvp, boxTriangles[0]);
  transformTriangle(mvp, boxTriangles[1]);
  transformTriangle(mvp, boxTriangles[2]);
  transformTriangle(mvp, boxTriangles[3]);
  transformTriangle(mvp, boxTriangles[4]);
  transformTriangle(mvp, boxTriangles[5]);
  transformTriangle(mvp, boxTriangles[6]);
  transformTriangle(mvp, boxTriangles[7]);
  transformTriangle(mvp, boxTriangles[8]);
  transformTriangle(mvp, boxTriangles[9]);
  transformTriangle(mvp, boxTriangles[10]);
  transformTriangle(mvp, boxTriangles[11]);

  fragColor = byIm(
       triangle2(boxTriangles[0].A.xy,boxTriangles[0].B.xy,boxTriangles[0].C.xy,p)
    || triangle2(boxTriangles[1].A.xy,boxTriangles[1].B.xy,boxTriangles[1].C.xy,p)
    || triangle2(boxTriangles[2].A.xy,boxTriangles[2].B.xy,boxTriangles[2].C.xy,p)
    || triangle2(boxTriangles[3].A.xy,boxTriangles[3].B.xy,boxTriangles[3].C.xy,p)
    || triangle2(boxTriangles[4].A.xy,boxTriangles[4].B.xy,boxTriangles[4].C.xy,p)
    || triangle2(boxTriangles[5].A.xy,boxTriangles[5].B.xy,boxTriangles[5].C.xy,p)
    || triangle2(boxTriangles[6].A.xy,boxTriangles[6].B.xy,boxTriangles[6].C.xy,p)
    || triangle2(boxTriangles[7].A.xy,boxTriangles[7].B.xy,boxTriangles[7].C.xy,p)
    || triangle2(boxTriangles[8].A.xy,boxTriangles[8].B.xy,boxTriangles[8].C.xy,p)
    || triangle2(boxTriangles[9].A.xy,boxTriangles[9].B.xy,boxTriangles[9].C.xy,p)
    || triangle2(boxTriangles[10].A.xy,boxTriangles[10].B.xy,boxTriangles[10].C.xy,p)
    || triangle2(boxTriangles[11].A.xy,boxTriangles[11].B.xy,boxTriangles[11].C.xy,p)
    , p);
}

