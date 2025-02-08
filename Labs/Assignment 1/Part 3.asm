INCLUDE Irvine32.inc

.data
input_msg	BYTE "Enter a number : ", 0
output_msg	BYTE "The number you typed was : ", 0
final_msg	BYTE "Program is done! ", 0

xval		DWORD 0

.code
main PROC

call Clrscr					;clear the screen

mov edx, OFFSET input_msg
call WriteString
call ReadDec
mov xval, eax
call Crlf

mov edx, OFFSET output_msg
call WriteString
mov eax, xval
call WriteDec
call Crlf

mov edx, OFFSET final_msg
call WriteString
call Crlf

call WaitMsg

call Clrscr
exit

main ENDP
END main