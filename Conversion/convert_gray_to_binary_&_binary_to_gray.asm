.data

msg1    db 10, 13,"< 0 >Binary to Gray or < 1 >Gray to Binary:","$"
msg2    db 10, 13,"Enter the binary number< 5 bit > to convert to grey:","$"
msg3    db 10, 13,"Enter the grey number < 5 bit > to convert to binary:","$"
msg4    db 10, 13,"Grey number < 5 bit > equivalent:","$" 
msg5    db 10, 13,"Binary number < 5 bit > equivalent:","$"   
b       db 5 dup(?)
g       db 5 dup(?)


.code
start:

mov ax, @data
mov ds, ax 

lea dx, msg1
call display_s 


mov ah, 1h
int 21h
sub al, 30h

cmp al, 0h

jnz graytobinary ;equal 1 or <> 0

jmp binarytogrey  




;lea si, d_i
;mov ah, 1h
;int 21h
;sub al, 30h
;mov [si],al




jmp quit  

ret 

binarytogrey:
    lea dx, msg2
    call display_s 
    
    mov di, offset b ;dup len 5 hold binary value   
    
    mov cx, 5
    
    
    get_char:
        mov ah, 1h
        int 21h
        sub al, 30h ; ascii to dec
        mov [di],al
        inc di 
        ;ret
    loop get_char 
    
    ;output grey
    mov si, offset b 
    mov di, offset g 
    call calculate_g_bits
 
ret 

graytobinary:
    lea dx, msg3
    call display_s    
    
    mov di, offset g ;dup len 5 hold grey value
    
    
    ;push di
    ;call get_chars
    ;pop di
    
    mov cx, 5
    
    
    get_g_char:
        mov ah, 1h
        int 21h
        sub al, 30h ; ascii to dec
        mov [di],al
        inc di 
        ;ret
    loop get_g_char 
    
    ;get binary
    mov si, offset g 
    mov di, offset b 
    call calculate_b_bits   

ret       


calculate_g_bits proc 
    
    mov cx, 5   
    
    convert_bits: 
        cmp cx, 5
        
        je set_term1
        
        pop ax  
        
         
        xor al, [si] 
        mov [di], al  
        
        mov al, [si]
        xor ah,ah
        
   
        push ax 
        
        inc si              
        inc di  
        
    loop convert_bits  
    
    lea dx, msg4
    call display_s 
    
    mov si, offset g
    mov cx,5   
    
    show_bits:
        mov ah,2h
        mov dl,[si]
        add dl, 30h   
        xor dh,dh
        int 21h
        inc si
    loop show_bits
    
    ;output to ppi
        
    jmp quit     
    
    set_term1:  
            mov al, [si]
            mov dl, al 
            xor ah, ah  
            
            mov [di], dl
             
            push ax 
            
            inc di
            inc si 
            
            sub cx,1
            jmp convert_bits
            
    
calculate_g_bits endp 



calculate_b_bits proc 
    
    mov cx, 5
    convert_g_bits: 
        cmp cx, 5
        
        je set_b_term1
        
        pop dx  
        
         
        xor dl, [si] 
        mov [di], dl  
        push dx 
        
        inc si              
        inc di  
        
    loop convert_g_bits  
    
    lea dx, msg5
    call display_s 
    
    mov si, offset b
    mov cx,5   
    
    show_b_bits:
        mov ah,2h
        mov dl,[si]
        add dl, 30h   
        xor dh,dh
        int 21h
        inc si
    loop show_b_bits
    
    ;output to ppi
        
    jmp quit     
    
    set_b_term1:  
            mov al, [si]
            mov dl, al 
            xor dh, dh
            mov [di], dl 
            push dx 
            inc si
            inc di 
            sub cx,1
            jmp convert_g_bits
            
    
calculate_b_bits endp
          


display_s proc
    mov ah,9h
    int 21h
ret        
    
display_s endp


quit:
    mov ah, 4ch
    int 21h

end start