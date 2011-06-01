#version 130
layout(location=0) in vec4 position;

smooth out vec2 tc;
smooth out vec3 origin;
smooth out vec3 raydir;

void
main()
{
  tc = position.xy;
  gl_Position = position;
  origin = vec3(0.0);
  raydir = vec3(position.x * 1.66667, position.y, -1.0);
}
