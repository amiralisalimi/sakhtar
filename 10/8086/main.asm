; Program 10

dseg    segment
    cr          equ     0Dh
    lf          equ     0Ah
    so          equ     0Eh
    new_line    equ     0Dh,0Ah, '$'
    unable_msg  db      'Unable to assign registers', new_line
    n           dw      ?              ; number of vertices
    a           db      100*100 dup(?) ; adjacency matrix
    r           dw      ?              ; number of registers
    c           db      100 dup(-1)     ; color of each vertex
    ten         db      10
dseg    ends

sseg    segment
    wrd dw  100h dup(?)
sseg    ends

cseg    segment
start   proc    far
    mov     ax, dseg
    mov     ds, ax
    mov     es, ax
    mov     ax, sseg
    mov     ss, ax
    
    call    scan_int
    mov     n, cx
    call    nxt_line
    
    xor     cx, cx
    xor     si, si
input_outer:
    xor     bx, bx
input_inner:
    call    nxt_bool
    mov     a[si+bx], al
    
    inc     bx
    cmp     bx, n
    jb      input_inner
    
    call    nxt_line
    add     si, n
    inc     cx
    cmp     cx, n
    jb      input_outer
    
    call    scan_int
    mov     r, cx
    call    nxt_line
    
    xor     cx, cx
    call    color_graph
    
    cmp     dx, 0
    jz      print_colors
    lea     dx, unable_msg
    call    puts
    jmp     done
print_colors:
    mov     bx, 0
print_loop:
    mov     dl, c[bx]
    add     dl, 'A'
    call    write_char
    mov     dl, ' '
    call    write_char
    inc     bx
    cmp     bx, n
    jne     print_loop
    
    call    nxt_line
done:
    hlt
    ret
start   endp

; current vertex in cx
; if ok, dx=0
color_graph proc    near
    push    ax
    push    bx

    cmp     cx, n
    je      color_graph_done
    mov     bx, cx
    mov     ax, r
    mov     c[bx], -1
color_loop:
    inc     c[bx]
    cmp     c[bx], al
    je      color_graph_done
    call    color_ok
    cmp     dx, 0
    jnz     color_loop
    inc     cx
    call    color_graph
    dec     cx
    cmp     dx, 0
    jnz     color_loop

color_graph_done:
    pop     bx
    pop     ax
    ret
color_graph endp

; for vertex cx, check if coloring is ok
; if ok, dx=0
color_ok    proc    near
    push    ax
    push    bx
    push    si
    push    di
    
    mov     bx, -1
    mov     ax, cx
    mul     n
    mov     di, ax
    xor     dx, dx
    mov     si, cx
color_chk_loop:
    inc     bx
    cmp     bx, cx
    je      color_chk_done
    cmp     a[di+bx], 0
    jz      color_chk_loop
    mov     al, c[si]
    cmp     al, c[bx]
    jne     color_chk_loop
    inc     dx
    jmp     color_chk_done  ; not color ok    
    
color_chk_done:
    pop     di
    pop     si
    pop     bx
    pop     ax
    ret
color_ok    endp

; prints positive number in ax
; after printing, ax=0
print_int   proc    near
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
print_int   endp 

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

; read next boolean number into al
nxt_bool    proc    near

read_nxt_char:
    call    read_char
    xor     al, 30h     ; convert from ascii
    jz      nxt_bool_done
    cmp     al, 1
    je      nxt_bool_done
    jmp     read_nxt_char
nxt_bool_done:
    ret
nxt_bool    endp

cseg    ends
        end     start