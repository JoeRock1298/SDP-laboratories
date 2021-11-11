// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: paso1_TB.v
//
// Descripción: Este código Verilog implementa el documento de TestBench para el paso 1 de la subtarea 3 de la tarea 2.
// Aquí se comprobará el funcionamiento del juego de luces (medvedev más contador 10 Hz)
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

//´timescale <time_unit>/<time_precision>
`timescale 10ns/10ns

module paso1_TB ();
    //definicion de parametros
    localparam T = 2;
    parameter mod = 5; // para tener una frecuencia de 10 MHz, para visualizar el resultado más rápido
	 localparam countT = T*mod;
	 
    // definicion de variables
	reg CLK, RST_n, ENABLE;
   wire [7:0] out;
	
	//instanciación de los DUT (Device Under Test)
	paso1 #(.mod(mod)) dut1(.iCLK(CLK),
				  .iRST_n(RST_n),
				  .iENABLE(ENABLE),
				  .out(out));

    initial 
        begin
         RST_n = 1'b0;
			CLK = 1'b0;
			ENABLE = 1'b0;
			$display("SIMULANDO!!!");

			//Esperamos 2 Periodos y desactivamos el reset
         #(countT*2)
			RST_n = 1'b1;

			//Esperamos 2 Periodos y activamos el ENABLE y el conteo hacia arriba
			#(countT*2)
			ENABLE = 1'b1;

         //Ejecutamos el juego de luces durante 22 periodos y desacticamos el enable
			#(countT*16)
         ENABLE = 1'b0;

         //Activamos el reset en 2 períodos
			#(countT*2)
         RST_n = 1'b0;
			#(countT*2)
         $display("Fin Simulación!!!");
			$stop;
        end

    always
		begin
			#(T/2) CLK <= ~CLK;
		end

endmodule
