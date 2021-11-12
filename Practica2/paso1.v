// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: paso1.v
//
// Descripción: Este código Verilog implementa la conexión con el contador con TC a 10 Hz (paso 1) para el TB del FSM de la
// subtarea 3 de la Tarea 2 (paso 1). Este modulo paso1 consiste en:
//		  - Un contador de modulo 5000000
//		  - Reloj, reset y enable igual que el modulo del FSM
//		  - El UP_DOWN del contador esta conectado al enebale (siempre contará hacia arriba)
//		  - El clock del FSM esta conectado al TC para realizar las pruebas (cambio estado a 10Hz)
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 12/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module paso1(
	input iCLK, iRST_n, iENABLE,
	output [7:0] out
);
	//definicion de parametros
    parameter mod = 5000000; // para tener una frecuencia de 10 Hz, 0.1s
	
   // definicion de variables
	wire TC;
	
	//instanciación de los DUT (Device Under Test)
	contador #(.fin_cuenta(mod)) i1 (.iCLK(iCLK),
												.iRST_n(iRST_n),
												.iENABLE (iENABLE),
												.iUP_DOWN (iENABLE),
												.oCOUNT(),
												.oTC(TC));
    
    medvedev_kit_LS i2 (.iCLK(TC), 
                       .iRST_n(iRST_n), 
                       .iENABLE(iENABLE),
                       .oLEDG(out));
endmodule

