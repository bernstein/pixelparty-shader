// from Visualizing Complex Functions by John L. Richardson
// http://web.archive.org/web/20030802162645/physics.hallym.ac.kr/education/TIPTOP/VLAB/QmSct/complex.html.
// Note: conformal maps, generalization of domain coloring

vec3
col(in vec2 z)
{
  float r = magnitude(z);
  float a = 0.40824829046386301636 * z.x;
  float b = 0.70710678118654752440 * z.y;
  float d = 1.0/(1.0 + r*r);
  vec3 rgb = vec3( 0.5 + 0.81649658092772603273 * z.x * d
                 , 0.5 - d * (a - b)
                 , 0.5 - d * (a+b));
  d = 0.5 - r*d;
  if (r < 1.0) { 
    d = -d; 
  }
  rgb += d;
  return rgb;
}
