;#################################################################################################################################
;## Title:  Program to find the Square and Cube of a Number                                                                     ## 
;## Author: GunjanShuvro                                                                                                        ##
;## Date:   26 May 2020                                                                                                         ## 
;## Repo:   https://github.com/dronegj                                                                                          ##
;#################################################################################################################################

.model  small 

.data
        a db 5

.code
    main proc
        
        mov ax,@data
        mov ds,ax
        
        mov ah,00
        mov al,a
        mul a
        mov bl,al       ;store square value at bl
        
        mul word ptr a
        mov bh,al       ;store cubic value at bh 
        
    main endp  
    
end main