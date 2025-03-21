; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py UTC_ARGS: --filter "LV: Found an estimated cost of [0-9]+ for VF [0-9]+ For instruction:\s*store i32 %valB, ptr %out, align 4"
; RUN: opt -passes=loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+sse2 --debug-only=loop-vectorize --disable-output < %s 2>&1 | FileCheck %s --check-prefixes=SSE2
; RUN: opt -passes=loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+sse4.2 --debug-only=loop-vectorize --disable-output < %s 2>&1 | FileCheck %s --check-prefixes=SSE42
; RUN: opt -passes=loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx  --debug-only=loop-vectorize --disable-output < %s 2>&1 | FileCheck %s --check-prefixes=AVX1
; RUN: opt -passes=loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx2,-fast-gather --debug-only=loop-vectorize --disable-output < %s 2>&1 | FileCheck %s --check-prefixes=AVX2
; RUN: opt -passes=loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx2,+fast-gather --debug-only=loop-vectorize --disable-output < %s 2>&1 | FileCheck %s --check-prefixes=AVX2
; RUN: opt -passes=loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx512bw --debug-only=loop-vectorize --disable-output < %s 2>&1 | FileCheck %s --check-prefixes=AVX512

; REQUIRES: asserts

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@A = global [1024 x i8] zeroinitializer, align 128
@B = global [1024 x i32] zeroinitializer, align 128
@C = global [1024 x i32] zeroinitializer, align 128

define void @test() {
; SSE2-LABEL: 'test'
; SSE2:  LV: Found an estimated cost of 1 for VF 1 For instruction: store i32 %valB, ptr %out, align 4
; SSE2:  LV: Found an estimated cost of 29 for VF 2 For instruction: store i32 %valB, ptr %out, align 4
; SSE2:  LV: Found an estimated cost of 59 for VF 4 For instruction: store i32 %valB, ptr %out, align 4
; SSE2:  LV: Found an estimated cost of 118 for VF 8 For instruction: store i32 %valB, ptr %out, align 4
; SSE2:  LV: Found an estimated cost of 236 for VF 16 For instruction: store i32 %valB, ptr %out, align 4
;
; SSE42-LABEL: 'test'
; SSE42:  LV: Found an estimated cost of 1 for VF 1 For instruction: store i32 %valB, ptr %out, align 4
; SSE42:  LV: Found an estimated cost of 26 for VF 2 For instruction: store i32 %valB, ptr %out, align 4
; SSE42:  LV: Found an estimated cost of 52 for VF 4 For instruction: store i32 %valB, ptr %out, align 4
; SSE42:  LV: Found an estimated cost of 104 for VF 8 For instruction: store i32 %valB, ptr %out, align 4
; SSE42:  LV: Found an estimated cost of 208 for VF 16 For instruction: store i32 %valB, ptr %out, align 4
;
; AVX1-LABEL: 'test'
; AVX1:  LV: Found an estimated cost of 1 for VF 1 For instruction: store i32 %valB, ptr %out, align 4
; AVX1:  LV: Found an estimated cost of 26 for VF 2 For instruction: store i32 %valB, ptr %out, align 4
; AVX1:  LV: Found an estimated cost of 53 for VF 4 For instruction: store i32 %valB, ptr %out, align 4
; AVX1:  LV: Found an estimated cost of 107 for VF 8 For instruction: store i32 %valB, ptr %out, align 4
; AVX1:  LV: Found an estimated cost of 214 for VF 16 For instruction: store i32 %valB, ptr %out, align 4
; AVX1:  LV: Found an estimated cost of 428 for VF 32 For instruction: store i32 %valB, ptr %out, align 4
;
; AVX2-LABEL: 'test'
; AVX2:  LV: Found an estimated cost of 1 for VF 1 For instruction: store i32 %valB, ptr %out, align 4
; AVX2:  LV: Found an estimated cost of 6 for VF 2 For instruction: store i32 %valB, ptr %out, align 4
; AVX2:  LV: Found an estimated cost of 13 for VF 4 For instruction: store i32 %valB, ptr %out, align 4
; AVX2:  LV: Found an estimated cost of 27 for VF 8 For instruction: store i32 %valB, ptr %out, align 4
; AVX2:  LV: Found an estimated cost of 54 for VF 16 For instruction: store i32 %valB, ptr %out, align 4
; AVX2:  LV: Found an estimated cost of 108 for VF 32 For instruction: store i32 %valB, ptr %out, align 4
;
; AVX512-LABEL: 'test'
; AVX512:  LV: Found an estimated cost of 1 for VF 1 For instruction: store i32 %valB, ptr %out, align 4
; AVX512:  LV: Found an estimated cost of 6 for VF 2 For instruction: store i32 %valB, ptr %out, align 4
; AVX512:  LV: Found an estimated cost of 13 for VF 4 For instruction: store i32 %valB, ptr %out, align 4
; AVX512:  LV: Found an estimated cost of 10 for VF 8 For instruction: store i32 %valB, ptr %out, align 4
; AVX512:  LV: Found an estimated cost of 18 for VF 16 For instruction: store i32 %valB, ptr %out, align 4
; AVX512:  LV: Found an estimated cost of 36 for VF 32 For instruction: store i32 %valB, ptr %out, align 4
; AVX512:  LV: Found an estimated cost of 72 for VF 64 For instruction: store i32 %valB, ptr %out, align 4
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]

  %inA = getelementptr inbounds [1024 x i8], ptr @A, i64 0, i64 %iv
  %valA = load i8, ptr %inA
  %valA.ext = sext i8 %valA to i64

  %inB = getelementptr inbounds [1024 x i32], ptr @B, i64 0, i64 %iv
  %valB = load i32, ptr %inB

  %out = getelementptr inbounds [1024 x i32], ptr @C, i64 0, i64 %valA.ext
  store i32 %valB, ptr %out

  %iv.next = add nuw nsw i64 %iv, 1
  %cmp = icmp ult i64 %iv.next, 1024
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  ret void
}
