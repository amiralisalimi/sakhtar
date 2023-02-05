; Program 1

dseg    segment 'data'
cr          equ 0Dh
lf          equ 0Ah
so          equ 0Eh
num         dw  ?           ; Polynomial degree
coeff_int   dw  100 dup(0)  ; Integer part of coeffs   
coeff_flt   dw  100 dup(0)  ; Fraction part of coeffs
is_negative db  0           ; is negative flag
ten         dw  10
dseg    ends

sseg    segment stack   'stack'    
words       dw  100h dup(?)
sseg    ends

cseg    segment 'code'
    
start       proc    far     
            ; set seg-registers
            push    ds
            mov     ax, dseg
            mov     ds, ax
            mov     es, ax
            ; input num
            call    scan_int
            mov     num, cx
            
            ; take n+1 input for coeffs
            add     cx, 1
            call    nxt_line    
scan_coeffs:
            call    scan_float     
            ; coeffs are words, index should be doubled     
            mov     bx, cx
            add     bx, cx
            mov     coeff_int[bx -2], ax
            mov     coeff_flt[bx -2], dx
            
            call    nxt_line
            loop    scan_coeffs         
            
            ; scan is_int
            call    scan_int
            
            cmp     cx, 0
            jnz     compute_integral
            
compute_derivative:
            mov     cx, num
multiply:   
            ; coeffs are words, index should be doubled
            mov     bx, cx
            add     bx, cx
            ; mov int part to ax, frac part to dx
            mov     ax, word ptr coeff_int[bx]
            mov     dx, word ptr coeff_flt[bx]
            call    mul_float
            ; store result in coeffs array
            mov     word ptr coeff_int[bx], ax
            mov     word ptr coeff_flt[bx], dx
                 
            loop    multiply
            
            mov     bx, cx
            add     bx, cx
            ; mov int part to ax, frac part to dx
            mov     ax, word ptr coeff_int[bx]
            mov     dx, word ptr coeff_flt[bx]
            call    mul_float
            ; store result in coeffs array
            mov     word ptr coeff_int[bx], ax
            mov     word ptr coeff_flt[bx], dx
            
            jmp     print_result

compute_integral:
            mov     cx, num
divide:
            ; coeffs are words, index should be doubled
            mov     bx, cx
            add     bx, cx
            ; mov int part to ax, frac part to dx
            mov     ax, word ptr coeff_int[bx]
            mov     dx, word ptr coeff_flt[bx]
            call    div_float
            ; store result in coeffs array
            mov     word ptr coeff_int[bx], ax
            mov     word ptr coeff_flt[bx], dx
            
            loop divide            
            
print_result:
            mov     cx, num
            call    nxt_line
print_coeff:
            ; coeffs are words, index should be doubled
            mov     bx, cx
            add     bx, cx
            ; mov int part to ax, frac part to dx
            mov     ax, word ptr coeff_int[bx]
            mov     dx, word ptr coeff_flt[bx]
            call    print_float
            
            call    nxt_line
            loop    print_coeff
            
            mov     bx, cx
            add     bx, cx
            mov     ax, word ptr coeff_int[bx]
            mov     dx, word ptr coeff_flt[bx]
            call    print_float
            
            mov     ah, 4Ch
            int     21h
            ret
start       endp        



; Multiply floating-point number with cx
; ax : Integer part
; dx : Fraction part
; cx : To be multiplied with
mul_float   proc    near
            imul    cx
            xor     dx, dx
            ret
mul_float   endp


; Divide floating-point number with cx
; ax : Integer part
; dx : Fraction part
; cx : To be divided by
div_float   proc    near
            inc     cx
            idiv    cx
            dec     cx
            xor     dx, dx
            ret
div_float   endp


; prints integer in ax and fraction in dx
print_float proc    near
        push    ax
        push    dx
        ; print integer part
        call    print_num
        
        ; if fraction part is zero no need to print
        cmp     dx, 0
        je      done_pf
        
        push    dx
        ; print dot
        mov     dl, '.'
        call    write_char
        pop     dx
        
        ; print fraction part
        push    ax
        mov     ax, dx
        call    print_num
        pop     ax
done_pf:
        pop     dx
        pop     ax
        ret
print_float endp
        
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

; print string with address in dx
puts    proc    near
        push    ax
        mov     ah, 09h
        int     21h
        pop     ax
        ret
puts    endp

; read char into al
read_char   proc    near
            mov     ah, 01h
            int     21h
            ret
read_char   endp

; print char in dl
write_char  proc    near
            push    ax
            mov     ah, 02h
            int     21h
            pop     ax
            ret
write_char  endp

; scan float, int part into ax, frac part into dx
scan_float  proc    near
            push    cx
            xor     dx, dx
            call    scan_int ; TODO scan float
            mov     ax, cx
            pop     cx
            ret
scan_float  endp

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
            cmp     al, cr
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

; go to next line in terminal
nxt_line    proc    near
            mov ah, so
            mov al, cr
            int 10h
            mov al, lf
            int 10h
            ret
nxt_line    endp

cseg    ends
        end     start