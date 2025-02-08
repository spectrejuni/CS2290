; Author: Jeremey Larter
; Lab Assignment #3 Part 3 v2 (Smiling Animation)
; Purpose: To demo a simple animation of a smiling face.
include Irvine32.inc

.data

.code
main PROC

mov dh, 0 ; DH = row
mov dl, 0 ; DL = column
mov ecx, 120 ; So the the smiley faces cover the width of the console window.
Stream:
	call Gotoxy
	mov eax, 1 ; The ASCII character of the smiley face, as well as the dalay in milliseconds.
	call WriteChar
	inc dl
	call Delay
	call Clrscr
	loop Stream

call Crlf
call WaitMsg
exit

main ENDP
END main