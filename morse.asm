.section .bss
	.trie: .zero 64

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
