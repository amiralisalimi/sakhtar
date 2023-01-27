     StSeg Segment STACK 'STACK'
     ns DB 100H DUP (?)
      StSeg ENDS  
 
 DtSeg Segment
    so  equ 0Eh
    cr  equ 0Dh
    lf  equ 0Ah
     ; define your variables here 
     string  DB 100 DUP(?)
     stringPost  DB 100 DUP(?)
     saveValueWithAscii  DB  256 DUP(?)

     A  DW  5
     B  DW  1
     C  DW  2 
     I  DW  0
     ten dw 10 
        
   
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
     MOV SI,OFFSET string                  
     MOV I, SP    
         
;40 IS (  
;41 IS ) 
;94 IS ^
;42 IS *
;43 IS+
;47 IS /
;45 IS -                                                                  

; get string to ds:di
lea     di, string      ; buffer offset. 
lea     bx, stringPost

mov     dx, 100        ; buffer size.
call    get_string
putc    0Dh
putc    10 ; next line.
; print string in ds:si using procedure:
mov     si, di
;call    print_string
;MOV [BX], '('
;INC B 


mov saveValueWithAscii['0'],0
mov saveValueWithAscii['1'],1
mov saveValueWithAscii['2'],2
mov saveValueWithAscii['3'],3
mov saveValueWithAscii['4'],4
mov saveValueWithAscii['5'],5
mov saveValueWithAscii['6'],6
mov saveValueWithAscii['7'],7
mov saveValueWithAscii['8'],8
mov saveValueWithAscii['9'],9    

mov dx, A   
mov [saveValueWithAscii + 'A'], dl 
mov dx, B  
mov [saveValueWithAscii + 'B'], dl
mov dx, C   
mov [saveValueWithAscii + 'C'], dl   

push bx
call read_char
xor  bx, bx
mov  bl, al
call read_char 
call scan_int
mov  saveValueWithAscii+bx, cl
call nxt_line 


call read_char
xor  bx, bx
mov  bl, al
call read_char 
call scan_int
mov  saveValueWithAscii+bx, cl
call nxt_line

call read_char
xor  bx, bx
mov  bl, al
call read_char 
call scan_int
mov  saveValueWithAscii+bx, cl  
call nxt_line

pop bx


L1: 

     CMP [SI], '(' 
     JNE l2
     PUSH 40
     JMP L10 
              
L2:  
     CMP [SI], ')'
     JNE l3  
     LL1:
        POP AX   
        CMP AX, '('  
        JE L10 
        MOV DL, AL
        MOV AH, 02
        INT 21H  
        MOV [BX], AL 
        INC BX
        JMP LL1
      
L3:      
     CMP [SI], '^'  
     JNE L4
     POP AX
     PUSH AX
     CMP AX, '^'
     JNE LL2
     MOV DL, AL 
     MOV AH, 02
     INT 21H 
     MOV [BX], AL 
     INC BX 
     JMP  L4  
LL2:  
     JMP L10 
               
L4:
     CMP [SI], '*'
     JNE L5 
     POP AX
     CMP AX, '^'
     JNE LL3 
     MOV DL, AL 
     MOV AH, 02
     INT 21H   
     MOV [BX], AL 
     INC BX 
     JMP  L4
LL3: 
     CMP AX, '*'
     JNE LL4 
     MOV DL, AL 
     MOV AH, 02
     INT 21H
     MOV [BX], AL 
     INC BX   
     JMP  L4
LL4: 
     CMP AX, '/'
     JNE H9 
     MOV DL, AL 
     MOV AH, 02
     INT 21H  
     MOV [BX], AL 
     INC BX 
     JMP  L4 
H9:  
     CMP AX, ')'
     JNE H10
     PUSH 41
H10:  
     CMP AX, '(' 
     JNE H11
     PUSH 40 
H11:  
     CMP AX, '+' 
     JNE H12
     PUSH 43
H12: 
     CMP AX, '-' 
     JNE LL5
     PUSH 45        
LL5: 
     PUSH 42
     JMP L10  
      
     
L5:
     CMP [SI], '/'
     JNE L6 
     POP AX
     CMP AX, '^'
     JNE LL6 
     MOV DL, AL
     MOV AH, 02
     INT 21H 
     MOV [BX], AL 
     INC BX  
     JMP  L5
LL6: 
     CMP AX, '*'
     JNE LL7 
     MOV DL, AL 
     MOV AH, 02
     INT 21H 
     MOV [BX], AL 
     INC BX  
     JMP  L5
LL7: 
     CMP AX, '/'
     JNE H5
     MOV DL, AL 
     MOV AH, 02
     INT 21H  
     MOV [BX], AL 
     INC BX 
     JMP  L5 
H5:  
     CMP AX, ')'
     JNE H6
     PUSH 41
H6:  
     CMP AX, '(' 
     JNE H7
     PUSH 40 
H7:  
     CMP AX, '+' 
     JNE H8
     PUSH 43
H8: 
     CMP AX, '-' 
     JNE LL8
     PUSH 45 
LL8:
     PUSH 47
     JMP L10 
     
        
L6:    
     CMP [SI], '+'
     JNE L7 
     POP AX
     CMP AX, '^'
     JNE LL9
     MOV DL, AL 
     MOV AH, 02
     INT 21H  
     MOV [BX], AL 
     INC BX 
     JMP  L6
LL9: 
     CMP AX, '*'
     JNE LL10 
     MOV DL, AL 
     MOV AH, 02
     INT 21H 
     MOV [BX], AL 
     INC BX  
     JMP  L6
LL10: 
     CMP AX, '/'
     JNE LL11 
     MOV DL, AL 
     MOV AH, 02
     INT 21H 
     MOV [BX], AL 
     INC BX 
     JMP  L6 
LL11: 
     CMP AX, '+'
     JNE LL12 
     MOV DL, AL 
     MOV AH, 02
     INT 21H 
     MOV [BX], AL 
     INC BX 
     JMP  L6  
LL12: 
     CMP AX, '-'
     JNE H1 
     MOV DL, AL 
     MOV AH, 02
     INT 21H  
     MOV [BX], AL 
     INC BX 
     JMP  L6
H1:  
     CMP AX, ')'
     JNE H2
     PUSH 41
H2:
     CMP AX, '(' 
     JNE LL13
     PUSH 40       
LL13:
     PUSH 43
     JMP L10 
             
L7:           
     CMP [SI], '-'
     JNE L8 
     POP AX
     CMP AX, '^'
     JNE LL14
     MOV DL, AL 
     MOV AH, 02
     INT 21H  
     MOV [BX], AL 
     INC BX 
     JMP  L6
LL14: 
     CMP AX, '*'
     JNE LL15 
     MOV DL, AL 
     MOV AH, 02
     INT 21H   
     MOV [BX], AL 
     INC BX 
     JMP  L6
LL15: 
     CMP AX, '/'
     JNE LL16 
     MOV DL, AL 
     MOV AH, 02
     INT 21H 
     MOV [BX], AL 
     INC BX 
     JMP  L6 
LL16: 
     CMP AX, '+'
     JNE LL17 
     MOV DL, AL 
     MOV AH, 02
     INT 21H 
     MOV [BX], AL 
     INC BX 
     JMP  L6  
LL17: 
     CMP AX, '-'
     JNE H3 
     MOV DL, AL 
     MOV AH, 02
     INT 21H  
     MOV [BX], AL 
     INC BX 
     JMP  L6 
H3:  
     CMP AX, ')'
     JNE H4
     PUSH 41
H4:
     CMP AX, '(' 
     JNE LL18
     PUSH 40       
LL18:
     PUSH 45
     JMP L10 
     
L8:  
     MOV DX, [SI] 
     MOV AH, 02
     INT 21H  
     MOV [BX], DL
     INC BX 
   
L10:  
         
 ADD SI, 1     
 CMP [SI],'$'
 JNE L1 
 
 L99:
 CMP I, SP 
 JE L100 
 PUSH AX
 MOV DL, AL 
 MOV AH, 02
 INT 21H
 MOV [BX], AL 
 INC BX  
 JMP L99 
 
 L100:
     call nxt_line
     MOV [BX], '$'
     INC BX
     MOV SI,OFFSET stringPost   
J1:
     CMP [SI],'$' 
     JE  done     
     CMP [SI], '+' 
     JNE J2
     POP AX
     POP BX
     ADD AX,BX
     PUSH AX 
     ADD SI, 1 
     JMP J1
                      
J2:   
     CMP [SI], '-'
     JNE J3   
     POP BX
     POP AX
     SUB AX,BX
     PUSH AX
     ADD SI, 1 
     JMP J1 
J3:     
     CMP [SI], '*'
     JNE J4  
     POP AX
     POP BX
     MUL BX
     PUSH AX
     ADD SI, 1 
     JMP J1 
J4:     
     CMP [SI], '/'
     JNE J5 
     POP BX
     POP AX
     DIV BL
     xor ah,ah
     PUSH AX
     ADD SI, 1 
     JMP J1 
J5:        
     CMP [SI], '^'
     JNE J6
     POP BX
     POP AX
     ;POWER
     MOV CX, 0
JJ1: 
     CMP CX, BX
     JE JJ2  
     MUL AX
     INC CX
     JMP JJ1
     ;END POWER  
JJ2:
     PUSH AX
     inc si
     JMP J1   
J6:  
     ;PUSH [SI] 
     xor ax, ax
     xor bx, bx
     mov bl, byte ptr [si] 
     mov al, byte ptr saveValueWithAscii+bx
     PUSH ax
     ADD SI, 1     
     CMP [SI],'$' 
     JNE J1

done:     
     ;MOV DX, SP 
     ;MOV AH, 02
     ;INT 21H    
     POP  AX
     
     CALL print_int  
     
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
            mov ah, so
            mov al, cr
            int 10h
            mov al, lf
            int 10h
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
            
stop_input:
            pop     dx
            pop     ax
            ret
scan_int    endp

     CDSeg ENDS 
 END Start 
