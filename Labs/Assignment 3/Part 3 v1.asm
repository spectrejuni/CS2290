; Author: Jeremey Larter
; Lab Assignment #3 Part 3 v1 (Smiling Animation)
; Purpose: To demo a simple animation of a smiling face.
include Irvine32.inc

.data

.code
main PROC

mov eax, 1 ; The ASCII character of the smiley face, as well as the dalay in milliseconds.
mov ecx, 120 ; So the the smiley faces cover the width of the console window.
Stream:
	call WriteChar
	call Delay
	loop Stream

call Crlf
call WaitMsg
exit

main ENDP
END main