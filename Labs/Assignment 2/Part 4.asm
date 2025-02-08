; Author: Jeremey Larter
; Lab Assignment #2 Part 4 (Movable Box)
; Purpose: To display a square in the area specified by the user.
include Irvine32.inc

.data
centre	BYTE	"   ", 0
xPrompt	BYTE	"Enter a x location (0 to 119) : ", 0
yPrompt BYTE	"Enter a y location (0 to 29)  : ", 0

xVal	BYTE 0
yVal	BYTE 0

.code
main PROC

; Sets the color of the background to black and the text color to lime.
mov eax, lightGreen+(black*16)
call SetTextColor
call Clrscr

; Asks the user where they want the box to be displayed. Values are stored.
mov edx, OFFSET xPrompt
call WriteString
call ReadDec
call Crlf
mov xVal, al
mov edx, OFFSET yPrompt
call WriteString
call ReadDec
call Crlf
mov yVal, al
call Crlf

call WaitMsg
call Clrscr

; Moves the cursor to the area specified by the user.
mov dl, xVal  ;column
mov dh, yVal  ;row
call Gotoxy

; Displays the top part of the box. Numbers stored in the al register are ASCII codes for symbols.
mov al, 201
call WriteChar
mov al, 205
call WriteChar
call WriteChar
call WriteChar
mov al, 187
call WriteChar

; Moves the cursor down one row.
mov dl, xVal
mov al, yVal
inc al
mov yVal, al
mov dh, yVal
call Gotoxy

; Displays the centre of the box.
mov al, 186
call WriteChar
mov edx, OFFSET centre
call WriteString
call WriteChar

; Moves the cursor down one row.
mov dl, xVal
mov al, yVal
inc al
mov yVal, al
mov dh, yVal
call Gotoxy

; Displays the bottom of the box.
mov al, 200
call WriteChar
mov al, 205
call WriteChar
call WriteChar
call WriteChar
mov al, 188
call WriteChar

call Crlf
call Crlf
call Crlf
call Crlf
call Crlf
call Crlf
call Crlf
call WaitMsg
call Clrscr
exit

main ENDP
END main