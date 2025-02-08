include Irvine32.inc

.data
message	BYTE	"This is a message.", 0
loopMax		DWORD	100

.code
main PROC

call Clrscr

mov eax, 100
mov ecx, loopMax
Run:
	mov loopMax, ecx
	call Statement
	mov ecx, loopMax
	call Delay
	loop Run

Statement:
	mov edx, OFFSET message
	call WriteString
	call Crlf
	ret

theExit:
	call WaitMsg
	call Clrscr

exit
main ENDP
end main