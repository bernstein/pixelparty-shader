#version 330

smooth in vec2 tc;
out vec4 fragColor;

void
main(void)
{
  fragColor = vec4(tc,0.0,1.0);
}
