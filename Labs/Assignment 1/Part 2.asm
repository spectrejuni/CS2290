INCLUDE Irvine32.inc

.data
input_msg	BYTE "Enter a number : ", 0
output_msg	BYTE "The number you typed was : ", 0

xval		DWORD 1
yval		DWORD 2

.code
main PROC

call Clrscr				;clear the screen

call DumpRegs			;note the content of registers
call Crlf

mov eax, xval
call DumpRegs
call Crlf

mov eax, yval
call DumpRegs
call Crlf

call WaitMsg

call Clrscr

mov edx, OFFSET input_msg
call WriteString

call ReadDec
call DumpRegs
call Crlf

call WaitMsg

call Clrscr
exit

main ENDP
END main