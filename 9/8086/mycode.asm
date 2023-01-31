
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

dseg    segment     'data'
    
        input   db  100 dup(13) 
        digits  dw  100 dup(0)
            
dseg    ends  

sseg    segment stack   'stack'    
words       dw  100h dup(?)
sseg    ends
            
            
            
cseg    segment     'code'
    
start   proc   
    
        ; set seg-registers
        push    ds
        mov     ax, dseg
        mov     ds, ax
        mov     es, ax
        call    get_input  
        call    nxt_line
        call    counter   
        mov     ax,cx
        mov     ah,0
        call    print_num
        call    nxt_line  
        call    sort
        call    final_print
        
        hlt
start   endp

; read char into al
read_char   proc    near
            mov     ah, 01h
            int     21h
            ret
read_char   endp


get_input   proc
            
            push    si
            mov     si,0
                
loop1:
            call    read_char
            mov     input[si],al 
            inc     si
            cmp     input[si-1],0dh
            je      end
            jmp     loop1
end:
            pop     si
            ret 
            
get_input   endp 
    
    
    
; go to next line in terminal
nxt_line    proc    near
            push ax
            mov ah, 0Eh
            mov al, 0Dh
            int 10h
            mov al, 0Ah
            int 10h   
            pop ax
            ret
nxt_line    endp
    
    
     
counter     proc 
    
            push    si 
            push    bx
            push    di 
            
            mov     di,0
            mov     bx,0        
            mov     si,0
            mov     cx,0 
            mov     dx,0 
            mov     ax,0
loop2:    
            
            cmp     input[si],0dh
            je      end1
            cmp     input[si],'(' 
            je      move
            cmp     input[si],')' 
            je      increment  
            cmp     input[si],0
            je      increment
            
            
            
            
loop3:      
            cmp     input[bx],0dh
            je      increment
            cmp     input[bx],0
            je      increment1
            cmp     input[bx],'('
            je      increment1
            cmp     input[bx],')' 
            je      index 
            inc     bx 
            jmp     loop3
            
    
    
index:              
            inc     si
            mov     digits[di],si 
            inc     cx
            inc     di 
            inc     bx
            mov     digits[di],bx 
            mov     input[bx-1],0
            inc     cx 
            inc     di
             
            jmp     loop2 
move:
            mov     bx,si
            jmp     loop3
           
            
increment:       
            inc     si
            jmp     loop2 
            
increment1:       
            inc     bx
            jmp     loop3         
end1:       
            
            pop     di
            pop     bx
            pop     si
            ret
    
counter     endp     



; print char in dl
write_char  proc    near
            push    ax
            mov     ah, 02h
            int     21h
            pop     ax
            ret
write_char  endp   



; prints integer in ax
print_num   proc    near
        push    ax
        push    dx
    
        cmp     ax, 0
        jl      negative
        jg      positive
        
        mov     dl, '0'
        call    write_char
        jmp     done_pn

negative:
        neg     ax
        
        mov     dl, '-'
        call    write_char
positive:
        call    print_pos
done_pn:
        pop     dx
        pop     ax
        ret
print_num   endp



; prints positive number in ax
; after printing, ax=0
print_pos   proc    near
        push    bx
        push    cx
        push    dx
                     
        ; number of digits
        mov     cx, 0
        mov     bx, 10
extract:
        ; ax = dx:ax / bx (dx=remainder)
        mov     dx, 0
        div     bx
        ; push digit to stack to print later
        push    dx
        inc     cx
        
        cmp     ax, 0
        jnz     extract
print:
        dec     cx
        pop     dx
        add     dx, 30h     ; convert to ascii
        call    write_char
        
        cmp     cx, 0
        jnz     print
done_pp:
        pop     dx
        pop     cx
        pop     bx
        ret        
print_pos   endp 



sort        proc

            
            mov ch,al
 
up2:        mov cl,al
            lea si,digits
 
up1:        mov al,[si]
            mov bl,[si+1]
            cmp al,bl
            jc  down
            mov dl,[si+1]
            xchg [si],dl
            mov [si+1],dl
 
down:       inc si
            dec cl
            jnz up1
            dec ch
            jnz up2    
            
            ret     
sort        endp  



final_print   proc
    
            mov     si,0
loopp:            
            cmp     si,100
            je      printEnd
            mov     ax,digits[si]
            mov     ah,0   
            cmp     ax,0
            jne     pr1
            inc     si 
            jmp     loopp
            
            
pr1:        
            call    print_num
            mov     dl,' '
            call    write_char
            inc     si   
            jmp     loopp
            
printEnd:
            ret
            
final_print   endp
            

        hlt
cseg    ends
        end     start


