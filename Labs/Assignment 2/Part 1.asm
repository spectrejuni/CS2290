; Author: Jeremey Larter
; Lab Assignment #2 Part 1 (Values in Different Bases)
; Purpose: To take the values inputted by user and display them in different bases.
include Irvine32.inc

.data
xPrompt	BYTE	"Enter Value for X : ", 0
yPrompt	BYTE	"Enter Value for Y : ", 0

xVal	DWORD 0
yVal	DWORD 0

xOutput	BYTE	"X = ", 0
yOutput	BYTE	"Y = ", 0

xHexOutput	BYTE	"Hex X	 =    ", 0
yHexOutput	BYTE	"Hex Y	 =    ", 0

xBinOutput	BYTE	"Binary X =    ", 0
yBinOutput	BYTE	"Binary Y =    ", 0

.code
main PROC

; Asks the user for an X value and stores it.
mov	edx, OFFSET	xPrompt
call WriteString
call ReadDec
mov xVal, eax

; Asks the user for a Y value and stores it.
mov	edx, OFFSET yPrompt
call WriteString
call ReadDec
mov yVal, eax

call Crlf

; Outputs the X value in decimal form.
mov edx, OFFSET xOutput
mov eax, xVal
call WriteString
call WriteDec

call Crlf

; Outputs the Y value in decimal form.
mov edx, OFFSET yOutput
mov eax, yVal
call WriteString
call WriteDec

call Crlf
call Crlf

; Outputs the X value in hexadecimal form.
mov edx, OFFSET xHexOutput
mov eax, xVal
mov ebx, 4
call WriteString
call WriteHexB

call Crlf

; Outputs the Y value in hexadecimal form.
mov edx, OFFSET yHexOutput
mov eax, yVal
mov ebx, 4
call WriteString
call WriteHexB

call Crlf
call Crlf

; Outputs the X value in binary form.
mov edx, OFFSET xBinOutput
mov eax, xVal
mov ebx, 4
call WriteString
call WriteBinB

call Crlf

; Outputs the Y value in binary form.
mov edx, OFFSET yBinOutput
mov eax, yVal
mov ebx, 4
call WriteString
call WriteBinB

call Crlf
call Crlf
call Crlf
call Crlf

call WaitMsg
call Clrscr
exit

main ENDP
END main