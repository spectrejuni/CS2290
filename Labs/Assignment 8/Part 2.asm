; Author: Jeremey Larter
; Lab Assignment #8 Part 2 (The Game Final Version)
; Purpose: Revamps the demo game from the previous part. This is the final product.
; NOTE: Use an 80x25 (WxH) console window for the best result.
include Irvine32.inc

.data
; Memory allocations for the main menu screen.
prompt			BYTE	"Pick your player skill level:", 0
novice			BYTE	"Novice", 0
intermediate	BYTE	"Intermediate", 0
advanced		BYTE	"Advanced", 0
expert			BYTE	"Expert", 0
insane			BYTE	"Insane", 0
speed			BYTE	70 ; Change delay between movements in milliseconds.

; Memory allocations for when the game is running.
arrowLocation	BYTE	2 ; DH = row.
columnBegin		BYTE	0 ; DL = column.
columnEnd		BYTE	79 ; DL = column.
position		BYTE	39 ; Used for keeping track of column. Initial value is starting location.
bounces			BYTE	"BOUNCES: ", 0
bouncesAmount	BYTE	0
pointBank		BYTE	"POINT BANK: ", 0
points			BYTE	50 ; Points is related to how many times the user can bounce the smiley face.

; Memory allocations for the game over and analysis screens.
gameOver		BYTE	"**** GAME OVER ****", 0Ah, 0Dh, 0Ah, 0Dh, 0
analysis		BYTE	"Bounce by Bounce Analysis", 0Ah, 0Dh, 0Ah, 0Dh, 0
bounce			BYTE	"Bounce", 0
score			BYTE	"Score", 0
endMessageWall	BYTE	"OOPs you hit the wall... no more game for you!:", 0Ah, 0Dh, 0
endMessagePnts	BYTE	"OOPS you ran out of points... no more game for you!:", 0Ah, 0Dh, 0
endMessageEsc	BYTE	"OOPS you hit the quit key... no more game for you!:", 0Ah, 0Dh, 0
pauseMsg		BYTE	"Press any key to continue . . .", 0

; Memory allocation for keeping track of scores per bounce. Exact usage of memory is user dependent.
bounceScore		BYTE	10 dup(?)

; Macro for where the smiley face is on the screen.
ROW = 11 ; DH = row.

.code
; Main procedure. Handles main menu.
Main PROC
call Safe
call Clrscr
mov EDX, OFFSET prompt
call WriteString
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
; Keeps the arrow at the highlighted location and changes on user input.
Cursor:
	mov DH, arrowLocation
	mov DL, 0
	call Gotoxy
	mov EAX, 50
	call Delay ; Delay so that input can be detected.
	push DX ; Saves the DX values as the register is overwriten from calling ReadKey.
	call ReadKey ; Checks for key presses without an interrupt.
	pop DX
	cmp AH, 50h ; Virtual-scan code for DOWN key.
	je Down
	cmp AH, 48h ; Virtual-scan code for UP key.
	je Up
	cmp AH, 1Ch ; Virtual-scan code for ENTER key.
	je SetSpeed
	jmp Cursor
Main ENDP

; Controls where the arrow goes when the user goes down the menu.
Down PROC
cmp DH, 6
je ResetArrowDown
inc arrowLocation
jmp Main
Down ENDP

; Resets arrow location to the top of the menu.
ResetArrowDown PROC
mov arrowLocation, 2
jmp Main
ResetArrowDown ENDP

; Controls where the arrow goes when the user goes up the menu.
Up PROC
cmp DH, 2
je ResetArrowUp
dec arrowLocation
jmp Main
up ENDP

; Resets arrow location to the bottom of the menu.
ResetArrowUp PROC
mov arrowLocation, 6
jmp Main
ResetArrowUp ENDP

; Changes the speed at which the smiley face moves. Speed corresponds to difficulty level.
SetSpeed PROC
call Clrscr
cmp DH, 2 ; Novice
je SetDirection
mov speed, 50
cmp DH, 3 ; Intermediate
je SetDirection
mov speed, 40
cmp DH, 4 ; Advanced
je SetDirection
mov speed, 30
cmp DH, 5 ; Expert
je SetDirection
mov speed, 20 ; Insane
SetSpeed ENDP

; The initial direction the smiley face moves is chosen at random.
SetDirection PROC
mov EAX, 2 ; Range of [0,2).
call Randomize
call RandomRange
cmp EAX, 1
mov ESI, 0 ; Sets the bounceScore array index to 0.
je MoveLeft
SetDirection ENDP

; Moves a smiley face right across the screen.
MoveRight PROC
cmp points, 0
jle GameOverPnts ; Once points is less than or equal to 0, the game ends.
call ShowScore
call ShowBank
Right:
	call LeftWall  ; Shows where the left wall is.
	call RightWall ; Shows where the right wall is.
	mov DL, position ; DL is set to position for seamless transition between movement directions.
	mov DH, ROW ; So that the smiley face is in the middle heightwise.
	call Gotoxy
	mov BL, columnEnd
	sub BL, DL
	call Safe
	cmp BL, 16
	ja Continue
	call Warning
	cmp BL, 8
	ja Continue
	call Danger
	Continue:
		mov AL, 1 ; The ASCII character of the smiley face.
		call WriteChar
		movzx EAX, speed ; Delay in milliseconds.
		call Delay
		call Gotoxy ; Go back one.
		mov AL, 32 ; The ASCII character of Space.
		call WriteChar
		call Safe
		inc DL
		mov position, DL
		cmp DL, columnEnd ; Column wall initially is 79 (for an 80x25 screen). Decreases over time.
		je GameOverWall
		push BX
		call ReadKey
		pop BX
		cmp AL, ' '
		je PauseRight
		cmp AH, 26h ; Virtual-scan code for l and L.
		je SetRight
		cmp AL, 1Bh ; Virtual-scan code for ESC key.
		je GameOverEsc
		jmp Right
MoveRight ENDP

; Moves the smiley face left across the screen.
MoveLeft PROC
cmp points, 0
jle GameOverPnts
call ShowScore
call ShowBank
Left:
	call LeftWall
	call RightWall
	mov DL, position
	mov DH, ROW
	call Gotoxy
	mov BL, columnBegin
	mov BH, DL
	sub BH, BL
	call Safe
	cmp BH, 15
	ja Continue
	call Warning
	cmp BH, 7
	ja Continue
	call Danger
	Continue:
		mov AL, 1
		call WriteChar
		movzx EAX, speed
		call Delay
		call Gotoxy
		dec DL
		mov AL, 32
		call WriteChar
		call Safe
		mov position, DL
		cmp DL, columnBegin
		je GameOverWall
		push BX
		call ReadKey
		pop BX
		cmp AL, ' '
		je PauseLeft
		cmp AH, 1Eh ; Virtual-scan code for a and A.
		je SetLeft
		cmp AL, 1Bh
		je GameOverEsc
		jmp Left
MoveLeft ENDP

; Sets text colour to white and background colour to black.
Safe PROC
mov EAX, white+(black*16)
call SetTextColor
ret
Safe ENDP

; Sets text colour to yellow and background colour to black.
Warning PROC
mov EAX, yellow+(black*16)
call SetTextColor
ret
Warning ENDP

; Sets text colour to red and background colour to black.
Danger PROC
mov EAX, red+(black*16)
call SetTextColor
ret
Danger ENDP

; Shows the user's current bounces.
ShowScore PROC
mov DX, 0
call Gotoxy
mov EDX, OFFSET bounces
call WriteString
movzx EAX, bouncesAmount
call WriteDec
call Crlf
ret
ShowScore ENDP

; Shows the remaining points the user has in the point bank.
ShowBank PROC
mov DX, 0
inc DH
call Gotoxy
mov EDX, OFFSET pointBank
call WriteString
movzx EAX, points
call WriteDec
mov AL, 32
call WriteChar
ret
ShowBank ENDP

; Shows the right wall.
RightWall PROC
mov DL, columnEnd
mov DH, ROW
call Gotoxy
mov AL, 221
call WriteChar
ret
RightWall ENDP

; Shows the left wall.
LeftWall PROC
mov DL, columnBegin
mov DH, ROW
call Gotoxy
mov AL, 222  
call WriteChar
ret
LeftWall ENDP

; Changes the right wall based on where the smiley face is bounced.
SetRight PROC
sub BL, 2 ; Ensures penalty score is accurate.
mov bounceScore[ESI], BL
inc ESI
mov DH, columnEnd
dec DH
mov DL, position
mov AL, 1 ; AL is used in IncreaseScore to know which direction the smiley face moves.
cmp DL, DH
je IncreaseScore
mov columnEnd, DL
inc DH
sub DH, DL
sub points, DH
jmp IncreaseScore
SetRight ENDP

; Changes the left wall based on where the smiley face is bounced.
SetLeft PROC
sub BH, 2
mov bounceScore[ESI], BH
inc ESI
mov DH, columnBegin
inc DH
mov DL, position
cmp DL, DH
je IncreaseScore
mov columnBegin, DL
dec DH
sub DL, DH
sub points, DL
SetLeft ENDP

; Increses the bounces with every direction switch. Direction is determined with the AL register.
IncreaseScore PROC
inc bouncesAmount
cmp AL, 1
jne MoveRight
jmp MoveLeft
IncreaseScore ENDP

; Pause for the smiley face moving right. Also fixes the smiley face disappearing.
PauseRight PROC
mov AL, 1
call WriteChar
mov ECX, 0
jmp Space
PauseRight ENDP

; Pause for the smiley face moving left. Same fix as above for the smiley face.
PauseLeft PROC
mov DL, position
mov DH, ROW
call Gotoxy
mov AL, 1
call WriteChar
mov ECX, 1
PauseLeft ENDP

; Infinite loop for the pause.
Space PROC
call ReadKey
cmp AL, ' '
jne Space
Space ENDP

; Unpause and Continue moving the smiley face in the last direction.
Return PROC
cmp ECX, 0
je MoveRight
jne MoveLeft
Return ENDP

; Game over when the smiley face hits the boundary.
GameOverWall PROC
call Clrscr
mov EDX, OFFSET gameOver
call WriteString
mov EDX, OFFSET bounces
call WriteString
movzx EAX, bouncesAmount
call WriteDec
call Crlf
call Crlf
mov EDX, OFFSET analysis
call WriteString
cmp bouncesAmount, 0
je Skip
mov EDX, OFFSET bounce
call WriteString
mov DH, 6
mov DL, 11
call Gotoxy
mov EDX, OFFSET score
call WriteString
call Crlf
call PrintNumbers
call Crlf
Skip:
	mov EDX, OFFSET endMessageWall
	call WriteString
	call Crlf
	mov EDX, OFFSET pauseMsg
	call WriteString
	NoPress:
		mov EAX, 50
		call Delay
		call ReadKey
		jz NoPress
	call Clrscr
	call Histogram
	call Crlf
	call WaitMsg
	call Clrscr
	Exit
GameOverWall ENDP

; Game over when the user depletes the point bank.
GameOverPnts PROC
call Clrscr
mov EDX, OFFSET gameOver
call WriteString
mov EDX, OFFSET bounces
call WriteString
movzx EAX, bouncesAmount
call WriteDec
call Crlf
call Crlf
mov EDX, OFFSET analysis
call WriteString
cmp bouncesAmount, 0
je Skip
mov EDX, OFFSET bounce
call WriteString
mov DH, 6
mov DL, 11
call Gotoxy
mov EDX, OFFSET score
call WriteString
call Crlf
call PrintNumbers
call Crlf
Skip:
	mov EDX, OFFSET endMessagePnts
	call WriteString
	call Crlf
	mov EDX, OFFSET pauseMsg
	call WriteString
	NoPress:
		mov EAX, 50
		call Delay
		call ReadKey
		jz NoPress
	call Clrscr
	call Histogram
	call Crlf
	call WaitMsg
	call Clrscr
	Exit
GameOverPnts ENDP

; Game over when the user hits the ESC key.
GameOverEsc PROC
call Clrscr
mov EDX, OFFSET gameOver
call WriteString
mov EDX, OFFSET bounces
call WriteString
movzx EAX, bouncesAmount
call WriteDec
call Crlf
call Crlf
mov EDX, OFFSET analysis
call WriteString
cmp bouncesAmount, 0
je Skip
mov EDX, OFFSET bounce
call WriteString
mov DH, 6
mov DL, 11
call Gotoxy
mov EDX, OFFSET score
call WriteString
call Crlf
call PrintNumbers
call Crlf
Skip:
	mov EDX, OFFSET endMessageEsc
	call WriteString
	call Crlf
	mov EDX, OFFSET pauseMsg
	call WriteString
	NoPress:
		mov EAX, 50
		call Delay
		call ReadKey
		jz NoPress
	call Clrscr
	call Histogram
	call Crlf
	call WaitMsg
	call Clrscr
	Exit
GameOverEsc ENDP

; Shows the penalty score for every bounce to the user.
PrintNumbers PROC
mov ESI, 0
mov DH, 7
mov DL, 11
movzx ECX, bouncesAmount
Print:
	mov EAX, ESI
	inc EAX
	call WriteDec
	call Gotoxy
	movzx EAX, bounceScore[ESI]
	call WriteDec
	call Crlf
	inc ESI
	inc DH
	loop Print
ret
PrintNumbers ENDP

; Shows a histogram to the user from 0 to 10 the frequencies of penalty scores.
Histogram PROC
mov BL, 0
mov ECX, 11
Check:
	push ECX
	mov ESI, 0
	mov BH, 0
	movzx ECX, bouncesAmount
	Read:
		cmp bounceScore[ESI], BL
		je Increment
		Continue:
			inc ESI
		loop Read
	cmp BL, 10 ; For formating of Histogram.
	jae NoSpace
	mov AL, 32
	call WriteChar
	NoSpace:
		movzx EAX, BL
		call WriteDec
		inc BL
		mov AL, 32
		call WriteChar
		mov AL, 124
		call WriteChar
		mov AL, 32
		call WriteChar
		mov AL, 42
		cmp BH, 0
		je Skip
		movzx ECX, BH
		Stars:
			call WriteChar
			loop Stars
		Skip:
			call Crlf
			pop ECX
	loop Check
ret
Increment:
	inc BH
	jmp Continue
Histogram ENDP

END Main