; Author: Jeremey Larter
; Lab Assignment #6 Part 3 (The Game Prototype)
; Purpose: To demo a simple game of bouncing a "ball".
; NOTE: Use an 80x25 (WxH) console window for the best result.
include Irvine32.inc

.data
column		BYTE	79 ; DL
row			BYTE	11 ; DH
endMessage	BYTE	"You hit the boundary!", 0Ah, 0Dh, "Game Over!", 0Ah, 0Dh, 0
done		BYTE	0 ; FALSE
position	BYTE	0 ; Used for keeping track of column.

.code
main PROC
call Game ; Calls the Game procedure.
call Crlf
call WaitMsg
call Clrscr
exit
main ENDP

; The Game procedure. Contains the game over message.
Game PROC
cmp done, 1
jne moveRight ; Jumps to the moveRight procedure when done is FALSE.
gameOver:
	call Clrscr
	mov EDX, OFFSET endMessage
	call WriteString
	ret
Game ENDP

; Moves a smiley face right across the screen.
moveRight PROC
mov done, 1
Right:
	mov DL, position ; Rather than 0, DL is whatever position is (for seamless transition from moving left).
	mov DH, row ; So that the smiley face is in the middle heightwise.
	call Gotoxy
	mov AL, 1 ; The ASCII character of the smiley face.
	call WriteChar
	mov EAX, 50 ; Delay in milliseconds.
	call Delay
	call Gotoxy ; Go back one.
	mov AL, 32 ; The ASCII character of space.
	call WriteChar
	inc DL
	cmp DL, column ; Column barrier is 79 (for an 80x25 screen).
	mov position, DL ; Saves DL to position as ReadKey overwrites the DX register.
	je Game
	call ReadKey ; Checks for key presses without an interrupt.
	cmp AL, ' '
	je setRight
	cmp AL, 'l'
	je moveLeft
	jmp Right
moveRight ENDP

setRight PROC
mov AL, 1
call WriteChar ; Fix for the smiley face disappearing on pause.
mov ECX, 0
setRight ENDP

space PROC
call ReadKey
cmp AL, ' '
jne space
space ENDP

return PROC
cmp ECX, 0
je moveRight
jne moveLeft
return ENDP

setLeft PROC
mov DL, position
mov DH, row
call Gotoxy
mov AL, 1
call WriteChar ; Same fix for the smiley face above. Also keeps the cursor on the smiley face. :)
mov ECX, 1
jmp space
setLeft ENDP

; Moves the smiley face left across the screen.
moveLeft PROC
Left:	
	mov DL, position
	mov DH, row
	call Gotoxy
	mov AL, 1
	call WriteChar
	mov EAX, 50
	call Delay
	call Gotoxy
	dec DL
	mov AL, 32
	call WriteChar
	cmp DL, 0
	mov position, DL
	je Game
	call ReadKey
	cmp AL, ' '
	je setLeft
	cmp AL, 'a'
	jne Left
	jmp moveRight
moveLeft ENDP

END main