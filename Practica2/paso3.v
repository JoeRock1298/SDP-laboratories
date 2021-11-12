// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: paso3.v
//
// Descripción: Este código Verilog implementa la conexión con el contador de modulo 4 (paso 2) para el TB del FSM dela 
// subtarea 3 de la Tarea 2 (Paso 3).
// Por lo tanto este modulo paso 3 (se hará una instanciación del contador de la tarea 1) tendrá: 
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Reset asincrono y activo a nivel bajo
//      - Enable activo a nivel alto
//      - Entrada de selección de modo del contador de modulo variable
//      - Entrada de control de velocidad mediante los pulsadores key[2] y key[1].
//        key[2] decrementa la velocidad y key[1] la disminuye
//      - Salida oLEDG correspondiente al juego de luces KIT
//      - Salida oLEDR[7:4] al contador de modulo variable que cambia la velocidad del juego de luces
//      - Salida oLEDR[3:0] al contador de selector de la velocidad
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module paso3 (
    input iCLK, iRST_n, iENABLE, iMODE, iKEY1, iKEY2,
    output [7:0] oLEDG, oLEDR
);

    //definicion de parametros
    parameter mod = 5000000; // para tener una frecuencia de 10 Hz, 0.1s
    parameter n = 16; // to instance a 4-bit counter [3:0]
	
   // definicion de variables
	wire TC_i1, TC_i5, ENABLE_i4, UP_DOWN_i4;
    wire [3:0] count_i3;

    //asignación de salidas
    assign oLEDR[3:0] = count_i3;

    //instanciación de los DUT (Device Under Test)
	contador #(.fin_cuenta(mod)) i1 (.iCLK(iCLK),
									 .iRST_n(iRST_n),
									 .iENABLE (iENABLE),
									 .iUP_DOWN (iENABLE),
									 .oCOUNT(),
									 .oTC(TC_i1));
    
    medvedev_kit_LS i2 (.iCLK(iCLK), 
                        .iRST_n(iRST_n), 
                        .iENABLE(TC_i5),
                        .oLEDG(oLEDG));
    
    contador #(.fin_cuenta(n)) i3 (.iCLK(iCLK),
						           .iRST_n(iRST_n),
                                   .iENABLE (ENABLE_i4),
                                   .iUP_DOWN (UP_DOWN_i4),
                                   .oCOUNT(count_i3),
                                   .oTC());
    
    mealy_speed i4 (.iCLK(iCLK), 
                    .iRST_n(iRST_n), 
                    .iKEY2(iKEY2), 
                    .iKEY1(iKEY1), 
                    .oENABLE(ENABLE_i4), 
                    .oUP_DOWN(UP_DOWN_i4));
    
    variable_counter i5 (.iCLK(iCLK), 
                         .iRST_n(iRST_n),
                         .iENABLE(TC_i1), 
                         .iMODE(iMODE),
                         .iMOD(count_i3),
                         .oTC(TC_i5),
                         .oCOUNT(oLEDR[7:4]));

endmodule