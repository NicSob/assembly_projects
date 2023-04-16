
.text

.global sha1_chunk

sha1_chunk:
        #Prologue
        pushq %rbp          
        movq %rsp, %rbp 

////////////////////Saving pointers to h0-h4 on the stack
        subq $176, %rsp
        movq %rdi, (%rsp)
        
        addq $4, %rdi
        addq $16, %rsp 
        movq %rdi, (%rsp)

        addq $4, %rdi
        addq $16, %rsp
        movq %rdi, (%rsp)

        addq $4, %rdi
        addq $16, %rsp
        movq %rdi, (%rsp)

        addq $4, %rdi
        addq $16, %rsp
        movq %rdi, (%rsp)

        addq $4, %rdi
        addq $16, %rsp
        movq %rdi, (%rsp)
        //Pointer to W[0]
        movq %rsi, %r13

        /call printf

        //Loop initialization
        movq $16, %rcx  
        movq $80, %rbx


        loop1:
                cmpq %rcx, %rbx
                je endOfLoop

                movq %rcx, %rax
                subq $3, %rax
                movq $4, %rsi
                mulq %rsi

                addq %rax, %r13
                //Address to W[i-3] in r8
                movq %r13, %r8 
                subq %rax, %r13


                movq %rcx, %rax
                subq $8, %rax
                movq $4, %rsi
                mulq %rsi


                addq %rax, %r13
                //Address to W[i-8] in r9
                movq %r13, %r9 
                subq %rax, %r13

                movq %rcx, %rax
                subq $14, %rax
                movq $4, %rsi
                mulq %rsi     

                addq %rax, %r13
                //Address to W[i-14] in r10
                movq %r13, %r10 
                subq %rax, %r13

                movq %rcx, %rax
                subq $16, %rax
                movq $4, %rsi
                mulq %rsi

                addq %rax, %r13 
                //Address to W[i-16] in r11
                movq %r13, %r11 
                subq %rax, %r13  


                //Calculation of the address of W[i]
                movq %rcx, %rax
                movq $4, %rsi
                mulq %rsi
                /r13 stores the address of W[i]
                addq %rax,%r13

                xorFunction1:
                        movq (%r8), %r14
                        movq (%r9), %rdx
                        movq (%r10), %rdi
                        movq (%r11), %rsi

                        xorq %r14, %rdx
                        xorq %rdx, %rdi
                        xorq %rdi, %rsi
                        roll $1, %esi
                        movq %rsi, (%r13)
                        subq %rax, %r13
                        incq %rcx
                        jmp loop1

                endOfLoop:
                        movq $0, %r8
                        movq $0, %r9
                        movq $0, %r10
                        movq $0, %r11
                        movq $0, %r12


        //Asigning h0 - h4 for this chunk

        
        // There is a 16 gap between addresses of h0-h4 and the values of a-e
        subq $80, %rsp
        movq (%rsp), %r8
        addq $16, %rsp
        movq (%r8), %r8


        /addq $4, %r15
        /leaq 4(%r15), %r9
        movq (%rsp), %r9
        movq (%r9), %r9
        /addq $4, %r15
        addq $16, %rsp

        /leaq 8(%r15), %r10
        movq (%rsp), %r10
        movq (%r10), %r10
       / addq $4, %r15
        addq $16, %rsp

        /leaq 12(%r15), %r11
        movq (%rsp), %r11
        movq (%r11), %r11
        /addq $4, %r15
        addq $16, %rsp

        /leaq 16(%r15), %r12
        movq (%rsp), %r12
        movq (%r12), %r12
        /addq $4, %r15
        /subq $16, %r15
        addq $112, %rsp

        movq $0, %rcx
        /movq $79, %rbx

        //So we can just add 4 after every iteration of the main loop (then it will be like: address of W[o] - 4 + 4 = address of W[0])
        subq $4, %r13

        mainLoop:
                /copying values of a b c d e so that we can use the registers in the elifs

                //reserve space  eeyy
                subq $80, %rsp                  
                movq %r8, (%rsp)
                addq $16, %rsp
                movq %r9, (%rsp)
                addq $16, %rsp
                movq %r10, (%rsp)
                addq $16, %rsp
                movq %r11, (%rsp)
                addq $16, %rsp
                movq %r12, (%rsp)
                //Now is in the position of rbp
                addq $16, %rsp

                cmpq $79, %rcx
                jg endMainLoop

                /movq $79, %rdx
                cmpq $60, %rcx
                jge fourth20times

                /movq $59, %rdx
                cmpq $40, %rcx
                jge third20times

                /movq $39, %rdx
                cmpq $20, %rcx
                jge second20times

                /movq $19, %rdx
                cmpq $0, %rcx
                jge first20times

                first20times:

                        function1:
                                //copy b
                                movq %r9, %rax

                                andq %r9, %r10
                                not %rax
                                andq %rax, %r11
                                xorq %r10, %r11

                                //Initialize temp with f
                                movq %r11, %rax

                        //r14 as the k variable
                        movq $0x5A827999, %r14
                        jmp loopsecondpart
                        

                second20times:

                        function2:
                                xorq %r9, %r10
                                xorq %r10, %r11

                                //Initialize temp with f
                                movq %r11, %rax
                        
                        //r14 as the k variable
                        movq $0x6ED9EBA1, %r14
                        jmp loopsecondpart

                third20times:

                        function3:
                                //copy b
                                movq %r9, %rax

                                //copy c
                                movq %r10, %rdi

                                //copy d
                                movq %r11, %rsi

                                andq %r9, %r10
                                andq %rax, %r11
                                andq %rdi, %rsi

                                xorq %r10, %r11
                                xorq %r11, %rsi

                                //Initialize temp with f
                                movq %rsi, %rax

                                //clear copy registers
                                movq $0, %rdi
                                movq $0, %rsi
                        
                        //r14 as the k variable
                        movq $0x8F1BBCDC, %r14
                        jmp loopsecondpart


                fourth20times:

                        function4:
                                xorq %r9, %r10
                                xorq %r10, %r11

                                //Initialize temp with f
                                movq %r11, %rax
                        
                        //r14 as the k variable
                        movq $0xCA62C1D6, %r14
                        jmp loopsecondpart
                        
                loopsecondpart:
                        subq $80, %rsp
                        movq (%rsp),%r8 
                        addq $16, %rsp
                        movq (%rsp),%r9 
                        addq $16, %rsp
                        movq (%rsp),%r10 
                        addq $16, %rsp
                        movq (%rsp),%r11
                        addq $16, %rsp
                        movq (%rsp),%r12
                        addq $16, %rsp
                        
                        //Temp is initialized with f already added!!!
                        //Temp = (a --> shr5) + f + e + k + w[i]
                        roll $5, %r8d
                        addq %r8, %rax
                        //unshift a
                        rorl $5, %r8d

                        addq $4, %r13
                        
                        //Continue with calculations on temp

                        addq %r12, %rax
                        addq %r14, %rax

                        movq (%r13), %rdi
                        addq %rdi, %rax
                        
                        // e = d
                        movq %r11, %r12

                        //d = c
                        movq %r10, %r11
    
                        //c = b rotated 30 left
                        roll $30, %r9d
                        movq %r9, %r10

                        movq %r8, %r9

                        movq %rax, %r8
                        incq %rcx
                        jmp mainLoop

        movq $0, %rbx

        //Make r13 point to W[0] again // 

        endMainLoop:

                subq $176, %rsp
                movq (%rsp), %rax 
                addl %r8d, (%rax)
                addq $16, %rsp

                movq (%rsp), %rax 
                addl %r9d, (%rax)
                addq $16, %rsp

                movq (%rsp), %rax 
                addl %r10d, (%rax)
                addq $16, %rsp

                movq (%rsp), %rax 
                addl %r11d, (%rax)
                addq $16, %rsp

                movq (%rsp), %rax 
                addl %r12d, (%rax)
                addq $96, %rsp
                addq $2016, %rsp

                //Getting registers back to their state before the subroutine
                movq %rsp, %rbx
                movq %rsp, %r14

                subq $316, %r13
                movq %r13, %r12
                subq $624, %r13


        
        #Epilogue#
        movq %rbp, %rsp     
        popq %rbp           
        ret
