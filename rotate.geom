#version 330

#include <complex.glsl>

uniform float time;

layout(triangles) in;

layout(triangle_strip, max_vertices = 3) out;
// layout(triangle_strip, max_vertices
// layout(max_vertices = 60) out;
// layout(triangle_strip) out;
// layout(points) out;
// layout(max_vertices = 30) out;

out vec2 tc;

const float pi = 3.14159265358979323846264;

void main()
{

  float s = sin(time) + 1.0;

  gl_Position = gl_in[0].gl_Position;
  gl_Position.xy = complexMult(cis(pi*s), gl_in[0].gl_Position.xy);
  tc = gl_in[0].gl_Position.xy;
  EmitVertex();

  gl_Position = gl_in[1].gl_Position;
  gl_Position.xy = complexMult(cis(pi*s), gl_in[1].gl_Position.xy);
  tc = gl_in[1].gl_Position.xy;
  EmitVertex();

  gl_Position = gl_in[2].gl_Position;
  gl_Position.xy = complexMult(cis(pi*s), gl_in[2].gl_Position.xy);
  tc = gl_in[2].gl_Position.xy;
  EmitVertex();

  EndPrimitive();
}

