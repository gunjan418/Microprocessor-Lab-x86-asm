;Program to display a string
;##################################################################
;## Title:  Assembly program to display a string in cmd-prompt   ## 
;## Author: GunjanShuvro                                         ##
;## Date:   25 May 2020                                          ## 
;## Ripo:   https://github.com/dronegj                           ##
;##################################################################

.model small
.stack 100h

.data
    str1 db "Welcome to dronegj github repo $"
    str2 db "This is a second string $"

.code
    main proc
        mov ax, @data       ;load data
        mov ds, ax

        lea dx, str1           
        mov ah, 9            
        int 21h             ;load & display the first string

        mov ah, 2            
        mov dl, 0dh
        int 21h             ;cursor to begining

        mov dl, 0ah          
        int 21h             ;new line

        lea dx, str2         
        mov ah, 9
        int 21h             ;load & display the second string

        mov ah, 4ch         
        int 21h
    main endp               ;return control to os
end main