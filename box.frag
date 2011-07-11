#version 330

// draws a bunch of distorted 3d boxes

#include <complex.glsl>
#include <matrix.glsl>

uniform vec2      resolution;
uniform float     time;
uniform sampler2D tex0;
smooth in vec2    tc;
out vec4          fragColor;

const vec4 empty = vec4(0.0,0.0,0.0,0.0);
const vec4 blue = vec4(0.0,0.0,1.0,1.0);
const vec4 white = vec4(1.0,1.0,1.0,1.0);
const vec4 yellow = vec4(1.0,1.0,0.0,1.0);
const vec4 red = vec4(1.0,0.0,0.0,1.0);
const vec4 grey = vec4(0.4,0.4,0.4,1.0);
const float pi = 3.14159265358979323846264;

struct Triangle
{
  vec4 A;
  vec4 B;
  vec4 C;
  vec3 Normal;
};

void perspectiveDivideTriangle(inout Triangle t);
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

vec3
saturate(in vec3 c)
{
  return clamp(c,0.0,1.0);
}

vec4
triangle2D(in Triangle t, in vec2 p)
{
  float s = sin(time);
  float c = cos(time);
  vec4 color = empty;

  vec3 L = normalize(vec3(1.0,1.0,1.0));
  vec3 V = normalize(vec3(-p.x,-p.y,1.0));
  vec3 H = normalize(L + V);
  float m = 1.0;

  bool frontFacing = dot(V,t.Normal) > 0.0;
  if (frontFacing && triangle2(t.A.xy, t.B.xy, t.C.xy, p)) {
    vec4 ambient = 0.1*red;
    vec4 diffuse = max(0.0,dot(t.Normal.xyz,L))*red * vec4(0.8,0.8,0.8,1.0);
    vec4 specular = pow(dot(t.Normal, H),m)*red * vec4(0.7,0.7,0.7,1.0);
    color = ambient + diffuse + specular;
  }
  return color;
}

void
transformTriangle(in mat4 mv, in mat4 proj, inout Triangle t)
{
  t.A = proj*mv*t.A;
  t.B = proj*mv*t.B;
  t.C = proj*mv*t.C;
  t.Normal = normalize((transpose(inverse(mv)) * vec4(t.Normal,0.0)).xyz);
  perspectiveDivideTriangle(t);
}

// clip space to normalized device coordinates (NDC)
void
perspectiveDivideTriangle(inout Triangle t)
{
  t.A /= t.A.w;
  t.B /= t.B.w;
  t.C /= t.C.w;
}

Triangle boxTriangles[12]=Triangle[12](
  // back
  Triangle( vec4(-0.5,-0.5,-0.5,1.0)
           ,vec4( 0.5,-0.5,-0.5,1.0)
           ,vec4( 0.5, 0.5,-0.5,1.0)
           ,vec3(0.0,0.0,-1.0) //,0.0)
           ),
  Triangle( vec4(-0.5,-0.5,-0.5,1.0)
           ,vec4( 0.5, 0.5,-0.5,1.0)
           ,vec4(-0.5, 0.5,-0.5,1.0)
           ,vec3(0.0,0.0,-1.0) //,0.0)
           ),
  // front
  Triangle( vec4(-0.5,-0.5, 0.5,1.0)
          , vec4( 0.5, 0.5, 0.5,1.0)
          , vec4( 0.5,-0.5, 0.5,1.0)
           ,vec3(0.0,0.0,1.0) //,0.0)
            ),
  Triangle( vec4(-0.5,-0.5, 0.5,1.0)
          , vec4(-0.5, 0.5, 0.5,1.0)
          , vec4( 0.5, 0.5, 0.5,1.0)
           ,vec3(0.0,0.0,1.0) //,0.0)
            ),
  //top
  Triangle( vec4(-0.5, 0.5, 0.5,1.0),
            vec4(-0.5, 0.5,-0.5,1.0),
            vec4( 0.5, 0.5,-0.5,1.0)
          , vec3( 0.0, 1.0, 0.0) //,0.0)
            ),
  Triangle( vec4(-0.5, 0.5, 0.5,1.0),
            vec4( 0.5, 0.5,-0.5,1.0),
            vec4( 0.5, 0.5, 0.5,1.0)
          , vec3( 0.0, 1.0, 0.0) //,0.0)
            ),
  //bottom
  Triangle( vec4(-0.5,-0.5, 0.5,1.0)
          , vec4(-0.5,-0.5,-0.5,1.0)
          , vec4( 0.5,-0.5,-0.5,1.0)
          , vec3(0.0,-1.0,0.0) //,0.0)
            ),
  Triangle( vec4(-0.5,-0.5, 0.5,1.0)
          , vec4( 0.5,-0.5,-0.5,1.0)
          , vec4( 0.5,-0.5, 0.5,1.0)
          , vec3(0.0,-1.0,0.0) //,0.0)
            ),
  // left
  Triangle( vec4(-0.5,-0.5,-0.5,1.0)
          , vec4(-0.5, 0.5, 0.5,1.0)
          , vec4(-0.5,-0.5, 0.5,1.0)
          , vec3(-1.0,0.0,0.0) //,0.0)
          ),
  Triangle( vec4(-0.5,-0.5,-0.5,1.0)
          , vec4(-0.5, 0.5,-0.5,1.0)
          , vec4(-0.5, 0.5, 0.5,1.0)
          , vec3(-1.0,0.0,0.0) //,0.0)
          ),
  // right
  Triangle( vec4( 0.5,-0.5,-0.5,1.0)
          , vec4( 0.5,-0.5, 0.5,1.0)
          , vec4( 0.5, 0.5, 0.5,1.0)
          , vec3( 1.0,0.0,0.0) //,0.0)
          ),
  Triangle( vec4( 0.5,-0.5,-0.5,1.0)
          , vec4( 0.5, 0.5, 0.5,1.0)
          , vec4( 0.5, 0.5,-0.5,1.0)
          , vec3( 1.0,0.0,0.0) //,0.0)
          ));

vec4
drawFlatBox(in mat4 mv, in mat4 proj, in vec2 p)
{
  transformTriangle(mv, proj, boxTriangles[0]);
  transformTriangle(mv, proj, boxTriangles[1]);
  transformTriangle(mv, proj, boxTriangles[2]);
  transformTriangle(mv, proj, boxTriangles[3]);
  transformTriangle(mv, proj, boxTriangles[4]);
  transformTriangle(mv, proj, boxTriangles[5]);
  transformTriangle(mv, proj, boxTriangles[6]);
  transformTriangle(mv, proj, boxTriangles[7]);
  transformTriangle(mv, proj, boxTriangles[8]);
  transformTriangle(mv, proj, boxTriangles[9]);
  transformTriangle(mv, proj, boxTriangles[10]);
  transformTriangle(mv, proj, boxTriangles[11]);

  vec4 color = empty;
  // back
  color += triangle2D(boxTriangles[0],p);
  color += triangle2D(boxTriangles[1],p);
  // front
  color += triangle2D(boxTriangles[2],p);
  color += triangle2D(boxTriangles[3],p);

  color += triangle2D(boxTriangles[4],p);
  color += triangle2D(boxTriangles[5],p);
  color += triangle2D(boxTriangles[6],p);
  color += triangle2D(boxTriangles[7],p);

  color += triangle2D(boxTriangles[8],p);
  color += triangle2D(boxTriangles[9],p);
  color += triangle2D(boxTriangles[10],p);
  color += triangle2D(boxTriangles[11],p);

  if (color == empty) {
    color = vec4(p.x,p.y,0.2,1.0)*white;
  }

  return color;
}

vec2
tunnel(in vec2 p, in float move, in float scaleR, in float scalePhi)
{
  // Invert r
  // Scale phi 
  // Scale r
  // Add move to r
  return vec2(move + scaleR/magnitude(p), scalePhi*arg(p));
}

void 
main(void)
{
  float s = sin(time) * 1.5 + 0.5;
  vec2 p = tc;
  p = complexMult(cis(s), p);
  p = mod(cos(s*p.y)*p,0.2)-vec2(0.1);

  float scaleR = 1.0; //0.1;
  float scalePhi = 1.5/pi;
  //p = tunnel(p, 0.75*time, scaleR, scalePhi);

  mat4 projection = perspective(90.0, 1.0, 1.0, 100.0);
  mat4 translate = make_translate(vec3(0.0, 0.0, -10.0));
  mat4 mv = translate * rotY(5*time)*rotX(pi/4)*rotZ(pi/4);

  fragColor = drawFlatBox(mv,projection, p);
}

