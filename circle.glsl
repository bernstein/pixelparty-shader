#version 330
uniform float time;
uniform sampler2D tex0;
uniform vec2 resolution;

smooth in vec2 tc;
out vec4 fragColor;
const float rIn = 0.6;
const float rOut = 0.7;

void main()
{
	float d = distance(tc, vec2(0.0));
	if( d > rOut || d < rIn)
		discard;
	fragColor = vec4(1.0);
}
