;########################################################################################################################################
;## Title:  Assembly program to read two number and display difference in cmd-prompt (SingleDigit) directly without using variables    ## 
;## Author: GunjanShuvro                                                                                                               ##
;## Date:   25 May 2020                                                                                                                ## 
;## Ripo:   https://github.com/dronegj                                                                                                 ##
;########################################################################################################################################

.model small
.stack 100h

.data
    msg1 db "Enter first number $"
    msg2 db "Enter second number: $"
    msg3 db "Difference btw two numbers: $"

.code
    main proc
      mov ax, @data             ;load data
      mov ds, ax

      lea dx, msg1              
      mov ah, 9
      int 21h                   ;display the msg1

      mov ah, 1                 
      int 21h                   ;read a single digit number

      mov bl, al                ;save first digit in bl
      sub bl, 30h               ;convert decimal to ascii

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

      mov bh, al                ;save second digit in bh
      sub bh, 30h               ;convert decimal to ascii

      mov ah, 2                 
      mov dl, 0dh
      int 21h                   ;cursor to begining

      mov dl, 0ah               
      int 21h                   ;new line

      lea dx, msg3              
      mov ah, 9
      int 21h                   ;display the msg3
      
      cmp bl, bh                ;check if first number at bl is larger
      jg diff                   ;if yes jump to substraction
      
      xchg bl, bh               ;else exhange the values

diff:
      sub bl, bh                ;sub first and second digit
      add bl, 30h               ;convert ascii to decimal


      mov ah, 2                 ;display the character
      mov dl, bl     
      int 21h

      mov ah, 4ch               ;return control to os
      int 21h
    main endp
end main