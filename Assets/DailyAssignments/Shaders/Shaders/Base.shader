﻿

Shader "Custom/Base" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo 1 (RGB)", 2D) = "white" {}
		_NormalMap("Normal 1", 2D) = "white" {}
		_MainTex2 ("Albedo 2 (RGB)", 2D) = "white" {}
		_NormalMap2("Normal 2", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_AlbedoLerp ("Lerp val", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _MainTex2;
		sampler2D _NormalMap;
		sampler2D _NormalMap2;

		struct Input {
			float2 uv_MainTex;
			float2 uv_MainTex2;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _AlbedoLerp;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 c2 = tex2D (_MainTex2, IN.uv_MainTex2);
			fixed4 col = lerp(c, c2, _AlbedoLerp) * _Color;
			o.Albedo = col.rgb;

			float4 n1 = tex2D(_NormalMap, IN.uv_MainTex);
			float4 n2 = tex2D(_NormalMap2, IN.uv_MainTex2);
			float4 trueN = lerp(n1, n2, _AlbedoLerp);

			float3 normal = UnpackNormal(trueN);
			//float3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
			o.Normal = normal;

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = col.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
