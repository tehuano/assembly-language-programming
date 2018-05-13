/*
a) Reciba un número entero  positivo mayor  o igual que 0,
   digamos x,  ingresado por el usuario
b) Realice la operación
   Y = (x + 4)^2-2
   y guarde el resultado en un registro del Microprocesador.
c) El programa debe calcular  D, donde D es el residuo
   resultante de dividir  Y/5 
d) Imprima en pantalla el valor  obtenido de y.
e) Imprima en pantalla el valor obtenido de D.
f) ¿Cuál es el valor máximo permitido de “x” para que
   el resultado en pantalla Y sea correcto?
   x = 46336
*/

.data
/* Primer mensaje */
.balign 4
mensaje_1: .asciz "Ingrese x: "

/* Segundo mensaje */
.balign 4
mensaje_2: .asciz "Y = (x + 4)^2 - 2, Y es %d\n"

/* tercer mensaje */
.balign 4
mensaje_3: .asciz "D = Y / 5, D es %d\n"

/* cuarto mensaje */
.balign 4
mensaje_4: .asciz "%d es negativo, fin del programa\n"

/* Formato para scanf */
.balign 4
formato_scanf: .asciz "%d"  /* Se prepara para recibir un dato entero*/

.balign 4
numero_leido:  .word 0 /* Posición de memoria donde será guardado el número leido */

.balign 4
retorno: .word 0

direccion_mensaje_1: .word mensaje_1

/* Función principal */

.global main
main:
    ldr r1, direccion_retorno
    str lr, [r1]

    /* r0 primer parametro a pasar por la función printf */
    ldr r0, direccion_mensaje_1  
    bl printf                           

    ldr r0, direccion_formato_scanf  /* r0 = dirección del formato scanf */
    ldr r1, direccion_numero_leido  /* r1 = dirección del número leido */
    bl scanf /* Ya podemos usar después de esta instrucción R0, y r1 de nuevo */

    ldr r0, direccion_numero_leido
    ldr r0, [r0]  /* r0 = número intruducido por el usuario */
    cmp r0, #0
    blt .negative

    /* Función  multiplicar por 4 */
    mov r5, r0
    add r6, r5, #4
    mul r6, r6, r6
    sub r6, r6, #2
    
    /* division por 5 */
    mov r4, #5 /* divisor */
    mov r1, r6 /* dividendo */
    mov r5, #0 /* resultado */
.check_div:
    cmp r4, r1
    bhs .end_div
    add r5, r5, #1
    sub r1, r1, r4
    b .check_div
.end_div:
    /* fin division por 5 */

    /* se pasa el resultado (Y) de la op en r1 */
    mov r1, r6  
    ldr r0, direccion_mensaje_2 
    bl printf 

    /* se pasa el resultado (D) de la op en r1 */
    mov r1, r5
    ldr r0, direccion_mensaje_3
    bl printf 
    b .program_end

.negative:
    mov r1, r0
    ldr r0, direccion_mensaje_4
    bl printf 

.program_end:
    ldr r14, direccion_retorno
    ldr r14, [r14]
    bx r14

@direccion_mensaje_1: .word mensaje_1
direccion_mensaje_2: .word mensaje_2
direccion_mensaje_3: .word mensaje_3
direccion_mensaje_4: .word mensaje_4
direccion_formato_scanf: .word formato_scanf
direccion_numero_leido: .word numero_leido
direccion_retorno: .word retorno
