; Author: Jeremey Larter
; Lab Assignment #10 (Tron)
; Purpose: To demonstrate different sorting algorithms in action.
; NOTE: For best results use a 80x30 window size.
include Irvine32.inc

.data
greet			BYTE	"Welcome to text-based Tron!", 0
directions		BYTE	" - In this game you are trying to fill the entire grid with your light-cycle", 0Ah, 0Dh
				BYTE	"   trails without hitting the border, an obstacle, or your trail.", 0Ah, 0Dh
				BYTE	" - Use the arrow keys to move your light-cycle. You can only move left or", 0Ah, 0Dh
				BYTE	"   right relative to where you are going.", 0Ah, 0Dh
				BYTE	" - Every time you color 100 characters on the screen, the speed increases", 0Ah, 0Dh
				BYTE	"   (until a minimum delay of 20ms is reached).", 0Ah, 0Dh
				BYTE	" - Every time you crash, you start over the current level.", 0Ah, 0Dh
				BYTE	" - For every 500 points you score, you get bumped up to the next level. Each", 0Ah, 0Dh
				BYTE	"   level has procedurally-generated objects, the number of which corresponds", 0Ah, 0Dh
				BYTE	"   to the level number.", 0Ah, 0Dh
				BYTE	" - Press SPACE any time to pause and play the game.", 0Ah, 0Dh
				BYTE	" - The game goes on until you give up (press the ESC key).", 0
promptMsg		BYTE	"Press any key to continue . . .", 0
levelMsg		BYTE	"Level ", 0
level			BYTE	0
countMsg		BYTE	"Starting in ", 0
levelScore		BYTE	"Level Score: ", 0
cumulativeScore	BYTE	"Cumulative Score (of completed levels): ", 0
currentScore	DWORD	0
totalScore		DWORD	0
limit			DWORD	100
speed			DWORD	100
theGrid			BYTE	2400 dup(0)

ROW EQU DH
COL EQU DL

.code
; Contains the pre-Game, score, and exit.
Main PROC
	mov EDX, OFFSET greet
	call WriteString
	call Crlf
	call Crlf
	mov EDX, OFFSET directions
	call WriteString
	call NoPress
	call Clrscr
Program:
	call StartGame
	push EAX
	call NoPress
	pop EAX
	cmp EAX, 5 ; Escape code.
	je Done
	cmp currentScore, 500
	jb Skip
	inc level ; New level when score is >= 500.
	mov EAX, currentScore
	add totalScore, EAX
Skip:
	mov currentScore, 0
	call Reset
	call Clrscr
	jmp Program
Done:
	exit
Main ENDP

; Procedure that mimics WaitMsg (but press any key instead of ENTER).
NoPress PROC
call Crlf
call Crlf
mov EDX, OFFSET promptMsg
call WriteString
KeepHere:
	mov EAX, 50
	call Delay
	call ReadKey
	jz KeepHere
	ret
NoPress ENDP

; Starts the game. The grid is set up and the player spawns. EAX is used as codes for operations.
StartGame PROC
	mov EDX, OFFSET levelMsg
	call WriteString
	movzx EAX, level
	call WriteDec
	call Countdown
	call Clrscr
	mov EAX, red + (black * 16) ; Borders and obstacles are red.
	call SetTextColor
	call FillBorder
	cmp level, 0
	je Skip
	movzx ECX, level
Print:
	push ECX
	call CreateObstacle
	pop ECX
	loop Print
Skip:
	mov EAX, lightBlue + (black * 16) ; Light-cycle is blue.
	call SetTextColor
	call SetPosition
	call SetDirection
Right:
	cmp EAX, 0 ; Right code.
	jne Down	
	call MoveRight
Down:
	cmp EAX, 1 ; Down code.
	jne Left
	call MoveDown
Left:
	cmp EAX, 2 ; Left code.
	jne Up
	call MoveLeft
Up:
	cmp EAX, 3 ; Up code.
	jne Crash
	call MoveUp
Crash:
	cmp EAX, 4 ; Crash code.
	jne Escape
	mov EAX, lightGray + (black * 16)
	call SetTextColor
	call Clrscr
	mov EDX, OFFSET levelScore
	call WriteString
	mov EAX, currentScore
	call WriteDec
	ret
Escape:
	cmp EAX, 5
	jne Right
	push EAX
	mov EAX, lightGray + (black * 16)
	call SetTextColor
	call Clrscr
	mov EDX, OFFSET cumulativeScore
	call WriteString
	mov EAX, totalScore
	call WriteDec
	pop EAX
	ret
StartGame ENDP

; Countdown before the game starts.
Countdown PROC
	mov ROW, 13
	mov COL, 33
	call Gotoxy
	mov EDX, OFFSET countMsg
	call WriteString
	mov ECX, 3
Count:
	mov EAX, ECX
	call WriteDec
	mov EAX, 1000
	call Delay
	mov ROW, 13
	mov COL, 45
	call Gotoxy
	loop Count
	ret
Countdown ENDP

; Fills out the border in the grid.
FillBorder PROC
	mov COL, 0
	mov ROW, 0
	mov AL, 219 ; ASCII code of block.
	mov ECX, 80
FillTop:
	call WriteChar
	call MultiplySize
	mov theGrid[ESI], 1
	inc COL
	loop FillTop
	mov COL, 79
	mov ROW, 1
	call Gotoxy
	mov ECX, 29
FillRight:
	call WriteChar
	call MultiplySize
	mov theGrid[ESI], 1
	inc ROW
	call Gotoxy
	loop FillRight
	dec COL
	dec ROW
	call Gotoxy
	mov ECX, 79
FillBottom:
	call WriteChar
	call MultiplySize
	mov theGrid[ESI], 1
	dec COL
	call Gotoxy
	loop FillBottom
	inc COL
	mov ECX, 29
FillLeft:
	call WriteChar
	call MultiplySize
	mov theGrid[ESI], 1
	dec ROW
	call Gotoxy
	loop FillLeft
	ret
FillBorder ENDP

; To be implemented.
CreateObstacle PROC
	call BoxPosition
	call SetColSize
	mov EBX, ECX
	call SetRowSize
BoxHeight:
	push ECX
	mov ECX, EBX
	mov AH, 0
BoxWidth:
	mov AL, 219
	call WriteChar
	push EBX
	call MultiplySize
	pop EBX
	mov theGrid[ESI], 1
	inc AH
	inc COL
	loop BoxWidth
	sub COL, AH
	inc ROW
	call Gotoxy
	pop ECX
	loop BoxHeight
	ret
CreateObstacle ENDP

; Sets a location to print out a box.
BoxPosition PROC
	mov EAX, 66
	call RandomRange
	inc EAX
	mov COL, AL
	mov EAX, 22
	call RandomRange
	inc EAX
	mov ROW, AL
	call Gotoxy
	ret
BoxPosition ENDP

; Gets a size for the height of the box.
SetRowSize PROC
	mov EAX, 5
	call RandomRange
	add EAX, 2
	mov ECX, EAX ; [2,6]
	ret
SetRowSize ENDP

; Gets a size for the width of the box.
SetColSize PROC
	mov EAX, 9
	call RandomRange
	add EAX, 4
	mov ECX, EAX ; [4,12]
	ret
SetColSize ENDP

; Sets a starting location for the light-cycle.
SetPosition PROC
	call Randomize
	mov EAX, 28
	call RandomRange
	add EAX, 25
	mov COL, AL
	mov EAX, 8
	call RandomRange
	add EAX, 10
	mov ROW, AL
	call Gotoxy
	ret
SetPosition ENDP

; Sets a starting direction for the light-cycle.
SetDirection PROC
	mov EAX, 4
	call RandomRange
	ret
SetDirection ENDP

; Resets the game.
Reset PROC
	mov speed, 100
	mov limit, 100
	mov ESI, 0
	mov ECX, 2400
Clear:
	mov theGrid[ESI], 0
	inc ESI
	loop Clear
	ret
Reset ENDP

; Continually moves the light-cycle right until a designated key is pressed or the light-cycle is over a covered area.
MoveRight PROC
	mov AL, 219
Move:
	call MultiplySize
	cmp theGrid[ESI], 1
	je Crash
	call WriteChar
	mov theGrid[ESI], 1
	inc currentScore
	inc COL
	push EAX
	mov EAX, limit
	cmp currentScore, EAX
	jne Stay
	call IncreaseSpeed
Stay:
	mov EAX, speed
	call Delay
	push EDX
	call ReadKey
	pop EDX
	cmp AH, 50h ; Virtual-scan code for DOWN arrow.
	jne Next
	pop EAX
	mov EAX, 1
	ret
Next:
	cmp AH, 48h ; Virtual-scan code for UP arrow.
	jne Escape
	pop EAX
	mov EAX, 3
	ret
Escape:
	cmp AH, 01h ; Virtual-scan code for ESC.
	jne SpaceCheck
	call Reset
	pop EAX
	mov EAX, 5
	ret
SpaceCheck:
	cmp AH, 39h ; Virtual-scan code for SPACE.
	jne Continue
	call PauseGame
Continue:
	pop EAX
	jmp Move
Crash:
	mov EAX, 4
	ret
MoveRight ENDP

; Continually moves the light-cycle down until a designated key is pressed or the light-cycle is over a covered area.
MoveDown PROC
	mov AL, 219
Move:
	call MultiplySize
	cmp theGrid[ESI], 1
	je Crash
	call WriteChar
	mov theGrid[ESI], 1
	inc currentScore
	inc ROW
	call Gotoxy
	push EAX
	mov EAX, limit
	cmp currentScore, EAX
	jne Stay
	call IncreaseSpeed
Stay:
	mov EAX, speed
	shl EAX, 1 ; Cuts the speed in half for vertical movement as characters are longer heightwise.
	call Delay
	push EDX
	call ReadKey
	pop EDX
	cmp AH, 4Dh ; Virtual-scan code for RIGHT arrow.
	jne Next
	pop EAX
	mov EAX, 0
	ret
Next:
	cmp AH, 4Bh ; Virtual-scan code for LEFT arrow.
	jne Escape
	pop EAX
	mov EAX, 2
	ret
Escape:
	cmp AH, 01h
	jne SpaceCheck
	call Reset
	pop EAX
	mov EAX, 5
	ret
SpaceCheck:
	cmp AH, 39h
	jne Continue
	call PauseGame
Continue:
	pop EAX
	jmp Move
Crash:
	mov EAX, 4
	ret
MoveDown ENDP

; Continually moves the light-cycle left until a designated key is pressed or the light-cycle is over a covered area.
MoveLeft PROC
	mov AL, 219
Move:
	call MultiplySize
	cmp theGrid[ESI], 1
	je Crash
	call WriteChar
	mov theGrid[ESI], 1
	inc currentScore
	dec COL
	call Gotoxy
	push EAX
	mov EAX, limit
	cmp currentScore, EAX
	jne Stay
	call IncreaseSpeed
Stay:
	mov EAX, speed
	call Delay
	push EDX
	call ReadKey
	pop EDX
	cmp AH, 48h
	jne Next
	pop EAX
	mov EAX, 3
	ret
Next:
	cmp AH, 50h
	jne Escape
	pop EAX
	mov EAX, 1
	ret
Escape:
	cmp AH, 01h
	jne SpaceCheck
	call Reset
	pop EAX
	mov EAX, 5
	ret
SpaceCheck:
	cmp AH, 39h
	jne Continue
	call PauseGame
Continue:
	pop EAX
	jmp Move
Crash:
	mov EAX, 4
	ret
MoveLeft ENDP

; Continually moves the light-cycle up until a designated key is pressed or the light-cycle is over a covered area.
MoveUp PROC
	mov AL, 219
Move:
	call MultiplySize
	cmp theGrid[ESI], 1
	je Crash
	call WriteChar
	mov theGrid[ESI], 1
	inc currentScore
	dec ROW
	call Gotoxy
	push EAX
	mov EAX, limit
	cmp currentScore, EAX
	jne Stay
	call IncreaseSpeed
Stay:
	mov EAX, speed
	shl EAX, 1
	call Delay
	push EDX
	call ReadKey
	pop EDX
	cmp AH, 4Dh
	jne Next
	pop EAX
	mov EAX, 0
	ret
Next:
	cmp AH, 4Bh
	jne Escape
	pop EAX
	mov EAX, 2
	ret
Escape:
	cmp AH, 01h
	jne SpaceCheck
	call Reset
	pop EAX
	mov EAX, 5
	ret
SpaceCheck:
	cmp AH, 39h
	jne Continue
	call PauseGame
Continue:
	pop EAX
	jmp Move
Crash:
	mov EAX, 4
	ret
MoveUp ENDP

; Multiplies ESI by the size of an abstract 2D-array. Used for accessing elements in theGrid array.
MultiplySize PROC
	movzx ESI, ROW
	shl ESI, 6 ; Multiply by 64.
	movzx EBX, ROW
	shl EBX, 4 ; Multiply by 16.
	add ESI, EBX ; Multiply by 80.
	movzx EBX, COL
	add ESI, EBX
	ret
MultiplySize ENDP

; Freezes movement until SPACE is pressed.
PauseGame PROC
KeepHere:
	mov EAX, 50
	call Delay
	push EDX
	call ReadKey
	pop EDX
	cmp AH, 39h
	jne KeepHere
	ret
PauseGame ENDP

; Decreases the delay between character writes until 20ms is reached.
IncreaseSpeed PROC
	cmp speed, 20
	je Skip
	sub speed, 20
Skip:
	add limit, 100
	ret
IncreaseSpeed ENDP

END Main