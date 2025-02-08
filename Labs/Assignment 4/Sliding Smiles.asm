include Irvine32.inc

.data
outerLoop	DWORD	120
innerLoop	DWORD 	1

.code
main PROC

call moveLeft

call Crlf
call WaitMsg
call Clrscr
exit

main ENDP

moveRight PROC
mov dh, 0 ; DH = row
mov dl, 0 ; DL = column
mov ecx, outerLoop ; So the the smiley faces cover the width of the console window.
Right:
	mov outerLoop, ecx
	mov eax, 1 ; The ASCII character of the smiley face.
	call WriteChar
	mov eax, 50 ; Delay in milliseconds.
	call Delay
	call Gotoxy
	mov eax, 32 ; The ASCII character of space.
	mov ecx, innerLoop
	frontSpace:
		call WriteChar
		loop frontSpace
	mov ecx, innerLoop
	inc ecx
	mov innerLoop, ecx
	mov ecx, outerLoop	
	loop Right
ret
moveRight ENDP

moveLeft PROC
mov dh, 0
mov dl, 119
call Gotoxy
mov ecx, 1
mov innerLoop, ecx
mov ecx, 120
Left:
	mov outerLoop, ecx
	mov eax, 1
	call WriteChar
	mov eax, 50
	call Delay
	mov ebx, innerLoop
	sub dl, bl
	call Gotoxy
	mov eax, 32
	mov ecx, innerLoop
	backSpace:
		call WriteChar
		loop backSpace
	mov ecx, innerLoop
	inc ecx
	mov innerLoop, ecx
	mov ecx, outerLoop
	loop Left
ret
moveLeft ENDP

END main