//Settings//
#include "/lib/common.glsl"

#define GBUFFERS_BEACONBEAM

#ifdef FSH

//Varyings//
in vec2 texCoord;
in vec4 color;

//Uniforms//
uniform sampler2D texture;

//Program//
void main() {
	vec4 albedo = texture2D(texture, texCoord) * color;
		 albedo.rgb *= 1.5 + clamp(pow16(length(albedo.rgb)), 0.0, 1.5);

	/* DRAWBUFFERS:0 */
	gl_FragData[0] = albedo;

	#ifdef BLOOM
	/* DRAWBUFFERS:02 */
	gl_FragData[1].b = 0.01;
	#endif

}

#endif

/////////////////////////////////////////////////////////////////////////////////////

#ifdef VSH

//Varyings//
out vec2 texCoord;
out vec4 color;

//Uniforms//
#ifdef TAA
uniform int framemod8;

uniform float viewWidth, viewHeight;
#endif

//Includes//
#ifdef TAA
#include "/lib/util/jitter.glsl"
#endif

//Program//
void main() {
	//Coord
    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

	//Color & Position
    color = gl_Color;

	gl_Position = ftransform();

	#ifdef TAA
	gl_Position.xy = TAAJitter(gl_Position.xy, gl_Position.w);
	#endif
}

#endif