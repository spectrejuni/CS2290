include Irvine32.inc

.data
message BYTE "Hello", 10, "Goodbye", 13, "No more", 0

.code
Main PROC
mov EDX, OFFSET message
call WriteString
call Crlf
call Crlf
call WaitMsg
exit
Main ENDP
END Main