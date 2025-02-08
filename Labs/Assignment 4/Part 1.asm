; Author: Jeremey Larter
; Lab Assignment #4 Part 1 (Fibonacci Sequence)
; Purpose: To compute and display the requested Fibonacci number.
include Irvine32.inc

.data
prompt		BYTE	"Which Fibonacci number do you wish: ", 0
response	BYTE	"Fibonacci value = ", 0

.code
main PROC

; Displays instructions to user and takes input.
mov edx, OFFSET prompt
call WriteString
call ReadDec
dec eax

; Calculates Fibonacci numbers.
; f(n) = f(n-2) + f(n-1)
mov bh, 0 ; f(0) = 0
mov bl, 1 ; f(1) = 1
mov ecx, eax
Fibonacci:
	mov al, bh
	add al, bl
	mov dl, al ; f(n) = f(n-2) + f(n-1)
	mov bh, bl ; f(n-2) = f(n-1)
	mov bl, dl ; f(n-1) = f(n)
	loop Fibonacci

call Crlf
movzx eax, dl
mov edx, OFFSET response
call WriteString
call WriteDec

call Crlf
call Crlf
call WaitMsg
call Clrscr
exit

main ENDP
END main