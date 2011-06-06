#version 330

smooth in vec2 tc;

void
main(void)
{
  gl_FragColor = vec4(tc,0.0,1.0);
}
