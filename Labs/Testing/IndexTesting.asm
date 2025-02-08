include Irvine32.inc

.data
myList WORD 1,2,3

.code
Main PROC
mov EAX, OFFSET myList
call WriteDec
call Crlf
mov EAX, OFFSET myList + 1
;add EAX, 1
call WriteDec
call Crlf
exit
Main ENDP
END Main