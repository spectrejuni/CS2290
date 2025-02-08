include Irvine32.inc

.data
str1	BYTE	"Enter your name", 0
str2	BYTE	'Error: halting program', 0
str3 	BYTE	'A','E','I','O','U'
greeting BYTE	"Welcome to the Encryption Demo program "
		BYTE	"created by Kip Irvine.",0
.code
main PROC
call Clrscr
mov edx, OFFSET str1
call WriteString
call Crlf
mov edx, OFFSET str2
call WriteString
call Crlf
mov edx, OFFSET str3
call WriteString
call Crlf
mov edx, OFFSET greeting
call WriteString
call Crlf
call WaitMsg
exit
main ENDP
END main