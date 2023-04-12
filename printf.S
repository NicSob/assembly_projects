# *********************************************************************************
# * Program name: my_printf                                                       *
# * Description :                                                                 *
# *********************************************************************************

# Define platform-specific symbols
#ifndef MACOS
.ifndef CODEGRADE
    .global main
    main: jmp my_main            # Define the main symbol for non-MacOS platforms
.endif
#else
    .global _main
    _main: jmp my_main           # Define the main symbol for MacOS platforms
    putchar: jmp _putchar        # Define putchar symbol for MacOS
    exit: jmp _exit              # Define exit symbol for MacOS
#endif

.text
# Define the format string and name string
string_format:
    // .asciz   "Stack arguments are also hard."
        .asciz   "Stack arguments are also hard. First not on the stack: %d %s %u %s %u, and now on the stack: %d %s %u %% %s %u \n"

string_name://Stack arguments are also hard. First not on the stack: -100000 Hi 54321 Bye 10, and now on the stack: -5 Hi 54321 % Bye 10
    .asciz "Hi"
str_bye:
    .asciz "Bye"
.global my_main                 # Declare the main function as global
.global my_printf               # Declare the my_printf function as global

# Main function
my_main:
    pushq %rbp                  # Prologue (save the previous frame pointer)
    movq %rsp, %rbp             # Set the current stack frame pointer

    # Load the format string, name string, and unsigned integer into the appropriate registers
    leaq string_format(%rip), %rdi   # Load the address of the format string into %rdi (first argument)
    leaq string_name(%rip), %rdx     # Load the address of the name string into %rsi (second argument)
    movq $-100000, %rsi
    movq $12, %rsi                   # Load the value 12 into %rdx (third argument)
    movq $54321, %rcx                   # Load the value -13 (fourth argument) into %r8
    leaq str_bye(%rip), %r8     # Load the address of the name string into %rsi (second argument)
    movq $10, %r9    // leaq string_name(%rip), %rdx     # Load the address of the name string into %rsi (second argument)

    pushq $10
    leaq str_bye(%rip), %r15
    pushq %r15
    pushq $54321
    leaq string_name(%rip), %r15
    pushq %r15
    pushq $-5

    call my_printf                   # Call the my_printf function
    # Epilogue and program exit
    movq %rbp, %rsp                 # Restore the previous stack frame pointer
    popq %rbp                        # Restore the previous frame pointer
    movq $0, %rdi                    # Load the program exit code (0) into %rdi
    movq $0, %rax                    # Set the syscall number for the exit system call
    ret                              # Return from main function

# my_printf function
my_printf:
  
    pushq %rbp
    movq %rsp, %rbp
  
    pushq %r9
    pushq %r8
    pushq %rcx
    pushq %rdx
    pushq %rsi
    pushq %rdi
    
    movq (%rsp), %r12
    addq $8, %rsp

    xorq %r15, %r15                  # Initialize %r15 to 0 for counting processed additional arguments

.next_char:
    # Load the next character from the format string
    movzbq (%r12), %rcx # Load the next character from the format string into %rcx
    testq %rcx, %rcx # Check if the character is a null terminator
    jz .end # If it is, jump to the end of the subroutine

comparison:
    cmpq $5, %r15
    je jumpOver

    # Check if the character is a percent sign and handle specifiers
    cmpb $'%', %cl
    jne .print_char                  # If it's not a percent sign, jump to print the character directly

    # If it's a percent sign, check the specifier character
    incq %r12                        # Increment the format string pointer to get the next specifier
    movzbq (%r12), %rcx              # Load the specifier character into %rcx
    // incq %r9
    # Check specifiers and jump to corresponding routines

    cmpb $'d', %cl                   # Check if the specifier is %d (signed integer)
    je .print_signed_integer
    cmpb $'u', %cl                   # Check if the specifier is %u (unsigned integer)
    je .print_unsigned_integer
    cmpb $'s', %cl                   # Check if the specifier is %s (string)
    je .print_string
    cmpb $'%', %cl                   # Check if the specifier is %% (percent sign)
    jne .next_char                   # If it's not a recognized specifier, jump to the next character

    # If the specifier is %%, print the % character
    movq $'%', %rdi                  # Move the % character to %rdi (putchar's argument)
    call putchar                     # Call putchar to print the character
    incq %r12                        # Increment the format string pointer
    jmp .next_char

    .print_signed_integer:
    // popq %rax
    movq (%rsp), %rax
    addq $8, %rsp
    incq %r15

    call print_decimal
    // incq %r15 # Increment the number of processed additional arguments
    jmp .next_char

    .print_unsigned_integer:
    // movq %rbx, %rax # Load the current argument (unsigned integer) into %rax
    // popq %rax
    
    movq (%rsp), %rax
    addq $8, %rsp
    
    incq %r15
    // movq %rsi, %rax
    call print_unsigned_integer
    // incq %r15 # Increment the number of processed additional arguments
    jmp .next_char

    .print_string:
    // movq %r13, %rsi # Load the current argument (string pointer) into %rsi
    // popq %rsi
    
    movq (%rsp), %rsi
    addq $8, %rsp
    
    incq %r15
    call print_string
    // incq %r15 # Increment the number of processed additional arguments
    jmp .next_char

    .print_char:
    movq %rcx, %rdi # Move the character to %rdi (putchar's argument)
    call putchar # Call putchar to print the character
    incq %r12 # Increment the format string pointer
    jmp .next_char

    .end:

    movq %rbp, %rsp  
    // pushq %r15

    popq %rbp
    ret
print_decimal:
    # Save callee-saved registers
    pushq %rbp
    movq %rsp, %rbp

    cmpq $0, %rax
    
    jge print_decimal_positive
    neg %rax
    
    // movq %rdi, %r14
    movq %rax, %r13
    movq $'-', %rdi
    call putchar
    movq %r14, %rdi
    movq %r13, %rax
    jmp print_decimal_positive

print_decimal_positive:
    movq $10, %rcx
    xorq %rdx, %rdx
    divq %rcx
    addq $'0', %rdx
    pushq %rdx
    cmpq $0, %rax
    jne print_decimal_positive
    jmp print_decimal_loop

print_decimal_loop:
    cmpq %rbp, %rsp
    je print_decimal_end
    popq %rdi
    // incq %r15
    # call print_char
    movq $0, %rax
    // movq %rdi, %rsi
    call putchar
    jmp print_decimal_loop

print_decimal_end:
    # Restore callee-saved registers
    incq %r12
    movq %rbp, %rsp
    popq %rbp
    ret





# Helper function to print an unsigned integer
print_unsigned_integer:
    pushq %rbp
    movq %rsp, %rbp
    // movq %rbx, %rax
    // popq %rax
.base10_loop:
    # Convert unsigned integer to decimal digits
    xorq %rdx, %rdx                  # Clear the %rdx register
    movq $10, %rcx                   # Load the value 10 into %rcx (divisor for base 10 conversion)
    divq %rcx                        # Divide %rax by %rcx, quotient in %rax, remainder in %rdx
    addq $'0', %rdx                  # Add the ASCII value of '0' to the remainder to get the digit character
    pushq %rdx                       # Push the digit character onto the stack
    testq %rax, %rax                 # Test if the quotient is zero
    jnz .base10_loop                 # If the quotient is not zero, continue the loop

.print_digits:
    popq %rdi                         # Pop the digit character from the stack into %rdi
    call putchar   
    cmpq %rbp, %rsp
    je .end_print_unsigned_integer
    jmp .print_digits                 # Repeat for the remaining digits

.end_print_unsigned_integer:
    incq %r12
    movq %rbp, %rsp
    popq %rbp
    ret



print_string:
    pushq %rbp
    movq %rsp, %rbp
    movq %rsi, %r10                  

.next_char_in_string:
    movzbq (%r10), %rdi              # Load the next character from the string into %rdi
    testq %rdi, %rdi                 # Test if the character is a null terminator 
    jz .end_print_string             # jump to the end of the print_string function
    call putchar                     
    incq %r10                        
    jmp .next_char_in_string         

.end_print_string:
    movq %rbp, %rsp
    popq %rbp

    incq %r12
    ret

jumpOver:
    addq $16, %rsp
    incq %r15
    jmp comparison
