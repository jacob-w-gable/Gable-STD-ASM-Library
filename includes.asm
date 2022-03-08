
; Commands:
;
;	exit <code>
;		- Exits the program
;
;	print <text>
;		- prints a given text to the screen
;
;	printline <text>
;		- prints a given text to the screen and moves to the next line
;
;	printint <qword>
;		- prints the given qword to the screen
;
;	newline
;		- prints a new-line character to the screen
;
;	readline <text> <length>
;		- reads text from the screen into "text" variable of length "length"
;
;	readint <qword>
; 		- reads an integer from the screen into the given qword
;
;	prompt <prompt-text> <destination-bytes> <bytes-length>
;		- prompts a user with text and saves input in destination variable
;
;	promptint <prompt-text> <destination-qword>
;		- prompts a user with text and saves input in destination variable (qword integer)
;
;	itoa <text/destination> <qword/source>
;		- converts integer to ascii
;
;	atoi <qword/destination> <text/source>
;		- converts ascii to integer
;
;	debug
;		- prints DEBUG to the screen



%ifndef INCLUDES_ASM
	%define INCLUDES_ASM

	%macro exit 1
		mov rax, 1
		mov rbx, %1
		int 80h
	%endmacro
	
	%macro promptint 2
		print %1
		readint %2
	%endmacro
	
	%macro prompt 3
		print %1
		readline %2, %3	
	%endmacro
	
	%macro printint 1
		itoa gablenumbertextbuffer, [%1]
		print gablenumbertextbuffer
	%endmacro
	
	%macro readint 1
		readline gablenumbertextbuffer, 12
		atoi [%1], gablenumbertextbuffer
	%endmacro
	
	%macro printline 1
		print %1
		newline
	%endmacro

	%macro print 1
		pushregisters
		
		lea rax, %1
		push rax
		call print_proc
		
		popregisters
	%endmacro

	%macro newline 0
		pushregisters
		
		mov rax, 4
		mov rbx, 1
		mov rcx, endl
		mov rdx, 1
		int 80h
		
		popregisters
	%endmacro
	
	%macro debug 0
		pushregisters
		
		mov rax, 4
		mov rbx, 1
		mov rcx, debugtext
		mov rdx, 6
		int 80h
		
		popregisters
	%endmacro

	%macro readline 2
		pushregisters
		
		mov rax, %2
		push rax
		lea rax, %1
		push rax
		call readline_proc
		
		popregisters
			
	%endmacro

	%macro ftoa 2
		pushregisters

		lea rax, %2
		push rax
		lea rax, %1
		push rax
		call ftoa_proc

		popregisters
	%endmacro

	; atof destination, source
	%macro atof 2
		pushregisters

		lea rax, %2
		push rax
		lea rax, %1
		push rax
		call atof_proc

		popregisters
	%endmacro
	
	; itoa destination, source
	; destination should be at least 12 characters long
	%macro itoa 2
		pushregisters
		
		lea rax, %2
		push rax
		lea rax, %1
		push rax
		call itoa_proc
		
		popregisters
	%endmacro
	
	; atoi destination, source
	%macro atoi 2
		pushregisters
		
		lea rax, %2
		push rax
		lea rax, %1
		push rax
		call atoi_proc
		
		popregisters
	%endmacro
	
	%macro pushregisters 0
		push rax
		push rbx
		push rcx
		push rdx
		pushfq
	%endmacro

	%macro popregisters 0
		popfq
		pop rdx
		pop rcx
		pop rbx
		pop rax
	%endmacro

	section .data
		endl db 0ah, 0
		gabledebugtext db "DEBUG", 0
		gablefloat_zero dq 0.0
		gablefloat_one dq 1.0
		gablefloat_two dq 2.0
		gablefloat_three dq 3.0
		gablefloat_four dq 4.0
		gablefloat_five dq 5.0
		gablefloat_six dq 6.0
		gablefloat_seven dq 7.0
		gablefloat_eight dq 8.0
		gablefloat_nine dq 9.0
		gablefloat_ten dq 10.0
		gablefloat_neg_one dq -1.0
	
	section .bss
		gablenumbertextbuffer resb 12
		
	section .text
	
		readline_proc:
			push rbp
			mov rbp, rsp
			
			mov rdi, [rbp+16]
			mov rcx, [rbp+24]
			dec rcx
			
			inputClear:
				mov BYTE [rdi+rcx], 0
				loop inputClear
			
			mov rax, 3
			mov rbx, 2
			mov rcx, rdi
			mov rdx, [rbp+24]
			int 80h
			
			xor rcx, rcx
			dec rdx
			
			inputL1:
				cmp BYTE [rdi], 10
				je inputL2
				cmp rcx, rdx
				je inputL2
				inc rcx
				inc rdi
				jmp inputL1
			inputL2:
				mov BYTE [rdi], 0				
			
			pop rbp
			ret 16
	
		print_proc:
			push rbp
			mov rbp, rsp
			
			mov rdi, [rbp+16]
			mov rax, 0
			
			outputL1:
				cmp BYTE [rdi], 0
				je outputL2
				inc rdi
				inc rax
				jmp outputL1
			outputL2:
			
			mov rdx, rax
			mov rax, 4
			mov rbx, 1
			mov rcx, [rbp+16]
			int 80h
			
			pop rbp
			ret 8

		push_digit_as_float:
			push rbp
			mov rbp, rsp

			mov rax, [rbp+16]

			cmp rax, 0
			je pdaf_zero
			cmp rax, 1
			je pdaf_one
			cmp rax, 2
			je pdaf_two
			cmp rax, 3
			je pdaf_three
			cmp rax, 4
			je pdaf_four
			cmp rax, 5
			je pdaf_five
			cmp rax, 6
			je pdaf_six
			cmp rax, 7
			je pdaf_seven
			cmp rax, 8
			je pdaf_eight
			cmp rax, 9
			je pdaf_nine

			pdaf_zero: fld QWORD [gablefloat_zero]
				jmp atofnumend
			pdaf_one: fld QWORD [gablefloat_one]
				jmp atofnumend
			pdaf_two: fld QWORD [gablefloat_two]
				jmp atofnumend
			pdaf_three: fld QWORD [gablefloat_three]
				jmp atofnumend
			pdaf_four: fld QWORD [gablefloat_four]
				jmp atofnumend
			pdaf_five: fld QWORD [gablefloat_five]
				jmp atofnumend
			pdaf_six: fld QWORD [gablefloat_six]
				jmp atofnumend
			pdaf_seven: fld QWORD [gablefloat_seven]
				jmp atofnumend
			pdaf_eight: fld QWORD [gablefloat_eight]
				jmp atofnumend
			pdaf_nine: fld QWORD [gablefloat_nine]
			atofnumend:

			pop rbp
			ret 8

		ftoa_proc:
			push rbp
			mov rbp, rsp

			mov rdi, [rbp+16]
			

			pop rbp
			ret 16

		atof_proc:
			push rbp
			mov rbp, rsp

			mov rdi, [rbp+24]

			mov r8, 0  ; bool: sign
			mov r9, 0  ; bool: past decimal
			mov r10, gablefloat_one ; point significance
			fld QWORD [gablefloat_zero] ; output number

			atofL1:
				cmp BYTE [rdi], 0 ; string ends
				je atofL2
				cmp BYTE [rdi], '-'
				je atofnegative
				cmp BYTE [rdi], '.'
				je atofpoint
				; else

				cmp r9, 0
				jne atofafterpoint

				atofbeforepoint:
					fld QWORD [gablefloat_ten]
					fmulp

					mov rax, 0
					mov al, BYTE [rdi]
					sub rax, '0'
					
					push rax
					call push_digit_as_float

					faddp

					inc rdi
					jmp atofL1

				atofafterpoint:
					fld QWORD [r10]
					fld QWORD [gablefloat_ten]
					fdivp

					fst QWORD [r10]

					mov rax, 0
					mov al, BYTE [rdi]
					sub rax, '0'

					push rax
					call push_digit_as_float
					
					fmulp
					faddp

					inc rdi
					jmp atofL1

				atofnegative:
					mov r8, 1
					inc rdi
					jmp atofL1

				atofpoint:
					mov r9, 1
					inc rdi
					jmp atofL1


			atofL2:
				cmp r8, 0
				je atofEnd
				fld QWORD [gablefloat_neg_one]
				fmulp
			
			atofEnd:
				mov rax, QWORD [rbp+16]
				fstp QWORD [rax]

			pop rbp
			ret 16
		
		atoi_proc:
			push rbp
			mov rbp, rsp
			
			mov rdi, [rbp+24] ; address of ascii text
			
			mov rbx, 0 ; sign
			mov rcx, 0 ; output number
			
			atoiL1:
				cmp BYTE [rdi], 0 ; string ends
				je atoiL2
				cmp BYTE [rdi], '-' ; if byte == '-', jump negative
				je atoinegative
									; else		
				mov rax, rcx
				mov rcx, 10
				imul rcx
				mov rcx, rax
				mov rax, 0
				mov al, BYTE [rdi]
				sub rax, '0'
				add rcx, rax
				
				inc rdi
				jmp atoiL1
				
				
				atoinegative:
					mov rbx, 1
					inc rdi
					jmp atoiL1
				
			atoiL2:
			
			cmp rbx, 1
			mov rax, rcx
			jne atoicont
			mov rcx, -1
			imul rcx
			
			atoicont:
						
			mov rcx, [rbp+16] ; integer number
			mov [rcx], rax
			
			pop rbp
			ret 16
			
		itoa_proc:
			push rbp
			mov rbp, rsp
			
			mov rdi, [rbp+16] ; ascii text
			mov rcx, 11
			
			itoaClear:
				mov BYTE [rdi+rcx], 0
				loop itoaClear
			
			mov rbx, [rbp+24] ; integer number
			mov rax, [rbx]    ; now in rax
			xor rbx, rbx
			cmp rax, 0
			jge itoastart
			mov rbx, -1
			xor rdx, rdx
			imul rbx
			mov rbx, 1 ; mark negative
			
			itoastart:
				push WORD 0
				
			itoaL1:
				mov rcx, 10
				xor rdx, rdx
				idiv rcx
				add rdx, '0'
				push WORD dx
				
				cmp rax, 0
				je itoaL2
				jmp itoaL1
			
			itoaL2:
				cmp rbx, 1
				jne itoaL3
				push WORD '-'
			
			itoaL3:
				pop WORD ax
				mov BYTE [rdi], al
				cmp BYTE [rdi], 0
				je itoaL4
				inc rdi
				jmp itoaL3
				
			itoaL4:
			
			pop rbp
			ret 16
			
%endif
