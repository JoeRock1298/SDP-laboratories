// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: paso2.v
//
// Descripción: Este código Verilog implementa la conexión con el contador de modulo 4 (paso 2) para el TB del FSM la 
// subtarea 3 de la Tarea 2 (Paso 2).
// Por lo tanto este modulo paso2 (se hará una instanciación del contador de la tarea 1) tendrá: 
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Reset asincrono y activo a nivel bajo
//      - Como entrada: los pulsadores key[2] y key[1] que controlarán la velocidad en el paso final.
//		  Para este paso, su funcionalidad es incrementar o decrementar el contador que se connectará despues.
//      - Salidas enable y up_down para la funcionalidad comentada arriba
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module paso2(
	input iCLK, iRST_n, iKEY1, iKEY2,
	output [3:0] oCOUNT,
   output oTC,
	output [1:0] out
);
	//parameter definition
    parameter n = 16; // to instance a 4-bit counter [3:0]
	
   // variable definition
	wire ENABLE, UP_DOWN;
	assign out = {ENABLE, UP_DOWN};
	
	//Declaring DUT's (Device Under Test)
	contador #(.fin_cuenta(n)) i1 (.iCLK(iCLK),
						  .iRST_n(iRST_n),
						  .iENABLE (ENABLE),
						  .iUP_DOWN (UP_DOWN),
						  .oCOUNT(oCOUNT),
						  .oTC(oTC));
    
    mealy_speed i2 (.iCLK(iCLK), 
                    .iRST_n(iRST_n), 
                    .iKEY2(iKEY2), 
                    .iKEY1(iKEY1), 
                    .oENABLE(ENABLE), 
                    .oUP_DOWN(UP_DOWN));              
endmodule