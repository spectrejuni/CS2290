; Author: Jeremey Larter
; Lab Assignment #9 Part 1 (Insertion Sort)
; Purpose: To sort an array using the insertion sort algorithm.
include Irvine32.inc

.data
; Memory allocations.
array		BYTE	 10 dup(?)
message1	BYTE	"The unsorted array is as follows:", 0Ah, 0Dh, 0
prompt		BYTE	"Press any key to sort . . .", 0
message2	BYTE	"The sorted array is as follows:", 0Ah, 0Dh, 0
index		DWORD	1

.code
Main PROC
call Clrscr
call CreateArray
mov EDX, OFFSET message1
call WriteString
call PrintArray
mov EDX, OFFSET prompt
call WriteString
NoPress:
	mov EAX, 50
	call Delay
	call ReadKey
	jz NoPress
call InsertionSort
call Crlf
call Crlf
mov EDX, OFFSET message2
call WriteString
call PrintArray
call WaitMsg
call Clrscr
exit
Main ENDP

; Generates random values for an array of size 10.
CreateArray PROC
mov ESI, 0
mov ECX, 10
call Randomize
Fill:
	mov EAX, 50
	call RandomRange
	inc EAX
	mov array[ESI], AL
	inc ESI
	loop Fill
ret
CreateArray ENDP

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
	cmp EDI, index ; Index is the partition between sorted and unsorted.
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
	inc index
	jmp InsertionSort
ShiftArray ENDP

; Prints out the contents of the array.
PrintArray PROC
mov ESI, 0
mov AL, 91
call WriteChar
mov ECX, SIZEOF array
print:
	movzx EAX, array[ESI]
	call WriteDec
	cmp ECX, 1
	je Omit
	mov AL, 44
	call WriteChar
	mov AL, 32
	call WriteChar
	inc ESI
	Omit:
	loop print
mov AL, 93
call WriteChar
call Crlf
call Crlf
ret
PrintArray ENDP

END Main