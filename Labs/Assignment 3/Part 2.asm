; Author: Jeremey Larter
; Lab Assignment #3 Part 2 (Screen Saver)
; Purpose: To demo a "basic" screen saver. NOTE: Use an 80x25 (WxH) console window for the best result.
include Irvine32.inc

.data
prompt		BYTE	"Simple Screen Saver", 0
loopMax		DWORD	100 ; Change this for number of loops.
boxCentre	BYTE	"        ", 0

.code
main PROC

; Sets the colour of the console window.
mov eax, lightMagenta+(black*16)
call SetTextColor
call Clrscr

; Screen Saver Message
mov edx, OFFSET prompt
call WriteString
call Crlf
call WaitMsg
call Clrscr

; Calls the Random procedure and returns once done.
call Random

; Controls the number of times the Screen Saver loops and the delay between each loop.
mov ecx, loopMax
ScreenSaver:
	mov loopMax, ecx
	call Box ; Calls the Box procedure and returns once done.
	mov ecx, loopMax
	mov eax, 100 ; Time in milliseconds. Change this for amount of delay between loops
	call Delay
	loop ScreenSaver

call Crlf
call Crlf
mov eax, 3000 ; 3 second delay before message.
call Delay
call WaitMsg
call Clrscr
exit

main ENDP

; This is where the 10x5 Box is created and displayed on screen (different location each time).
Box PROC
mov al, 201 ; ASCII codes
call WriteChar
mov al, 205
mov ecx, 8
Top:
	call WriteChar
	loop Top	
mov al, 187
call WriteChar
mov al, 186
mov ecx, 3
Centre:
	inc dh
	call Gotoxy
	call WriteChar
	mov bx, dx
	mov edx, OFFSET boxCentre
	call WriteString
	call WriteChar
	mov dx, bx
	loop Centre	
inc dh
call Gotoxy
mov al, 200
call WriteChar
mov al, 205
mov ecx, 8
Bottom:
	call WriteChar
	loop Bottom
mov al, 188
call WriteChar
call Random ; Calls the Random subroutine and returns once done.
ret ; Needed to go back to previous instruction.
Box ENDP
	
; This is where the location of the box is determined.
Random PROC
mov eax, 70
call Randomize ; Needed so that we don't get the same numbers everytime.
call RandomRange ; Gets a random number from 0 to n-1, n being the number in the eax register.
mov dl, al ; The number stored in the eax register is small enough that it only occupies the al (reg8) register. DL = column
mov eax, 20
call Randomize
call RandomRange
mov dh, al ; DH = row
call Gotoxy
ret
Random ENDP

END main