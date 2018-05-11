/*Utilizaremos scanf para multiplicar  por 4 un número introducido por el usuario*/

.data
/*Primer mensaje*/

.balign 4
mensaje_1: .asciz "Escriba un número:"

/*Segundo mensaje*/
.balign 4

mensaje_2: .asciz " %d multiplicado 4 veces es %d \n"

/*Formato para scanf*/

.balign 4

formato_scanf: .asciz "%d"  /* Se prepara para recibir un dato entero*/

.balign 4
numero_leido:  .word 0 /*Posición de memoria donde será guardado el número leido*/

.balign 4
retorno: .word 0

direccion_mensaje_1: .word mensaje_1

/*Función principal*/

.global main
main:
	ldr r1, direccion_retorno
	str lr, [r1]
	
	ldr r0, direccion_mensaje_1  /*R0 primer parametro a pasar por la función printf*/
	bl printf                           

/*Para el scanf realizamos en dos pasos, utilizamos dos parametros el almacenamiento del dato*/
	ldr r0, direccion_formato_scanf  /*R0= dirección del formato scanf */
	ldr r1, direccion_numero_leido  /*r1= dirección del número leido*/
	bl scanf    /*Ya podemos usar después de esta instrucción R0, y r1 de nuevo*/

	ldr r0, direccion_numero_leido
	ldr r0, [r0]  /*R0= número intruducido por el usuario*/

/*Función  multiplicar por 4*/

	mov r4, r0 
	mov r5, #4
	mul r6, r5, r4

/*Terminamos nuestra operación. El argumento es pasado mediante r2*/

	mov r2, r6  

	ldr r1, direccion_numero_leido
	ldr r1, [r1]    /*r1=número leido*/

	ldr r0, direccion_mensaje_2   /*Este mensaje necesitara tres argumentos 1) la dirección del mensaje(R0), 2) el número leido(r1) y 3) el resultado(R2)*/
	bl printf 

	ldr r14,  direccion_retorno
	ldr r14, [r14]
	bx r14

@direccion_mensaje_1: .word mensaje_1
direccion_mensaje_2: .word mensaje_2
direccion_formato_scanf: .word formato_scanf
direccion_numero_leido: .word numero_leido
direccion_retorno: .word retorno
