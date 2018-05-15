/*
Programa en ensamblador ARM que realiza lo siguiente:
    a) Define una matriz A de dimensión 3x4, con sus elementos previamente establecidos, por ejemplo, sea
       A = [10 4 2 8;13 2 0 7;5 0 3 2]
    b) Obtiene la matriz resultante B = 2A, imprime en panatalla la matriz resultante
    c) Determina el resultado de la suma de todos los elementos individuales de B y los imprime en pantalla.
*/
.data
matrix_A: .word 1, 2, 3, 4
          .word 5, 6, 7, 8
          .word 9, 10, 11, 12

matrix_B: .word 0, 0, 0, 0
          .word 0, 0, 0, 0
          .word 0, 0, 0, 0

scalar_c: .word 2

suma_de_B: .word 0

msg_matrix_A: .asciz "Matrix A:\n"
msg_matrix_B: .asciz "Matrix B:\n"
msg_sum: .asciz "Suma de B: %d\n"

format_number: .asciz "%d " 
format_new_line: .asciz "\n"

.text

matmul_1x4:
    push {r3, r4, r5, r6, r7, r8, lr}
    /* inicializar en cero la matriz */
    mov r4, r1
    mov r5, #12
    mov r6, #5
    b .loop_init_test
    .loop_init:
        str r6, [r4], +#4 
    .loop_init_test:
        subs r5, r5, #1
        bge .loop_init

     /* inicializar i, i = 0, suma = 0 */
     mov r5, #0 /* r5 = 0 */
     mov r12, #0 /* r13 = 0 */
    .loop_i: /* loop header of i */
        cmp r5, #3 /* if r5 == 3 salta al final del loop i */
        beq .end_loop_i
        /* calcular la direccion B[i][0] */
        /* r6 =  r1 + (r5 << 4). Entonces, r6 = B + 4 * (4 * i) */
        add r6, r1, r5, lsl #4
        /* calcular la direccion A[i][0] */
        /* r7 =  r0 + (r5 << 4). Entonces, r7 = A + 4 * (4 * i) */
        add r7, r0, r5, lsl #4
        /* cargar en  {d4,d5,d6,d7} la fila i-esima de A */
        ldm r7, {r8-r11}
        /* {r8,r9,r10,r11} = {r8,r9,r10,r11} * c */
        mul r8, r8, r2
        mul r9, r9, r2
        mul r10, r10, r2
        mul r11, r11, r2
        /* suma valores de B */
        add r12, r12, r8
        add r12, r12, r9
        add r12, r12, r10
        add r12, r12, r11
        /* guarda en B */
        stm r6, {r8-r11}
        /* r5 = r5 + 1 */
        add r5, r5, #1 
        b .loop_i /* siguiente iteracion de loop i */
    .end_loop_i: /* fin de loop i */

    pop {r3, r4, r5, r6, r7, r8, lr}  /* regresar los registros enteros */
    bx lr /* salir de la function */

/* imprime una matriz de 3x4 */
print_matrix:
    push {r3, r4, r5, r6, r7, r8, r12, lr} /* guardar integer registers */
    /* imprime una matriz de 3x4 */
    mov r5, #0
    mov r6, #0
    .print_loop:
        /* print valor */
        ldr r1, [r4] /* r1 = *r4. carga el elemento actual */
        ldr r0, addr_format_number
        bl printf /* llama a printf */
        add r6, r6, #1
        cmp r6, #4
        bne .no_print_nl
            /* imprime un salto de linea */
            ldr r0, addr_format_new_line
            bl printf /* llama a printf  */
            mov r6, #0
        .no_print_nl:
        add r4, r4, #4 /* mover al diguiente indice del arreglo  */
        add r5, r5, #1 /* incrementa i */
        cmp r5, #12 /* saltar si no llegamos a 12 */
        bne .print_loop
    
    /* saca registros de la pila */
    pop {r3, r4, r5, r6, r7, r8, r12, lr}  /* Restore integer registers */
    bx lr /* Leave function */

.globl main
main:
    push {r4, lr}
    ldr r0, addr_matrix_A  /* r0 ← a */
    ldr r1, addr_matrix_B  /* r1 ← b */
    ldr r2, addr_scalar_c  /* r2 ← c */
    ldr r2, [r2]
    
    bl matmul_1x4
    mov r10, r12

    ldr r0, addr_msg_matrix_A
    bl printf /* llama a printf */
    ldr r4, addr_matrix_A
    bl print_matrix
    
    ldr r0, addr_msg_matrix_B 
    bl printf /* llama a printf */
    ldr r4, addr_matrix_B
    bl print_matrix

    /* mover resultado de la suma a r1 */
    mov r1, r10
    ldr r0, addr_msg_sum
    bl printf /* llama a printf */

    pop {r4, lr}
    bx lr

addr_matrix_A: .word matrix_A
addr_matrix_B: .word matrix_B
addr_scalar_c: .word scalar_c
/* mensajes */
addr_msg_matrix_A: .word msg_matrix_A
addr_msg_matrix_B: .word msg_matrix_B
addr_msg_sum: .word msg_sum
addr_format_number: .word format_number
addr_format_new_line: .word format_new_line
