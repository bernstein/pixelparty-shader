// -----------------------------------------------------------------------------
// some utilities

mat4 rotX(in float a);
mat4 rotY(in float a);
mat4 rotZ(in float a);
mat4 make_translate(vec3 tx);

mat4 perspective(in float fov, in float aspect, in float n, in float f);
mat4 from_frustum(in float l, in float r, in float t, in float b, in float n, in float f);
mat4 from_symmetric_frustum(in float l, in float b, in float n, in float f);

mat4
rotX(in float a)
{
  float c = cos(a);
  float s = sin(a);
  return transpose(
          mat4(1.0, 0.0, 0.0, 0.0,
              0.0,   c,   s, 0.0,
              0.0,  -s,   c, 0.0,
              0.0, 0.0, 0.0, 1.0 ));
}

mat4
rotY(in float a)
{
  float c = cos(a);
  float s = sin(a);
  return transpose(
        mat4(  c, 0.0,  -s, 0.0,
              0.0, 1.0, 0.0, 0.0,
                s, 0.0,   c, 0.0,
              0.0, 0.0, 0.0, 1.0 ));
}

mat4
rotZ(in float a)
{
  float c = cos(a);
  float s = sin(a);
  return transpose(
        mat4(  c,  -s, 0.0, 0.0,
                s,   c, 0.0, 0.0,
              0.0, 0.0, 1.0, 0.0,
              0.0, 0.0, 0.0, 1.0 ));
}

mat4
from_frustum(in float l, in float r, in float t, in float b, in float n, in float f)
{
  float r_lInv = 1.0 / (r - l);
  float t_bInv = 1.0 / (t - b);
  float f_nInv = 1.0 / (f - n);
  return transpose(
                mat4(2.0*r_lInv, 0.0, (r+l)*r_lInv, 0.0,
                     0.0, 2.0*n*t_bInv, (t+b)*t_bInv, 0.0,
                     0.0,      0.0, -(f+n)*f_nInv, -2*f*n*f_nInv,
                     0.0,      0.0,         -1.0,          0.0));
}

mat4
from_symmetric_frustum(in float l, in float b, in float n, in float f)
{
  float r = -l;
  float t = -b;

  float f_nInv = 1 / (f - n);
  return transpose(
          mat4( n/r, 0.0,0.0,0.0, 
               0.0, n/t, 0.0, 0.0,
               0.0, 0.0, -(f+n)*f_nInv, -2*f*n*f_nInv,
               0.0, 0.0, -1.0, 0.0));
}

mat4 
perspective(in float fov, in float aspect, in float n, in float f)
{
  float deg2rad = 0.0174532925;
  float t = tan(0.5*fov*deg2rad);
  float h = n * t;
  float w = h * aspect;

  //return from_frustum(-w, w, -h, h, n, f);
  return from_symmetric_frustum(-w, -h, n, f);
}

mat4
make_translate(vec3 tx)
{
  return transpose(
          mat4(1.0, 0.0, 0.0, tx.x,
              0.0, 1.0, 0.0, tx.y,
              0.0, 0.0, 1.0, tx.z,
              0.0, 0.0, 0.0, 1.0));
}
