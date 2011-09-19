#version 330

// a very simple raytracer

uniform vec2      resolution;
uniform float     time;
uniform sampler2D tex0;
out vec4          fragColor;

const float pi = 3.14159265358979323846264;
const vec4 empty = vec4(0.0,0.0,0.0,0.0);
const vec4 grey = vec4(0.4,0.4,0.4,1.0);
const vec3 eye = vec3(0.0,0.0,0.0);

struct Ray
{
  vec3 o;
  vec3 d;
};

struct Sphere
{
  vec3 center;
  float r;
};

struct PointLight
{
  vec3 location;
  vec4 ambient;
  vec4 color;
};

struct Material
{
  vec4 ka;
  vec4 kd;
  vec4 ks;
  float m;
};

PointLight gPointLight = PointLight(vec3(5.0,5.0,-2.0),
                                    vec4(0.1,0.1,0.1,1.0), 
                                    vec4(0.8,0.8,0.8,1.0));

Sphere gSphere = Sphere(vec3(0.0, sin(time), -6.0),1.0);
Sphere gSphere2 = Sphere(vec3(3.0, sin(time), -16.0),1.0);
Material gMaterial = Material(vec4(0.2,0.2,0.2,1.0)
                            , vec4(0.8,0.0,0.0,1.0)
                            , vec4(0.8,0.8,0.8,1.0)
                            , 20.0);
Material gMaterial2 = Material(vec4(0.3,0.3,0.3,1.0)
                            , vec4(0.2,0.2,0.8,1.0)
                            , vec4(0.5,0.5,0.5,1.0)
                            , 50.0);

float
degToRad(in float a)
{
  return a*pi/180.0;
}

// http://wiki.cgsociety.org/index.php/Ray_Sphere_Intersection
bool
intersect(in Sphere s, in Ray r, out float t)
{
  float a = dot(r.d, r.d);
  float b = 2.0*dot(r.o - s.center, r.d);
  float c = dot(r.o - s.center, r.o - s.center) - s.r*s.r;
  float discriminant = b*b - 4*a*c;
  t = (-b - discriminant)/ 2*a; //t2 = (-b + discriminant)/ 2*a;
  return (discriminant > 0.0);
}

vec3
calcNormal(in Sphere s, in Ray r, in float t)
{
  vec3 P = r.o + t*r.d;
  vec3 N = normalize(P - s.center);
  return N; 
}

Ray eyeRay(vec2 p)
{
  float alpha = 45.0;
  float aspect = resolution.y/resolution.x;
  vec3 dir = vec3(
      (p.x / resolution.x) * 2.0 - 1.0,
      aspect*(p.y / resolution.y) * 2.0 - aspect,
      -1.0 / tan(0.5 * degToRad(alpha)));

  return Ray(eye, normalize(dir));
}

vec4
background()
{
  return grey;
}

vec4
shade(in Sphere sphere, in Ray r, in float t, in Material material)
{
  vec3 N = calcNormal(sphere,r,t);
  vec3 P = r.o + t*r.d;
  vec3 L = normalize(gPointLight.location - P);
  vec3 V = -r.d;
  vec3 H = normalize(L + V);

  vec4 ambient = gPointLight.ambient * material.ka;
  vec4 diffuse = gPointLight.color * material.kd * max(0.0, dot(N,L));
  float s = max(dot(N,H),0.0);
  vec4 specular = pow(s,material.m) * material.ks * gPointLight.color;
  return ambient + diffuse + specular;
}

vec4
raytrace(Ray r,int depth)
{
  float t0=-1.0;
  if (intersect(gSphere, r, t0)) {
    return shade(gSphere, r, t0, gMaterial);
  }
  if (intersect(gSphere2, r, t0)) {
    return shade(gSphere2, r, t0, gMaterial2);
  } else {
    return background();
  }
}

void 
main(void)
{
  Ray r = eyeRay(gl_FragCoord.xy);
  int depth=2;
  vec4 clr = raytrace(r, depth);
  fragColor = clr;
}
