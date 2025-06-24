# Morse - encoder and decoder
# 23 Jun 2025
# This file handles english parsing

.section .text

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
	movq	(%rax, %rbx, 8), %rsi


	jmp	.t_resume
.t_unknown:
	# print the character as it is
	movq	$1, %rax
	movq	$1, %rdi
	movq	%r8, %rsi
	movq	$1, %rdx
	syscall
	jmp	.t_resume
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
	jmp	.ma_return
.ma_si:
	movq	$1, %rax
.ma_return:
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
	addb	$25, %dil
.go_return:
	movb	%dil, %al
	cltq
	ret
