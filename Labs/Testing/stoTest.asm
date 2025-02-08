include Irvine32.inc

.data
target BYTE	?

.code
Main proc
mov AL, 15
mov EDI, offset target
stosb
movzx EAX, target
call WriteDec
call Crlf
call WaitMsg
exit
Main ENDP
END Main