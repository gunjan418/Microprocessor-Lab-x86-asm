;########################################################################################################################
;## Title:  Assembly program to read two number and display difference in cmd-prompt (SingleDigit)  using variables    ## 
;## Author: GunjanShuvro                                                                                               ##
;## Date:   25 May 2020                                                                                                ## 
;## Ripo:   https://github.com/dronegj                                                                                 ##
;########################################################################################################################

.model small
.stack 100h

.data
    msg1 db "Enter first number $"
    msg2 db "Enter second number: $"
    msg3 db "Difference btw two numbers: $"
    
    num1 db ?
    num2 db ?

.code
    main proc
      mov ax, @data             ;load data
      mov ds, ax

      lea dx, msg1              
      mov ah, 9
      int 21h                   ;display the msg1

      mov ah, 1                 
      int 21h                   ;read a single digit number

      sub al, 30h               ;convert decimal to ascii
      mov num1, al              ;save first number in num1

      mov ah, 2                 
      mov dl, 0dh
      int 21h                   ;cursor to begining

      mov dl, 0ah               
      int 21h                   ;new line

      lea dx, msg2              
      mov ah, 9
      int 21h                   ;display the msg2

      mov ah, 1                  
      int 21h                   ;read a single digit number

      sub al, 30h               ;convert decimal to ascii
      mov num2, al              ;save second digit in num2

      mov ah, 2                 
      mov dl, 0dh
      int 21h                   ;cursor to begining
      
      mov dl, 0ah               
      int 21h                   ;new line

      lea dx, msg3              
      mov ah, 9
      int 21h                   ;display the msg3
      
      mov bl, num1              
      mov bh, num2              ;load values for comparison
      
      cmp bl, bh                ;check if first number at num1 is larger
      jg diff                   ;if yes jump to difference
      
      xchg bl, bh               ;else exhange the values
      mov num1, bl
      mov num2, bh              ;store the values in order (Doing this extra step for showing the variable use)

diff:
      mov al, num1
      sub al, num2              ;do the actual substraction
      add al, 30h               ;convert ascii to decimal


      mov ah, 2                 
      mov dl, al     
      int 21h                   ;display the character

      mov ah, 4ch               ;return control to os
      int 21h
    main endp
end main