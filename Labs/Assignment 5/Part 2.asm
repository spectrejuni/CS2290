; Author: Jeremey Larter
; Lab Assignment #5 Part 2 (Array Index Shift)
; Purpose: To demo inserting an element and shifting the contents of an array.
include Irvine32.inc

.data
sorted		BYTE	2,5,9,11,23,41,57,68,71,82,85
message		BYTE	"The array is as follows:", 0Ah, 0Dh, 0Ah, 0Dh, 0 ; 0Ah and 0Dh is equivalent to crlf.
array		BYTE	"array", 0
location	BYTE	"location ", 0
equal		BYTE	"  = ", 0
prompt		BYTE	"Which location do you wish to change: ", 0

.code
main PROC

call Clrscr
mov edx, OFFSET message
call WriteString
call printArray ; Calls the printArray procedure.
call Crlf
call Crlf
mov edx, OFFSET prompt
call WriteString
call ReadDec
mov edi, eax ; edi can be used like esi for indices.
call shiftArray ; Calls the shiftArray procedure.
call Crlf
call printArray

call Crlf
call Crlf
call WaitMsg
call Clrscr
exit

main ENDP

; Prints out the contents of the array.
printArray PROC
mov edx, OFFSET array
call WriteString
mov esi, 0
mov ecx, SIZEOF sorted
print:
	call Crlf
	mov edx, OFFSET location
	call WriteString
	mov eax, esi
	call WriteDec
	mov edx, OFFSET equal
	call WriteString
	movzx eax, sorted[esi]
	call WriteDec
	inc esi
	loop print
ret
printArray ENDP

; Shifts the contents of the array by one right until the location specified by the user.
shiftArray PROC
mov esi, SIZEOF sorted
shift:
	cmp esi, edi
	jbe fill
	dec esi
	mov al, sorted[esi]
	mov sorted[esi + 1], al
	jmp shift
fill:
	mov sorted[edi], 0
	ret
shiftArray ENDP

END main