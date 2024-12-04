section .data
input_file: db "input", 0

section .text
	global _start
	extern malloc, printnumber

_start:
	mov rbp, rsp
	sub rsp, 32
	; on the stack:
	; - file descriptor
	; - file size
	; - buffer address

	; open input file
	mov rax, 2 ; sys_open
	lea rdi, [input_file]
	xor rsi, rsi ; read_only
	syscall
	mov [rbp - 8], rax ; save file descriptor


	; determine byte count of input file:
	mov rax, 8 ; sys_lseek
	mov rdi, [rbp - 8] ; file descriptor
	xor rsi, rsi ; offset = 0
	mov rdx, 2 ; SEEK_END
	syscall
	mov [rbp - 16], rax ; save file size

	; Reset file pointer to the start of the file
	mov rax, 8           ; sys_lseek
	mov rdi, [rbp - 8]   ; file descriptor
	xor rsi, rsi         ; offset = 0
	xor rdx, rdx         ; SEEK_SET (0)
	syscall

	; reserve memory for file on the heap
	mov rdi, rax ; file size
	call malloc
	mov [rbp - 24], rax ; save buffer address

	; read file into memory
	xor rax, rax ; sys_read
	mov rdi, [rbp - 8] ; file descriptor
	mov rsi, [rbp - 24] ; pointer to malloc'd buffer
	mov rdx, [rbp - 16] ; file size
	syscall

	; close file descriptor
	mov rax, 3
	mov rdi, [rbp - 8]
	syscall

	; actual program logic begins
	; registers:
	; - rbx: buffer
	; - rcx: result
	; - r8: len(x)
	; - r9: len(y)
	; - r10: x
	; - r11: y
	; - r12; dx
	; - r13; dy

	; determine line length
	mov rbx, [rbp - 24] ; buffer in rbx
	xor r8, r8 ; line length in r8
	xor rax, rax
loop_line_length:
	mov al, byte [rbx + r8]
	inc r8
	cmp al, 10 ; newline character?
	je exit_line_length
	jmp loop_line_length
exit_line_length:

	; determine line count
	mov rax, [rbp - 16]
	xor rdx, rdx
	idiv r8
	mov r9, rax ; line count in r9

	; iterate over input
	xor rcx, rcx ; result in rcx
	xor r11, r11 ; y in r11
loop_y:
	cmp r11, r9 ; line count reached?
	je exit_y

	xor r10, r10 ; x in r10
loop_x:
	inc r10
	cmp r10, r8 ; line length reached?
	je exit_x
	dec r10

	; check all 8 directions
	mov r14, r11
	imul r14, r8
	add r14, r10
	cmp byte [rbx + r14], 'X'
	jne next_x

	mov r13, -1
	mov r12, -1
	call check_xmas
	add rcx, rax

	mov r12, 0
	call check_xmas
	add rcx, rax
	
	mov r12, 1
	call check_xmas
	add rcx, rax

	mov r13, 0
	mov r12, -1
	call check_xmas
	add rcx, rax

	mov r12, 1
	call check_xmas
	add rcx, rax

	mov r13, 1
	mov r12, -1
	call check_xmas
	add rcx, rax

	mov r12, 0
	call check_xmas
	add rcx, rax
	
	mov r12, 1
	call check_xmas
	add rcx, rax

next_x:
	inc r10
	jmp loop_x

exit_x:
	inc r11 ; y++
	jmp loop_y
exit_y:

	; print result
	mov rdi, rcx
	call printnumber

	; exit program
	mov rax, 60
	xor rdi, rdi
	syscall



; I don't give a fuck about calling conventions
check_xmas:
	mov rsi, r10 ; x in rsi
	mov rdi, r11 ; y in rdi

	mov rdx, 'M'
	call check_letter
	cmp rax, 0
	je return

	mov rdx, 'A'
	call check_letter
	cmp rax, 0
	je return

	mov rdx, 'S'
	call check_letter
	ret

check_letter:
	xor rax, rax
	add rsi, r12 ; x += dx
	add rdi, r13 ; y += dy
	
	; check bounds
	cmp rsi, -1
	je return
	inc rsi
	cmp rsi, r8
	je return
	dec rsi

	cmp rdi, -1
	je return
	cmp rdi, r9
	je return

	; compare cell with letter
	mov r14, rdi
	imul r14, r8
	add r14, rsi
	cmp byte [rbx + r14], dl
	jne return

	; rax = 1 means correct letter
	inc rax
	
return:
	ret
