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

	movq	$60, %rax
	movq	$60, %rdi
	syscall

.usage:
	PUTS	$2, .usage_msg(%rip), .usage_len(%rip)
	EXIT	$1
