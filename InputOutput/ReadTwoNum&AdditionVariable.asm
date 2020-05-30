;#################################################################################################################
;## Title:  Assembly program to read two number and display sum in cmd-prompt (SingleDigit)  using variables    ## 
;## Author: GunjanShuvro                                                                                        ##
;## Date:   25 May 2020                                                                                         ## 
;## Ripo:   https://github.com/dronegj                                                                          ##
;#################################################################################################################

.model small
.stack 100h

.data
    msg1 db "Enter first number $"
    msg2 db "Enter second number: $"
    msg3 db "Sum of two numbers: $"
    
    num1 db ?
    num2 db ?

.code
    main proc
      mov ax, @data             ;load data
      mov ds, ax

      lea dx, msg1              ;display the msg1
      mov ah, 9
      int 21h

      mov ah, 1                 ;read a digit
      int 21h
      
      sub al, 30h               ;convert ascii to decimal 
      mov num1, al              ;save first number in num1

      mov ah, 2                 ;cursor to begining
      mov dl, 0dh
      int 21h

      mov dl, 0ah               ;new line
      int 21h

      lea dx, msg2              ;display the msg2
      mov ah, 9
      int 21h

      mov ah, 1                 ;read a character
      int 21h

      sub al, 30h               ;convert ascii to decimal
      mov num2, al              ;save second number in num2

      mov ah, 2                 ;cursor to begining
      mov dl, 0dh
      int 21h

      mov dl, 0ah               ;new line
      int 21h

      lea dx, msg3              ;display the msg3
      mov ah, 9
      int 21h

      mov al, num1
      add al, num2              ;add first and second variable
      
      add al, 30h               ;convert ascii to decimal

      mov ah, 2                 ;display the character
      mov dl, al     
      int 21h

      mov ah, 4ch               ;return control to os
      int 21h
    main endp
end main