// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.04 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.04;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:0,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:2,bsrc:0,bdst:0,culm:2,dpts:2,wrdp:False,dith:2,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:6987,x:33090,y:32668,varname:node_6987,prsc:2|emission-8198-OUT;n:type:ShaderForge.SFN_Tex2d,id:9144,x:32405,y:32616,varname:node_9144,prsc:2,tex:27a981ef8f6b3ba40a29ded93dc5ecf1,ntxv:0,isnm:False|UVIN-5023-UVOUT,TEX-3883-TEX;n:type:ShaderForge.SFN_Tex2dAsset,id:3883,x:32129,y:32678,ptovrint:False,ptlb:ScrollingFire,ptin:_ScrollingFire,varname:node_3883,tex:27a981ef8f6b3ba40a29ded93dc5ecf1,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2dAsset,id:8814,x:32110,y:32999,ptovrint:False,ptlb:stillAlpha,ptin:_stillAlpha,varname:node_8814,tex:ffd1a50b0ba557445a1b273f635bb2b2,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Panner,id:5023,x:32228,y:32520,varname:node_5023,prsc:2,spu:0,spv:1;n:type:ShaderForge.SFN_Multiply,id:8198,x:32580,y:32781,varname:node_8198,prsc:2|A-9144-RGB,B-2531-RGB,C-1461-OUT,D-6171-OUT;n:type:ShaderForge.SFN_Tex2d,id:2531,x:32366,y:32901,varname:node_2531,prsc:2,tex:ffd1a50b0ba557445a1b273f635bb2b2,ntxv:0,isnm:False|TEX-8814-TEX;n:type:ShaderForge.SFN_Fresnel,id:6693,x:32100,y:32842,varname:node_6693,prsc:2|EXP-1152-OUT;n:type:ShaderForge.SFN_OneMinus,id:1461,x:32337,y:32781,varname:node_1461,prsc:2|IN-6693-OUT;n:type:ShaderForge.SFN_Vector1,id:1152,x:31895,y:32900,varname:node_1152,prsc:2,v1:0.9;n:type:ShaderForge.SFN_Vector1,id:6171,x:32494,y:32942,varname:node_6171,prsc:2,v1:1.8;proporder:3883-8814;pass:END;sub:END;*/

Shader "Shader Forge/fireScroll" {
    Properties {
        _ScrollingFire ("ScrollingFire", 2D) = "white" {}
        _stillAlpha ("stillAlpha", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _ScrollingFire; uniform float4 _ScrollingFire_ST;
            uniform sampler2D _stillAlpha; uniform float4 _stillAlpha_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
////// Lighting:
////// Emissive:
                float4 node_8830 = _Time + _TimeEditor;
                float2 node_5023 = (i.uv0+node_8830.g*float2(0,1));
                float4 node_9144 = tex2D(_ScrollingFire,TRANSFORM_TEX(node_5023, _ScrollingFire));
                float4 node_2531 = tex2D(_stillAlpha,TRANSFORM_TEX(i.uv0, _stillAlpha));
                float3 emissive = (node_9144.rgb*node_2531.rgb*(1.0 - pow(1.0-max(0,dot(normalDirection, viewDirection)),0.9))*1.8);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
