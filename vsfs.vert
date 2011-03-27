#version 130
in vec2 position;

smooth out vec2 tc;
smooth out vec3 origin;
smooth out vec3 raydir;

void
main()
{
  tc = position;
	gl_Position = vec4(position,0.,1.);
  origin = vec3(0.0);
  raydir = vec3(position.x * 1.66667, position.y, -1.0);
}
