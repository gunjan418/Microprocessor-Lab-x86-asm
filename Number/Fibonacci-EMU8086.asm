include "emu8086.inc"
org 100h

    lim dw ?

    mov dx, offset msg
    mov ah, 9 
    int 21h                 ;print title

    mov dx, offset msg1    
    mov ah, 9
    int 21h
    call scan_num           ;get lim in cx

    mov CX, CX              ;store cx again cx to solve unwanted char
    mov BH, 01h
	mov DH, 01h
	mov DL, 00h             ;clear DL to solve unwanted char
	
	lea si, msg2
    call print_string       ;print series message
	
fibLoop:                    ;30h for ascii zero
		or DL, 30h
		mov AH, 02h
		int 21h             ;print series chars
		
		mov DL, DH
		mov DH, BH
		    
		push DX
	        mov AL, DL
	        mov AH, DH
	        add AH, AL
	        mov BH, AH 
	    pop DX
	    
loop fibLoop       

                
    mov ah, 0
    int 16h                 ; wait for any key press to exit
        
ret                                

    msg db "Fibonacci Series (Single Digit)$"
    msg1 db 13,10, "Enter limit(1-7): $"
    msg2 db 13,10, "Series : ", 0    
    
define_scan_num
define_print_num
define_print_num_uns
define_print_string

end                 