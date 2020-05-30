data segment
a db 1,2,5,6,4,8              ;array of numbers
data ends
    
code segment
      assume ds:data,cs:code
start:
      mov ax,data
      mov ds,ax
      mov cx,0000
      mov cl,06
      lea bx,a
      mov al,00
      mov ah,byte ptr[bx]
      
   l1:cmp al,byte ptr[bx]
      jnc l2
      
      mov al,byte ptr[bx]     ;store largest value at al
      
   l2:cmp ah,byte ptr[bx]
      jc l3               
      
      mov ah,byte ptr[bx]     ;store smallest value at ah
      
   l3:inc bx
      dec cl
      cmp cl,00
      jnz l1  
       
code ends 
end start
