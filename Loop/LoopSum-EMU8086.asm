include "emu8086.inc"
org 100h

    range dw ?
    res dw ?


    mov dx, offset msg
    mov ah, 9 
    int 21h                 ;print title

    mov dx, offset msg1    
    mov ah, 9
    int 21h                 ;ask range

    call scan_num
    mov range, cx           ;store range

    mov res, 0              
    mov bx, 1

    jmp label

label:
    mov dx, offset msg2
    mov ah, 9
    int 21h                 ;print ask values

    call scan_num           ;get values

    add res, cx             ;add current input with result
    inc bx                  ;increment of bx
                        
    cmp range, bx           ;compare and substract bx from range
    jb exit                 ;jump if bx is below range

    jmp label               ;else jump to print result
       
exit:
    mov ax,res 
    lea si, msg3
    call print_string
    call print_num  
                
    mov ah, 0
    int 16h                 ; wait for any key press to exit
        
ret                                

    msg db "Addition in Loop $"
    msg1 db 13,10, "Enter Total No of Numbers: $"
    msg2 db 13,10, "Number to Add : $"
    msg3 db 13,10, "Total Sum: ", 0 
    
define_scan_num
define_print_num
define_print_num_uns
define_print_string                          