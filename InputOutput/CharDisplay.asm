;#########################################################
;## Title:  Assembly program to display a character     ## 
;## Author: GunjanShuvro                                ##
;## Date:   25 May 2020                                 ## 
;## Ripo:   https://github.com/dronegj                  ##
;#########################################################

.model small
.stack 100h

.code
   main proc
	 mov ah, 2			
	 mov dl, "A"
	 int 21h            ;display the character A

	 mov ah, 4ch		
	 int 21h            ;return control to os
   main endp
end main