include Irvine32.inc

.data
valW WORD -32768
.code
main PROC
movsx eax, valW
call WriteInt
neg eax
call WriteInt

call Crlf
call WaitMsg
exit
main ENDP
END main