     StSeg Segment STACK 'STACK'
     ns DB 100H DUP (?)
      StSeg ENDS  
 
 DtSeg Segment
    so  equ 0Eh
    cr  equ 0Dh
    lf  equ 0Ah
     ; define your variables here 
     
     array  DB  256 DUP(?)
     ten dw 10
     num  dW 0 
     REM DB 0 
     EDGE Dw 0
     DtSeg ENDS 
 
 CDSeg Segment 
    putc    macro   char
        push    ax
        mov     al, char
        mov     ah, 0eh
        int     10h     
        pop     ax
pc    endm
    
     ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
     Start:
     MOV AX,DtSeg ; set DS to point to the data segment
     MOV DS,AX  
     call scan_int
     mov  num, cX
     call nxt_line 
     XOR BX,BX
     INPUT:            
     CALL scan_int 
     MOV  ARRAY[BX], CL
     INC Bl
     CMP num, BX
     JNE INPUT 
     
     
     XOR BX, BX
     XOR SI, SI

     LOOP1:
     MOV SI, 0 
     
     LOOP2: 
     MOV AL, byte ptr ARRAY[BX]
     MOV CL, byte ptr ARRAY[SI]
     SUB AL, CL
     CMP AL, 1   
     JNE T
     INC EDGE  
     T:
     ADD SI, 1 
     MOV DX, SI 
     CMP DX, NUM
     JNE LOOP2 
     
     INC BX 
     CMP BX, NUM
     JNE LOOP1
       
     mov ax, edge
     call nxt_line
     call print_int
     
     
     
     ; type your code here
     MOV AH,4CH ; DOS: terminate program
     MOV AL,0 ; return code will be 0
     INT 21H ; terminate the program
                              
HLT
ret



; get a null terminated string from keyboard,
; write it to buffer at ds:di, maximum buffer size is set in dx.
; 'enter' stops the input.
get_string      proc    near
push    ax
push    cx
push    di
push    dx

mov     cx, 0                   ; char counter.

cmp     dx, 1                   ; buffer too small?
jbe     empty_buffer            ;

dec     dx                      ; reserve space for last zero.


;============================
; eternal loop to get
; and processes key presses:                                                                                    

mov     [di], '('
inc     di

wait_for_key:

mov     ah, 0                   ; get pressed key.
int     16h

cmp     al, 0Dh                  ; 'return' pressed?
jz      exit


cmp     al, 8                   ; 'backspace' pressed?
jne     add_to_buffer
jcxz    wait_for_key            ; nothing to remove!
dec     cx
dec     di
putc    8                       ; backspace.
putc    ' '                     ; clear position.
putc    8                       ; backspace again.
jmp     wait_for_key

add_to_buffer:

        cmp     cx, dx          ; buffer is full?
        jae     wait_for_key    ; if so wait for 'backspace' or 'return'...

        mov     [di], al
        inc     di
        inc     cx
        
        ; print the key:
        mov     ah, 0eh
        int     10h

jmp     wait_for_key


;============================

exit:
mov     [di], ')'
inc     di
mov     [di], '$'
inc     di
; terminate by null:
mov     [di], 0

empty_buffer:

pop     dx
pop     di
pop     cx
pop     ax
ret
get_string      endp
 
 

; prints positive number in ax
; after printing, ax=0
print_int   proc    near
    push    bx
    push    cx
    push    dx
    TEST    AX, 8000H
    JZ      M
    MOV     DL, '-'
    call    write_char
    NEG     AX
M:             
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


; go to next line in terminal
nxt_line    proc    near
            push ax
            mov ah, so
            mov al, cr
            int 10h
            mov al, lf
            int 10h
            pop ax
            ret
nxt_line    endp

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

     CDSeg ENDS 
 END Start 