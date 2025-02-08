; Author: Jeremey Larter
; Lab Assignment #8 Part 1 (The Game Version 4)
; Purpose: Revamps the demo game from the previous part.
; NOTE: Use an 80x25 (WxH) console window for the best result.
include Irvine32.inc

.data

; Memory locations.
prompt			BYTE	"Pick your player skill level:", 0
novice			BYTE	"Novice", 0
intermediate	BYTE	"Intermediate", 0
advanced		BYTE	"Advanced", 0
expert			BYTE	"Expert", 0
insane			BYTE	"Insane", 0
arrowLocation	BYTE	2
columnBegin		BYTE	0 ; DL
columnEnd		BYTE	79 ; DL
endMessageB		BYTE	"You hit the boundary!", 0Ah, 0Dh, "Game Over!", 0Ah, 0Dh, 0
endMessageP		BYTE	"You ran out of points!", 0Ah, 0Dh, "Game Over!", 0Ah, 0Dh, 0
endMessageE		BYTE	"You forfeited!", 0Ah, 0Dh, "Game Over!", 0Ah, 0Dh, 0
position		BYTE	39 ; Used for keeping track of column. Initial value is starting location.
score			BYTE	"Score: ", 0
pointBank		BYTE	"Point Bank: ", 0
blank			BYTE	"        ", 0
speed			DWORD	70 ; Change delay between movements in milliseconds.
points			DWORD	50
bounces			DWORD	0

; Macro.
ROW = 11 ; DH

.code

; Main procedure. Handles menu and game over.
main PROC
call Clrscr
mov EDX, OFFSET prompt
call WriteString
menu:
	mov DH, arrowLocation
	mov DL, 0
	call Gotoxy
	mov AL, 62 ; ASCII code of right arrow.
	call WriteChar
	mov DH, 2
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET novice
	call WriteString
	mov DH, 3
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET intermediate
	call WriteString
	mov DH, 4
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET advanced
	call WriteString
	mov DH, 5
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET expert
	call WriteString
	mov DH, 6
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET insane
	call WriteString
	cursor:
		mov DH, arrowLocation
		mov DL, 0
		call Gotoxy
		mov EAX, 50
		call Delay
		push DX
		call ReadKey
		cmp AH, 50h ; Virtual-scan code for DOWN key.
		je down
		cmp AH, 48h ; Virtual-scan code for UP key.
		je up
		cmp AH, 1Ch ; Virtual-scan code for ENTER key.
		je setSpeed
		jmp cursor
gameOverB:: ; Global label.
	call Clrscr
	mov EDX, OFFSET score
	call WriteString
	mov EAX, bounces
	call WriteDec
	call Crlf
	mov EDX, OFFSET endMessageB
	call WriteString
	call Crlf
	call WaitMsg
	call Clrscr
	exit
gameOverP::
	call Clrscr
	mov EDX, OFFSET score
	call WriteString
	mov EAX, bounces
	call WriteDec
	call Crlf
	mov EDX, OFFSET endMessageP
	call WriteString
	call Crlf
	call WaitMsg
	call Clrscr
	exit 
gameOverE::
	call Clrscr
	mov EDX, OFFSET score
	call WriteString
	mov EAX, bounces
	call WriteDec
	call Crlf
	mov EDX, OFFSET endMessageE
	call WriteString
	call Crlf
	call WaitMsg
	call Clrscr
	exit
main ENDP

; Controls where the arrow goes when the user goes down the menu.
down PROC
pop DX
cmp DH, 6
jne setArrowD
mov arrowLocation, 2
jmp main
down ENDP

; Moves arrow location down as user goes down the menu.
setArrowD PROC
inc DH
mov arrowLocation, DH
jmp main
setArrowD ENDP

; Controls where the arrow goes when the user goes up the menu.
up PROC
pop DX
cmp DH, 2
jne setArrowU
mov arrowLocation, 6
jmp main
up ENDP

; Moves arrow location up as the user goes up the menu.
setArrowU PROC
dec DH
mov arrowLocation, DH
jmp main
setArrowU ENDP

; Changes the speed at which the smiley face moves. Speed corresponds to difficulty level.
setSpeed PROC
call Clrscr
pop DX
cmp DH, 2
je setDirection
mov speed, 50
cmp DH, 3
je setDirection
mov speed, 40
cmp DH, 4
je setDirection
mov speed, 30
cmp DH, 5
je setDirection
mov speed, 20
setSpeed ENDP

; The initial direction the smiley face moves is chosen at random.
setDirection PROC
mov EAX, 2
call Randomize
call RandomRange
cmp EAX, 1
je moveLeft
setDirection ENDP

; Moves a smiley face right across the screen.
moveRight PROC
cmp points, 0
jle gameOverP
call showScore
call showBank
Right:
	call leftBarrier
	call rightBarrier
	mov DL, position ; DL is set to position for seamless transition.
	mov DH, ROW ; So that the smiley face is in the middle heightwise.
	call Gotoxy
	mov BL, columnEnd
	sub BL, DL
	call safe
	cmp BL, 16
	ja continue
	call warning
	cmp BL, 8
	ja continue
	call danger
	continue:
		mov AL, 1 ; The ASCII character of the smiley face.
		call WriteChar
		mov EAX, speed ; Delay in milliseconds.
		call Delay
		call Gotoxy ; Go back one.
		mov AL, 32 ; The ASCII character of space.
		call WriteChar
		call safe
		inc DL
		mov position, DL ; Saves DL to position as ReadKey overwrites the DX register.
		cmp DL, columnEnd ; Column barrier initially is 79 (for an 80x25 screen). Decreases over time.
		je gameOverB
		call ReadKey ; Checks for key presses without an interrupt.
		cmp AL, ' '
		je pauseRight
		cmp AH, 26h ; Virtual-scan code for l and L.
		je setRight
		cmp AL, 1Bh ; Virtual-scan code for ESC key.
		je gameOverE
		jmp Right
moveRight ENDP

; Moves the smiley face left across the screen.
moveLeft PROC
cmp points, 0
jle gameOverP
call showScore
call showBank
Left:
	call leftBarrier
	call rightBarrier
	mov DL, position
	mov DH, ROW
	call Gotoxy
	mov BL, columnBegin
	mov BH, DL
	sub BH, BL
	call safe
	cmp BH, 15
	ja continue
	call warning
	cmp BH, 7
	ja continue
	call danger
	continue:
		mov AL, 1
		call WriteChar
		mov EAX, speed
		call Delay
		call Gotoxy
		dec DL
		mov AL, 32
		call WriteChar
		call safe
		mov position, DL
		cmp DL, columnBegin
		je gameOverB
		call ReadKey
		cmp AL, ' '
		je pauseLeft
		cmp AH, 1Eh ; Virtual-scan code for a and A.
		je setLeft
		cmp AL, 1Bh
		je gameOverE
		jmp Left
moveLeft ENDP

safe PROC
mov EAX, white+(black*16)
call SetTextColor
ret
safe ENDP

warning PROC
mov EAX, yellow+(black*16)
call SetTextColor
ret
warning ENDP

danger PROC
mov EAX, red+(black*16)
call SetTextColor
ret
danger ENDP

; Shows the user's current score.
showScore PROC
mov DX, 0
call Gotoxy
mov EDX, OFFSET score
call WriteString
mov EAX, bounces
call WriteDec
call Crlf
ret
showScore ENDP

; Increses the score with every direction switch. Direction is determined with the AL register.
increaseScore PROC
inc bounces
cmp AL, 1
jne moveRight
jmp moveLeft
increaseScore ENDP

showBank PROC
mov DX, 0
inc DH
call Gotoxy
mov EDX, OFFSET pointBank
call WriteString
mov EAX, points
call WriteDec
mov EDX, OFFSET blank
call WriteString
ret
showBank ENDP

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
inc DH
sub DH, DL
movzx EDX, DH
sub points, EDX
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
dec DH
sub DL, DH
movzx EDX, DL
sub points, EDX
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