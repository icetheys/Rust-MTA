#include "tex_matrix.fx"

texture sPicTexture;
texture sMaskTexture;

float2 gUVPrePosition = float2( 0, 0 );
float2 gUVScale = float( 1 );                     // UV scale
float2 gUVScaleCenter = float2( 0.5, 0.5 );
float gUVRotAngle = float( 0 );                   // UV Rotation
float2 gUVRotCenter = float2( 0.5, 0.5 );
float2 gUVPosition = float2( 0, 0 );              // UV position

float3x3 getTextureTransform()
{
    return makeTextureTransform( gUVPrePosition, gUVScale, gUVScaleCenter, gUVRotAngle, gUVRotCenter, gUVPosition );
}

technique hello
{
    pass P0
    {
        Texture[0] = sPicTexture;
        TextureTransform[0] = getTextureTransform();
        TextureTransformFlags[0] = Count2;
        AddressU[0] = Clamp;
        AddressV[0] = Clamp;
        // Color mix texture and diffuse
        ColorOp[0] = Modulate;
        ColorArg1[0] = Texture;
        ColorArg2[0] = Diffuse;

        AlphaOp[0] = Modulate;
        AlphaArg1[0] = Texture;
        AlphaArg2[0] = Diffuse;

        Texture[1] = sMaskTexture;
        TexCoordIndex[1] = 0;
        AddressU[1] = Clamp;
        AddressV[1] = Clamp;

        ColorOp[1] = SelectArg1;
        ColorArg1[1] = Current;

        AlphaOp[1] = Modulate;
        AlphaArg1[1] = Current;
        AlphaArg2[1] = Texture;

        ColorOp[2] = Disable;
        AlphaOp[2] = Disable;
    }
}
