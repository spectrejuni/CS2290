; Author: Jeremey Larter
; Lab Assignment #6 Part 1 (Array Pointer Fibonacci Sequence)
; Purpose: To compute and display the requested Fibonacci number.
include Irvine32.inc

.data
prompt		BYTE	"The Fibonacci sequence for the first 50 members is as follows:", 0
response	BYTE	"Fibonacci number  ", 0
equal		BYTE	" = ", 0
sequence	DWORD	41 dup(?)

.code
main PROC

call Clrscr ; Weird things happen without this.

; Notifies the user what's being printed.
mov edx, OFFSET prompt
call WriteString
call Crlf
call Crlf

; Calculates Fibonacci numbers.
; f(n) = f(n-2) + f(n-1)
mov esi, OFFSET sequence
mov eax, 0
mov DWORD PTR [esi], 0 ; f(0) = 0
call printResult
inc eax
mov ebx, type sequence ; DWORD = 4 bits
add esi, ebx
mov DWORD PTR [esi], 1 ; f(1) = 1
call printResult
mov ecx, 39
Fibonacci:
	inc eax
	sub esi, ebx
	mov edx, [esi]
	add esi, ebx
	add edx, [esi]
	add esi, ebx
	mov [esi], edx ; f(n) = f(n-2) + f(n-1)
	push eax
	mov eax, 50
	call Delay ; Adds a 50ms delay between numbers.
	pop eax
	call printResult
	loop Fibonacci
call Crlf
call WaitMsg
call Clrscr
exit

main ENDP

; Prints out the Fibonacci numbers.
printResult PROC

mov edx, OFFSET response
call WriteString
call WriteDec
mov edx, OFFSET equal
call WriteString
push eax
mov eax, [esi]
call WriteDec
call Crlf
pop eax
ret

printResult ENDP

END main