include "emu8086.inc"
org 100h
                
    num dw ?
    
    mov dx, offset msg
    mov ah, 9 
    int 21h                 ;print title
                                         
    mov dx, offset msg1    
    mov ah, 9
    int 21h                 ;ask number
    
    call scan_num
    mov num, cx
                                         
	mov ax, num
	and ax, 1
	xor ax, 1
	
	jz oddcheck
	
evencheck:
	lea si, msg2
	call print_string
	jmp exit
	
oddcheck:
	lea si, msg3
	call print_string	

exit:               
    mov ah, 0
    int 16h                 ; wait for any key press:    
ret                                

    msg db "Check Number Even/Odd $"
    msg1 db 13,10, "Enter your Number: $"
    msg2 db 13,10, "Number is Even. ", 0
    msg3 db 13,10, "Number is Odd. ", 0  

define_scan_num
define_print_num
define_print_num_uns
define_print_string

end                   