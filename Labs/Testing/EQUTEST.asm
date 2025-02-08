include Irvine32.inc

PI EQU <3.1416>
pressKey EQU "Press any key to continue. . .", 0

.data
prompt BYTE pressKey
number DWORD PI

.code
Main PROC
mov EDX, OFFSET prompt
mov EAX, number
call WriteString
call Crlf
call WriteInt
call Crlf
call WaitMsg
exit
Main ENDP
END Main