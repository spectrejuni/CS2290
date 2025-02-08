; Author: Jeremey Larter
; Lab Assignment #2 Part 2 (Contents of the EAX Register)
; Purpose: To take the value inputted by the user, store it in the EAX register, and display the contents.
include Irvine32.inc

.data
prompt	BYTE	"Enter a value for EAX : ", 0

eaxOutput	BYTE	"EAX = ", 0
axOutput	BYTE	" AX =     ", 0
alOutput	BYTE	" AL =       ", 0

value	DWORD 0

.code
main PROC

call Clrscr

; Asks the user for a value and stores it in the eax register.
mov edx, OFFSET prompt
call WriteString
call ReadDec
mov value, eax

call Crlf

; Displays the contents of the eax register.
mov edx, OFFSET eaxOutput
mov eax, value
mov ebx, 4
call WriteString
call WriteHexB
call Crlf
mov edx, OFFSET axOutput
mov ebx, 2
call WriteString
call WriteHexB
call Crlf
mov edx, OFFSET alOutput
mov ebx, 1
call WriteString
call WriteHexB

call Crlf

call Crlf
call WaitMsg
call Clrscr
exit

main ENDP
END main