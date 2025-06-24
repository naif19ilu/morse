# Morse - encoder and decoder
# 23 Jun 2025
# This file handles english parsing

.section .text

.include "macros.inc"

.globl Text

Text:
	xorq	%rax, %rax
.t_loop:
	movzbl	(%r8), %edi
	cmpb	$0, %dil
	je	.t_return
	call	.MorseAble
	cmpq	$0, %rax
	je	.t_unknown
	call	.GetOffset
	movq	%rax, %rbx
	leaq	Code(%rip), %rax
	movq	(%rax, %rbx, 8), %rdi
	movq	$-1, %rsi
	call	BufWri
	leaq	Useful(%rip), %rdi
	movq	$1, %rsi
	call	BufWri
	jmp	.t_resume
.t_unknown:
	cmpb	$' ', %dil
	je	.t_space
	UNKCHR
	jmp	.t_resume
.t_space:
	leaq	Useful(%rip), %rdi
	addq	$2, %rdi
	movq	$1, %rsi
	call	BufWri
.t_resume:
	incq	%r8
	jmp	.t_loop
.t_return:
	ret

.MorseAble:
	cmpb	$'0', %dil
	jl	.ma_no
	cmpb	$'9', %dil
	jle	.ma_si
	cmpb	$'A', %dil
	jl	.ma_no
	cmpb	$'Z', %dil
	jle	.ma_si
	cmpb	$'a', %dil
	jl	.ma_no
	cmpb	$'z', %dil
	jle	.ma_si
.ma_no:
	movq	$0, %rax
	ret
.ma_si:
	movq	$1, %rax
	ret

.GetOffset:
 	xorq	%rax, %rax
	cmpb	$'9', %dil
	jle	.go_number
	cmpb	$'Z', %dil
	jle	.go_upper
	jmp	.go_lower
.go_upper:
	addb	$32, %dil
.go_lower:
	subb	$'a', %dil
	jmp	.go_return
.go_number:
	subb	$'0', %dil
	addb	$26, %dil
.go_return:
	movb	%dil, %al
	cltq
	ret
