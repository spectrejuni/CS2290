include Irvine32.inc

.data
source DWORD 0FFFFFFFFh
target DWORD ?

.code
Main PROC
	mov EAX, source
	call WriteHex
	call Crlf
	
	mov ESI, OFFSET source
	mov EDI, OFFSET target
	movsd
	
	mov EAX, target
	call WriteHex
	call Crlf
	
	call WaitMsg
	exit
Main ENDP
END Main