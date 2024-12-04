SECTION .text
global printnumber

printnumber:
push rbp
mov rbp, rsp

mov rax, rdi ;Ich lade die Zahl nach rax
mov r10, 10 
xor rcx, rcx ; Ich setze rcx auf Null

;Erster Loop um zu ermitteln wie viele Stellen die Zahl hat
loop: xor rdx,rdx ;Ich setze rdx auf 0
div r10 ;eax = quotient, edx = remainder
inc rcx ; i++
cmp rax, 0 ; Ist rax 0?
jne loop ; Sonst mache mit dem Loop weiter

mov r11, rcx ; Länge der Ausgabe wird gespeichert

push 0xA ; der Stack wächst nach unten, also schreiben wir den String rückwärts in den Stack (0xA ist newline)
mov rax, rdi ;Ich lade die Zahl nach rax
loop2: xor rdx,rdx ;Ich setze rdx auf 0
dec rcx ;i--
div r10 ;eax = quotient, edx = remainder 
add dl, '0' ; Ich wandele rdx was die niedrigste Ziffer enthält in den Wert für das Ascii Zeichen der Ziffer um
dec rsp
mov [rsp], dl ; Ich schreibe das Zeichen in den Stack
cmp rcx, 0 ; Ist rcx 0?
jne loop2

mov rax, 1 ; Damit gleich der Syscall sys_write ausgeführt wird
mov rdi, 1 ; Damit in die Standardausgabe geschrieben wird
mov rsi, rsp ; Erste Adresse des zu drucken Textes
add r11, 1
mov rdx, r11 ; Wie viele Zeichen gedruckt werden sollen


syscall

mov rsp, rbp
pop rbp

ret; Beendet Funktion
