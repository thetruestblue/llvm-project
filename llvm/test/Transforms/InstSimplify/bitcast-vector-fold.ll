; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s
; RUN: opt < %s -passes=instsimplify -use-constant-fp-for-fixed-length-splat -use-constant-int-for-fixed-length-splat -S | FileCheck %s
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-f64:32:64-v64:64:64-v128:128:128"

define <2 x i64> @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret <2 x i64> <i64 4294967296, i64 12884901890>
;
  %tmp3 = bitcast <4 x i32> < i32 0, i32 1, i32 2, i32 3 > to <2 x i64>
  ret <2 x i64> %tmp3
}

define <4 x i32> @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret <4 x i32> <i32 0, i32 0, i32 1, i32 0>
;
  %tmp3 = bitcast <2 x i64> < i64 0, i64 1 > to <4 x i32>
  ret <4 x i32> %tmp3
}

define <2 x double> @test3() {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret <2 x double> <double 0x100000000, double 0x300000002>
;
  %tmp3 = bitcast <4 x i32> < i32 0, i32 1, i32 2, i32 3 > to <2 x double>
  ret <2 x double> %tmp3
}

define <4 x float> @test4() {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret <4 x float> <float 0.000000e+00, float 0.000000e+00, float 0x36A0000000000000, float 0.000000e+00>
;
  %tmp3 = bitcast <2 x i64> < i64 0, i64 1 > to <4 x float>
  ret <4 x float> %tmp3
}

define <2 x i64> @test5() {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret <2 x i64> <i64 4575657221408423936, i64 4629700418010611712>
;
  %tmp3 = bitcast <4 x float> <float 0.0, float 1.0, float 2.0, float 3.0> to <2 x i64>
  ret <2 x i64> %tmp3
}

define <4 x i32> @test6() {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret <4 x i32> <i32 0, i32 1071644672, i32 0, i32 1072693248>
;
  %tmp3 = bitcast <2 x double> <double 0.5, double 1.0> to <4 x i32>
  ret <4 x i32> %tmp3
}

define i32 @test7() {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i32 1118464
;
  %tmp3 = bitcast <2 x half> <half 0xH1100, half 0xH0011> to i32
  ret i32 %tmp3
}

define <4 x i32> @test8(<1 x i64> %y) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret <4 x i32> zeroinitializer
;
  %c = bitcast <2 x i64> <i64 0, i64 0> to <4 x i32>
  ret <4 x i32> %c
}

define <4 x i32> @test9(<1 x i64> %y) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    ret <4 x i32> splat (i32 -1)
;
  %c = bitcast <2 x i64> <i64 -1, i64 -1> to <4 x i32>
  ret <4 x i32> %c
}

define <1 x i1> @test10() {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret <1 x i1> zeroinitializer
;
  %ret = icmp eq <1 x i64> <i64 bitcast (<1 x double> <double 0xFFFFFFFFFFFFFFFF> to i64)>, zeroinitializer
  ret <1 x i1> %ret
}

; from MultiSource/Benchmarks/Bullet
define <2 x float> @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    ret <2 x float> splat (float 0xFFFFFFFFE0000000)
;
  %cast = bitcast i64 -1 to <2 x float>
  ret <2 x float> %cast
}


define <2 x double> @foo2() {
; CHECK-LABEL: @foo2(
; CHECK-NEXT:    ret <2 x double> splat (double 0xFFFFFFFFFFFFFFFF)
;
  %cast = bitcast i128 -1 to <2 x double>
  ret <2 x double> %cast
}

define <1 x float> @foo3() {
; CHECK-LABEL: @foo3(
; CHECK-NEXT:    ret <1 x float> splat (float 0xFFFFFFFFE0000000)
;
  %cast = bitcast i32 -1 to <1 x float>
  ret <1 x float> %cast
}

define float @foo4() {
; CHECK-LABEL: @foo4(
; CHECK-NEXT:    ret float 0xFFFFFFFFE0000000
;
  %cast = bitcast <1 x i32 ><i32 -1> to float
  ret float %cast
}

define double @foo5() {
; CHECK-LABEL: @foo5(
; CHECK-NEXT:    ret double 0xFFFFFFFFFFFFFFFF
;
  %cast = bitcast <2 x i32 ><i32 -1, i32 -1> to double
  ret double %cast
}

define <2 x double> @foo6() {
; CHECK-LABEL: @foo6(
; CHECK-NEXT:    ret <2 x double> splat (double 0xFFFFFFFFFFFFFFFF)
;
  %cast = bitcast <4 x i32><i32 -1, i32 -1, i32 -1, i32 -1> to <2 x double>
  ret <2 x double> %cast
}

define <4 x i32> @bitcast_constexpr_4i32_2i64_u2() {
; CHECK-LABEL: @bitcast_constexpr_4i32_2i64_u2(
; CHECK-NEXT:    ret <4 x i32> <i32 undef, i32 undef, i32 2, i32 0>
;
  %cast = bitcast <2 x i64><i64 undef, i64 2> to <4 x i32>
  ret <4 x i32> %cast
}

define <4 x i32> @bitcast_constexpr_4i32_2i64_1u() {
; CHECK-LABEL: @bitcast_constexpr_4i32_2i64_1u(
; CHECK-NEXT:    ret <4 x i32> <i32 1, i32 0, i32 undef, i32 undef>
;
  %cast = bitcast <2 x i64><i64 1, i64 undef> to <4 x i32>
  ret <4 x i32> %cast
}

define <4 x i32> @bitcast_constexpr_4i32_2i64() {
; CHECK-LABEL: @bitcast_constexpr_4i32_2i64(
; CHECK-NEXT:    ret <4 x i32> <i32 undef, i32 undef, i32 2, i32 0>
;
  %cast = bitcast <2 x i64><i64 undef, i64 2> to <4 x i32>
  ret <4 x i32> %cast
}

define <8 x i16> @bitcast_constexpr_8i16_2i64_u2() {
; CHECK-LABEL: @bitcast_constexpr_8i16_2i64_u2(
; CHECK-NEXT:    ret <8 x i16> <i16 undef, i16 undef, i16 undef, i16 undef, i16 2, i16 0, i16 0, i16 0>
;
  %cast = bitcast <2 x i64><i64 undef, i64 2> to <8 x i16>
  ret <8 x i16> %cast
}

define <8 x i16> @bitcast_constexpr_8i16_2i64_1u() {
; CHECK-LABEL: @bitcast_constexpr_8i16_2i64_1u(
; CHECK-NEXT:    ret <8 x i16> <i16 1, i16 0, i16 0, i16 0, i16 undef, i16 undef, i16 undef, i16 undef>
;
  %cast = bitcast <2 x i64><i64 1, i64 undef> to <8 x i16>
  ret <8 x i16> %cast
}

define <8 x i16> @bitcast_constexpr_8i16_2i64_u65536() {
; CHECK-LABEL: @bitcast_constexpr_8i16_2i64_u65536(
; CHECK-NEXT:    ret <8 x i16> <i16 undef, i16 undef, i16 undef, i16 undef, i16 0, i16 1, i16 0, i16 0>
;
  %cast = bitcast <2 x i64><i64 undef, i64 65536> to <8 x i16>
  ret <8 x i16> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_2i64_u2() {
; CHECK-LABEL: @bitcast_constexpr_16i8_2i64_u2(
; CHECK-NEXT:    ret <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 2, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
;
  %cast = bitcast <2 x i64><i64 undef, i64 2> to <16 x i8>
  ret <16 x i8> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_2i64_256u() {
; CHECK-LABEL: @bitcast_constexpr_16i8_2i64_256u(
; CHECK-NEXT:    ret <16 x i8> <i8 0, i8 1, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>
;
  %cast = bitcast <2 x i64><i64 256, i64 undef> to <16 x i8>
  ret <16 x i8> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_2i64_u256() {
; CHECK-LABEL: @bitcast_constexpr_16i8_2i64_u256(
; CHECK-NEXT:    ret <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 1, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
;
  %cast = bitcast <2 x i64><i64 undef, i64 256> to <16 x i8>
  ret <16 x i8> %cast
}

define <8 x i16> @bitcast_constexpr_8i16_4i32_uu22() {
; CHECK-LABEL: @bitcast_constexpr_8i16_4i32_uu22(
; CHECK-NEXT:    ret <8 x i16> <i16 undef, i16 undef, i16 undef, i16 undef, i16 2, i16 0, i16 2, i16 0>
;
  %cast = bitcast <4 x i32><i32 undef, i32 undef, i32 2, i32 2> to <8 x i16>
  ret <8 x i16> %cast
}

define <8 x i16> @bitcast_constexpr_8i16_4i32_10uu() {
; CHECK-LABEL: @bitcast_constexpr_8i16_4i32_10uu(
; CHECK-NEXT:    ret <8 x i16> <i16 1, i16 0, i16 0, i16 0, i16 undef, i16 undef, i16 undef, i16 undef>
;
  %cast = bitcast <4 x i32><i32 1, i32 0, i32 undef, i32 undef> to <8 x i16>
  ret <8 x i16> %cast
}

define <8 x i16> @bitcast_constexpr_8i16_4i32_u257u256() {
; CHECK-LABEL: @bitcast_constexpr_8i16_4i32_u257u256(
; CHECK-NEXT:    ret <8 x i16> <i16 undef, i16 undef, i16 0, i16 1, i16 undef, i16 undef, i16 0, i16 1>
;
  %cast = bitcast <4 x i32><i32 undef, i32 65536, i32 undef, i32 65536> to <8 x i16>
  ret <8 x i16> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_4i32_u2u2() {
; CHECK-LABEL: @bitcast_constexpr_16i8_4i32_u2u2(
; CHECK-NEXT:    ret <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 2, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 2, i8 0, i8 0, i8 0>
;
  %cast = bitcast <4 x i32><i32 undef, i32 2, i32 undef, i32 2> to <16 x i8>
  ret <16 x i8> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_4i32_1u1u() {
; CHECK-LABEL: @bitcast_constexpr_16i8_4i32_1u1u(
; CHECK-NEXT:    ret <16 x i8> <i8 1, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 1, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef>
;
  %cast = bitcast <4 x i32><i32 1, i32 undef, i32 1, i32 undef> to <16 x i8>
  ret <16 x i8> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_4i32_u256uu() {
; CHECK-LABEL: @bitcast_constexpr_16i8_4i32_u256uu(
; CHECK-NEXT:    ret <16 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 1, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>
;
  %cast = bitcast <4 x i32><i32 undef, i32 256, i32 undef, i32 undef> to <16 x i8>
  ret <16 x i8> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_8i16_u2u2u2u2() {
; CHECK-LABEL: @bitcast_constexpr_16i8_8i16_u2u2u2u2(
; CHECK-NEXT:    ret <16 x i8> <i8 undef, i8 undef, i8 2, i8 0, i8 undef, i8 undef, i8 2, i8 0, i8 undef, i8 undef, i8 2, i8 0, i8 undef, i8 undef, i8 2, i8 0>
;
  %cast = bitcast <8 x i16><i16 undef, i16 2, i16 undef, i16 2, i16 undef, i16 2, i16 undef, i16 2> to <16 x i8>
  ret <16 x i8> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_8i16_1u1u1u1u() {
; CHECK-LABEL: @bitcast_constexpr_16i8_8i16_1u1u1u1u(
; CHECK-NEXT:    ret <16 x i8> <i8 1, i8 0, i8 undef, i8 undef, i8 1, i8 0, i8 undef, i8 undef, i8 1, i8 0, i8 undef, i8 undef, i8 1, i8 0, i8 undef, i8 undef>
;
  %cast = bitcast <8 x i16><i16 1, i16 undef, i16 1, i16 undef, i16 1, i16 undef, i16 1, i16 undef> to <16 x i8>
  ret <16 x i8> %cast
}

define <16 x i8> @bitcast_constexpr_16i8_8i16_u256uuu256uu() {
; CHECK-LABEL: @bitcast_constexpr_16i8_8i16_u256uuu256uu(
; CHECK-NEXT:    ret <16 x i8> <i8 undef, i8 undef, i8 0, i8 1, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 1, i8 undef, i8 undef, i8 undef, i8 undef>
;
  %cast = bitcast <8 x i16><i16 undef, i16 256, i16 undef, i16 undef, i16 undef, i16 256, i16 undef, i16 undef> to <16 x i8>
  ret <16 x i8> %cast
}

define <1 x i32> @bitcast_constexpr_scalar_fp_to_vector_int() {
; CHECK-LABEL: @bitcast_constexpr_scalar_fp_to_vector_int(
; CHECK-NEXT:    ret <1 x i32> splat (i32 1065353216)
;
  %res = bitcast float 1.0 to <1 x i32>
  ret <1 x i32> %res
}

define <2 x i64> @bitcast_constexpr_4f32_2i64_1111() {
; CHECK-LABEL: @bitcast_constexpr_4f32_2i64_1111(
; CHECK-NEXT:    ret <2 x i64> splat (i64 4575657222473777152)
;
  %res = bitcast <4 x float> splat (float 1.0) to <2 x i64>
  ret <2 x i64> %res
}
