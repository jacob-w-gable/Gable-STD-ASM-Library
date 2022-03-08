%include "includes.asm"

; docs: https://x86.puri.sm/

section .data
	helloTag db 'Hello, welcome to the multiplier calculator!', 0
	firstTag db 'Enter first number: ', 0
	secondTag db 'Enter second number: ', 0
	resultTag db 'Here is the result: ', 0

section .bss
	firstNum resq 1
	secondNum resq 1
	result resq 1
	
section .text
global _start
_start:

	printline helloTag 					; display hello
	
	promptint firstTag, firstNum		; get two numbers
	promptint secondTag, secondNum
	
	mov rax, [firstNum]					; multiply them together
	xor rdx, rdx
	mov rbx, [secondNum]
	imul rbx
	mov [result], rax
	
	print resultTag						; print result
	printint result
	newline
    
	exit 0								; exit successfully

