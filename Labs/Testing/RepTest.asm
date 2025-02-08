include Irvine32.inc

.data
source	BYTE	"hello world!", 0
target	BYTE	13 dup(?)

.code
Main PROC
	cld
	mov ECX, LENGTHOF source
	mov ESI, OFFSET source
	mov EDI, OFFSET target
	rep movsb
	mov EDX, OFFSET target
	call WriteString
	call Crlf
	call WaitMsg
	exit
Main ENDP
END Main