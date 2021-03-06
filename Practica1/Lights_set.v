// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: Lights_set.v
//
// Descripción: Este código Verilog implementa el decodificador del contador Johnson de la subtarea 3 de la Tarea 1. 
// Además, se instancia el contador parametrizable de la Subtarea 1, y el registro de desplazamiento de la Subtarea 2.
// Su funcionalidad es:
//      - El contador (frequencia de 50 MHz) se empleará para habilitar con su salida TC la señal de enable del registro de desplazamiento,
//        de forma que el desplazamiento sea cada 0,25 segundos.
//      - El registro de desplazamiento funciona como un contador Johnson (generará 14 ciclos  para el juego de luces).
//      - iRST_n, activo a nivel bajo
//      - iCLK, Reloj activo por flanco de subida
//      - ENABLE
//      - LEDS_out, salida del juego de luces
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module Lights_set (iENABLE, iCLK, iRST_n, LEDS_out);
    input iENABLE, iCLK, iRST_n;
    output [7:0] LEDS_out;
    
    // Declaración de parámetros
    parameter modulo = 12500000 ; //50 MHz * 0.25 = 12500000

    //Declaración de variables
    reg [7:0] x;
    wire UP = 1;
    wire TC, Johnson;
    wire [6:0] OUT_P;   

    // Instanciación de modulos
    contador #(.fin_cuenta(modulo)) c1(.iUP_DOWN(UP),
                                       .iRST_n(iRST_n),
                                       .iCLK(iCLK),
                                       .iENABLE(iENABLE),
                                       .oCOUNT(),
                                       .oTC(TC));
    registro7 r1(.iCLK(iCLK),
                 .iRST_n(iRST_n),
                 .iENABLE(TC),
                 .iSR(!Johnson),
                 .oPR(OUT_P),
                 .oSR(Johnson));
    //Decodificación de LEDs
    always @(OUT_P) 
        case (OUT_P)
            7'b 0000000: x = 8'b 10000000;
            7'b 0000001: x = 8'b 01000000; 
            7'b 0000011: x = 8'b 00100000;
            7'b 0000111: x = 8'b 00010000; 
            7'b 0001111: x = 8'b 00001000;
            7'b 0011111: x = 8'b 00000100; 
            7'b 0111111: x = 8'b 00000010;
            7'b 1111111: x = 8'b 00000001;
            7'b 1111110: x = 8'b 00000010;
            7'b 1111100: x = 8'b 00000100;
            7'b 1111000: x = 8'b 00001000; 
            7'b 1110000: x = 8'b 00010000;
            7'b 1100000: x = 8'b 00100000;
            7'b 1000000: x = 8'b 01000000;  
            default: x = 8'b 00000000; 
        endcase
		  
    assign LEDS_out = x;
	 
endmodule
