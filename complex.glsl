// -----------------------------------------------------------------------------
// type complex = vec2

vec2
complexMult(in vec2 z0, in vec2 z1)
{
  float a = z0.x*z1.x - z0.y*z1.y;
  float b = z0.x*z1.y + z0.y*z1.x;
  return vec2(a,b);
}

vec2
complexSquare(in vec2 z)
{
  return vec2(z.x*z.x-z.y*z.y,2.0*z.x*z.y);
}

float
realPart(vec2 z)
{
  return z.x;
}

float
imagPart(vec2 z)
{
  return z.y;
}

float
arg(vec2 z)
{
  return atan(z.y,z.x);
}

vec2
polar(in vec2 z)
{
  return vec2(length(z), arg(z));
}

// e^ix = cos(x) + i*sin(x)
vec2
cis(float phi)
{
  return vec2(cos(phi),sin(phi));
}

vec2
mkPolar(in float r, in float phi)
{
  return r*cis(phi);
}

vec2
complexInvert(in vec2 z)
{
  float rinv = 1.0/length(z);
  float phi = arg(z);
  //return rinv * vec2(cos(-phi),sin(-phi));
  return rinv * vec2(cos(phi),sin(phi));
}
