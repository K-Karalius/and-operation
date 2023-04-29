.model small

.stack 100h

.data

    f1Name db 255 dup (?)
    f1handle dw 0
     
    f2Name db 255 dup (?) 
    f2Handle dw 0
    
    outputFile db 255 dup (?)
    outputHandle dw 0
    
    binary1 db 255 dup ('2')
    binary2 db 255 dup ('2')
    result db 255 dup(?)
	biLength dw 0

    
    msg_formatError db "Wrong format of paramaters of file names", 13, 10, '$'
    msg_correctFormat db "Correct format: example.exe data1.txt data2.txt output.txt", 13, 10, '$'
    msg_failedToOpenData db "Failed to open data files!", 13, 10, '$'
    msg_failedToCloseData db "Failed to close data files!", 13, 10, '$'
    msg_failedToRead db "Failed to read data files!", 13, 10, '$'
    msg_failedToOpenOut db "Failed to open output file!", 13, 10, '$'
    msg_failedToCloseOut db "Failed to close output file!", 13, 10, '$'
    msg_failedToWrite db "Failed to write to output file!", 13, 10, '$'
    msg_failedToCreateFile db "Could not create an output file!", 13, 10, '$' 
    

.code
start:
    
	mov	ax, @data                                                                                                       
	mov	ds, ax			
	
	call FileNames
	call OpenDataFiles
	call ReadDataFiles     
	call CreateFile 
	call OpenOutputFile
	  
    call CalcAndWriteToFile
	
	        
	mov	ah, 4Ch
	mov al, 0
	int	21h

	
	
FileNames PROC
    
    mov si, 82h
     
    lea bx, f1Name
    file1:
    mov cl, es:[si]
    cmp cl, 20h
    je file1End
    cmp cl, 13
    je formatError
    mov [bx], cl
    inc bx 
    inc si
    jmp file1
      
    
    file1End:
    lea bx, f2Name
    inc si    
    
    file2:
    mov cl, es:[si]
    cmp cl, 20h
    je file2End
    cmp cl, 13
    je formatError
    mov [bx], cl
    inc bx 
    inc si
    jmp file2
    
    
    file2End:
    lea bx, outputFile
    inc si
     
    file3:
    mov cl, es:[si]
    cmp cl, 13
    je file3End
    mov [bx], cl
    inc bx 
    inc si
    jmp file3
       
    file3End:
                  
    ret
       
    
    formatError: 
    mov ah, 9
    lea dx, msg_formatError
    int 21h
    
    lea dx, msg_correctFormat
    int 21h
    
    mov	ah, 4Ch			
	int	21h
    
FileNames ENDP		

OpenDataFiles PROC
    mov al, 0
    lea dx, f1Name
    mov ah, 3Dh
    int 21h 
    
    jc openingError
    mov f1Handle, ax
    
    
    mov al, 0
    lea dx, f2Name
    mov ah, 3Dh
    int 21h
    
    jc openingError 
    mov f2Handle, ax
    
        
    ret
    
    openingError:
    
    mov ah, 9
    lea dx, msg_failedToOpenData
    int 21h
    
    mov	ah, 4Ch			
	int	21h
    
OpenDataFiles ENDP


ReadDataFiles PROC
    
    mov ah, 3Fh
	mov cx, 255
	lea dx, binary1
	mov bx, f1Handle
	int 21h
	jc readError
	
	mov ah, 3Fh
	mov cx, 255
	lea dx, binary2
	mov bx, f2Handle
	int 21h
    jc readError
	
	lea bx, biLength
	mov [bx], ax
	
	
    
    mov ah, 3Eh
    mov bx, f1Handle
    int 21h
    jc dataClosingError
    
    mov ah, 3Eh
    mov bx, f2Handle
    int 21h
    jc dataClosingError 
       
    ret
    
    dataClosingError:
    mov ah, 9
    lea dx, msg_failedToCloseData
    int 21h
    
    mov	ah, 4Ch			
	int	21h
	
	readError:
	mov ah, 9
	lea dx, msg_failedToRead
	int 21h
	
	mov	ah, 4Ch			
	int	21h
	
       
ReadDataFiles ENDP 

CreateFile PROC
    mov ah, 3Ch
    mov cx, 0
    lea dx, outputFile
    int 21h
    jc creatingError
    
    mov outputHandle, ax                
    
    ret 
    
    creatingError:  
    mov ah, 9
    lea dx, msg_failedToCreateFile 
    int 21h
    
    mov	ah, 4Ch			
	int	21h 

CreateFile ENDP

OpenOutputFile PROC
    
    mov ah, 3Dh
	mov al, 1
	lea dx, outputFile
	int 21h
	jc openingOutputError
    
    ret
    
    openingOutputError: 
    mov ah, 9
    lea dx, msg_failedToOpenOut
    int 21h
    
    mov	ah, 4Ch			
	int	21h
    
OpenOutputFile ENDP

CalcAndWriteToFile PROC
    
    ;mov si, 0
	;biLengthCalc:
	;cmp binary1[si], '0' 
	;je equalZero
	;cmp binary1[si], '1'
	;je equalOne
	;jmp endBi
	
	;equalZero:
	;inc si
	;jmp biLengthCalc
	
	;equalOne:
	;inc si
	;jmp biLengthCalc
	
	
	;endBi:
	
	
	
	mov si, biLength
    mov di, 0
    resultCalc:
    cmp si, di
    je calcFinished
    mov ah, binary1[di]
    mov al, binary2[di]
    and ah, al
    mov result[di], ah
    inc di            
    jmp resultCalc
    
    
    calcFinished:
   	
	push ax
	push dx
	mov ax, biLength
	mov ah, 2
	mov dl, al
	add dl, 30h
	int 21h
	pop dx
	pop ax
	
    mov ah, 40h
	mov cx, biLength
	mov bx, outputHandle
	lea dx, result
	int 21h
	jc writingError
	
    mov ah, 3Eh
    mov bx, outputHandle
    int 21h
    jc outputClosingError
    
    ret 
    
    writingError:
    mov ah, 9
    lea dx, msg_failedToWrite 
    int 21h
    
    mov	ah, 4Ch			
	int	21h
    
    outputClosingError:
    mov ah, 9
    lea dx, msg_failedToCloseOut
    int 21h
    
    mov	ah, 4Ch			
	int	21h
        
    
CalcAndWriteToFile ENDP
		
end start

