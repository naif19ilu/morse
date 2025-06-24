# Morse - encoder and decoder
# 23 Jun 2025
# This file is the program's starting point

.section .rodata
	.usage_msg: .string "morse-usage: morse [mode] [message]\n"
	.usage_len: .quad    36

.section .text

.include "macros.inc"

.globl _start

_start:
	popq	%rax
	cmpq	$3, %rax
	jne	.usage
	# rax = executable name
	# rax = mode to be used
	# r8  = message
	popq	%rax
	popq	%rax
	popq	%r8
	movzbl	(%rax), %edi
	cmpb	$'m', %dil
	je	.m_mode
	cmpb	$'t', %dil
	je	.t_mode
	jmp	.usage
.m_mode:
	call	Morse
	jmp	.leave
.t_mode:
	call	Text
	jmp	.leave
.leave:
	call	BufPuts
	PUTU	$1
	EXIT	$0
.usage:
	PUTS	$2, .usage_msg(%rip), .usage_len(%rip)
	EXIT	$1
