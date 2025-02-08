; Author: Jeremey Larter
; Lab Assignment #9 Part 3 (Bubble Sort Visualization)
; Purpose: To sort an array using the bubble sort algorithm.
include Irvine32.inc

.data
; Memory allocations.
array		BYTE	50 dup(?)
message1	BYTE	"The unsorted array is as follows:", 0Ah, 0Dh, 0
prompt1		BYTE	"Press any key to sort . . .", 0
prompt2		BYTE	"Press any key to continue . . .", 0
message2	BYTE	"The sorted array is as follows:", 0Ah, 0Dh, 0

.code
Main PROC
call Clrscr
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
call BubbleSort
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
Main ENDP

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
		mov EAX, 100
		call Delay
		pop ESI
		pop ECX
		jmp Check
	Next:
		loop Pass
	ret
BubbleSort ENDP

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