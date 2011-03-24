attribute vec2 position;

varying vec2 tc;
varying vec3 origin;
varying vec3 raydir;
/*
varying vec3 raydir;
uniform vec4 fpar00[16];

void main( void )
{
    vec3 r;

    gl_Position=gl_Vertex;

    r = gl_Vertex.xyz*vec3(1.3333,1.0,0.0)+vec3(0.0,0.0,-1.0);

    raydir.x=dot(r,fpar00[13].xyz);
    raydir.y=dot(r,fpar00[14].xyz);
    raydir.z=dot(r,fpar00[15].xyz);
};
*/ 

void
main()
{
  tc = position;
	gl_Position = vec4(position,0.,1.);
  origin = vec3(0.0);
  raydir = vec3(position.x * 1.66667, position.y, -1.0);
}
