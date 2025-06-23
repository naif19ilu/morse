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

.macro PUTA a
.endm
