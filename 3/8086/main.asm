

dseg segment 'data' 
    
    num                 dw  ?
    anknown_matrix      dw  num dup(num dup(?))
    difinite_matrix     dw  num dup(num dup(?))
    triangu_matrix      dw  num dup(num dup(?)) 
    ten                 dw  10 
    is_negative         dw  0 
    index               dw  0  
    ratio               dw  0
    i                   dw  0
    j                   dw  0
    k                   dw  0
    g                   dw  0
    b                   dw  0 
    det                 dw  1
    
    
dseg ends    


sseg    segment stack   'stack'    
words       dw  100h dup(?)
sseg    ends


cseg    segment 'code'

start   proc    far
        mov     ax,dseg
        mov     dx,ax 
        call    scan_int 
        call    nxt_line
        mov     num,cx 
        call    get_anknown_matrix_input 
        
        ;call    get_difinite_matrix_input
        call    to_triangular_matrix 
        call    determinant
        mov     ax,det
        mov     ah,01
        int     21h
        ret
        
    
    
    
    
    
    
    
        mov     ah, 4Ch
        int     21h
        ret 
start   endp


; scan integer into cx
scan_int    proc    near
            push    ax
            push    dx
            xor     cx, cx
            ; negative flag
            mov is_negative, 0
next_digit:
            call    read_char
            ; check if is negative
            cmp     al, '-'
            je      set_minus
            ; check if should stop input
            cmp     al, 0dh
            je      stop_input
            cmp     al, '.'
            je      stop_input
            cmp     al, ' '
            je      stop_input
            
            ; add digit to cx
            push    ax
            mov     ax, cx
            mul     ten
            mov     cx, ax
            pop     ax
            sub     al, 30h ; convert from ascii
            xor     ah, ah
            add     cx, ax
            
            jmp     next_digit

set_minus:
            mov     is_negative, 1
            jmp     next_digit
            
stop_input:
            cmp     is_negative, 0
            je      not_negative
            neg     cx
not_negative:
            pop     dx
            pop     ax
            ret
scan_int    endp



read_char   proc    near
            mov     ah,01
            int     21h
            ret
read_char   endp



get_anknown_matrix_input    proc    near  
                    
                    add     num,1
                    mov     cx,num
                    mov     bx,cx
                    xor     si,si 
                    mov     si,0 
         
                    loop1:
                         dec    bx
                         mov    dx,cx  
                         loop2:
                         
                              call      scan_int
                              mov       word ptr anknown_matrix[si][index],cx
                              mov       cx,dx
                              dec       dx
                              inc       word ptr index
                              
                         loop loop2
                          
                         inc    si
                         mov    cx,bx
                         
                    loop loop1
                    ret 
get_anknown_matrix_input    endp
    
    

get_difinite_matrix_input    proc    near  
                    
                    
                    mov     cx,num
                    mov     bx,cx
                    xor     si,si 
                    mov     si,0 
         
                    loop3:
                         dec    bx
                         call   scan_int
                         mov    word ptr difinite_matrix[si][0],cx
                         inc    si
                         mov    cx,bx
                         
                    loop loop3
                    ret 
get_difinite_matrix_input    endp  



to_triangular_matrix    proc    near
    
                        add     num,1
                        mov     cx,num
                        mov     word ptr i,cx
                        mov     word ptr j,cx
                        
                        
                        loop4:
                        
                        dec     word ptr i 
                        
                        
                            
                            loop5:
                            
                            dec     word ptr j 
                            mov     bx,word ptr b ;i
                            mov     word ptr g,bx
                            inc     word ptr g;j    
                            mov     si,word ptr g
                            mov     bx,word ptr anknown_matrix[si][b]   
                            mov     si,word ptr b
                            mov     cx,word ptr anknown_matrix[b][si]  
                            mov     ax,bx  
                            div     cx
                            mov     cx,num
                            mov     word ptr ratio,ax  
                            xor     bx,bx
                            xor     si,si
                            xor     ax,ax
                            
                                loop6:

                                mov     ax,word ptr ratio 
                                mov     si,word ptr b
                                mov     cx,word ptr anknown_matrix[si][k]
                                mul     cx 
                                mov     si,word ptr g
                                mov     bx,word ptr anknown_matrix[si][k]
                                sub     bx,ax
                                mov     word ptr triangu_matrix[si][k],bx            
                                inc     word ptr k  
                                mov     cx,num                                 
                                
                                loop loop6
                                mov     cx,word ptr j 
                                inc     word ptr g
                                
                            loop loop5       
                            mov     cx,word ptr i 
                            inc     word ptr b
                            
                        
                        loop loop4
                        ret
to_triangular_matrix    endp 



determinant     proc    near
                
                mov     word ptr i,0
                mov     bx,word ptr i
                mov     cx,num
                
                
                loop7:
                
                     mov    dx,word ptr triangu_matrix[bx][i]
                     inc    word ptr i
                     mov    bx,word ptr i
                     mov    ax,dx
                     mul    det 
                     add    det,ax
                     
                loop loop7   
                
                sub     det,1  
                ret
determinant     endp 
                    
                    
; go to next line in terminal
nxt_line    proc    near
            mov ah, 0Eh
            mov al, 0Dh
            int 10h
            mov al, 0Ah
            int 10h
            ret
nxt_line    endp

cseg    ends
        end     start

                
    