; Author: Jeremey Larter
; Lab Assignment #6 Part 4 (The Game Version 1)
; Purpose: Revamps the demo game from the previous part.
; NOTE: Use an 80x25 (WxH) console window for the best result.
include Irvine32.inc

.data

; Memory locations.
columnBegin	BYTE	0 ; DL
columnEnd	BYTE	79 ; DL
endMessage	BYTE	"You hit the boundary!", 0Ah, 0Dh, "Game Over!", 0Ah, 0Dh, 0
position	BYTE	39 ; Used for keeping track of column. Initial value is starting location.
score		BYTE	"Score: ", 0
bounces		DWORD	0

; Macros.
ROW = 11 ; DH
SPEED = 50 ; Change delay between movements in milliseconds.

.code

; Main procedure. Handles game over.
main PROC
jmp moveRight
gameOver:: ; Global label.
	call Clrscr
	mov EDX, OFFSET score
	call WriteString
	mov EAX, bounces
	call WriteDec
	call Crlf
	mov EDX, OFFSET endMessage
	call WriteString
	call Crlf
	call WaitMsg
	call Clrscr
	exit
main ENDP

; Moves a smiley face right across the screen.
moveRight PROC
call showScore
Right:
	call leftBarrier
	call rightBarrier
	mov DL, position ; DL is set to position for seamless transition.
	mov DH, ROW ; So that the smiley face is in the middle heightwise.
	call Gotoxy
	mov AL, 1 ; The ASCII character of the smiley face.
	call WriteChar
	mov EAX, SPEED ; Delay in milliseconds.
	call Delay
	call Gotoxy ; Go back one.
	mov AL, 32 ; The ASCII character of space.
	call WriteChar
	inc DL
	mov position, DL ; Saves DL to position as ReadKey overwrites the DX register.
	cmp DL, columnEnd ; Column barrier initially is 79 (for an 80x25 screen). Decreases over time.
	je gameOver
	call ReadKey ; Checks for key presses without an interrupt.
	cmp AL, ' '
	je pauseRight
	cmp AH, 26h ; Virtual-scan code for l and L.
	je setRight
	jmp Right
moveRight ENDP

; Moves the smiley face left across the screen.
moveLeft PROC
call showScore
Left:
	call leftBarrier
	call rightBarrier
	mov DL, position
	mov DH, ROW
	call Gotoxy
	mov AL, 1
	call WriteChar
	mov EAX, SPEED
	call Delay
	call Gotoxy
	dec DL
	mov AL, 32
	call WriteChar
	mov position, DL
	cmp DL, columnBegin
	je gameOver
	call ReadKey
	cmp AL, ' '
	je pauseLeft
	cmp AH, 1Eh ; Virtual-scan code for a and A.
	je setLeft
	jmp Left
moveLeft ENDP

; Shows the user's current score.
showScore PROC
mov DX, 0
call Gotoxy
mov EDX, OFFSET score
call WriteString
mov EAX, bounces
call WriteDec
ret
showScore ENDP

; Increses the score with every direction switch. Direction is determined with the AL register.
increaseScore PROC
inc bounces
cmp AL, 1
jne moveRight
jmp moveLeft
increaseScore ENDP

; Shows the right barrier.
rightBarrier PROC
mov DL, columnEnd
mov DH, ROW
call Gotoxy
mov AL, 221
call WriteChar
ret
rightBarrier ENDP

; Shows the left barrier.
leftBarrier PROC
mov DL, columnBegin
mov DH, ROW
call Gotoxy
mov AL, 222  
call WriteChar
ret
leftBarrier ENDP

; Changes the right boundary based on where the smiley face is bounced.
setRight PROC
mov DH, columnEnd
dec DH
mov DL, position
mov AL, 1 ; AL is used in increaseScore to know which direction the smiley face moves.
cmp DL, DH
je increaseScore
mov columnEnd, DL
jmp increaseScore
setRight ENDP

; Changes the left boundary based on where the smiley face is bounced.
setLeft PROC
mov DH, columnBegin
inc DH
mov DL, position
cmp DL, DH
je increaseScore
mov columnBegin, DL
jmp increaseScore
setLeft ENDP

; Pause for the smiley face moving right. Also fixes the smiley face disappearing.
pauseRight PROC
mov AL, 1
call WriteChar
mov ECX, 0
jmp space
pauseRight ENDP

; Pause for the smiley face moving left. Same fix as above for the smiley face.
pauseLeft PROC
mov DL, position
mov DH, ROW
call Gotoxy
mov AL, 1
call WriteChar
mov ECX, 1
pauseLeft ENDP

; Infinite loop for the pause.
space PROC
call ReadKey
cmp AL, ' '
jne space
space ENDP

; Unpause and continue moving the smiley face in the last direction.
return PROC
cmp ECX, 0
je moveRight
jne moveLeft
return ENDP

END main