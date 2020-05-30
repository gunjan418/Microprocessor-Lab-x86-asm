;#################################################################################################################################
;## Title:  Program to Check Whether the Input is Prime or Not                                                                  ## 
;## Author: GunjanShuvro                                                                                                        ##
;## Date:   24 May 2020                                                                                                         ## 
;## Repo:   https://github.com/dronegj                                                                                          ##
;#################################################################################################################################

.model  small
.data
    val1 db ?
    nl1 db "Enter No to check: $"
    nl2 db 0ah,0dh,"It is not a Prime $"
    nl3 db 0ah,0dh,"It is a Prime $"

.code
    
    main proc

        mov ax,@data
        mov ds,ax

        lea dx,nl1
        mov ah,09h
        int 21h

        mov ah,01h
        int 21h
        sub al,30h
        mov val1,al

        mov ah,00

        mov cl,2
        div cl
        mov cl,al

    lbl1:
        mov ah,00
        mov al,val1
        div cl
        cmp ah,00
        jz lbl2
        dec cl
        cmp cl,1
        jne lbl1
        jmp lbl3

    lbl2:

        mov ah,09h
        lea dx,nl2
        int 21h
        jmp exit    

    lbl3:
        mov ah,09h
        lea dx,nl3
        int 21h

    exit:
        mov ah,4ch
        int 21h

    main endp
    
end main