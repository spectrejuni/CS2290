; Author: Jeremey Larter
; Lab Assignment #2 Part 3 (Centre Square)
; Purpose: To display a square in the centre of the window.
include Irvine32.inc

.data
centre	BYTE	"   ", 0

.code
main PROC

call Clrscr

; Sets the color of the background to black and the text color to lime.
mov eax, lightGreen+(black*16)
call SetTextColor
call Clrscr

; Moves the cursor near the centre of the window.
mov dl, 58  ;column
mov dh, 13  ;row
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
mov dl, 58
mov dh, 14
call Gotoxy

; Displays the centre of the box.
mov al, 186
call WriteChar
mov edx, OFFSET centre
call WriteString
call WriteChar

; Moves the cursor down one row.
mov dl, 58
mov dh, 15
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