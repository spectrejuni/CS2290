; Author: Jeremey Larter
; Lab Assignment #3 Part 1 (Basic Calculator)
; Purpose: To do some basic arithmetic with the values provided by the user.
include Irvine32.inc

.data
mainPrompt	BYTE	"Math Drill - Enter two values and get the following results:", 0
addPrompt	BYTE	"+     Addition", 0
subPrompt	BYTE    "-     Subtraction", 0
mulPrompt	BYTE	"*     Multiplication", 0

xPrompt		BYTE	"Enter Value for X : ", 0
yPrompt		BYTE	"Enter Value for Y : ", 0
xVal		SDWORD ?
yVal		SDWORD ?

xEquals		BYTE	"X          =     ", 0
yEquals		BYTE	"Y          =     ", 0
xAddY		BYTE	"X + Y      =     ", 0
xSubY		BYTE	"X - Y      =     ", 0
xMulY		BYTE	"X * Y      =     ", 0
space		BYTE	"	    ", 0
hexVal		BYTE	"Hex value = ", 0

.code
main PROC

call Clrscr 

; Displays the instructions to the user.
mov edx, OFFSET mainPrompt
call WriteString
call Crlf
call Crlf
mov edx, OFFSET addPrompt
call WriteString
call Crlf
mov edx, OFFSET subPrompt
call WriteString
call Crlf
mov edx, OFFSET mulPrompt
call WriteString
call Crlf
call Crlf

; Asks the user to input values for X and Y and stores it.
mov edx, OFFSET xPrompt
call WriteString
call ReadDec ; Assumes user values are always positive.
mov xVal, eax
mov edx, OFFSET yPrompt
call WriteString
call ReadDec
mov yVal, eax
call Crlf

; Displays the X and Y values in both decimal and hexadeximal form.
mov edx, OFFSET xEquals
call WriteString
mov eax, xVal
call WriteDec
mov edx, OFFSET space
call WriteString
mov edx, OFFSET hexVal
call WriteString
call WriteHex
call Crlf
mov edx, OFFSET yEquals
call WriteString
mov eax, yVal
call WriteDec
mov edx, OFFSET space
call WriteString
mov edx, OFFSET hexVal
call WriteString
call WriteHex
call Crlf
call Crlf

; Displays the addition of X and Y in both decimal and hexadecimal form.
mov edx, OFFSET xAddY
call WriteString
mov eax, xVal
add eax, yVal
call WriteInt
mov edx, OFFSET space
call WriteString
mov edx, OFFSET hexVal
call WriteString
call WriteHex
call Crlf

; Displays the subtraction of X and Y in both decimal and hexadecimal form.
mov edx, OFFSET xSubY
call WriteString
mov eax, xVal
sub eax, yVal
call WriteInt
mov edx, OFFSET space
call WriteString
mov edx, OFFSET hexVal
call WriteString
call WriteHex
call Crlf

; Displays the multiplication of X and Y in both decimal and hexadecimal form.
mov edx, OFFSET xMulY
call WriteString
mov eax, yVal
dec eax
mov ecx, eax
mov eax, xVal
Multiply:
	add eax, xVal
	loop Multiply
call WriteInt
mov edx, OFFSET space
call WriteString
mov edx, OFFSET hexVal
call WriteString
call WriteHex
call Crlf

call Crlf
call WaitMsg
call Clrscr
exit

main ENDP
END main