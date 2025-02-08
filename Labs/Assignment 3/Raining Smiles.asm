; Author: Jeremey Larter
; Lab Assignment #3 Part 3 v3 (Smiling Animation) Glitch
; Purpose: To demo a simple animation of a smiling face.
include Irvine32.inc

.data
outerLoop	DWORD	120
innerLoop	DWORD	1

.code
main PROC

call Clrscr
mov ecx, outerLoop ; So the the smiley faces cover the width of the console window.
Stream:
	mov outerLoop, ecx
	mov eax, 1 ; The ASCII character of the smiley face, as well as the dalay in milliseconds.
	call WriteChar
	call Delay
	mov eax, 32 ; The ASCII character of space.
	mov ecx, innerLoop
	Space:
		call WriteChar
		loop Space
	mov ecx, innerLoop
	inc ecx
	mov innerLoop, ecx
	mov ecx, outerLoop	
	loop Stream

call Crlf
call WaitMsg
exit

main ENDP
END main