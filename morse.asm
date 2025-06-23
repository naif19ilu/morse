.section .bss
	.trie: .zero 64
	.code: .zero 8

.section .text

.include "macros.inc"

.globl Morse

Morse:
	call	.TrieBuild
	# r9  = Code's length
	# r10 = Code itself
	xorq	%r9, %r9
	leaq	.code(%rip), %r10

.m_loop:
	movzbl	(%r8), %edi
	cmpb	$0, %dil
	je	.m_return
	# Store only morse character aka dot (.) and dash (-)
	cmpb	$'.', %dil
	je	.m_store
	cmpb	$'-', %dil
	je	.m_store
	cmpb	$' ', %dil
	je	.m_complete
	cmpb	$'/', %dil
	je	.m_space
	PUTS	$1, Unknown(%rip), $3
	jmp	.m_resume
.m_store:
	cmpq	$5, %r9
	je	.m_complete
	movb	%dil, (%r10)
	incq	%r9
	incq	%r10
	jmp	.m_resume
.m_complete:

	leaq	.code(%rip), %rdi
	call	.TrieGet	


	movq	%rax, %rbx
	leaq	.trie(%rip), %rax
	addq	%rbx, %rax
	movq	%rax, %rsi
	movq	$1, %rax
	movq	$1, %rdi
	movq	$1, %rdx
	syscall

	movq	$0, (.code)
	leaq	.code(%rip), %r10
	xorq	%r9, %r9
	jmp	.m_resume

.m_space:

.m_resume:
	incq	%r8
	jmp	.m_loop

.m_return:
	ret

.TrieBuild:
 	# r9  = Current morse code (address)
	# r10 = Number of codes parsed already
	# r11 = Alphabet character (goes along with r10)
	leaq	Code(%rip), %r9
	xorq	%r10, %r10
	leaq	Alphabet(%rip), %r11
.tb_loop:
	cmpq	$36, %r10
	je	.tb_return
	movq	(%r9), %rdi
	call	.TrieGet
	# Getting rax position within the trie to set
	# the r11th alphabet character in there
	movq	%rax, %rbx
	leaq	.trie(%rip), %rax
	addq	%rbx, %rax
	movzbl	(%r11), %edi
	movb	%dil, (%rax)
	incq	%r11
	incq	%r10
	addq	$8, %r9
	jmp	.tb_loop
.tb_return:
	ret

# This function gets the value within the trie of the code rdi holds
# in the moment this function is called. Return is given via rax
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
