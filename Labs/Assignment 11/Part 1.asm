; Author: Jeremey Larter
; Lab Assignment #11 (Procedure Parameters)
; Purpose: To demonstrate procedure parameters using the push and pop operations as well as the ESP and EBP registers.
include Irvine32.inc

.data
; Memory allocations.
prompt		BYTE	"Which procedure do you wish to see?", 0
program1	BYTE	"addTwoV1 Procedure", 0
value1		BYTE	"value 1 : ", 0
value2		BYTE	"value 2 : ", 0
eaxValue	BYTE	"eax     : ", 0
program2	BYTE	"addTwoV2 Procedure", 0
resultMes	BYTE	"result  : ", 0
result		DWORD	?
program3	BYTE	"loadArray Procedure", 0
loadedVal	BYTE	"Value to be loaded    : ", 0
arrayLen	BYTE	"Length of the array   : ", 0
listBefore	BYTE	"List before: ", 0
listAfter	BYTE	"List after : ", 0
program4	BYTE	"loadArrayRange Procedure", 0
startLoc	BYTE	"Start location        : ", 0
endLoc		BYTE	"End location          : ", 0
program5	BYTE	"loadArrayGeneral Procedure", 0
arrayType	BYTE	"Type of the array     : ", 0
offsetDump	BYTE	"Dump of offset ", 0
dashes		BYTE	26 dup('-'), 0
arrowPos	BYTE	2
list		DWORD	10 dup(0)

.code
; Contains the menu for selecting a procedure.
Main PROC
	call Clrscr
	mov EDX, OFFSET prompt
	call WriteString
	mov DH, arrowPos
	mov DL, 0
	call Gotoxy
	mov AL, 62 ; ASCII code of right arrow.
	call WriteChar
	mov DH, 2
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET program1
	call WriteString
	mov DH, 3
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET program2
	call WriteString
	mov DH, 4
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET program3
	call WriteString
	mov DH, 5
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET program4
	call WriteString
	mov DH, 6
	mov DL, 4
	call Gotoxy
	mov EDX, OFFSET program5
	call WriteString
Cursor:
	mov DH, arrowPos
	mov DL, 0
	call Gotoxy
	mov EAX, 50
	call Delay
	push EDX
	call ReadKey
	pop EDX
	cmp AH, 50h ; Virtual-scan code for DOWN key.
	je Down
	cmp AH, 48h ; Virtual-scan code for UP key.
	je Up
	cmp AH, 1Ch ; Virtual-scan code for ENTER key.
	je GoToProc
	jmp Cursor
Down:
	cmp DH, 6
	jne SetArrowD
	mov arrowPos, 2
	jmp Main
SetArrowD:
	inc DH
	mov arrowPos, DH
	jmp Main
Up:
	cmp DH, 2
	jne SetArrowU
	mov arrowPos, 6
	jmp Main
SetArrowU:
	dec DH
	mov arrowPos, DH
	jmp Main
GoToProc:
	call Clrscr
	cmp DH, 2
	jne FirstSkip
	push 7 ; y
	push 12 ; x
	call addTwoV1
	call printSumV1
	add ESP, 8
	jmp Done
FirstSkip:
	cmp DH, 3
	jne SecondSkip
	push OFFSET result ; z
	push 5 ; y
	push 9 ; x
	call addTwoV2
	call printSumV2
	add ESP, 12
	jmp Done
SecondSkip:
	cmp DH, 4
	jne ThirdSkip
	push 4 ; z
	push 10 ; y
	push OFFSET list ; x
	call loadArray
	call printArray
	add ESP, 12
	jmp Done
ThirdSkip:
	cmp DH, 5
	jne FourthSkip
	push 9 ; w
	push 4 ; z
	push 2 ; y
	push OFFSET list ; x
	call loadArrayRange
	call printArrayRange
	add ESP, 16
	jmp Done
FourthSkip:
	push 7 ; w
	push 2 ; z
	push 10 ; y
	push OFFSET list ; x
	call loadArrayGeneral
	call printArrayGeneral
	add ESP, 16
Done: 
	exit
Main ENDP

; Expects two parameters of type DWORD in the stack and returns the sum in the EAX register. Uses C calling convention.
addTwoV1 PROC
	push EBP
	mov EBP, ESP
	mov EAX, [EBP + 8] ; x
	add EAX, [EBP + 12] ; y
	pop EBP
	ret
addTwoV1 ENDP

; Expects two parameters of type DWORD in the stack and prints out the sum of the two. Uses C calling convention.
printSumV1 PROC
	push EBP
	mov EBP, ESP
	push EDX
	mov EDX, OFFSET program1
	call WriteString
	call Crlf
	mov EDX, OFFSET value1
	call WriteString
	push EAX
	mov EAX, [EBP + 8]
	call WriteDec
	call Crlf
	mov EDX, OFFSET value2
	call WriteString
	mov EAX, [EBP + 12]
	call WriteDec
	call Crlf
	pop EAX
	mov EDX, OFFSET eaxValue
	call WriteString
	call WriteDec
	call Crlf
	pop EDX
	pop EBP
	ret
printSumV1 ENDP

; Expects three parameters of type DWORD in the stack and returns the sum in the memory location of the third parameter. Uses STD calling convention.
addTwoV2 PROC
	push EBP
	mov EBP, ESP
	push EAX
	push EBX
	mov EAX, [EBP + 8] ; x
	add EAX, [EBP + 12] ; y
	mov EBX, [EBP + 16]
	mov [EBX], EAX ; z
	pop EBX
	pop EAX
	pop EBP
	ret
addTwoV2 ENDP

; Expects three parameters of type 
printSumV2 PROC
	push EBP
	mov EBP, ESP
	push EDX
	mov EDX, OFFSET program2
	call WriteString
	call Crlf
	mov EDX, OFFSET value1
	call WriteString
	push EAX
	mov EAX, [EBP + 8]
	call WriteDec
	call Crlf
	mov EDX, OFFSET value2
	call WriteString
	mov EAX, [EBP + 12]
	call WriteDec
	call Crlf
	mov EDX, OFFSET resultMes
	call WriteString
	mov EAX, result
	call WriteDec
	call Crlf
	pop EAX
	pop EDX
	pop EBP
	ret
printSumV2 ENDP

; Expects three parameters of type DWORD (array, imm32, imm32) and returns the modified array in the memory location of the first parameter. Uses C calling convention.
loadArray PROC
	push EBP
	mov EBP, ESP
	push EAX
	mov EAX, [EBP + 16] ; z
	push ESI
	mov ESI, [EBP + 8] ; x
	push ECX
	mov ECX, [EBP + 12] ; y
Fill:
	mov [ESI], EAX
	add ESI, 4
	loop Fill
	pop ECX
	pop ESI
	pop EAX
	pop EBP
	ret
loadArray ENDP

; Expects three parameters of type DWORD (array, imm32, imm32) and prints out the array. Uses C calling convention.
printArray PROC
	push EBP
	mov EBP, ESP
	push EDX
	mov EDX, OFFSET program3
	call WriteString
	call Crlf
	mov EDX, OFFSET loadedVal
	call WriteString
	push EAX
	mov EAX, [EBP + 16]
	call WriteDec
	call Crlf
	mov EDX, OFFSET arrayLen
	call WriteString
	mov EAX, [EBP + 12]
	call WriteDec
	call Crlf
	call Crlf
	mov EDX, OFFSET listBefore
	call WriteString
	push ESI
	mov ESI, [EBP + 8] ; x
	push ECX
	mov ECX, EAX ; y
Before:
	mov EAX, 0
	call WriteDec
	mov AL, 32
	call WriteChar
	loop Before
	call Crlf
	mov EDX, OFFSET listAfter
	call WriteString
	mov ECX, [EBP + 12]
After:
	mov EAX, [ESI]
	call WriteDec
	mov AL, 32
	call WriteChar
	add ESI, 4
	loop After
	call Crlf
	pop ECX
	pop ESI
	pop EAX
	pop EDX
	pop EBP
	ret
printArray ENDP

; Expects four parameters of type DWORD (array, imm32, imm32, imm32) and returns the modified array in the memory location of the first parameter. Uses C calling convention.
loadArrayRange PROC
	push EBP
	mov EBP, ESP
	push EAX
	mov EAX, [EBP + 12] ; y
	push ESI
	mov ESI, [EBP + 8] ; x
	push EBX
	mov EBX, [EBP + 16] ; z
	shl EBX, 2 ; Multiply EBX by 4
	add ESI, EBX
	push ECX
	mov ECX, [EBP + 20] ; w
	sub ECX, [EBP + 16] ; z
	inc ECX
Fill:
	mov [ESI], EAX
	add ESI, 4
	loop Fill
	pop ECX
	pop EBX
	pop ESI
	pop EAX
	pop EBP
	ret
loadArrayRange ENDP

; Expects four parameters of type DWORD (array, imm32, imm32, imm32) and prints out the array. Uses C calling convention.
printArrayRange PROC
	push EBP
	mov EBP, ESP
	push EDX
	mov EDX, OFFSET program4
	call WriteString
	call Crlf
	mov EDX, OFFSET loadedVal
	call WriteString
	push EAX
	mov EAX, [EBP + 12]
	call WriteDec
	call Crlf
	mov EDX, OFFSET startLoc
	call WriteString
	mov EAX, [EBP + 16]
	call WriteDec
	call Crlf
	mov EDX, OFFSET endLoc
	call WriteString
	mov EAX, [EBP + 20]
	call WriteDec
	call Crlf
	call Crlf
	mov EDX, OFFSET listBefore
	call WriteString
	push ECX
	mov ECX, EAX ; w
	inc ECX
Before:
	mov EAX, 0
	call WriteDec
	mov AL, 32
	call WriteChar
	loop Before
	call Crlf
	mov EDX, OFFSET listAfter
	call WriteString
	push ESI
	mov ESI, [EBP + 8] ; x
	mov ECX, [EBP + 20]
	inc ECX
After:
	mov EAX, [ESI]
	call WriteDec
	mov AL, 32
	call WriteChar
	add ESI, 4
	loop After
	call Crlf
	pop ESI
	pop ECX
	pop EAX
	pop EDX
	pop EBP
	ret
printArrayRange ENDP

; Expects four parameters of type DWORD (array, imm32, imm32, imm32) and returns the modified array in the memory location of the first parameter. Uses C calling convention.
loadArrayGeneral PROC
	push EBP
	mov EBP, ESP
	push EBX
	mov EBX, [EBP + 16] ; z
	cmp EBX, 1
	jne WordArray
	jmp Done
WordArray:
	cmp EBX, 2
	jne DwordArray
	jmp Done
DwordArray:
	mov EBX, 4
Done:
	push EAX
	mov EAX, [EBP + 20] ; w
	push ESI
	mov ESI, [EBP + 8] ; x
	push ECX
	mov ECX, [EBP + 12] ; y
Fill:
	cmp EBX, 1
	jne WordEntry
	mov [ESI], AL
	jmp Continue
WordEntry:
	cmp EBX, 2
	jne DwordEntry
	mov [ESI], AX
	jmp Continue
DwordEntry:
	mov [ESI], EAX
Continue:
	add ESI, EBX
	loop Fill
	pop ECX
	pop ESI
	pop EAX
	pop EBX
	pop EBP
	ret
loadArrayGeneral ENDP

printArrayGeneral PROC
	push EBP
	mov EBP, ESP
	push EDX
	mov EDX, OFFSET program5
	call WriteString
	call Crlf
	mov EDX, OFFSET loadedVal
	call WriteString
	push EAX
	mov EAX, [EBP + 20]
	call WriteDec
	call Crlf
	mov EDX, OFFSET arrayLen
	call WriteString
	mov EAX, [EBP + 12]
	call WriteDec
	call Crlf
	mov EDX, OFFSET arrayType
	call WriteString
	mov EAX, [EBP + 16]
	call WriteDec
	call Crlf
	call Crlf
	mov EDX, OFFSET listBefore
	call WriteString
	call Crlf
	call Crlf
	mov EDX, OFFSET offsetDump
	call WriteString
	mov EAX, [EBP + 8]
	call WriteDec
	call Crlf
	mov EDX, OFFSET dashes
	call WriteString
	call Crlf
	push EBX
	push ECX
	mov ECX, [EBP + 12]
Before:
	mov EAX, 0
	mov EBX, 2
	call WriteHexB
	mov AL, 32
	call WriteChar
	loop Before	
	call Crlf
	call Crlf
	mov EDX, OFFSET listAfter
	call WriteString
	call Crlf
	call Crlf
	mov EDX, OFFSET offsetDump
	call WriteString
	mov EAX, [EBP + 8]
	call WriteDec
	call Crlf
	mov EDX, OFFSET dashes
	call WriteString
	call Crlf
	mov EBX, [EBP + 16] ; z
	cmp EBX, 1
	jne WordArray
	jmp Done
WordArray:
	cmp EBX, 2
	jne DwordArray
	jmp Done
DwordArray:
	mov EBX, 4
Done:
	push ESI
	mov ESI, [EBP + 8]
	mov ECX, [EBP + 12]
After:
	cmp EBX, 4
	jne WordElement
	mov EAX, [ESI]
	jmp Continue
WordElement:
	cmp EBX, 2
	jne ByteElement
	movsx EAX, WORD PTR [ESI]
	jmp Continue
ByteElement:
	movsx EAX, BYTE PTR [ESI]
Continue:
	push EBX
	mov EBX, 2
	call WriteHexB
	pop EBX
	mov AL, 32
	call WriteChar
	add ESI, EBX
	loop After
	call Crlf
	pop ESI
	pop ECX
	pop EBX
	pop EAX
	pop EDX
	pop EBP
	ret
printArrayGeneral ENDP
	
END Main