include Irvine32.inc

.data
valW SWORD -32768

.code
Main PROC
movsx EAX, valW
call WriteInt
call Crlf
neg EAX
call WriteInt
call Crlf
call WaitMsg
exit
Main ENDP
END Main