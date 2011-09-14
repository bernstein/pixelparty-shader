#version 330


layout(triangles) in;

layout(triangle_strip, max_vertices = 3) out;
// layout(triangle_strip, max_vertices
// layout(max_vertices = 60) out;
// layout(triangle_strip) out;
// layout(points) out;
// layout(max_vertices = 30) out;

out vec2 tc;

void main()
{
  gl_Position = gl_in[0].gl_Position;
  tc = gl_in[0].gl_Position.xy;
  EmitVertex();

  gl_Position = gl_in[1].gl_Position;
  tc = gl_in[1].gl_Position.xy;
  EmitVertex();

  gl_Position = gl_in[2].gl_Position;
  tc = gl_in[2].gl_Position.xy;
  EmitVertex();

  EndPrimitive();
}

