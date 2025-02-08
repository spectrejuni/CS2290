INCLUDE Irvine32.inc

.data
hello1_msg	BYTE "Hello to the world", 0
hello2_msg	BYTE "Another message to the world", 0

.code
main PROC

call Clrscr					;clear the screen

mov edx, OFFSET hello1_msg	;print the Hello1 string
call WriteString
call Crlf
call Crlf

mov edx, OFFSET hello2_msg	;print the Hello2 string
call WriteString
call Crlf

call WaitMsg
call Clrscr
exit

main ENDP
END main