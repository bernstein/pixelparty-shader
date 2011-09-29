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
const float infinity = 1e20;
const float eps = 1e-4; 

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

//PointLight gPointLight = PointLight(vec3(5*sin(2.5*time),5.0,5*cos(2.5*time)-5.0),
PointLight gPointLight = PointLight(vec3(5*sin(2.5),5.0,5*cos(2.5)-5.0),
                                    vec4(0.3,0.3,0.3,1.0), 
                                    vec4(0.8,0.8,0.8,1.0));

Sphere spheres[4] = Sphere[4](
  Sphere(vec3( 0.0, -1e5-1, -10.0),1e5), // Bottom
  Sphere(vec3(3*sin(time), 0.0, -10.0+3*cos(time)),1.0),
  Sphere(vec3(3*sin(time+pi), 0.0, -10.0+3*cos(time+pi)),1.0),
  Sphere(vec3(+0.0, sin(time)+1.0, -10.0),1.0) // yellow sphere
  );

Material materials[4] = Material[4](
  Material(vec4(0.8,0.8,0.8,1.0)
        , vec4(0.75,0.75,0.75,1.0)
        , vec4(0.5,0.5,0.5,1.0)
        , 50.0),
  Material(vec4(0.3,0.3,0.3,1.0)
        , vec4(0.2,0.2,0.8,1.0)
        , vec4(0.5,0.5,0.5,1.0)
        , 50.0),
  Material(vec4(0.2,0.2,0.2,1.0)
        , vec4(0.8,0.0,0.0,1.0)
        , vec4(0.8,0.8,0.8,1.0)
        , 20.0),
  Material(vec4(0.4,0.4,0.4,1.0)
        , vec4(0.9,0.9,0.9,1.0)
        , vec4(0.5,0.5,0.5,1.0)
        , 50.0)
  );

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
  t = (-b - sqrt(discriminant))/ 2*a; //t2 = (-b + discriminant)/ 2*a;
  return (discriminant > 0.0);
}

bool
intersectOld(in Sphere s, in Ray r, out float t)
{
  vec3 op = s.center - r.o;
  float b = dot(op,r.d); 
  float discriminant = b*b - dot(op,op) + s.r*s.r;
  float sqrtDisc=sqrt(discriminant);
  float t0 = b-sqrtDisc;
  float t1 = b+sqrtDisc;
  t = t0>eps ? t0 : (t1>eps ? t1 : 0.0);
  return (discriminant > 0.0);
}

vec3
calcNormal(in Sphere s, in vec3 P)
{
  return normalize(P - s.center);
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
shade(in vec3 P, in vec3 N, in vec3 V, in Material material)
{
  vec4 ambient = gPointLight.ambient * material.ka;

  vec3 L = normalize(gPointLight.location - P);
  vec3 H = normalize(L + V);
  vec4 diffuse = gPointLight.color * material.kd * max(0.0, dot(N,L));
  float s = max(dot(N,H),0.0);
  vec4 specular = pow(s,material.m) * material.ks * gPointLight.color;

  return ambient + diffuse + specular;
}

vec4
trace(Ray r,out Ray refl)
{
  refl = r;
  float tmin=infinity;
  float t=infinity;
  vec4 color = background();
  bool h = false;
  Sphere k = spheres[0];
  Material mat = materials[0];

  h = intersect(spheres[0], r, t);
  if (h && eps < t && t<tmin) {
    tmin=t;
    mat = materials[0];
    k = spheres[0];
  }
  h = intersect(spheres[1], r, t);
  if (h && eps < t && t<tmin) {
    tmin=t;
    mat = materials[1];
    k = spheres[1];
  }
  h = intersect(spheres[2], r, t);
  if (h && eps < t && t<tmin) {
    tmin=t;
    mat = materials[2];
    k = spheres[2];
  }
  h = intersect(spheres[3], r, t);
  if (h && eps < t && t<tmin) {
    tmin=t;
    mat = materials[3];
    k = spheres[3];
  }

  if (eps < tmin && tmin < infinity) {
    vec3 P = r.o + tmin*r.d;
    vec3 N = calcNormal(k,P);
    vec3 V = -r.d;
    color = shade(P, N, V, mat);
    refl = Ray(P,reflect(-V,N));
  }

  return color;
}

void 
main(void)
{
  vec4 color = empty;
  Ray r = eyeRay(gl_FragCoord.xy);
  Ray refl;
  color += trace(r,refl);
  Ray refl2;
  color = color + 0.1*trace(refl,refl2);
  Ray refl3;
  color = color + 0.05*trace(refl2,refl3);
  fragColor = color;
}
