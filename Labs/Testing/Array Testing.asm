include Irvine32.inc

.data
myArrayB	BYTE	00h,01h,02h,03h,04h,05h,06h,07h,08h,09h
myArrayW	WORD	0000h,0001h,0002h,0003h,0004h,0005h,0006h,0007h,0008h,0009h
myArrayD	DWORD	00000001h,00000002h,00000003h,00000004h,00000005h,00000006h,00000007h,00000008h,00000009h

.code
Main PROC
mov ESI, 0
mov ECX, LENGTHOF myArrayD
Print:
	mov EAX, myArrayD[ESI]
	call WriteHex
	call Crlf
	add ESI, TYPE myArrayD
	loop Print
Main ENDP
END Main