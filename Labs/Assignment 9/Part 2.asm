; Author: Jeremey Larter
; Lab Assignment #9 Part 2 (Insertion Sort Visualization)
; Purpose: To sort an array using the insertion sort algorithm.
include Irvine32.inc

.data
; Memory allocations.
array		BYTE	50 dup(?)
message1	BYTE	"The unsorted array is as follows:", 0Ah, 0Dh, 0
prompt1		BYTE	"Press any key to sort . . .", 0
prompt2		BYTE	"Press any key to continue . . .", 0
message2	BYTE	"The sorted array is as follows:", 0Ah, 0Dh, 0
partition	DWORD	1

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
call InsertionSort
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
	mov EAX, 100
	call Delay
	jmp InsertionSort
ShiftArray ENDP

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