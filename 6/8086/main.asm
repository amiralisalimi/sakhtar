dseg    segment     'data'
        line1   db  100 dup(5)
        line2   db  100 dup(5)
        line3   db  100 dup(5)
        input   db  100 dup(5)
        ans_line1  db  100 dup(5) 
        size_of_word    db  100 dup(0)
        ans_line2  db  100 dup(5) 
        size_of_word2    db  100 dup(0)
        ans_line3  db  100 dup(5) 
        size_of_word3    db  100 dup(0)
        index   db  1   dup(5)
    
    
dseg    ends

cseg    segment     'code'

start   proc    far 
        ; set seg-registers
        push    ds
        mov     ax, dseg
        mov     ds, ax
        mov     es, ax
        call    get_char1_input 
        mov     si,0
        call    nxt_line 
        call    get_char2_input
        mov     si,0
        call    nxt_line
        call    get_char3_input
        mov     si,0
        call    nxt_line       
        call    get_input
        call    nxt_line  
        call    find_answers1           ;find all possible answers  
        call    find_size               ;find size of all possible answers
        call    find_largest            ;find largest size
        call    find_largestNum_index   ;find largest size index in size array
        call    print_final                    
        
        call    nxt_line
        call    find_answers2            ;find all possible answers  
        call    find_size2               ;find size of all possible answers
        call    find_largest2            ;find largest size
        call    find_largestNum_index2   ;find largest size index in size array
        call    print_final2  
        
        call    nxt_line
        call    find_answers3            ;find all possible answers  
        call    find_size3               ;find size of all possible answers
        call    find_largest3            ;find largest size
        call    find_largestNum_index3   ;find largest size index in size array
        call    print_final3    
              
            
        hlt    
        ret
start   endp


cseg    ends
   
   
; read char into al
read_char   proc    near
            mov     ah, 01h
            int     21h
            ret
read_char   endp
                
                
get_char1_input  proc
    
next_char1:
            call    read_char
            cmp     al, 0dh
            je     end1
            cmp     al, ' '
            je     next_char1 
            mov     line1[si],al
            inc     si
            jmp    next_char1
end1:
            ret
get_char1_input     endp  



get_char2_input  proc
    
next_char2:
            call    read_char
            cmp     al, 0dh
            je     end2
            cmp     al, ' '
            je     next_char2 
            mov     line2[si],al
            inc     si
            jmp    next_char2
end2:
            ret
get_char2_input     endp


get_char3_input  proc
    
next_char3:
            call    read_char
            cmp     al, 0dh
            je     end3
            cmp     al, ' '
            je     next_char3 
            mov     line3[si],al
            inc     si
            jmp    next_char3
end3:
            ret
get_char3_input     endp
            
; go to next line in terminal
nxt_line    proc    near
            mov ah, 0Eh
            mov al, 0Dh
            int 10h
            mov al, 0Ah
            int 10h
            ret
nxt_line    endp 


get_input  proc
    
next_char4:
            call    read_char
            cmp     al, 0dh
            je      end4
            mov     input[si],al
            inc     si
            jmp     next_char4
end4:
            ret
get_input     endp


; print char in dl
write_char  proc    near
            push    ax
            mov     ah, 02h
            int     21h
            pop     ax
            ret
write_char  endp


find_answers1    proc
    
                push    cx
                push    bx 
                push    si
                push    di
                mov     cx,0
                mov     bx,0
                mov     si,0 
                mov     di,0 
                mov     dx,0
loop1:           
                cmp     input[bx],5
                je      end5
                 
main:
                mov     cl,line1[si]  
                cmp     cl,input[bx]
                je      assignment  
                inc     si
                cmp     line1[si],5
                je      label1 
                ;inc     bx
                jmp     loop1

assignment:                         
                cmp     dx,0
                je      zero
                mov     cl,input[bx]
                mov     ans_line1[di],cl 
                inc     di 
                inc     bx
                jmp     loop1
                
label1:
               
                mov     si,0 
                inc     di
               
      loop2:
                mov     cl,input[bx]
                cmp     line1[si],cl
                je      assignment
                inc     si
                cmp     line1[si],5
                jne     loop2
                
                inc     bx 
                mov     si,0
                jmp     main
                
end5:   
                pop     di
                pop     si
                pop     bx
                pop     cx
                ret   
                
zero:
                mov dx,1   
                mov di,0
                jmp assignment
                
find_answers1    endp  




        

find_largest    proc  
            
                mov cx, 100
 
                mov bl, 00h
                lea si, size_of_word
up:
                mov al, [SI]
                cmp al, bl
                jl nxt
                mov bl, al
nxt:
                inc si
                dec cx
                jnz up
 
                mov size_of_word[99],bl
                ret

               
            
find_largest  endp 



find_size   proc
            
            push    si
            push    cx
            push    bx           
            mov     si,0  
            mov     bx,0  
            mov     cx,0
loop3:       
            cmp     si,100
            je      end7
            cmp     ans_line1[si],5
            je      lbl1
            inc     cx 
            inc     si
            jmp     loop3
lbl1:
            inc     si
            cmp     cx,0
            jne     lbl2
            jmp     loop3
            
            
lbl2:       
            mov     size_of_word[bx],cl
            inc     bx
            mov     cx,0
            jmp     loop3  
end7:
            pop     bx
            pop     cx
            pop     si
            
            ret
find_size   endp
 



find_largestNum_index   proc   
                        
                        mov     bx,0
                        mov     cl,size_of_word[99]
l2:
                        cmp     cl,size_of_word[bx]
                        je      pEnd
                        inc     bx
                        jmp     l2
                        
pEnd:
                        mov     index[0],bl
                        ret 
                        
find_largestNum_index   endp


print_final     proc
                
                mov     si,-1
                mov     cl,index[0] 
                cmp     cl,0
                je      printEnd  
l3:             
              
                inc     si
                cmp     ans_line1[si],5
                je      decre  
                jmp     l3
                
decre:          
                cmp     ans_line1[si+1],5
                jne     l4
                jmp     l3
    l4:
                dec     cx
                cmp     cx,0
                je      printEnd
                jmp     l3 
                
printEnd:
                inc     si
                mov     dl,ans_line1[si]      
                cmp     ans_line1[si],5
                je      end6 
                call    write_char 
                jmp     printEnd
        
        
        
end6:
                
                ret
print_final     endp 








find_answers2    proc
    
                push    cx
                push    bx 
                push    si
                push    di
                mov     cx,0
                mov     bx,0
                mov     si,0 
                mov     di,0 
                mov     dx,0
loopp1:           
                cmp     input[bx],5
                je      endd5
                 
mainn:           
                cmp     dx,0
                je      zeroo
                mov     cl,line2[si]  
                cmp     cl,input[bx]
                je      assignmentt  
                inc     si
                cmp     line2[si],5
                je      labell1 
                ;inc     bx
                jmp     loopp1

assignmentt:
                mov     cl,input[bx]
                mov     ans_line2[di],cl 
                inc     di 
                inc     bx
                jmp     loopp1
                
labell1:
               
                mov     si,0 
                inc     di
               
      loopp2:
                mov     cl,input[bx]
                cmp     line2[si],cl
                je      assignmentt
                inc     si
                cmp     line2[si],5
                jne     loopp2
                
                inc     bx 
                mov     si,0
                jmp     mainn 
                
                
endd5:   
                pop     di
                pop     si
                pop     bx
                pop     cx
                ret 
zeroo:
                mov dx,1
                jmp assignmentt
                
find_answers2    endp  




        

find_largest2  proc  
            
                mov cx, 100
 
                mov bl, 00h
                lea si, size_of_word2
upp:
                mov al, [SI]
                cmp al, bl
                jl nxtt
                mov bl, al
nxtt:
                inc si
                dec cx
                jnz upp
 
                mov size_of_word2[99],bl
                ret

            
find_largest2  endp 



find_size2   proc
            
            push    si
            push    cx
            push    bx           
            mov     si,0  
            mov     bx,0  
            mov     cx,0
loopp3:       
            cmp     si,100
            je      endd7
            cmp     ans_line2[si],5
            je      lbll1
            inc     cx 
            inc     si
            jmp     loopp3
lbll1:
            inc     si
            cmp     cx,0
            jne     lbll2
            jmp     loopp3
            
            
lbll2:       
            mov     size_of_word2[bx],cl
            inc     bx
            mov     cx,0
            jmp     loopp3  
endd7:
            pop     bx
            pop     cx
            pop     si
            
            ret
find_size2   endp
 



find_largestNum_index2   proc   
                        
                        mov     bx,0
                        mov     cl,size_of_word2[99]
ll2:
                        cmp     cl,size_of_word2[bx]
                        je      pEndd
                        inc     bx
                        jmp     ll2
                        
pEndd:
                        mov     index[0],bl
                        ret 
                        
find_largestNum_index2   endp


print_final2     proc
                
                mov     si,-1
                mov     cl,index[0] 
                cmp     cl,0
                je      printEndd
ll3:             
                inc     si
                cmp     ans_line2[si],5
                je      decree  
                jmp     ll3
                
decree:          
                cmp     ans_line2[si+1],5
                jne     ll4
                jmp     ll3
    ll4:
                dec     cx
                cmp     cx,0
                je      printEndd
                jmp     ll3 
                
printEndd:
                inc     si
                mov     dl,ans_line2[si]      
                cmp     ans_line2[si],5
                je      endd6 
                call    write_char 
                jmp     printEndd
        
        
        
endd6:
                
                ret
print_final2     endp








find_answers3    proc
    
                push    cx
                push    bx 
                push    si
                push    di
                mov     cx,0
                mov     bx,0
                mov     si,0 
                mov     di,0 
                mov     dx,0
looppp1:           
                cmp     input[bx],5
                je      enddd5
                 
mainnn:           
                cmp     dx,0
                je      zerooo
                mov     cl,line3[si]  
                cmp     cl,input[bx]
                je      assignmenttt  
                inc     si
                cmp     line3[si],5
                je      labelll1 
                ;inc     bx
                jmp     looppp1

assignmenttt:
                mov     cl,input[bx]
                mov     ans_line3[di],cl 
                inc     di 
                inc     bx
                jmp     looppp1
                
labelll1:
               
                mov     si,0 
                inc     di
               
      looppp2:
                mov     cl,input[bx]
                cmp     line3[si],cl
                je      assignmenttt
                inc     si
                cmp     line3[si],5
                jne     looppp2
                
                inc     bx 
                mov     si,0
                jmp     mainnn 
                
                
enddd5:   
                pop     di
                pop     si
                pop     bx
                pop     cx
                ret 
zerooo:
                mov dx,1
                jmp assignmenttt
                
find_answers3    endp  




        

find_largest3  proc  
            
                mov cx, 100
 
                mov bl, 00h
                lea si, size_of_word3
uppp:
                mov al, [SI]
                cmp al, bl
                jl nxttt
                mov bl, al
nxttt:
                inc si
                dec cx
                jnz uppp
 
                mov size_of_word3[99],bl
                ret

            
find_largest3  endp 



find_size3   proc
            
            push    si
            push    cx
            push    bx           
            mov     si,0  
            mov     bx,0  
            mov     cx,0
looppp3:       
            cmp     si,100
            je      enddd7
            cmp     ans_line3[si],5
            je      lblll1
            inc     cx 
            inc     si
            jmp     looppp3
lblll1:
            inc     si
            cmp     cx,0
            jne     lblll2
            jmp     looppp3
            
            
lblll2:       
            mov     size_of_word3[bx],cl
            inc     bx
            mov     cx,0
            jmp     looppp3  
enddd7:
            pop     bx
            pop     cx
            pop     si
            
            ret
find_size3   endp
 



find_largestNum_index3   proc   
                        
                        mov     bx,0
                        mov     cl,size_of_word3[99]
lll2:
                        cmp     cl,size_of_word3[bx]
                        je      pEnddd
                        inc     bx
                        jmp     lll2
                        
pEnddd:
                        mov     index[0],bl
                        ret 
                        
find_largestNum_index3   endp


print_final3     proc
                
                mov     si,-1
                mov     cl,index[0] 
                cmp     cl,0
                je      printEnddd
lll3:             
                inc     si
                cmp     ans_line3[si],5
                je      decreee  
                jmp     lll3
                
decreee:          
                cmp     ans_line3[si+1],5
                jne     lll4
                jmp     lll3
    lll4:
                dec     cx
                cmp     cx,0
                je      printEnddd
                jmp     lll3 
                
printEnddd:
                inc     si
                mov     dl,ans_line3[si]      
                cmp     ans_line3[si],5
                je      enddd6 
                call    write_char 
                jmp     printEnddd
        
        
        
enddd6:
                
                ret
print_final3     endp


            
            
            
END     start