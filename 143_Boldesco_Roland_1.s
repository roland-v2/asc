.data
    v: .space 4194304
    n: .long 1024
    n2: .long 1048576
    index1: .space 4
    index2: .space 4
    index3: .space 4
    index4: .space 4
    index5: .space 4
    index_i: .space 4
    index_j: .space 4
    count: .space 4
    count_add: .space 4
    operation_count: .space 4
    operation: .space 4
    file_count: .space 4
    id: .space 4
    id_copy: .space 4
    size: .space 4
    space_needed: .space 4
    format_out: .asciz "%d "
    format_in: .asciz "%d"
    format_add: .asciz "%d: ((%d, %d), (%d, %d))\n"
    format_get: .asciz "((%d, %d), (%d, %d))\n"
    newline: .asciz "\n"
    test_defr: .asciz "Defr\n"
.text
.global main
main:
    lea v, %edi

    push $operation_count
    push $format_in
    call scanf
    pop %ebx
    pop %ebx

    movl $0, index1
    for1:
        mov index1, %ecx
        cmp %ecx, operation_count
        je exit
    
        push $operation
        push $format_in
        call scanf
        pop %ebx
        pop %ebx

        movl $1, %eax
        cmp operation, %eax
        je add_tag
        movl $2, %eax
        cmp operation, %eax
        je get_tag
        movl $3, %eax
        cmp operation, %eax
        je del_tag
        movl $4, %eax
        cmp operation, %eax
        je defragmentation_tag

        for_contor1:
            incl index1
            jmp for1
continue:
    movl $0, index1
    movl $0, count
display_loop:
    mov index1, %ecx
    mov %ecx, %eax
    mov n, %ebx
    mov $0, %edx
    divl %ebx
    mov $0, %ebx
    cmp %edx, %ebx
    je newline_tag
    mov (%edi, %ecx, 4), %edx
    push %edx
    push $format_out
    call printf
    pop %edx
    pop %edx
    push $0
    call fflush
    pop %edx
display_loop_contor:
    incl index1
    jmp display_loop
newline_tag:
    push $newline
    call printf
    pop %edx
    push $0
    call fflush
    pop %edx
    mov index1, %ecx
    mov (%edi, %ecx, 4), %edx
    push %edx
    push $format_out
    call printf
    pop %edx
    pop %edx
    mov count, %ebx
    incl count
    cmp %ebx, n
    je exit
    jmp display_loop_contor
exit:
    pushl $0
    call fflush
    popl %eax

    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
    
add_tag:
    push $file_count
    push $format_in
    call scanf
    pop %ebx
    pop %ebx

    movl $0, index2
    for2:
        mov index2, %ecx
        cmp %ecx, file_count
        je for_contor1

        push $id
        push $format_in
        call scanf
        pop %ebx
        pop %ebx

        push $size
        push $format_in
        call scanf
        pop %ebx
        pop %ebx

        mov size, %eax
        mov $8, %ebx
        mov $0, %edx
        div %ebx
        mov %eax, space_needed
        mov $0, %eax
        cmp %edx, %eax
        jne add_size
    add_continue:
        movl $0, index_i
        for3:
            mov index_i, %ecx
            cmp %ecx, n
            je add_0

            movl $0, count_add
            movl $0, index_j
            for4:
                mov index_j, %ecx
                cmp %ecx, n
                je for_contor3

                mov index_i, %eax
                mov $1024, %ebx
                mul %ebx
                add %eax, %ecx
                mov (%edi, %ecx, 4), %edx
                mov $0, %ebx
                cmp %edx, %ebx
                je count_add_inc
                movl $0, count_add
            continue_for4:
                mov space_needed, %ebx
                cmp %ebx, count_add
                je display_add
            for_contor4:
                incl index_j
                jmp for4
        for_contor3:
            incl index_i
            jmp for3
    for_contor2:
        incl index2
        jmp for2
add_size:
    incl space_needed
    jmp add_continue
count_add_inc:
    incl count_add
    jmp continue_for4
display_add:
    mov index_j, %ecx
    sub count_add, %ecx
    add $1, %ecx
    mov %ecx, index5
    incl index_j
    for5:
        mov index5, %ecx
        cmp %ecx, index_j
        je display_print

        mov index_i, %eax
        mov $1024, %ebx
        mul %ebx
        add %eax, %ecx
        mov id, %ebx
        mov %ebx, (%edi, %ecx, 4)

    for_contor5:
        incl index5
        jmp for5
    display_print:
        decl index_j
        push index_j
        push index_i
        mov index_j, %ecx
        sub count_add, %ecx
        add $1, %ecx
        push %ecx
        push index_i
        push id
        push $format_add
        call printf
        pop %ebx
        pop %ebx
        pop %ebx
        pop %ebx
        pop %ebx
        pop %ebx
        jmp for_contor2
add_0:
    push $0
    push $0
    push $0
    push $0
    push id
    push $format_add
    call printf
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    jmp for_contor2
get_tag:
    push $id
    push $format_in
    call scanf
    pop %ebx
    pop %ebx
    movl $0, index3
    movl $0, index4
    movl $0, index2
    for_get1:
        mov index2, %ecx
        cmp %ecx, n2
        je get_display
        mov (%edi, %ecx, 4), %edx
        cmp %edx, id
        je get_range
    for_get1_contor:
        incl index2
        jmp for_get1
get_range:
    mov index4, %ebx
    incl %ebx
    mov %ebx, index4
    mov index2, %ebx
    mov %ebx, index3
    jmp for_get1_contor 
get_display:
    mov index3, %eax
    mov n, %ebx
    mov $0, %edx
    div %ebx
    push %edx
    push %eax

    mov $0, %ebx
    cmp %ebx, index3
    je get_display_0

    mov index3, %ebx
    sub index4, %ebx
    add $1, %ebx
    mov %ebx, %eax
    mov n, %ebx
    mov $0, %edx
    div %ebx
    push %edx
    push %eax
    push $format_get
    call printf
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    jmp get_out
get_display_0:
    push $0
    push $0
    push $0
    push $format_get
    call printf
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    jmp get_out
get_out:
    jmp for_contor1  
del_tag:
    push $id
    push $format_in
    call scanf
    pop %ebx
    pop %ebx
    movl $0, index2
    for_del1:
        mov index2, %ecx
        cmp %ecx, n2
        je del_display
        mov (%edi, %ecx, 4), %edx
        cmp %edx, id
        je del_range
    for_del1_contor:
        incl index2
        jmp for_del1
del_range:
    movl $0, (%edi, %ecx, 4)
    jmp for_del1_contor 
del_display:
    movl $0, index3
    for_del_display:
        mov index3, %ecx
        cmp %ecx, n2
        je del_out
        mov (%edi, %ecx, 4), %edx
        mov %edx, id_copy
        cmp $0, %edx
        jne del_id
    for_del_display_contor:
        incl index3
        jmp for_del_display
del_id:
    mov index3, %eax
    mov %eax, index4
    for_del4:
        mov index4, %ecx
        cmp %ecx, n2
        je del_out
        mov (%edi, %ecx, 4), %ebx
        cmp %ebx, %edx
        jne del_display_2
        incl index4
        jmp for_del4
del_display_2:
    mov index4, %eax
    dec %eax
    mov n, %ebx
    mov $0, %edx
    div %ebx
    push %edx
    push %eax
    mov index3, %eax
    mov n, %ebx
    mov $0, %edx
    div %ebx
    push %edx
    push %eax
    push id_copy
    push $format_add
    call printf
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    pop %ebx
    push index4
    pop index3
    jmp for_del_display
del_out:
    jmp for_contor1
defragmentation_tag:
    movl $0, index3
    for_defrag:
        mov index3, %ecx
        cmp %ecx, n2
        je defr_out
        mov (%edi, %ecx, 4), %edx
        mov %edx, id
        mov $0, %eax
        cmp %ebx, %eax
        jne continue_defr
    for_defrag_contor:
        incl index3
        jmp for_defrag
continue_defr:
    mov index3, %ebx
    mov %ebx, index2
    mov %ebx, size
    for_defr1:
        mov index2, %ecx
        push index2
        pop index3

        mov index3, %eax
        sub size, %eax
        mov %eax, space_needed

        cmp %ecx, n2
        je loop_defrag_add
        mov (%edi, %ecx, 4), %edx
        cmp %edx, id
        jne loop_defrag_add
        movl $0, (%edi, %ecx, 4)
    for_defr1_contor:
        incl index2
        jmp for_defr1


loop_defrag_add:


defr_out:
    jmp for_contor1 