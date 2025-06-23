.section .rodata
	.trie: .bss 64

.section .bss
 	# Stores the current code in the message
	.code: .zero 8

.section .text

.globl Morse

Morse:
	call	.TrieBuild
	ret

.TrieBuild:
 	# r9  = Current morse code (address)
	# r10 = Number of codes parsed already
	leaq	Code(%rip), %r9
	xorq	%r10, %r10
	xorq	%r11, %r11
	xorq	%rdi, %rdi
.tb_loop:
	cmpq	$36, %r10
	je	.tb_return
	movq	(%r9), %rdi
	call	.TrieGet

	movq	%rax, %rdi
	movq	$60, %rax
	syscall

	incq	%r10
	addq	$8, %r9
	jmp	.tb_loop
.tb_return:
	ret

.TrieGet:
	xorq	%rax, %rax
	xorq	%rbx, %rbx
.tg_loop:
	movzbl	(%rdi), %ebx
	cmpb	$0, %bl
	je	.tg_return
	shlq	$1, %rax
	cmpb	$'.', %bl
	je	.tg_dot	
	addq	$2, %rax
	jmp	.tg_resume
.tg_dot:
	addq	$1, %rax
.tg_resume:
	incq	%rdi
	jmp	.tg_loop
.tg_return:
	ret