# *********************************************************************************
# * Program name: fibonacci                                                       *
# * Description :                                                                 *
# *********************************************************************************

#ifndef MACOS
.ifndef CODEGRADE
    .global main
    main: jmp my_main
.endif
#else
    .global _main
    _main: jmp my_main
    printf: jmp _printf
    scanf: jmp _scanf
    malloc: jmp _malloc
    calloc: jmp _calloc
    realloc: jmp _realloc
    free: jmp _free
    exit: jmp _exit
#endif

.text
#our strings here
format: .asciz "%ld"
numInput: .asciz "Please enter which term you want calculated: "
outputPretty: .asciz "This is your term: %d\n"
negNumError: .asciz "You, have entered a negative number, try again!\n" //err
debug: .asciz "This is your number debug: %d\n"
debug2: .asciz "Address: %d\n"

.global my_main
.global fibonacci


my_main:
    #Prologue
    pushq %rbp          
    movq %rsp, %rbp     

    call input

    movq $0, %rsi
    movq $0, %rdx

    mainLoop:
        cmpq $0, %rdi
        je endMainLoop

        cmpq $0, %rdi
        jl endlooperror

        call fibonacci

        movq %rax, %r14
        movq %r11, %r15

        repeatInput:
            call input

            movq %r14, %rdx
            movq %r15, %rsi
            jmp mainLoop

    endlooperror:

        leaq negNumError(%rip), %rdi
        call printf
        jmp repeatInput
        

    endMainLoop:
        #Epilogue#
        movq %rbp, %rsp     
        popq %rbp 

        #load program exit code        
        movq $0, %rdi    
        movq $0, %rax
        ret



input:

    pushq %rbp          #Prologue
    movq %rsp, %rbp     #
    #input

    #Output prettyfied query for inpiut START#
    leaq numInput(%rip), %rdi
    call printf
    #END#

    subq $16, %rsp              //reserve space
    leaq -16(%rbp), %rsi        //load first destination adress
    leaq format(%rip), %rdi     //load string adress           
    call scanf

    movq -16(%rbp), %rdi

    addq $16, %rsp              //clear stack

    movq %rbp, %rsp     #
    popq %rbp           #
    ret 

fibonacci:
    pushq %rbp          #Prologue
    movq %rsp, %rbp     #

    movq %rdi, %r11 //Copy n
    movq %rsi, %r12 //copy curr_max
    movq %rdx, %r13 //copy pointer to the address

    cmpq %r12, %r11
    jg reallocateFunction

    movq $8, %rax
    mulq %r11
    addq %rax, %r13
    subq $8, %r13

    subq $16, %rsp
    movq %rax, (%rsp)

    #output prettyfied Num#
    movq (%r13), %rsi
    leaq outputPretty(%rip), %rdi
    call printf
    #end of output Num#
    movq (%rsp), %rax

    subq %rax, %r13
    addq $8, %r13
    movq %r13, %rax

    end:
        movq %rbp, %rsp     #Epilogue#
        popq %rbp           #
        ret
    
    reallocateFunction:
        
        subq $16, %rsp
        movq %r11, (%rsp)       //Saving n on the stack so it s u r v i v e s realloc

        movq $8, %rax
        mulq %r11
        movq %rax, %rsi
        movq %r13, %rdi
        call realloc
        movq %rax, %r13     //overwriting the pointer
        movq (%rsp), %r11

        movq %r11, %rdi
        movq %r13, %rsi
        call fibonacciCalc

        #output prettyfied Num#
        movq %rax, %rsi
        leaq outputPretty(%rip), %rdi
        call printf
        #end of output Num#

        movq (%rsp), %r11
        addq $16, %rsp

        movq %r13, %rax
        movq %r12, %r11
        movq %rbp, %rsp     #Epilogue#
        popq %rbp           #
        ret 


fibonacciCalc:
        # IMPLEMENT ME
        pushq %rbp          #Prologue
        movq %rsp, %rbp     #

        cmpq $0, %r12
        jne whenAddressGreaterThan0
               
        cmpq $1, %rdi
        je endloop1

        cmpq $2, %rdi
        je endloop2

        cmpq $0, %rdi
        jl endlooperror
        

        firstAllocation:
        movq $0, %r8
        movq %r8, (%rsi)
        addq $8, %rsi
        movq $1, %r9
        movq %r9, (%rsi)
        addq $8, %rsi
        movq $0, %rax
        movq $2, %rcx

        loop:
            cmpq %rcx, %rdi
            je endloopnormal
            movq %r9, %r10
            addq %r8, %r9
            movq %r9, %rax 
            movq %rax, (%rsi)
            addq $8, %rsi
            movq %r10, %r8 
            incq %rcx
            jmp loop
        
        whenAddressGreaterThan0:
                cmpq $1, %rdi
                je endloop1

                cmpq $2, %rdi
                je endloop2

                cmpq $0, %rdi
                jl endlooperror

                movq %rdi, %r15     //saving n
                movq %r12, %r14     //curr max copied to r14 for the counter -- HOW MANY TIMES CALC BUT NOT SAVE

                movq $0, %r8
                movq $1, %r9
                movq $0, %rax
                movq $2, %rcx

            loopPartOne:                ////Calc without saving
                cmpq %rcx, %r15
                jg endloopnormal                
                cmpq %rcx, %r14
                jg save

            continue:
                movq %r9, %r10
                addq %r8, %r9
                movq %r9, %rax 
                addq $8, %rsi
                movq %r10, %r8 
                incq %rcx
                jmp loopPartOne  
            
            save:
                movq %rax, (%rsi)
                jmp continue


        endloop1:               #end when asked for 1st term which is 0
            movq $0, %rax 
            movq %rax, (%rsi)      
            movq %rbp, %rsp     #Epilogue#
            popq %rbp           #
            ret 

        endloop2:
            movq $0, %rax
            movq %rax, (%rsi)               #end when asked for 2nd term which is 1
            addq $8, %rsi
            movq $1, %rax
            movq %rax, (%rsi)
            movq %rbp, %rsp     #Epilogue#
            popq %rbp           #
            ret       

        endloopnormal:          #end, when asked for numth > 1
            movq %rbp, %rsp     #Epilogue#
            popq %rbp           #
            ret




