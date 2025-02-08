include Irvine32.inc

.data
menu BYTE "Checking Account",0dh,0ah,0dh,0ah,
"1. Create a new account",0dh,0ah,
"2. Open an existing account",0dh,0ah,
"3. Credit the account",0dh,0ah,
"4. Debit the account",0dh,0ah,
"5. Exit",0ah,0ah,
"Choice> ",0

.code
main PROC
call Clrscr
mov edx, OFFSET menu
call WriteString
call Crlf
call WaitMsg
exit
main ENDP
END main