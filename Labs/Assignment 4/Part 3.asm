; Author: Jeremey Larter
; Lab Assignment #4 Part 3 (Bouncing Smiles)
; Purpose: To demo a more complex bouncing animation of a smiley face.
include Irvine32.inc

.data
outerLoop	BYTE	?
innerLoop	BYTE 	?

.code
main PROC

infinity:
	mov cl, 120
	mov outerLoop, cl
	mov cl, 1
	mov innerLoop, cl
	call moveRight
	call Clrscr
	mov cl, 120
	mov outerLoop, cl
	dec cl
	mov innerLoop, cl
	call moveLeft
	call Clrscr
	jmp infinity

call Crlf
call WaitMsg
call Clrscr
exit

main ENDP

; Moves a smiley face right across the screen.
moveRight PROC
mov dh, 0 ; DH = row
mov dl, 0 ; DL = column
movzx ecx, outerLoop ; So the the smiley faces cover the width of the console window.
Right:
	mov outerLoop, cl
	mov eax, 1 ; The ASCII character of the smiley face.
	call WriteChar
	mov eax, 50 ; Delay in milliseconds.
	call Delay
	call Gotoxy
	mov eax, 32 ; The ASCII character of space.
	mov cl, innerLoop
	frontSpace:
		call WriteChar
		loop frontSpace
	mov cl, innerLoop
	inc cl
	mov innerLoop, cl
	mov cl, outerLoop	
	loop Right
ret
moveRight ENDP

; Moves the smiley face left across the screen.
moveLeft PROC
mov dh, 0
mov dl, 120
movzx ecx, outerLoop
Left:
	call Clrscr
	mov outerLoop, cl
	mov eax, 32
	mov cl, innerLoop
	jecxz noSpace ; Skips adding a space before the smiley face.
	backSpace:
		call WriteChar
		loop backSpace
	mov cl, innerLoop
	dec cl
	mov innerLoop, cl
	noSpace: mov eax, 1
	call WriteChar
	mov eax, 32
	call WriteChar
	mov eax, 50
	call Gotoxy
	dec dl
	call Delay
	mov cl, outerLoop
	loop Left
ret
moveLeft ENDP

END main