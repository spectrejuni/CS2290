; Author: Jeremey Larter
; Lab Assignment #9 Part 5 (Sorting Algorithms Visualization)
; Purpose: To demonstrate different sorting algorithms in action.
; NOTE: For best results use a 100x38 window size
include Irvine32.inc

.data
; Memory allocations.
array		BYTE	50 dup(?)
message1	BYTE	"The unsorted array is as follows:", 0Ah, 0Dh, 0
prompt1		BYTE	"Press any key to sort . . .", 0
prompt2		BYTE	"Press any key to continue . . .", 0
message2	BYTE	"The sorted array is as follows:", 0Ah, 0Dh, 0
choiceSort	BYTE	"Which sorting algorithm do you want to see?", 0
insertion	BYTE	"Insertion Sort", 0
bubble		BYTE	"Bubble Sort", 0
selection	BYTE	"Selection Sort", 0
choiceSpeed	BYTE	"What speed do you want the sorting alogrithm to run at?", 0
slow		BYTE	"1.00s", 0
normal		BYTE	"0.50s", 0
fast		BYTE	"0.25s", 0
extreme		BYTE	"0.10s", 0
arrowLoc	BYTE	2
index		DWORD	0
partition	DWORD	1
algorithm	DWORD	1
speed		DWORD	1000

.code
; Contains the menu for selecting an algorithm.
Main PROC
call Clrscr
mov EDX, OFFSET choiceSort
call WriteString
mov DH, arrowLoc
mov DL, 0
call Gotoxy
mov AL, 62 ; ASCII code of right arrow.
call WriteChar
mov DH, 2
mov DL, 4
call Gotoxy
mov EDX, OFFSET insertion
call WriteString
mov DH, 3
mov DL, 4
call Gotoxy
mov EDX, OFFSET bubble
call WriteString
mov DH, 4
mov DL, 4
call Gotoxy
mov EDX, OFFSET selection
call WriteString
Cursor:
	mov DH, arrowLoc
	mov DL, 0
	call Gotoxy
	mov EAX, 50
	call Delay
	push DX
	call ReadKey
	cmp AH, 50h ; Virtual-scan code for DOWN key.
	je Down
	cmp AH, 48h ; Virtual-scan code for UP key.
	je Up
	cmp AH, 1Ch ; Virtual-scan code for ENTER key.
	je SetAlgorithm
	jmp Cursor
Down:
	pop DX
	cmp DH, 4
	jne SetArrowD
	mov arrowLoc, 2
	jmp Main
SetArrowD:
	inc DH
	mov arrowLoc, DH
	jmp Main
Up:
	pop DX
	cmp DH, 2
	jne SetArrowU
	mov arrowLoc, 4
	jmp Main
SetArrowU:
	dec DH
	mov arrowLoc, DH
	jmp Main
SetAlgorithm:
	call Clrscr
	mov arrowLoc, 2
	pop DX
	cmp DH, 2
	je ChooseSpeed
	mov algorithm, 2
	cmp DH, 3
	je ChooseSpeed
	mov algorithm, 3
Main ENDP

; Contains the menu for selecting a speed.
ChooseSpeed PROC
call Clrscr
mov EDX, OFFSET choiceSpeed
call WriteString
mov DH, arrowLoc
mov DL, 0
call Gotoxy
mov AL, 62
call WriteChar
mov DH, 2
mov DL, 4
call Gotoxy
mov EDX, OFFSET slow
call WriteString
mov DH, 3
mov DL, 4
call Gotoxy
mov EDX, OFFSET normal
call WriteString
mov DH, 4
mov DL, 4
call Gotoxy
mov EDX, OFFSET fast
call WriteString
mov DH, 5
mov DL, 4
call Gotoxy
mov EDX, OFFSET extreme
call WriteString
Cursor:
	mov DH, arrowLoc
	mov DL, 0
	call Gotoxy
	mov EAX, 50
	call Delay
	push DX
	call ReadKey
	cmp AH, 50h
	je Down
	cmp AH, 48h
	je Up
	cmp AH, 1Ch
	je SetSpeed
	jmp Cursor
Down:
	pop DX
	cmp DH, 5
	jne SetArrowD
	mov arrowLoc, 2
	jmp ChooseSpeed
SetArrowD:
	inc DH
	mov arrowLoc, DH
	jmp ChooseSpeed
Up:
	pop DX
	cmp DH, 2
	jne SetArrowU
	mov arrowLoc, 5
	jmp ChooseSpeed
SetArrowU:
	dec DH
	mov arrowLoc, DH
	jmp ChooseSpeed
SetSpeed:
	call Clrscr
	pop DX
	cmp DH, 2
	je Sort
	mov speed, 500
	cmp DH, 3
	je Sort
	mov speed, 250
	cmp DH, 4
	je Sort
	mov speed, 100
ChooseSpeed ENDP

; Displays the unsorted array, sorts it based on what "algorithm" is set to, and displays the sorted array.
Sort PROC
call CreateArray
mov EDX, OFFSET message1
call WriteString
call PrintArray
mov DL, 0
mov DH, 2
call Gotoxy
mov EDX, OFFSET prompt1
call WriteString
call NoPress
call Clrscr
cmp algorithm, 1
jne FirstSkip
call InsertionSort
jmp Done
FirstSkip:
	cmp algorithm, 2
	jne SecondSkip
	call BubbleSort
	jmp Done
SecondSkip:
	call SelectionSort
Done:
	call Clrscr
	mov EDX, OFFSET message2
	call WriteString
	call PrintArray
	mov DL, 0
	mov DH, 2
	call Gotoxy
	mov EDX, OFFSET prompt2
	call WriteString
	call NoPress
	call Clrscr
	exit
Sort ENDP

; Generates random values for an array of size 50.
CreateArray PROC
mov ESI, 0
mov ECX, 50
call Randomize
Fill:
	mov EAX, 33
	call RandomRange
	inc EAX
	mov array[ESI], AL
	inc ESI
	loop Fill
ret
CreateArray ENDP

; Procedure that mimics WaitMsg (but press any key instead of ENTER).
NoPress PROC
mov EAX, 50
call Delay
call ReadKey
jz NoPress
ret
NoPress ENDP

; Sorts the array using a less efficient version of Insertion Sort.
InsertionSort PROC
mov ESI, SIZEOF array
dec ESI
mov EDI, -1 ; Set to -1 instead of 0 to utilize overflow as EDI is incremented before anything else.
Check:
	inc EDI
	mov BL, array[ESI]
	cmp EDI, ESI
	je Done
	cmp EDI, partition ; partition is the partition between sorted and unsorted.
	je ShiftArray
	mov AL, array[EDI]
	cmp AL, BL
	ja ShiftArray
	jmp Check
Done:
	ret
InsertionSort ENDP

; Shifts the contents of the array by one right until the location specified EDI. The location is filled with the contents of BL.
ShiftArray PROC
mov ESI, SIZEOF array
Shift:
	cmp ESI, EDI
	jbe Fill
	dec ESI
	mov AL, array[ESI]
	mov array[ESI + 1], AL
	jmp Shift
Fill:
	mov array[EDI], BL
	inc partition
	call Clrscr
	call PrintArray
	mov EAX, speed
	call Delay
	jmp InsertionSort
ShiftArray ENDP

; Sorts the array using Bubble Sort.
BubbleSort PROC
mov ECX, SIZEOF array
dec ECX
Pass:
	mov ESI, 0
	mov EDI, 1
	Check:
		mov AL, array[ESI]
		mov BL, array[EDI]
		cmp AL, BL
		ja Swap
		cmp EDI, ECX
		ja Next
		inc ESI
		inc EDI
		jmp Check
	Swap:
		mov array[ESI], BL
		mov array[EDI], AL
		inc ESI
		inc EDI
		push ECX
		push ESI
		call Clrscr
		call PrintArray
		mov EAX, speed
		call Delay
		pop ESI
		pop ECX
		jmp Check
	Next:
		loop Pass
	ret
BubbleSort ENDP

; Sorts the array using Selection Sort.
SelectionSort PROC
mov ESI, 0
Selections:
	mov index, ESI
	mov EDI, ESI
	inc EDI
	mov AL, array[ESI]
	Check:
		cmp EDI, SIZEOF array
		je Swap
		ja Done
		mov BL, array[EDI]
		cmp AL, BL
		ja NewMin
		Continue:
			inc EDI
			jmp Check
	NewMin:
		mov index, EDI
		mov AL, BL
		jmp Continue
	Swap:
		mov EDI, index
		mov BL, array[ESI]
		mov array[ESI], AL
		mov array[EDI], BL
		inc ESI
		push ESI
		call Clrscr
		call PrintArray
		mov EAX, speed
		call Delay
		pop ESI
		jmp Selections
	Done:
		ret
SelectionSort ENDP

; Prints out the contents of the array in the form of vertical bars.
PrintArray PROC
mov ESI, 0
mov DL, -2
mov AL, 219
mov ECX, SIZEOF array
print:
	add DL, 2
	mov DH, 36
	push ECX
	movzx ECX, array[ESI]
	bar:
		call Gotoxy
		call WriteChar
		dec DH
		loop bar
	inc ESI
	pop ECX
	loop print
ret
PrintArray ENDP

END Main