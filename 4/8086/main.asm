; Program 04

dseg    segment
    so      equ 0Eh
    cr      equ 0Dh
    lf      equ 0Ah
    len     equ 16
    num1    db  len dup(0)
    num2    db  len dup(0)
    cnt1    db  0
    cnt2    db  0
    inp     db  len dup(?)
    res     db  2*len dup(0)
    is_neg  db  0
dseg    ends

cseg    segment
start   proc    far
    mov     ax, dseg
    mov     ds, ax

    lea     dx, num1
    call    input
    call    nxt_line
    lea     dx, num2
    call    input  
    call    nxt_line
    
input_ins:
    mov     ah, 1
    int     21h
    call    nxt_line
    cmp     al, '+'
    je      sum
    cmp     al, '-'
    je      subt
    cmp     al, '*'
    je      mult

subt:
    call    swap_if_less
    mov     is_neg, dl
    mov     bx, len
    mov     cx, bx
    clc
sub_loop:
    lahf
    and     ah, 0EFh     ; clear AF!?
    sahf
    mov     al, num1[bx-1]
    sbb     al, num2[bx-1]
    aas
    mov     res[bx+len-1], al
    dec     bx
    loop    sub_loop
    jmp     output

sum:
    mov     bx, len
    mov     cx, bx
    clc
sum_loop:
    mov     al, num1[bx-1]
    adc     al, num2[bx-1]
    aaa
    mov     res[bx+len-1], al
    dec     bx
    loop    sum_loop
    jmp     output

mult:
    mov     bx, len
mult_outer:
    mov     si, len
mult_inner:
    mov     al, num1[bx-1]
    mul     num2[si-1]
    add     res[bx+si-1], al
    dec     si
    jnz     mult_inner 
    dec     bx
    jnz     mult_outer
mult_norm:
    mov     bx, 2*len
norm_loop:
    add     res[bx-1], ah
adj_mul:
    mov     al, res[bx-1]
    aam
    cmp     al, 10
    jae     adj_mul
    
    mov     res[bx-1], al
    dec     bx
    jnz     norm_loop
    
    jmp     output
    
output:              
    xor     bx, bx
    mov     ah, so
    cmp     is_neg, 0
    jz      skip_lzero
    mov     al, '-'
    int     10h
skip_lzero:
    cmp     bx, 2*len-1
    je      print       
    inc     bx
    test    res[bx], 0Fh
    jz      skip_lzero
print:
    mov     al, res[bx]
    or      al, 30h     ; convert to ascii
    int     10h         ; print to terminal
    inc     bx
    cmp     bx, 2*len
    jne     print
    ret
start   endp

; takes input into inp,
; then copies to address in dx
input   proc    near
    push    ax
    push    bx
    
    xor     bx, bx
    mov     ah, 1
input_num:
    cmp     bx, len
    je      copy_to_cx
    int     21h
    cmp     al, cr
    je      copy_to_cx
    xor     al, 30h     ; convert from ascii
    mov     inp[bx], al
    inc     bx
    jmp     input_num

copy_to_cx:    
    mov     si, len
    add     si, dx
copy_loop:
    mov     al, byte ptr inp[bx-1]
    mov     byte ptr[si-1], al
    dec     si
    dec     bx
    jnz     copy_loop
input_done:
    pop     bx
    pop     ax
    ret
input   endp

; go to next line in terminal
nxt_line    proc    near
    push    ax
    mov     ah, so
    mov     al, cr
    int     10h
    mov     al, lf
    int     10h
    pop     ax
    ret
nxt_line    endp

; swap two numbers if num1<num2
; if swap done, dx=1
swap_if_less    proc    near
    push    ax
    push    bx
    push    cx
    
    xor     bx, bx
cmp_loop:
    mov     al, num1[bx]
    cmp     al, num2[bx]
    ja      swap_done
    jb      swap
    inc     bx
    cmp     bx, len
    jne     cmp_loop
swap:
    mov     dx, 1
    mov     bx, len
swap_loop:
    mov     al, num1[bx-1]
    xchg    al, num2[bx-1]
    xchg    al, num1[bx-1]
    dec     bx
    jnz     swap_loop
swap_done:
    pop     cx
    pop     bx
    pop     ax
    ret
swap_if_less    endp 
cseg    ends
        end     start