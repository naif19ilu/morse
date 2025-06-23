.section .rodata
	.trie: .bss 64

.section .bss
 	# Stores the current code in the message
	.code: .zero 8

.section .text

.globl Morse

Morse:
 	# r9  = current morse code
	# r10 = r9's length
	leaq	.code(%rip), %r9
	xorq	%r10, %r10
.loop:
	movzbl	(%r8), %edi
	cmpb	$0, %dil
	je	.return
	cmpb	$'.', %dil
	je	.ok
	cmpb	$'-', %dil
	je	.ok
	cmpb	$' ', %dil
	je	.print
	cmpb	$'/', %dil
	je	.space
	jmp	.resume
.ok:
 	# The maximum length of a morse code is
	# 5 characters, if 5 bytes were already
	# written then we got a code to be translated
	cmpq	$5, %r10
	je	.print
	movb	%dil, (%r9)
	incq	%r9
	incq	%r10
	jmp	.resume
.print:

.space:

.resume:
	incq	%r8
	jmp	.loop
.return:
	ret

.TrieBuild: