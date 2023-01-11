
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

compute_derivative:

; Counter register: N -> 0
mov cx, N  

multiply: 

; Move double of counter to SI
; C is array of word -> counter should be doubled      
mov si, cx
add si, cx
    
; Move current array element to AX for multiplication
mov ax, word ptr C[si -2]
; Should be multiplied by (N)-(CX)+1
mov dx, N
sub dx, cx
inc dx
imul dx

; Store result into C array
mov word ptr C[si -2], ax

; Loop on CX
loop multiply

ret

N   dw  4
C   dw  5, 2, 8, 1, 9, 100 dup(?)
T   dw  0

