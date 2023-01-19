; Program 07

dseg    segment        
    so          equ 0Eh
    cr          equ 0Dh
    lf          equ 0Ah
    max_number  equ 100
    is_prime    db  max_number  dup(1)
    inp         db  ?
    ten         db  10
dseg    ends

cseg    segment
start   proc    far
    mov     ax, dseg
    mov     ds, ax
    mov     es, ax
    
    call    eratost
    
    call    scan_int
    call    nxt_line
    mov     inp, cl
    
    mov     bx, 2
outer:
    add     bl, 2
    cmp     bl, inp
    ja      done
    mov     si, 1
inner:
    inc     si
    cmp     is_prime[si], 0
    jz      inner       
    mov     di, si
    neg     di
    cmp     is_prime[bx+di], 0
    jz      inner
    mov     ax, bx
    call    print_pos
    mov     dl, '='
    call    write_char
    mov     ax, si
    call    print_pos
    mov     dl, '+'
    call    write_char
    mov     ax, bx
    sub     ax, si
    call    print_pos
    call    nxt_line
    loop    outer
    
done:
    hlt
    ret
start   endp            

; set is_prime for 1->max_number
eratost proc    near
    push    si
    push    di
    
    mov     is_prime[0], 0
    mov     is_prime[1], 0
    mov     si, 1
outer_erat:
    inc     si
    cmp     si, max_number
    jae     erat_done
    mov     di, si
inner_erat:
    add     di, si
    cmp     di, max_number
    jae     outer_erat
    mov     is_prime[di], 0
    jmp     inner_erat
erat_done:
    pop     di
    pop     si
    ret
eratost endp

read_char   proc    near
            mov     ah, 01h
            int     21h
            ret
read_char   endp

; scan integer into cx
scan_int    proc    near
            push    ax
            push    dx
            xor     cx, cx
next_digit:
            call    read_char
            ; check if should stop input
            cmp     al, cr
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
stop_input:
            pop     dx
            pop     ax
            ret
scan_int    endp

; go to next line in terminal
nxt_line    proc    near
            mov ah, so
            mov al, cr
            int 10h
            mov al, lf
            int 10h
            ret
nxt_line    endp

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

; print char in dl
write_char  proc    near
            push    ax
            mov     ah, 02h
            int     21h
            pop     ax
            ret
write_char  endp

cseg    ends
        end     start