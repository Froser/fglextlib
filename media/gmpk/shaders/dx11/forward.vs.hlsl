cbuffer MatrixBuffer
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

struct VS_INPUT
{
    float3 position    : POSITION;
    float3 normal      : NORMAL;
    float2 texcoord    : TEXCOORD0;
};

struct VS_OUTPUT
{
    float3 normal      : NORMAL;
    float2 texcoord    : TEXCOORD0;
    float4 position    : SV_POSITION;
};

VS_OUTPUT VS( VS_INPUT input )
{
    VS_OUTPUT output;
    output.position = float4(input.position.x, input.position.y, input.position.z, 1);
    output.position = mul(output.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);

    output.normal = input.normal;
    output.texcoord = input.texcoord;
    return output;
}