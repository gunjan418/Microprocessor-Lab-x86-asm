include "emu8086.inc"
org 100h

    a dw ?
    b dw ?
    hcf dw ?
    lcm dw ?

    mov dx, offset msg
    mov ah, 9 
    int 21h                 ;print title

    mov dx, offset msg1    
    mov ah, 9
    int 21h                 ;ask first value

    call scan_num
    mov a, cx               ;store first value

    mov dx, offset msg2    
    mov ah, 9
    int 21h                 ;ask second value

    call scan_num
    mov b, cx               ;store second valu

	mov ax, a
	mov bx, b
	
aloop:
	cmp ax, bx              ;Compare 
	je hcfe                 ;Jump if equal
	jb exchange             ;Jump to exchange if bx is greater
		
	bloop:
		mov dx, 0
		div bx              ;Check if ax is divisible by bx
			
		cmp dx, 0   
		je hcfe             ;If no remainder, jump to end
			
		mov ax, dx          ;Else move the remainder to ax
			
		jmp aloop           ;Repeat
		
	exchange:
		mov cx, ax      
		mov ax, bx      
		mov bx, cx      
		jmp bloop
	
hcfe:
	mov hcf, bx
	mov ax, a
	mul b
	div bx
	mov lcm, ax             ;Calculate LCM = a * b / HCF
    
    ;output
    mov ax,hcf
    lea si, msg3
    call print_string
    call print_num          ;print HCF
    
    mov ax,lcm
    lea si, msg4
    call print_string
    call print_num          ;print LCM
                
    mov ah, 0
    int 16h                 ; wait for any key press to exit
        
ret                                

    msg db "Calculating HCF and LCM $"
    msg1 db 13,10, "Enter first value: $"
    msg2 db 13,10, "Enter second value: $"
    msg3 db 13,10, "HCF: ", 0 
    msg4 db 13,10, "LCM: ", 0 
    
define_scan_num
define_print_num
define_print_num_uns
define_print_string

end    