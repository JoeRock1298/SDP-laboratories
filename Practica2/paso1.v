// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: paso1.v
//
// Descripción: Este código Verilog el paso 1 de la subtarea 3 de la tarea 2.
// Consiste en generar el juego de luces (medvedev más contador 10 Hz)
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Reset asincrono y activo a nivel bajo
//      - Enable activo a nivel lto
//      - Salida [7:0] correspondiente al estado de los LED's
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/11/2021
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
    
    medvedev_kit_LS i2(.iCLK(TC), 
                       .iRST_n(iRST_n), 
                       .iENABLE(iENABLE),
                       .oLEDG(out));
endmodule
