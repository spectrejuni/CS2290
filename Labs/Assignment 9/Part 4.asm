; Author: Jeremey Larter
; Lab Assignment #9 Part 4 (Selection Sort Visualization)
; Purpose: To sort an array using the selection sort algorithm.
include Irvine32.inc

.data
; Memory allocations.
array		BYTE	50 dup(?)
message1	BYTE	"The unsorted array is as follows:", 0Ah, 0Dh, 0
prompt1		BYTE	"Press any key to sort . . .", 0
prompt2		BYTE	"Press any key to continue . . .", 0
message2	BYTE	"The sorted array is as follows:", 0Ah, 0Dh, 0
index		DWORD	0

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
call SelectionSort
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
		mov EAX, 100
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