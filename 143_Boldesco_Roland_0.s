.data
    v: .space 4096
    n: .long 1024
    operation_count: .space 4
    operation: .space 4
    file_count: .space 4
    id: .space 4
    size: .space 4
    space_needed: .space 4
    format_add: .asciz "%d: (%d, %d)\n"
    format_0: .asciz "%d: (0, 0)\n"
    format_get: .asciz "(%d, %d)\n"
    index1: .space 4
    index2: .space 4
    index3: .space 4
    index4: .space 4
    index5: .space 4
    index_add1: .space 4
    index_add2: .space 4
    count_add: .space 4
    format_out: .asciz "%d "
    format_in: .asciz "%d"
    newline: .asciz "\n"
    var_nou: .space 4
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
    mov $0, %ecx
    push %ecx
display_loop:
    pop %ecx
    cmp %ecx, n
    je exit
    mov (%edi, %ecx, 4), %edx
    inc %ecx
    push %ecx

    push %edx
    push $format_out
    call printf
    pop %edx
    pop %edx
    
    push $0
    call fflush
    pop %edx
    jmp display_loop
exit:
    pushl $0
    call fflush
    popl %edx

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

        movl $-1, index_add1
        movl $-1, index_add2
        movl $0, count_add
        mov size, %eax
        mov $8, %ebx
        mov $0, %edx
        div %ebx
        mov %eax, space_needed
        mov $0, %eax
        cmp %edx, %eax
        jne add_size
    add_continue:
        movl $0, index3
        for3:
            mov index3, %ecx
            cmp %ecx, n
            je for3_break_continue

            mov (%edi, %ecx, 4), %edx
            mov $0, %ebx
            cmp %edx, %ebx
            je count_add_modify
        for3_continue:
            movl $0, count_add
        for_contor3:
            incl index3
            jmp for3
        for3_break:
            mov index_add1, %eax
            mov index_add2, %ebx
            mov $-1, %ecx
            cmp %eax, %ecx
            jne index_add2_check
        for3_break_continue:
            push id
            push $format_0
            call printf
            pop %ebx
            pop %ebx
    for_contor2:
        incl index2
        jmp for2
add_size:
    incl space_needed
    jmp add_continue
count_add_modify:
    incl count_add
    mov count_add, %ecx
    mov space_needed, %ebx
    cmp %ecx, %ebx
    je index_change
    jmp for_contor3
index_change:
    mov index3, %ebx
    mov %ebx, index_add2
    sub space_needed, %ebx
    add $1, %ebx
    mov %ebx, index_add1
    jmp for3_break
index_add2_check:
    cmp %ebx, %ecx
    jne set_contor
    jmp for3_break_continue
set_contor:
    mov index_add2, %eax
    inc %eax
    push index_add1
for4_tag:
    mov index_add1, %ecx
    cmp %ecx, %eax
    je display_values
    mov id, %ebx
    mov %ebx, (%edi, %ecx, 4)
    for_contor4:
        incl index_add1
        jmp for4_tag
display_values:
    pop index_add1
    push index_add2
    push index_add1
    push id
    push $format_add
    call printf
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
        cmp %ecx, n
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
    push index3

    mov $0, %ebx
    cmp %ebx, index3
    je get_display_0

    mov index3, %ebx
    sub index4, %ebx
    add $1, %ebx
    push %ebx
    push $format_get
    call printf
    pop %ebx
    pop %ebx
    pop %ebx

    jmp get_out

get_display_0:
    push $0
    push $format_get
    call printf
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
        cmp %ecx, n
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
        cmp %ecx, n
        je del_out
        mov (%edi, %ecx, 4), %edx
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
        cmp %ecx, n
        je del_display_2
        mov (%edi, %ecx, 4), %ebx
        cmp %ebx, %edx
        jne del_display_2
        incl index4
        jmp for_del4
del_display_2:
    mov index4, %ebx
    dec %ebx
    push %ebx
    push %eax
    push %edx
    push $format_add
    call printf
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
    movl $0, index2
    movl $0, index3
    movl $0, index4
    for_defrag:
        mov index2, %ecx
        cmp %ecx, n
        je for_defrag_0
        mov (%edi, %ecx, 4), %edx
        cmp $0, %edx
        je for_defrag_change
        incl index3
        incl index4
        mov index4, %ebx
        mov (%edi, %ebx, 4), %eax
        mov index3, %esi
        mov %eax, (%edi, %esi, 4)
    for_defrag_contor:
        incl index2
        jmp for_defrag
for_defrag_change:
    incl index4
    mov index4, %ebx
    mov (%edi, %ebx, 4), %eax
    mov index3, %esi
    mov %eax, (%edi, %esi, 4)
    jmp for_defrag_contor
for_defrag_0:
    push index3
    pop index5
    for_defrag_01:
        mov index5, %ecx
        cmp %ecx, n
        je del_display
        movl $0, (%edi, %ecx, 4)
    for_defrag_01_contor:
        incl index5
        jmp for_defrag_01