/*
Programa en ensamblador que contiene llamadas a dos subrutinas diferentes.
Utilice la instrucción MLA en alguna de sus operaciones. Explique el 
funcionamiento de los registros SP, LR y PC en su programa. 
La funcionalidad se basa BL_instruction.s.
*/

.text
funcion_1:
    mla r7, r4, r5, r6
    bx lr

funcion_2:
    mla r8, r6, r5, r4
    bx lr

.data
/* primer mensaje */
.balign 4
mensaje_1: .asciz "Ingrese primer dato: "

/* segundo mensaje */
.balign 4
mensaje_2: .asciz "Ingrese segundo dato: "

/* tercer mensaje */
.balign 4
mensaje_3: .asciz "Ingrese tercer dato: "

/* cuarto mensaje */
.balign 4
mensaje_4: .asciz "MLA, (Dato1 * Dato2) + Dato3: %d\n"

/* quinto mensaje */
.balign 4
mensaje_5: .asciz "MLA, (Dato3 * Dato2) + Dato1: %d\n"

/* Formato para scanf */
.balign 4
formato_scanf: .asciz "%d"  /* Se prepara para recibir un dato entero*/

/* Operandos */
.balign 4
multiplicando_1: .word 0 /* Posición de memoria donde será guardado el número leido */

.balign 4
multiplicando_2: .word 0 /* Posición de memoria donde será guardado el número leido */

.balign 4
sumando_1: .word 0 /* Posición de memoria donde será guardado el número leido */

.balign 4
retorno: .word 0

.global main
main:
    ldr r1, direccion_retorno
    str lr, [r1]

    /* pedir el primer número */
    ldr r0, direccion_mensaje_1
    bl printf
    ldr r0, direccion_formato_scanf  /* r0 = dirección del formato scanf */
    ldr r1, direccion_multiplicando_1  /* r1 = dirección del número leido */
    bl scanf /* Ya podemos usar después de esta instrucción R0, y r1 de nuevo */
    ldr r0, direccion_multiplicando_1
    ldr r4, [r0]  /* r4 = número intruducido por el usuario */

    /* pedir el segundo número */
    ldr r0, direccion_mensaje_2
    bl printf
    ldr r0, direccion_formato_scanf  /* r0 = dirección del formato scanf */
    ldr r1, direccion_multiplicando_2  /* r1 = dirección del número leido */
    bl scanf /* Ya podemos usar después de esta instrucción R0, y r1 de nuevo */
    ldr r0, direccion_multiplicando_2
    ldr r5, [r0]  /* r5 = número intruducido por el usuario */

    /* pedir el tercer número */
    ldr r0, direccion_mensaje_3
    bl printf
    ldr r0, direccion_formato_scanf  /* r0 = dirección del formato scanf */
    ldr r1, direccion_sumando_1  /* r1 = dirección del número leido */
    bl scanf /* Ya podemos usar después de esta instrucción R0, y r1 de nuevo */
    ldr r0, direccion_sumando_1
    ldr r6, [r0]  /* r6 = número intruducido por el usuario */
    
    /* guardar el valor del lr para volver de la subrutina */
    push {lr} 
    bl funcion_1
    pop {lr}

    push {lr} 
    bl funcion_2
    pop {lr}

    /* imprimir resultados de las subrutinas */
    mov r1, r7
    ldr r0, direccion_mensaje_4
    bl printf

    mov r1, r8
    ldr r0, direccion_mensaje_5
    bl printf
    
    /* program end */
    ldr r14, direccion_retorno
    ldr r14, [r14]
    bx r14

direccion_mensaje_1: .word mensaje_1
direccion_mensaje_2: .word mensaje_2
direccion_mensaje_3: .word mensaje_3
direccion_mensaje_4: .word mensaje_4
direccion_mensaje_5: .word mensaje_5
direccion_formato_scanf: .word formato_scanf
direccion_multiplicando_1: .word multiplicando_1
direccion_multiplicando_2: .word multiplicando_2
direccion_sumando_1: .word sumando_1
direccion_retorno: .word retorno
