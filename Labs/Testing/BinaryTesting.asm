include Irvine32.inc

.data
binaryUnsigned	BYTE	00101101b
binarySigned	BYTE	-00101101b

.code
main PROC
	mov EBX, 1
	movzx EAX, binarySigned
	call WriteBinB
	call Crlf
	call WriteChar
	call Crlf
	call WriteInt
	call Crlf
	call WriteHexB
	call Crlf
	call WaitMsg
	exit
main ENDP
END main