INCLUDE Irvine32.inc

.data
moving_msg	BYTE "Look Here", 0

xval		DWORD 15

.code
main PROC

call Clrscr					;clear the screen

mov dh, 5
mov dl, 30
call Gotoxy

mov edx, OFFSET moving_msg
call WriteString

mov dh, 10
mov dl, 40
call Gotoxy

mov edx, OFFSET moving_msg
call WriteString

mov eax, 2000
call Delay

mov dh, 15
mov dl, 50
call Gotoxy

mov edx, OFFSET moving_msg
call WriteString

CALL WaitMsg
call Clrscr

mov eax, xval
call Writedec
call Crlf
call WriteHex
call Crlf
call WriteBin

CALL WaitMsg
call Clrscr

exit

main ENDP
END main