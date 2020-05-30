include "emu8086.inc"
org 100h
           
    num dw ?  
                   
    mov dx, offset msg
    mov ah, 9 
    int 21h                 ;print title  
                       
    mov dx, offset msg1
    mov ah, 9 
    int 21h                 ;ask for number
    
    call scan_num
    mov num, cx             ;store to num

    mov bx, 1
    mov ax, 1 
    jmp cal

cal:
    mul bx                  ;multiply bx with ax
    inc bx                  ;increment bx
    cmp bx,num              ;compare bx with num
    ja exit                 ;jump if num is above bx
    jmp cal
    
exit:
    lea si, msg2
    call print_string
    call print_num  
    ret               

    mov ah, 0
    int 16h                 ; wait for any key press
        
ret 

msg db "Factorial Calculator $"
msg1 db 13,10, "Enter Number: $"
msg2 db 13,10, "Factorial: ", 0

define_scan_num
define_print_num
define_print_num_uns
define_print_string    

end