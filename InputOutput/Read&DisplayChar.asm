;#################################################################################
;## Title:  Assembly program to read a character and display from cmd-prompt    ## 
;## Author: GunjanShuvro                                                        ##
;## Date:   25 May 2020                                                         ## 
;## Ripo:   https://github.com/dronegj                                          ##
;#################################################################################

.model small
.stack 100h 

.code
   main proc
	 mov ah, 1					  
	 int 21h                      ;read a character

	 mov bl, al					  ;store input character into bl

	 mov ah, 2					  
	 mov dl, 0dh		  
	 int 21h                      ;cursor to begining

	 mov dl, 0ah				  
	 int 21h                      ;new line

	 mov ah, 2					    
	 mov dl, bl
	 int 21h                      ;display the character stored in bl 

	 mov ah, 4ch				  
	 int 21h                      ;return control to os

   main endp
end main