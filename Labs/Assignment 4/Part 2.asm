; Author: Jeremey Larter
; Lab Assignment #4 Part 2 (Random Screensaver)
; Purpose: To demo an improved version of the screensaver from Lab Assignment #3 Part 2.
; NOTE: Use an 80x25 (WxH) console window for the best result.
include Irvine32.inc

.data
prompt		BYTE	"Simple Screen Saver", 0
loopMax		DWORD	100
widht		DWORD	? ; Intentionally spelt wrong because width is a reserved word.
height		DWORD	?

.code
main PROC

; Displays the wait message prompt before the screensaver starts.
mov edx, OFFSET prompt
call WriteString
call Crlf
call WaitMsg
call Clrscr

; Controls how long it runs.
mov ecx, loopMax
ScreenSaver:
	mov loopMax, ecx
	call Box ; Calls the box process and displays a box.
	mov ecx, loopMax
	mov eax, 100
	call Delay ; Delay for 100ms.
	loop ScreenSaver

call Crlf
call Crlf
mov eax, 3000
call Delay ; 3-second delay before end of program.
call WaitMsg
call Clrscr
exit

main ENDP

; Prints out a box on the console window.
Box PROC

; Sets the location and size of the next box.
call RandomLocation
call RandomRowSize
call RandomColSize

; Sets the background and foreground colours for the box.
mov eax, 255
call Randomize
call RandomRange
inc eax
call SetTextColor

; Draws the actual box.
call drawTop
mov ecx, height
middle:
	call drawMiddle
	loop middle	
call drawBottom
ret

Box ENDP

; Draws the top portion of the box.
drawTop PROC
mov al, 201
call WriteChar
mov al, 205
mov ecx, widht
centre:
	call WriteChar
	loop centre
mov al, 187
call WriteChar
ret
drawTop ENDP

; Draws the middle portion of the box.
drawMiddle PROC
inc dh
call Gotoxy
mov al, 186
call WriteChar
mov al, 32
mov ebx, ecx
mov ecx, widht
Space:
	call WriteChar
	loop Space
mov al, 186
call WriteChar
mov ecx, ebx
ret
drawMiddle ENDP

; Draws the bottom portion of the box.
drawBottom PROC
inc dh
call Gotoxy
mov al, 200
call WriteChar
mov al, 205
mov ecx, widht
bottom:
	call WriteChar
	loop bottom
mov al, 188
call WriteChar
ret
drawBottom ENDP

; Sets the width of the box to a size that is smaller that the console window and fits within it.
RandomColSize PROC
mov eax, 17
;call Randomize
call RandomRange
add eax, 62
mov ebx, 80
sub ebx, eax
mov widht, ebx ;eax
ret
RandomColSize ENDP

; Sets the length of the box to a size that is smaller that the console window and fits within it.
RandomRowSize PROC
mov eax, 7
;call Randomize
call RandomRange
add eax, 17 ;inc eax
mov ebx, 25
sub ebx, eax
mov height, ebx ;eax
ret
RandomRowSize ENDP

; Sets the location of the cursor using the gotoxy process.	
RandomLocation PROC
	mov eax, 60
	;call Randomize
	call RandomRange
	mov dl, al ; DL = column
	mov eax, 15
	;call Randomize
	call RandomRange
	mov dh, al ; DH = row
	call Gotoxy
	ret
RandomLocation ENDP

END main