# Morse - encoder and decoder
# 23 Jun 2025
# This file contains macros that text.asm, main.asm
# and morse.asm might use

.macro PUTS fd, msg, len
	leaq	\msg, %rsi
	movq	\len, %rdx
	movq	\fd,  %rdi
	movq	$1,   %rax
	syscall
.endm

.macro EXIT status
	movq	\status, %rdi
	movq	$60, %rax
	syscall
.endm

.macro PUTU offset
	leaq	Useful(%rip), %rsi
	addq	\offset, %rsi
	movq	$1, %rax
	movq	$1, %rdi
	movq	$1, %rdx
	syscall
.endm

.macro UNKCHR
	leaq	Unknown(%rip), %rdi
	movq	$-1, %rsi
	call	BufWri
.endm
